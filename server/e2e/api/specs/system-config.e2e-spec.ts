import { LoginResponseDto } from '@app/domain';
import { SystemConfigController } from '@app/immich';
import { errorStub, userDto } from '@test/fixtures';
import request from 'supertest';
import { api } from '../client';
import { testApp } from '../utils';

describe(`${SystemConfigController.name} (e2e)`, () => {
  let server: any;
  let admin: LoginResponseDto;
  let nonAdmin: LoginResponseDto;

  beforeAll(async () => {
    server = (await testApp.create()).getHttpServer();

    await testApp.reset();
    await api.authApi.adminSignUp(server);
    admin = await api.authApi.adminLogin(server);
    await api.userApi.create(server, admin.accessToken, userDto.user1);
    nonAdmin = await api.authApi.login(server, userDto.user1);
  });

  afterAll(async () => {
    await testApp.teardown();
  });

  describe('GET /system-config/map/style.json', () => {
    it('should require authentication', async () => {
      const { status, body } = await request(server).get('/system-config/map/style.json');
      expect(status).toBe(401);
      expect(body).toEqual(errorStub.unauthorized);
    });

    it('should throw an error if a theme is not light or dark', async () => {
      for (const theme of ['dark1', true, 123, '', null, undefined]) {
        const { status, body } = await request(server)
          .get('/system-config/map/style.json')
          .query({ theme })
          .set('Authorization', `Bearer ${admin.accessToken}`);
        expect(status).toBe(400);
        expect(body).toEqual(errorStub.badRequest(['theme must be one of the following values: light, dark']));
      }
    });

    it('should return the light style.json', async () => {
      const { status, body } = await request(server)
        .get('/system-config/map/style.json')
        .query({ theme: 'light' })
        .set('Authorization', `Bearer ${admin.accessToken}`);
      expect(status).toBe(200);
      expect(body).toEqual(expect.objectContaining({ id: 'immich-map-light' }));
    });

    it('should return the dark style.json', async () => {
      const { status, body } = await request(server)
        .get('/system-config/map/style.json')
        .query({ theme: 'dark' })
        .set('Authorization', `Bearer ${admin.accessToken}`);
      expect(status).toBe(200);
      expect(body).toEqual(expect.objectContaining({ id: 'immich-map-dark' }));
    });

    it('should not require admin authentication', async () => {
      const { status, body } = await request(server)
        .get('/system-config/map/style.json')
        .query({ theme: 'dark' })
        .set('Authorization', `Bearer ${nonAdmin.accessToken}`);
      expect(status).toBe(200);
      expect(body).toEqual(expect.objectContaining({ id: 'immich-map-dark' }));
    });
  });
});
