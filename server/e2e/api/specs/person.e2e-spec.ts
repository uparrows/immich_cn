import { IPersonRepository, LoginResponseDto } from '@app/domain';
import { PersonController } from '@app/immich';
import { PersonEntity } from '@app/infra/entities';
import { INestApplication } from '@nestjs/common';
import { errorStub, uuidStub } from '@test/fixtures';
import request from 'supertest';
import { api } from '../client';
import { testApp } from '../utils';

describe(`${PersonController.name}`, () => {
  let app: INestApplication;
  let server: any;
  let loginResponse: LoginResponseDto;
  let accessToken: string;
  let personRepository: IPersonRepository;
  let visiblePerson: PersonEntity;
  let hiddenPerson: PersonEntity;

  beforeAll(async () => {
    app = await testApp.create();
    server = app.getHttpServer();
    personRepository = app.get<IPersonRepository>(IPersonRepository);
  });

  afterAll(async () => {
    await testApp.teardown();
  });

  beforeEach(async () => {
    await testApp.reset();
    await api.authApi.adminSignUp(server);
    loginResponse = await api.authApi.adminLogin(server);
    accessToken = loginResponse.accessToken;

    const faceAsset = await api.assetApi.upload(server, accessToken, 'face_asset');
    visiblePerson = await personRepository.create({
      ownerId: loginResponse.userId,
      name: 'visible_person',
      thumbnailPath: '/thumbnail/face_asset',
    });
    await personRepository.createFace({
      assetId: faceAsset.id,
      personId: visiblePerson.id,
      embedding: Array.from({ length: 512 }, Math.random),
    });

    hiddenPerson = await personRepository.create({
      ownerId: loginResponse.userId,
      name: 'hidden_person',
      isHidden: true,
      thumbnailPath: '/thumbnail/face_asset',
    });
    await personRepository.createFace({
      assetId: faceAsset.id,
      personId: hiddenPerson.id,
      embedding: Array.from({ length: 512 }, Math.random),
    });
  });

  describe('GET /person', () => {
    beforeEach(async () => {});

    it('should require authentication', async () => {
      const { status, body } = await request(server).get('/person');

      expect(status).toBe(401);
      expect(body).toEqual(errorStub.unauthorized);
    });

    it('should return all people (including hidden)', async () => {
      const { status, body } = await request(server)
        .get('/person')
        .set('Authorization', `Bearer ${accessToken}`)
        .query({ withHidden: true });

      expect(status).toBe(200);
      expect(body).toEqual({
        total: 2,
        visible: 1,
        people: [
          expect.objectContaining({ name: 'visible_person' }),
          expect.objectContaining({ name: 'hidden_person' }),
        ],
      });
    });

    it('should return only visible people', async () => {
      const { status, body } = await request(server).get('/person').set('Authorization', `Bearer ${accessToken}`);

      expect(status).toBe(200);
      expect(body).toEqual({
        total: 1,
        visible: 1,
        people: [expect.objectContaining({ name: 'visible_person' })],
      });
    });
  });

  describe('GET /person/:id', () => {
    it('should require authentication', async () => {
      const { status, body } = await request(server).get(`/person/${uuidStub.notFound}`);

      expect(status).toBe(401);
      expect(body).toEqual(errorStub.unauthorized);
    });

    it('should throw error if person with id does not exist', async () => {
      const { status, body } = await request(server)
        .get(`/person/${uuidStub.notFound}`)
        .set('Authorization', `Bearer ${accessToken}`);

      expect(status).toBe(400);
      expect(body).toEqual(errorStub.badRequest());
    });

    it('should return person information', async () => {
      const { status, body } = await request(server)
        .get(`/person/${visiblePerson.id}`)
        .set('Authorization', `Bearer ${accessToken}`);

      expect(status).toBe(200);
      expect(body).toEqual(expect.objectContaining({ id: visiblePerson.id }));
    });
  });

  describe('PUT /person/:id', () => {
    it('should require authentication', async () => {
      const { status, body } = await request(server).put(`/person/${uuidStub.notFound}`);
      expect(status).toBe(401);
      expect(body).toEqual(errorStub.unauthorized);
    });

    for (const { key, type } of [
      { key: 'name', type: 'string' },
      { key: 'featureFaceAssetId', type: 'string' },
      { key: 'isHidden', type: 'boolean value' },
    ]) {
      it(`should not allow null ${key}`, async () => {
        const { status, body } = await request(server)
          .put(`/person/${visiblePerson.id}`)
          .set('Authorization', `Bearer ${accessToken}`)
          .send({ [key]: null });
        expect(status).toBe(400);
        expect(body).toEqual(errorStub.badRequest([`${key} must be a ${type}`]));
      });
    }

    it('should not accept invalid birth dates', async () => {
      for (const { birthDate, response } of [
        { birthDate: false, response: 'Not found or no person.write access' },
        { birthDate: 'false', response: ['birthDate must be a Date instance'] },
        { birthDate: '123567', response: 'Not found or no person.write access' },
        { birthDate: 123567, response: 'Not found or no person.write access' },
      ]) {
        const { status, body } = await request(server)
          .put(`/person/${uuidStub.notFound}`)
          .set('Authorization', `Bearer ${accessToken}`)
          .send({ birthDate });
        expect(status).toBe(400);
        expect(body).toEqual(errorStub.badRequest(response));
      }
    });

    it('should update a date of birth', async () => {
      const { status, body } = await request(server)
        .put(`/person/${visiblePerson.id}`)
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ birthDate: '1990-01-01T05:00:00.000Z' });
      expect(status).toBe(200);
      expect(body).toMatchObject({ birthDate: '1990-01-01' });
    });

    it('should clear a date of birth', async () => {
      const person = await personRepository.create({
        birthDate: new Date('1990-01-01'),
        ownerId: loginResponse.userId,
      });

      expect(person.birthDate).toBeDefined();

      const { status, body } = await request(server)
        .put(`/person/${person.id}`)
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ birthDate: null });
      expect(status).toBe(200);
      expect(body).toMatchObject({ birthDate: null });
    });
  });
});
