import { IPersonRepository } from '@app/domain';

export const newPersonRepositoryMock = (): jest.Mocked<IPersonRepository> => {
  return {
    getById: jest.fn(),
    getAll: jest.fn(),
    getAllForUser: jest.fn(),
    getAssets: jest.fn(),
    getAllWithoutFaces: jest.fn(),

    getByName: jest.fn(),

    create: jest.fn(),
    update: jest.fn(),
    deleteAll: jest.fn(),
    delete: jest.fn(),
    deleteAllFaces: jest.fn(),

    getStatistics: jest.fn(),
    getAllFaces: jest.fn(),
    getFacesByIds: jest.fn(),
    getRandomFace: jest.fn(),

    reassignFaces: jest.fn(),
    createFace: jest.fn(),
    getFaces: jest.fn(),
    reassignFace: jest.fn(),
    getFaceById: jest.fn(),
    getFaceByIdWithAssets: jest.fn(),
  };
};
