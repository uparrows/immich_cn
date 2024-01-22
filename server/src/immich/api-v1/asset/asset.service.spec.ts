import { IJobRepository, ILibraryRepository, IUserRepository, JobName } from '@app/domain';
import { ASSET_CHECKSUM_CONSTRAINT, AssetEntity, AssetType, ExifEntity } from '@app/infra/entities';
import { BadRequestException } from '@nestjs/common';
import {
  IAccessRepositoryMock,
  assetStub,
  authStub,
  fileStub,
  newAccessRepositoryMock,
  newJobRepositoryMock,
  newLibraryRepositoryMock,
  newUserRepositoryMock,
} from '@test';
import { when } from 'jest-when';
import { QueryFailedError } from 'typeorm';
import { IAssetRepository } from './asset-repository';
import { AssetService } from './asset.service';
import { CreateAssetDto } from './dto/create-asset.dto';
import { AssetRejectReason, AssetUploadAction } from './response-dto/asset-check-response.dto';

const _getCreateAssetDto = (): CreateAssetDto => {
  const createAssetDto = new CreateAssetDto();
  createAssetDto.deviceAssetId = 'deviceAssetId';
  createAssetDto.deviceId = 'deviceId';
  createAssetDto.fileCreatedAt = new Date('2022-06-19T23:41:36.910Z');
  createAssetDto.fileModifiedAt = new Date('2022-06-19T23:41:36.910Z');
  createAssetDto.isFavorite = false;
  createAssetDto.isArchived = false;
  createAssetDto.duration = '0:00:00.000000';
  createAssetDto.libraryId = 'libraryId';

  return createAssetDto;
};

const _getAsset_1 = () => {
  const asset_1 = new AssetEntity();

  asset_1.id = 'id_1';
  asset_1.ownerId = 'user_id_1';
  asset_1.deviceAssetId = 'device_asset_id_1';
  asset_1.deviceId = 'device_id_1';
  asset_1.type = AssetType.VIDEO;
  asset_1.originalPath = 'fake_path/asset_1.jpeg';
  asset_1.resizePath = '';
  asset_1.fileModifiedAt = new Date('2022-06-19T23:41:36.910Z');
  asset_1.fileCreatedAt = new Date('2022-06-19T23:41:36.910Z');
  asset_1.updatedAt = new Date('2022-06-19T23:41:36.910Z');
  asset_1.isFavorite = false;
  asset_1.isArchived = false;
  asset_1.webpPath = '';
  asset_1.encodedVideoPath = '';
  asset_1.duration = '0:00:00.000000';
  asset_1.exifInfo = new ExifEntity();
  asset_1.exifInfo.latitude = 49.533547;
  asset_1.exifInfo.longitude = 10.703075;
  return asset_1;
};

const _getAsset_2 = () => {
  const asset_2 = new AssetEntity();

  asset_2.id = 'id_2';
  asset_2.ownerId = 'user_id_1';
  asset_2.deviceAssetId = 'device_asset_id_2';
  asset_2.deviceId = 'device_id_1';
  asset_2.type = AssetType.VIDEO;
  asset_2.originalPath = 'fake_path/asset_2.jpeg';
  asset_2.resizePath = '';
  asset_2.fileModifiedAt = new Date('2022-06-19T23:41:36.910Z');
  asset_2.fileCreatedAt = new Date('2022-06-19T23:41:36.910Z');
  asset_2.updatedAt = new Date('2022-06-19T23:41:36.910Z');
  asset_2.isFavorite = false;
  asset_2.isArchived = false;
  asset_2.webpPath = '';
  asset_2.encodedVideoPath = '';
  asset_2.duration = '0:00:00.000000';

  return asset_2;
};

const _getAssets = () => {
  return [_getAsset_1(), _getAsset_2()];
};

describe('AssetService', () => {
  let sut: AssetService;
  let accessMock: IAccessRepositoryMock;
  let assetRepositoryMock: jest.Mocked<IAssetRepository>;
  let jobMock: jest.Mocked<IJobRepository>;
  let libraryMock: jest.Mocked<ILibraryRepository>;
  let userMock: jest.Mocked<IUserRepository>;

  beforeEach(() => {
    assetRepositoryMock = {
      get: jest.fn(),
      create: jest.fn(),
      upsertExif: jest.fn(),

      getAllByUserId: jest.fn(),
      getAllByDeviceId: jest.fn(),
      getById: jest.fn(),
      getDetectedObjectsByUserId: jest.fn(),
      getLocationsByUserId: jest.fn(),
      getSearchPropertiesByUserId: jest.fn(),
      getAssetsByChecksums: jest.fn(),
      getExistingAssets: jest.fn(),
      getByOriginalPath: jest.fn(),
    };

    accessMock = newAccessRepositoryMock();
    jobMock = newJobRepositoryMock();
    libraryMock = newLibraryRepositoryMock();
    userMock = newUserRepositoryMock();

    sut = new AssetService(accessMock, assetRepositoryMock, jobMock, libraryMock, userMock);

    when(assetRepositoryMock.get)
      .calledWith(assetStub.livePhotoStillAsset.id)
      .mockResolvedValue(assetStub.livePhotoStillAsset);
    when(assetRepositoryMock.get)
      .calledWith(assetStub.livePhotoMotionAsset.id)
      .mockResolvedValue(assetStub.livePhotoMotionAsset);
  });

  describe('uploadFile', () => {
    it('should handle a file upload', async () => {
      const assetEntity = _getAsset_1();
      const file = {
        uuid: 'random-uuid',
        originalPath: 'fake_path/asset_1.jpeg',
        mimeType: 'image/jpeg',
        checksum: Buffer.from('file hash', 'utf8'),
        originalName: 'asset_1.jpeg',
        size: 42,
      };
      const dto = _getCreateAssetDto();

      assetRepositoryMock.create.mockResolvedValue(assetEntity);
      accessMock.library.checkOwnerAccess.mockResolvedValue(new Set([dto.libraryId!]));

      await expect(sut.uploadFile(authStub.user1, dto, file)).resolves.toEqual({ duplicate: false, id: 'id_1' });

      expect(assetRepositoryMock.create).toHaveBeenCalled();
      expect(userMock.updateUsage).toHaveBeenCalledWith(authStub.user1.user.id, file.size);
    });

    it('should handle a duplicate', async () => {
      const file = {
        uuid: 'random-uuid',
        originalPath: 'fake_path/asset_1.jpeg',
        mimeType: 'image/jpeg',
        checksum: Buffer.from('file hash', 'utf8'),
        originalName: 'asset_1.jpeg',
        size: 0,
      };
      const dto = _getCreateAssetDto();
      const error = new QueryFailedError('', [], new Error('unique key violation'));
      (error as any).constraint = ASSET_CHECKSUM_CONSTRAINT;

      assetRepositoryMock.create.mockRejectedValue(error);
      assetRepositoryMock.getAssetsByChecksums.mockResolvedValue([_getAsset_1()]);
      accessMock.library.checkOwnerAccess.mockResolvedValue(new Set([dto.libraryId!]));

      await expect(sut.uploadFile(authStub.user1, dto, file)).resolves.toEqual({ duplicate: true, id: 'id_1' });

      expect(jobMock.queue).toHaveBeenCalledWith({
        name: JobName.DELETE_FILES,
        data: { files: ['fake_path/asset_1.jpeg', undefined, undefined] },
      });
      expect(userMock.updateUsage).not.toHaveBeenCalled();
    });

    it('should handle a live photo', async () => {
      const dto = _getCreateAssetDto();
      const error = new QueryFailedError('', [], new Error('unique key violation'));
      (error as any).constraint = ASSET_CHECKSUM_CONSTRAINT;

      assetRepositoryMock.create.mockResolvedValueOnce(assetStub.livePhotoMotionAsset);
      assetRepositoryMock.create.mockResolvedValueOnce(assetStub.livePhotoStillAsset);
      accessMock.library.checkOwnerAccess.mockResolvedValue(new Set([dto.libraryId!]));

      await expect(
        sut.uploadFile(authStub.user1, dto, fileStub.livePhotoStill, fileStub.livePhotoMotion),
      ).resolves.toEqual({
        duplicate: false,
        id: 'live-photo-still-asset',
      });

      expect(jobMock.queue.mock.calls).toEqual([
        [
          {
            name: JobName.METADATA_EXTRACTION,
            data: { id: assetStub.livePhotoMotionAsset.id, source: 'upload' },
          },
        ],
        [{ name: JobName.METADATA_EXTRACTION, data: { id: assetStub.livePhotoStillAsset.id, source: 'upload' } }],
      ]);
      expect(userMock.updateUsage).toHaveBeenCalledWith(authStub.user1.user.id, 111);
    });
  });

  it('get assets by device id', async () => {
    const assets = _getAssets();

    assetRepositoryMock.getAllByDeviceId.mockImplementation(() =>
      Promise.resolve<string[]>(Array.from(assets.map((asset) => asset.deviceAssetId))),
    );

    const deviceId = 'device_id_1';
    const result = await sut.getUserAssetsByDeviceId(authStub.user1, deviceId);

    expect(result.length).toEqual(2);
    expect(result).toEqual(assets.map((asset) => asset.deviceAssetId));
  });

  describe('bulkUploadCheck', () => {
    it('should accept hex and base64 checksums', async () => {
      const file1 = Buffer.from('d2947b871a706081be194569951b7db246907957', 'hex');
      const file2 = Buffer.from('53be335e99f18a66ff12e9a901c7a6171dd76573', 'hex');

      assetRepositoryMock.getAssetsByChecksums.mockResolvedValue([
        { id: 'asset-1', checksum: file1 },
        { id: 'asset-2', checksum: file2 },
      ]);

      await expect(
        sut.bulkUploadCheck(authStub.admin, {
          assets: [
            { id: '1', checksum: file1.toString('hex') },
            { id: '2', checksum: file2.toString('base64') },
          ],
        }),
      ).resolves.toEqual({
        results: [
          { id: '1', assetId: 'asset-1', action: AssetUploadAction.REJECT, reason: AssetRejectReason.DUPLICATE },
          { id: '2', assetId: 'asset-2', action: AssetUploadAction.REJECT, reason: AssetRejectReason.DUPLICATE },
        ],
      });

      expect(assetRepositoryMock.getAssetsByChecksums).toHaveBeenCalledWith(authStub.admin.user.id, [file1, file2]);
    });
  });

  describe('getAssetById', () => {
    it('should allow owner access', async () => {
      accessMock.asset.checkOwnerAccess.mockResolvedValue(new Set([assetStub.image.id]));
      assetRepositoryMock.getById.mockResolvedValue(assetStub.image);
      await sut.getAssetById(authStub.admin, assetStub.image.id);
      expect(accessMock.asset.checkOwnerAccess).toHaveBeenCalledWith(
        authStub.admin.user.id,
        new Set([assetStub.image.id]),
      );
    });

    it('should allow shared link access', async () => {
      accessMock.asset.checkSharedLinkAccess.mockResolvedValue(new Set([assetStub.image.id]));
      assetRepositoryMock.getById.mockResolvedValue(assetStub.image);
      await sut.getAssetById(authStub.adminSharedLink, assetStub.image.id);
      expect(accessMock.asset.checkSharedLinkAccess).toHaveBeenCalledWith(
        authStub.adminSharedLink.sharedLink?.id,
        new Set([assetStub.image.id]),
      );
    });

    it('should allow partner sharing access', async () => {
      accessMock.asset.checkPartnerAccess.mockResolvedValue(new Set([assetStub.image.id]));
      assetRepositoryMock.getById.mockResolvedValue(assetStub.image);
      await sut.getAssetById(authStub.admin, assetStub.image.id);
      expect(accessMock.asset.checkPartnerAccess).toHaveBeenCalledWith(
        authStub.admin.user.id,
        new Set([assetStub.image.id]),
      );
    });

    it('should allow shared album access', async () => {
      accessMock.asset.checkAlbumAccess.mockResolvedValue(new Set([assetStub.image.id]));
      assetRepositoryMock.getById.mockResolvedValue(assetStub.image);
      await sut.getAssetById(authStub.admin, assetStub.image.id);
      expect(accessMock.asset.checkAlbumAccess).toHaveBeenCalledWith(
        authStub.admin.user.id,
        new Set([assetStub.image.id]),
      );
    });

    it('should throw an error for no access', async () => {
      await expect(sut.getAssetById(authStub.admin, assetStub.image.id)).rejects.toBeInstanceOf(BadRequestException);
      expect(assetRepositoryMock.getById).not.toHaveBeenCalled();
    });

    it('should throw an error for an invalid shared link', async () => {
      await expect(sut.getAssetById(authStub.adminSharedLink, assetStub.image.id)).rejects.toBeInstanceOf(
        BadRequestException,
      );
      expect(accessMock.asset.checkOwnerAccess).not.toHaveBeenCalled();
      expect(assetRepositoryMock.getById).not.toHaveBeenCalled();
    });
  });
});
