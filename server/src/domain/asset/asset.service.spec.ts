import { AssetEntity, AssetType } from '@app/infra/entities';
import { BadRequestException, UnauthorizedException } from '@nestjs/common';
import {
  IAccessRepositoryMock,
  assetStub,
  authStub,
  faceStub,
  newAccessRepositoryMock,
  newAssetRepositoryMock,
  newCommunicationRepositoryMock,
  newCryptoRepositoryMock,
  newJobRepositoryMock,
  newPartnerRepositoryMock,
  newStorageRepositoryMock,
  newSystemConfigRepositoryMock,
  newUserRepositoryMock,
} from '@test';
import { when } from 'jest-when';
import { Readable } from 'stream';
import { CacheControl, ImmichFileResponse } from '../domain.util';
import { JobName } from '../job';
import {
  AssetStats,
  ClientEvent,
  IAssetRepository,
  ICommunicationRepository,
  ICryptoRepository,
  IJobRepository,
  IPartnerRepository,
  IStorageRepository,
  ISystemConfigRepository,
  IUserRepository,
  JobItem,
  TimeBucketSize,
} from '../repositories';
import { AssetService, UploadFieldName } from './asset.service';
import { AssetJobName, AssetStatsResponseDto, DownloadResponseDto } from './dto';
import { mapAsset } from './response-dto';

const downloadResponse: DownloadResponseDto = {
  totalSize: 105_000,
  archives: [
    {
      assetIds: ['asset-id', 'asset-id'],
      size: 105_000,
    },
  ],
};

const stats: AssetStats = {
  [AssetType.IMAGE]: 10,
  [AssetType.VIDEO]: 23,
  [AssetType.AUDIO]: 0,
  [AssetType.OTHER]: 0,
};

const statResponse: AssetStatsResponseDto = {
  images: 10,
  videos: 23,
  total: 33,
};

const uploadFile = {
  nullAuth: {
    auth: null,
    fieldName: UploadFieldName.ASSET_DATA,
    file: {
      uuid: 'random-uuid',
      checksum: Buffer.from('checksum', 'utf8'),
      originalPath: 'upload/admin/image.jpeg',
      originalName: 'image.jpeg',
      size: 1000,
    },
  },
  filename: (fieldName: UploadFieldName, filename: string) => {
    return {
      auth: authStub.admin,
      fieldName,
      file: {
        uuid: 'random-uuid',
        mimeType: 'image/jpeg',
        checksum: Buffer.from('checksum', 'utf8'),
        originalPath: `upload/admin/${filename}`,
        originalName: filename,
        size: 1000,
      },
    };
  },
};

const validImages = [
  '.3fr',
  '.ari',
  '.arw',
  '.avif',
  '.cap',
  '.cin',
  '.cr2',
  '.cr3',
  '.crw',
  '.dcr',
  '.dng',
  '.erf',
  '.fff',
  '.gif',
  '.heic',
  '.heif',
  '.iiq',
  '.jpeg',
  '.jpg',
  '.jxl',
  '.k25',
  '.kdc',
  '.mrw',
  '.nef',
  '.orf',
  '.ori',
  '.pef',
  '.png',
  '.psd',
  '.raf',
  '.raw',
  '.rwl',
  '.sr2',
  '.srf',
  '.srw',
  '.tiff',
  '.webp',
  '.x3f',
];

const validVideos = ['.3gp', '.avi', '.flv', '.m2ts', '.mkv', '.mov', '.mp4', '.mpg', '.mts', '.webm', '.wmv'];

const uploadTests = [
  {
    label: 'asset images',
    fieldName: UploadFieldName.ASSET_DATA,
    valid: validImages,
    invalid: ['.html', '.xml'],
  },
  {
    label: 'asset videos',
    fieldName: UploadFieldName.ASSET_DATA,
    valid: validVideos,
    invalid: ['.html', '.xml'],
  },
  {
    label: 'live photo',
    fieldName: UploadFieldName.LIVE_PHOTO_DATA,
    valid: validVideos,
    invalid: ['.html', '.jpeg', '.jpg', '.xml'],
  },
  {
    label: 'sidecar',
    fieldName: UploadFieldName.SIDECAR_DATA,
    valid: ['.xmp'],
    invalid: ['.html', '.jpeg', '.jpg', '.mov', '.mp4', '.xml'],
  },
  {
    label: 'profile',
    fieldName: UploadFieldName.PROFILE_DATA,
    valid: ['.avif', '.dng', '.heic', '.heif', '.jpeg', '.jpg', '.png', '.webp'],
    invalid: ['.arf', '.cr2', '.html', '.mov', '.mp4', '.xml'],
  },
];

describe(AssetService.name, () => {
  let sut: AssetService;
  let accessMock: IAccessRepositoryMock;
  let assetMock: jest.Mocked<IAssetRepository>;
  let cryptoMock: jest.Mocked<ICryptoRepository>;
  let jobMock: jest.Mocked<IJobRepository>;
  let storageMock: jest.Mocked<IStorageRepository>;
  let userMock: jest.Mocked<IUserRepository>;
  let communicationMock: jest.Mocked<ICommunicationRepository>;
  let configMock: jest.Mocked<ISystemConfigRepository>;
  let partnerMock: jest.Mocked<IPartnerRepository>;

  it('should work', () => {
    expect(sut).toBeDefined();
  });

  beforeEach(async () => {
    accessMock = newAccessRepositoryMock();
    assetMock = newAssetRepositoryMock();
    communicationMock = newCommunicationRepositoryMock();
    cryptoMock = newCryptoRepositoryMock();
    jobMock = newJobRepositoryMock();
    storageMock = newStorageRepositoryMock();
    userMock = newUserRepositoryMock();
    configMock = newSystemConfigRepositoryMock();
    partnerMock = newPartnerRepositoryMock();

    sut = new AssetService(
      accessMock,
      assetMock,
      cryptoMock,
      jobMock,
      configMock,
      storageMock,
      userMock,
      communicationMock,
      partnerMock,
    );

    when(assetMock.getById)
      .calledWith(assetStub.livePhotoStillAsset.id)
      .mockResolvedValue(assetStub.livePhotoStillAsset as AssetEntity);
    when(assetMock.getById)
      .calledWith(assetStub.livePhotoMotionAsset.id)
      .mockResolvedValue(assetStub.livePhotoMotionAsset as AssetEntity);
  });

  describe('canUpload', () => {
    it('should require an authenticated user', () => {
      expect(() => sut.canUploadFile(uploadFile.nullAuth)).toThrowError(UnauthorizedException);
    });

    for (const { fieldName, valid, invalid } of uploadTests) {
      describe(fieldName, () => {
        for (const filetype of valid) {
          it(`should accept ${filetype}`, () => {
            expect(sut.canUploadFile(uploadFile.filename(fieldName, `asset${filetype}`))).toEqual(true);
          });
        }

        for (const filetype of invalid) {
          it(`should reject ${filetype}`, () => {
            expect(() => sut.canUploadFile(uploadFile.filename(fieldName, `asset${filetype}`))).toThrowError(
              BadRequestException,
            );
          });
        }

        it('should be sorted (valid)', () => {
          // TODO: use toSorted in NodeJS 20.
          expect(valid).toEqual([...valid].sort());
        });

        it('should be sorted (invalid)', () => {
          // TODO: use toSorted in NodeJS 20.
          expect(invalid).toEqual([...invalid].sort());
        });
      });
    }
  });

  describe('getUploadFilename', () => {
    it('should require authentication', () => {
      expect(() => sut.getUploadFilename(uploadFile.nullAuth)).toThrowError(UnauthorizedException);
    });

    it('should be the original extension for asset upload', () => {
      expect(sut.getUploadFilename(uploadFile.filename(UploadFieldName.ASSET_DATA, 'image.jpg'))).toEqual(
        'random-uuid.jpg',
      );
    });

    it('should be the mov extension for live photo upload', () => {
      expect(sut.getUploadFilename(uploadFile.filename(UploadFieldName.LIVE_PHOTO_DATA, 'image.mp4'))).toEqual(
        'random-uuid.mov',
      );
    });

    it('should be the xmp extension for sidecar upload', () => {
      expect(sut.getUploadFilename(uploadFile.filename(UploadFieldName.SIDECAR_DATA, 'image.html'))).toEqual(
        'random-uuid.xmp',
      );
    });

    it('should be the original extension for profile upload', () => {
      expect(sut.getUploadFilename(uploadFile.filename(UploadFieldName.PROFILE_DATA, 'image.jpg'))).toEqual(
        'random-uuid.jpg',
      );
    });
  });

  describe('getUploadFolder', () => {
    it('should require authentication', () => {
      expect(() => sut.getUploadFolder(uploadFile.nullAuth)).toThrowError(UnauthorizedException);
    });

    it('should return profile for profile uploads', () => {
      expect(sut.getUploadFolder(uploadFile.filename(UploadFieldName.PROFILE_DATA, 'image.jpg'))).toEqual(
        'upload/profile/admin_id',
      );
      expect(storageMock.mkdirSync).toHaveBeenCalledWith('upload/profile/admin_id');
    });

    it('should return upload for everything else', () => {
      expect(sut.getUploadFolder(uploadFile.filename(UploadFieldName.ASSET_DATA, 'image.jpg'))).toEqual(
        'upload/upload/admin_id/ra/nd',
      );
      expect(storageMock.mkdirSync).toHaveBeenCalledWith('upload/upload/admin_id/ra/nd');
    });
  });

  describe('getMapMarkers', () => {
    it('should get geo information of assets', async () => {
      assetMock.getMapMarkers.mockResolvedValue(
        [assetStub.withLocation].map((asset) => ({
          id: asset.id,

          /* eslint-disable-next-line @typescript-eslint/no-non-null-assertion */
          lat: asset.exifInfo!.latitude!,

          /* eslint-disable-next-line @typescript-eslint/no-non-null-assertion */
          lon: asset.exifInfo!.longitude!,
        })),
      );

      const markers = await sut.getMapMarkers(authStub.user1, {});

      expect(markers).toHaveLength(1);
      expect(markers[0]).toEqual({
        id: assetStub.withLocation.id,
        lat: 100,
        lon: 100,
      });
    });
  });

  describe('getMemoryLane', () => {
    beforeAll(() => {
      jest.useFakeTimers();
      jest.setSystemTime(new Date('2024-01-15'));
    });

    afterAll(() => {
      jest.useRealTimers();
    });

    it('should set the title correctly', async () => {
      assetMock.getByDayOfYear.mockResolvedValue([assetStub.image, assetStub.imageFrom2015]);

      await expect(sut.getMemoryLane(authStub.admin, { day: 15, month: 1 })).resolves.toEqual([
        { title: '1 year since...', assets: [mapAsset(assetStub.image)] },
        { title: '9 years since...', assets: [mapAsset(assetStub.imageFrom2015)] },
      ]);

      expect(assetMock.getByDayOfYear.mock.calls).toEqual([[authStub.admin.user.id, { day: 15, month: 1 }]]);
    });
  });

  describe('getTimeBuckets', () => {
    it("should return buckets if userId and albumId aren't set", async () => {
      assetMock.getTimeBuckets.mockResolvedValue([{ timeBucket: 'bucket', count: 1 }]);

      await expect(
        sut.getTimeBuckets(authStub.admin, {
          size: TimeBucketSize.DAY,
        }),
      ).resolves.toEqual(expect.arrayContaining([{ timeBucket: 'bucket', count: 1 }]));
      expect(assetMock.getTimeBuckets).toBeCalledWith({ size: TimeBucketSize.DAY, userIds: [authStub.admin.user.id] });
    });
  });

  describe('getTimeBucket', () => {
    it('should return the assets for a album time bucket if user has album.read', async () => {
      accessMock.album.checkOwnerAccess.mockResolvedValue(new Set(['album-id']));
      assetMock.getTimeBucket.mockResolvedValue([assetStub.image]);

      await expect(
        sut.getTimeBucket(authStub.admin, { size: TimeBucketSize.DAY, timeBucket: 'bucket', albumId: 'album-id' }),
      ).resolves.toEqual(expect.arrayContaining([expect.objectContaining({ id: 'asset-id' })]));

      expect(accessMock.album.checkOwnerAccess).toHaveBeenCalledWith(authStub.admin.user.id, new Set(['album-id']));
      expect(assetMock.getTimeBucket).toBeCalledWith('bucket', {
        size: TimeBucketSize.DAY,
        timeBucket: 'bucket',
        albumId: 'album-id',
      });
    });

    it('should return the assets for a archive time bucket if user has archive.read', async () => {
      assetMock.getTimeBucket.mockResolvedValue([assetStub.image]);

      await expect(
        sut.getTimeBucket(authStub.admin, {
          size: TimeBucketSize.DAY,
          timeBucket: 'bucket',
          isArchived: true,
          userId: authStub.admin.user.id,
        }),
      ).resolves.toEqual(expect.arrayContaining([expect.objectContaining({ id: 'asset-id' })]));
      expect(assetMock.getTimeBucket).toBeCalledWith('bucket', {
        size: TimeBucketSize.DAY,
        timeBucket: 'bucket',
        isArchived: true,
        userIds: [authStub.admin.user.id],
      });
    });

    it('should return the assets for a library time bucket if user has library.read', async () => {
      assetMock.getTimeBucket.mockResolvedValue([assetStub.image]);

      await expect(
        sut.getTimeBucket(authStub.admin, {
          size: TimeBucketSize.DAY,
          timeBucket: 'bucket',
          userId: authStub.admin.user.id,
        }),
      ).resolves.toEqual(expect.arrayContaining([expect.objectContaining({ id: 'asset-id' })]));
      expect(assetMock.getTimeBucket).toBeCalledWith('bucket', {
        size: TimeBucketSize.DAY,
        timeBucket: 'bucket',
        userIds: [authStub.admin.user.id],
      });
    });

    it('should throw an error if withParners is true and isArchived true or undefined', async () => {
      await expect(
        sut.getTimeBucket(authStub.admin, {
          size: TimeBucketSize.DAY,
          timeBucket: 'bucket',
          isArchived: true,
          withPartners: true,
          userId: authStub.admin.user.id,
        }),
      ).rejects.toThrowError(BadRequestException);

      await expect(
        sut.getTimeBucket(authStub.admin, {
          size: TimeBucketSize.DAY,
          timeBucket: 'bucket',
          isArchived: undefined,
          withPartners: true,
          userId: authStub.admin.user.id,
        }),
      ).rejects.toThrowError(BadRequestException);
    });

    it('should throw an error if withParners is true and isFavorite is either true or false', async () => {
      await expect(
        sut.getTimeBucket(authStub.admin, {
          size: TimeBucketSize.DAY,
          timeBucket: 'bucket',
          isFavorite: true,
          withPartners: true,
          userId: authStub.admin.user.id,
        }),
      ).rejects.toThrowError(BadRequestException);

      await expect(
        sut.getTimeBucket(authStub.admin, {
          size: TimeBucketSize.DAY,
          timeBucket: 'bucket',
          isFavorite: false,
          withPartners: true,
          userId: authStub.admin.user.id,
        }),
      ).rejects.toThrowError(BadRequestException);
    });

    it('should throw an error if withParners is true and isTrash is true', async () => {
      await expect(
        sut.getTimeBucket(authStub.admin, {
          size: TimeBucketSize.DAY,
          timeBucket: 'bucket',
          isTrashed: true,
          withPartners: true,
          userId: authStub.admin.user.id,
        }),
      ).rejects.toThrowError(BadRequestException);
    });
  });

  describe('downloadFile', () => {
    it('should require the asset.download permission', async () => {
      await expect(sut.downloadFile(authStub.admin, 'asset-1')).rejects.toBeInstanceOf(BadRequestException);

      expect(accessMock.asset.checkOwnerAccess).toHaveBeenCalledWith(authStub.admin.user.id, new Set(['asset-1']));
      expect(accessMock.asset.checkAlbumAccess).toHaveBeenCalledWith(authStub.admin.user.id, new Set(['asset-1']));
      expect(accessMock.asset.checkPartnerAccess).toHaveBeenCalledWith(authStub.admin.user.id, new Set(['asset-1']));
    });

    it('should throw an error if the asset is not found', async () => {
      accessMock.asset.checkOwnerAccess.mockResolvedValue(new Set(['asset-1']));
      assetMock.getByIds.mockResolvedValue([]);

      await expect(sut.downloadFile(authStub.admin, 'asset-1')).rejects.toBeInstanceOf(BadRequestException);

      expect(assetMock.getByIds).toHaveBeenCalledWith(['asset-1']);
    });

    it('should download a file', async () => {
      accessMock.asset.checkOwnerAccess.mockResolvedValue(new Set(['asset-1']));
      assetMock.getByIds.mockResolvedValue([assetStub.image]);

      await expect(sut.downloadFile(authStub.admin, 'asset-1')).resolves.toEqual(
        new ImmichFileResponse({
          path: '/original/path.jpg',
          contentType: 'image/jpeg',
          cacheControl: CacheControl.NONE,
        }),
      );
    });

    it('should download an archive', async () => {
      const archiveMock = {
        addFile: jest.fn(),
        finalize: jest.fn(),
        stream: new Readable(),
      };

      accessMock.asset.checkOwnerAccess.mockResolvedValue(new Set(['asset-1', 'asset-2']));
      assetMock.getByIds.mockResolvedValue([assetStub.noResizePath, assetStub.noWebpPath]);
      storageMock.createZipStream.mockReturnValue(archiveMock);

      await expect(sut.downloadArchive(authStub.admin, { assetIds: ['asset-1', 'asset-2'] })).resolves.toEqual({
        stream: archiveMock.stream,
      });

      expect(archiveMock.addFile).toHaveBeenCalledTimes(2);
      expect(archiveMock.addFile).toHaveBeenNthCalledWith(1, 'upload/library/IMG_123.jpg', 'IMG_123.jpg');
      expect(archiveMock.addFile).toHaveBeenNthCalledWith(2, 'upload/library/IMG_456.jpg', 'IMG_456.jpg');
    });

    it('should handle duplicate file names', async () => {
      const archiveMock = {
        addFile: jest.fn(),
        finalize: jest.fn(),
        stream: new Readable(),
      };

      accessMock.asset.checkOwnerAccess.mockResolvedValue(new Set(['asset-1', 'asset-2']));
      assetMock.getByIds.mockResolvedValue([assetStub.noResizePath, assetStub.noResizePath]);
      storageMock.createZipStream.mockReturnValue(archiveMock);

      await expect(sut.downloadArchive(authStub.admin, { assetIds: ['asset-1', 'asset-2'] })).resolves.toEqual({
        stream: archiveMock.stream,
      });

      expect(archiveMock.addFile).toHaveBeenCalledTimes(2);
      expect(archiveMock.addFile).toHaveBeenNthCalledWith(1, 'upload/library/IMG_123.jpg', 'IMG_123.jpg');
      expect(archiveMock.addFile).toHaveBeenNthCalledWith(2, 'upload/library/IMG_123.jpg', 'IMG_123+1.jpg');
    });
  });

  describe('getDownloadInfo', () => {
    it('should throw an error for an invalid dto', async () => {
      await expect(sut.getDownloadInfo(authStub.admin, {})).rejects.toBeInstanceOf(BadRequestException);
    });

    it('should return a list of archives (assetIds)', async () => {
      accessMock.asset.checkOwnerAccess.mockResolvedValue(new Set(['asset-1', 'asset-2']));
      assetMock.getByIds.mockResolvedValue([assetStub.image, assetStub.video]);

      const assetIds = ['asset-1', 'asset-2'];
      await expect(sut.getDownloadInfo(authStub.admin, { assetIds })).resolves.toEqual(downloadResponse);

      expect(assetMock.getByIds).toHaveBeenCalledWith(['asset-1', 'asset-2']);
    });

    it('should return a list of archives (albumId)', async () => {
      accessMock.album.checkOwnerAccess.mockResolvedValue(new Set(['album-1']));
      assetMock.getByAlbumId.mockResolvedValue({
        items: [assetStub.image, assetStub.video],
        hasNextPage: false,
      });

      await expect(sut.getDownloadInfo(authStub.admin, { albumId: 'album-1' })).resolves.toEqual(downloadResponse);

      expect(accessMock.album.checkOwnerAccess).toHaveBeenCalledWith(authStub.admin.user.id, new Set(['album-1']));
      expect(assetMock.getByAlbumId).toHaveBeenCalledWith({ take: 2500, skip: 0 }, 'album-1');
    });

    it('should return a list of archives (userId)', async () => {
      accessMock.library.checkOwnerAccess.mockResolvedValue(new Set([authStub.admin.user.id]));
      assetMock.getByUserId.mockResolvedValue({
        items: [assetStub.image, assetStub.video],
        hasNextPage: false,
      });

      await expect(sut.getDownloadInfo(authStub.admin, { userId: authStub.admin.user.id })).resolves.toEqual(
        downloadResponse,
      );

      expect(assetMock.getByUserId).toHaveBeenCalledWith({ take: 2500, skip: 0 }, authStub.admin.user.id, {
        isVisible: true,
      });
    });

    it('should split archives by size', async () => {
      accessMock.library.checkOwnerAccess.mockResolvedValue(new Set([authStub.admin.user.id]));

      assetMock.getByUserId.mockResolvedValue({
        items: [
          { ...assetStub.image, id: 'asset-1' },
          { ...assetStub.video, id: 'asset-2' },
          { ...assetStub.withLocation, id: 'asset-3' },
          { ...assetStub.noWebpPath, id: 'asset-4' },
        ],
        hasNextPage: false,
      });

      await expect(
        sut.getDownloadInfo(authStub.admin, {
          userId: authStub.admin.user.id,
          archiveSize: 30_000,
        }),
      ).resolves.toEqual({
        totalSize: 251_456,
        archives: [
          { assetIds: ['asset-1', 'asset-2'], size: 105_000 },
          { assetIds: ['asset-3', 'asset-4'], size: 146_456 },
        ],
      });
    });

    it('should include the video portion of a live photo', async () => {
      const assetIds = [assetStub.livePhotoStillAsset.id];

      accessMock.asset.checkOwnerAccess.mockResolvedValue(new Set(assetIds));
      when(assetMock.getByIds)
        .calledWith([assetStub.livePhotoStillAsset.id])
        .mockResolvedValue([assetStub.livePhotoStillAsset]);
      when(assetMock.getByIds)
        .calledWith([assetStub.livePhotoMotionAsset.id])
        .mockResolvedValue([assetStub.livePhotoMotionAsset]);

      await expect(sut.getDownloadInfo(authStub.admin, { assetIds })).resolves.toEqual({
        totalSize: 125_000,
        archives: [
          {
            assetIds: [assetStub.livePhotoStillAsset.id, assetStub.livePhotoMotionAsset.id],
            size: 125_000,
          },
        ],
      });
    });
  });

  describe('getStatistics', () => {
    it('should get the statistics for a user, excluding archived assets', async () => {
      assetMock.getStatistics.mockResolvedValue(stats);
      await expect(sut.getStatistics(authStub.admin, { isArchived: false })).resolves.toEqual(statResponse);
      expect(assetMock.getStatistics).toHaveBeenCalledWith(authStub.admin.user.id, { isArchived: false });
    });

    it('should get the statistics for a user for archived assets', async () => {
      assetMock.getStatistics.mockResolvedValue(stats);
      await expect(sut.getStatistics(authStub.admin, { isArchived: true })).resolves.toEqual(statResponse);
      expect(assetMock.getStatistics).toHaveBeenCalledWith(authStub.admin.user.id, { isArchived: true });
    });

    it('should get the statistics for a user for favorite assets', async () => {
      assetMock.getStatistics.mockResolvedValue(stats);
      await expect(sut.getStatistics(authStub.admin, { isFavorite: true })).resolves.toEqual(statResponse);
      expect(assetMock.getStatistics).toHaveBeenCalledWith(authStub.admin.user.id, { isFavorite: true });
    });

    it('should get the statistics for a user for all assets', async () => {
      assetMock.getStatistics.mockResolvedValue(stats);
      await expect(sut.getStatistics(authStub.admin, {})).resolves.toEqual(statResponse);
      expect(assetMock.getStatistics).toHaveBeenCalledWith(authStub.admin.user.id, {});
    });
  });

  describe('update', () => {
    it('should require asset write access for the id', async () => {
      await expect(sut.update(authStub.admin, 'asset-1', { isArchived: false })).rejects.toBeInstanceOf(
        BadRequestException,
      );
      expect(assetMock.save).not.toHaveBeenCalled();
    });

    it('should update the asset', async () => {
      accessMock.asset.checkOwnerAccess.mockResolvedValue(new Set(['asset-1']));
      assetMock.save.mockResolvedValue(assetStub.image);
      await sut.update(authStub.admin, 'asset-1', { isFavorite: true });
      expect(assetMock.save).toHaveBeenCalledWith({ id: 'asset-1', isFavorite: true });
    });

    it('should update the exif description', async () => {
      accessMock.asset.checkOwnerAccess.mockResolvedValue(new Set(['asset-1']));
      assetMock.save.mockResolvedValue(assetStub.image);
      await sut.update(authStub.admin, 'asset-1', { description: 'Test description' });
      expect(assetMock.upsertExif).toHaveBeenCalledWith({ assetId: 'asset-1', description: 'Test description' });
    });
  });

  describe('updateAll', () => {
    it('should require asset write access for all ids', async () => {
      await expect(
        sut.updateAll(authStub.admin, {
          ids: ['asset-1'],
          isArchived: false,
        }),
      ).rejects.toBeInstanceOf(BadRequestException);
    });

    it('should update all assets', async () => {
      accessMock.asset.checkOwnerAccess.mockResolvedValue(new Set(['asset-1', 'asset-2']));
      await sut.updateAll(authStub.admin, { ids: ['asset-1', 'asset-2'], isArchived: true });
      expect(assetMock.updateAll).toHaveBeenCalledWith(['asset-1', 'asset-2'], { isArchived: true });
    });

    /// Stack related

    it('should require asset update access for parent', async () => {
      accessMock.asset.checkOwnerAccess.mockResolvedValue(new Set(['asset-1']));
      await expect(
        sut.updateAll(authStub.user1, {
          ids: ['asset-1'],
          stackParentId: 'parent',
        }),
      ).rejects.toBeInstanceOf(BadRequestException);
    });

    it('should update parent asset when children are added', async () => {
      accessMock.asset.checkOwnerAccess.mockResolvedValue(new Set(['parent']));
      await sut.updateAll(authStub.user1, {
        ids: [],
        stackParentId: 'parent',
      }),
        expect(assetMock.updateAll).toHaveBeenCalledWith(['parent'], { stackParentId: null });
    });

    it('should update parent asset when children are removed', async () => {
      accessMock.asset.checkOwnerAccess.mockResolvedValue(new Set(['child-1']));
      assetMock.getByIds.mockResolvedValue([{ id: 'child-1', stackParentId: 'parent' } as AssetEntity]);

      await sut.updateAll(authStub.user1, {
        ids: ['child-1'],
        removeParent: true,
      }),
        expect(assetMock.updateAll).toHaveBeenCalledWith(expect.arrayContaining(['parent']), { stackParentId: null });
    });

    it('update parentId for new children', async () => {
      accessMock.asset.checkOwnerAccess.mockResolvedValueOnce(new Set(['child-1', 'child-2']));
      accessMock.asset.checkOwnerAccess.mockResolvedValueOnce(new Set(['parent']));
      await sut.updateAll(authStub.user1, {
        stackParentId: 'parent',
        ids: ['child-1', 'child-2'],
      });

      expect(assetMock.updateAll).toBeCalledWith(['child-1', 'child-2'], { stackParentId: 'parent' });
    });

    it('nullify parentId for remove children', async () => {
      accessMock.asset.checkOwnerAccess.mockResolvedValue(new Set(['child-1', 'child-2']));
      await sut.updateAll(authStub.user1, {
        removeParent: true,
        ids: ['child-1', 'child-2'],
      });

      expect(assetMock.updateAll).toBeCalledWith(['child-1', 'child-2'], { stackParentId: null });
    });

    it('merge stacks if new child has children', async () => {
      accessMock.asset.checkOwnerAccess.mockResolvedValueOnce(new Set(['child-1']));
      accessMock.asset.checkOwnerAccess.mockResolvedValueOnce(new Set(['parent']));
      assetMock.getByIds.mockResolvedValue([
        { id: 'child-1', stack: [{ id: 'child-2' } as AssetEntity] } as AssetEntity,
      ]);

      await sut.updateAll(authStub.user1, {
        ids: ['child-1'],
        stackParentId: 'parent',
      });

      expect(assetMock.updateAll).toBeCalledWith(['child-1', 'child-2'], { stackParentId: 'parent' });
    });

    it('should send ws asset update event', async () => {
      accessMock.asset.checkOwnerAccess.mockResolvedValueOnce(new Set(['asset-1']));
      accessMock.asset.checkOwnerAccess.mockResolvedValueOnce(new Set(['parent']));

      await sut.updateAll(authStub.user1, {
        ids: ['asset-1'],
        stackParentId: 'parent',
      });

      expect(communicationMock.send).toHaveBeenCalledWith(ClientEvent.ASSET_UPDATE, authStub.user1.user.id, [
        'asset-1',
      ]);
    });
  });

  describe('deleteAll', () => {
    it('should require asset delete access for all ids', async () => {
      await expect(
        sut.deleteAll(authStub.user1, {
          ids: ['asset-1'],
        }),
      ).rejects.toBeInstanceOf(BadRequestException);
    });

    it('should force delete a batch of assets', async () => {
      accessMock.asset.checkOwnerAccess.mockResolvedValue(new Set(['asset1', 'asset2']));

      await sut.deleteAll(authStub.user1, { ids: ['asset1', 'asset2'], force: true });

      expect(jobMock.queueAll).toHaveBeenCalledWith([
        { name: JobName.ASSET_DELETION, data: { id: 'asset1' } },
        { name: JobName.ASSET_DELETION, data: { id: 'asset2' } },
      ]);
    });

    it('should soft delete a batch of assets', async () => {
      accessMock.asset.checkOwnerAccess.mockResolvedValue(new Set(['asset1', 'asset2']));

      await sut.deleteAll(authStub.user1, { ids: ['asset1', 'asset2'], force: false });

      expect(assetMock.softDeleteAll).toHaveBeenCalledWith(['asset1', 'asset2']);
      expect(jobMock.queue.mock.calls).toEqual([]);
    });
  });

  describe('restoreAll', () => {
    it('should require asset restore access for all ids', async () => {
      await expect(
        sut.deleteAll(authStub.user1, {
          ids: ['asset-1'],
        }),
      ).rejects.toBeInstanceOf(BadRequestException);
    });

    it('should restore a batch of assets', async () => {
      accessMock.asset.checkOwnerAccess.mockResolvedValue(new Set(['asset1', 'asset2']));

      await sut.restoreAll(authStub.user1, { ids: ['asset1', 'asset2'] });

      expect(assetMock.restoreAll).toHaveBeenCalledWith(['asset1', 'asset2']);
      expect(jobMock.queue.mock.calls).toEqual([]);
    });
  });

  describe('handleAssetDeletion', () => {
    beforeEach(() => {
      when(jobMock.queue)
        .calledWith(
          expect.objectContaining({
            name: JobName.ASSET_DELETION,
          }),
        )
        .mockImplementation(async (item: JobItem) => {
          const jobData = (item as { data?: any })?.data || {};
          await sut.handleAssetDeletion(jobData);
        });
    });

    it('should remove faces', async () => {
      const assetWithFace = { ...assetStub.image, faces: [faceStub.face1, faceStub.mergeFace1] };

      when(assetMock.getById)
        .calledWith(assetWithFace.id, {
          faces: {
            person: true,
          },
          library: true,
          stack: true,
          exifInfo: true,
        })
        .mockResolvedValue(assetWithFace);

      await sut.handleAssetDeletion({ id: assetWithFace.id });

      expect(jobMock.queue.mock.calls).toEqual([
        [
          {
            name: JobName.DELETE_FILES,
            data: {
              files: [
                assetWithFace.webpPath,
                assetWithFace.resizePath,
                assetWithFace.encodedVideoPath,
                assetWithFace.sidecarPath,
                assetWithFace.originalPath,
              ],
            },
          },
        ],
      ]);

      expect(assetMock.remove).toHaveBeenCalledWith(assetWithFace);
    });

    it('should update stack parent if asset has stack children', async () => {
      when(assetMock.getById)
        .calledWith(assetStub.primaryImage.id, {
          faces: {
            person: true,
          },
          library: true,
          stack: true,
          exifInfo: true,
        })
        .mockResolvedValue(assetStub.primaryImage);

      await sut.handleAssetDeletion({ id: assetStub.primaryImage.id });

      expect(assetMock.updateAll).toHaveBeenCalledWith(['stack-child-asset-2'], {
        stackParentId: 'stack-child-asset-1',
      });
      expect(assetMock.updateAll).toHaveBeenCalledWith(['stack-child-asset-1'], {
        stackParentId: null,
      });
    });

    it('should not schedule delete-files job for readonly assets', async () => {
      when(assetMock.getById)
        .calledWith(assetStub.readOnly.id, {
          faces: {
            person: true,
          },
          library: true,
          stack: true,
          exifInfo: true,
        })
        .mockResolvedValue(assetStub.readOnly);

      await sut.handleAssetDeletion({ id: assetStub.readOnly.id });

      expect(jobMock.queue.mock.calls).toEqual([]);

      expect(assetMock.remove).toHaveBeenCalledWith(assetStub.readOnly);
    });

    it('should not process assets from external library without fromExternal flag', async () => {
      when(assetMock.getById).calledWith(assetStub.external.id).mockResolvedValue(assetStub.external);

      await sut.handleAssetDeletion({ id: assetStub.external.id });

      expect(jobMock.queue).not.toHaveBeenCalled();
      expect(jobMock.queueAll).not.toHaveBeenCalled();
      expect(assetMock.remove).not.toHaveBeenCalled();
    });

    it('should process assets from external library with fromExternal flag', async () => {
      when(assetMock.getById)
        .calledWith(assetStub.external.id, {
          faces: {
            person: true,
          },
          library: true,
          stack: true,
          exifInfo: true,
        })
        .mockResolvedValue(assetStub.external);

      await sut.handleAssetDeletion({ id: assetStub.external.id, fromExternal: true });

      expect(assetMock.remove).toHaveBeenCalledWith(assetStub.external);
      expect(jobMock.queue.mock.calls).toEqual([
        [
          {
            name: JobName.DELETE_FILES,
            data: {
              files: [
                assetStub.external.webpPath,
                assetStub.external.resizePath,
                assetStub.external.encodedVideoPath,
                assetStub.external.sidecarPath,
              ],
            },
          },
        ],
      ]);
    });

    it('should delete a live photo', async () => {
      when(assetMock.getById)
        .calledWith(assetStub.livePhotoStillAsset.id, {
          faces: {
            person: true,
          },
          library: true,
          stack: true,
          exifInfo: true,
        })
        .mockResolvedValue(assetStub.livePhotoStillAsset);
      when(assetMock.getById)
        .calledWith(assetStub.livePhotoMotionAsset.id, {
          faces: {
            person: true,
          },
          library: true,
          stack: true,
          exifInfo: true,
        })
        .mockResolvedValue(assetStub.livePhotoMotionAsset);

      await sut.handleAssetDeletion({ id: assetStub.livePhotoStillAsset.id });

      expect(jobMock.queue.mock.calls).toEqual([
        [{ name: JobName.ASSET_DELETION, data: { id: assetStub.livePhotoMotionAsset.id } }],
        [
          {
            name: JobName.DELETE_FILES,
            data: {
              files: [undefined, undefined, undefined, undefined, 'fake_path/asset_1.mp4'],
            },
          },
        ],
        [
          {
            name: JobName.DELETE_FILES,
            data: {
              files: [undefined, undefined, undefined, undefined, 'fake_path/asset_1.jpeg'],
            },
          },
        ],
      ]);
    });

    it('should update usage', async () => {
      when(assetMock.getById)
        .calledWith(assetStub.image.id, {
          faces: {
            person: true,
          },
          library: true,
          stack: true,
          exifInfo: true,
        })
        .mockResolvedValue(assetStub.image);
      await sut.handleAssetDeletion({ id: assetStub.image.id });

      expect(userMock.updateUsage).toHaveBeenCalledWith(assetStub.image.ownerId, -5000);
    });
  });

  describe('run', () => {
    it('should run the refresh metadata job', async () => {
      accessMock.asset.checkOwnerAccess.mockResolvedValue(new Set(['asset-1']));
      await sut.run(authStub.admin, { assetIds: ['asset-1'], name: AssetJobName.REFRESH_METADATA }),
        expect(jobMock.queueAll).toHaveBeenCalledWith([{ name: JobName.METADATA_EXTRACTION, data: { id: 'asset-1' } }]);
    });

    it('should run the refresh thumbnails job', async () => {
      accessMock.asset.checkOwnerAccess.mockResolvedValue(new Set(['asset-1']));
      await sut.run(authStub.admin, { assetIds: ['asset-1'], name: AssetJobName.REGENERATE_THUMBNAIL }),
        expect(jobMock.queueAll).toHaveBeenCalledWith([
          { name: JobName.GENERATE_JPEG_THUMBNAIL, data: { id: 'asset-1' } },
        ]);
    });

    it('should run the transcode video', async () => {
      accessMock.asset.checkOwnerAccess.mockResolvedValue(new Set(['asset-1']));
      await sut.run(authStub.admin, { assetIds: ['asset-1'], name: AssetJobName.TRANSCODE_VIDEO }),
        expect(jobMock.queueAll).toHaveBeenCalledWith([{ name: JobName.VIDEO_CONVERSION, data: { id: 'asset-1' } }]);
    });
  });

  describe('updateStackParent', () => {
    it('should require asset update access for new parent', async () => {
      accessMock.asset.checkOwnerAccess.mockResolvedValue(new Set(['old']));
      await expect(
        sut.updateStackParent(authStub.user1, {
          oldParentId: 'old',
          newParentId: 'new',
        }),
      ).rejects.toBeInstanceOf(BadRequestException);
    });

    it('should require asset read access for old parent', async () => {
      accessMock.asset.checkOwnerAccess.mockResolvedValue(new Set(['new']));
      await expect(
        sut.updateStackParent(authStub.user1, {
          oldParentId: 'old',
          newParentId: 'new',
        }),
      ).rejects.toBeInstanceOf(BadRequestException);
    });

    it('make old parent the child of new parent', async () => {
      accessMock.asset.checkOwnerAccess.mockResolvedValueOnce(new Set([assetStub.image.id]));
      accessMock.asset.checkOwnerAccess.mockResolvedValueOnce(new Set(['new']));

      when(assetMock.getById)
        .calledWith(assetStub.image.id, {
          faces: {
            person: true,
          },
          library: true,
          stack: true,
        })
        .mockResolvedValue(assetStub.image as AssetEntity);

      await sut.updateStackParent(authStub.user1, {
        oldParentId: assetStub.image.id,
        newParentId: 'new',
      });

      expect(assetMock.updateAll).toBeCalledWith([assetStub.image.id], { stackParentId: 'new' });
    });

    it('remove stackParentId of new parent', async () => {
      accessMock.asset.checkOwnerAccess.mockResolvedValueOnce(new Set([assetStub.primaryImage.id]));
      accessMock.asset.checkOwnerAccess.mockResolvedValueOnce(new Set(['new']));

      await sut.updateStackParent(authStub.user1, {
        oldParentId: assetStub.primaryImage.id,
        newParentId: 'new',
      });

      expect(assetMock.updateAll).toBeCalledWith(['new'], { stackParentId: null });
    });

    it('update stackParentId of old parents children to new parent', async () => {
      accessMock.asset.checkOwnerAccess.mockResolvedValueOnce(new Set([assetStub.primaryImage.id]));
      accessMock.asset.checkOwnerAccess.mockResolvedValueOnce(new Set(['new']));
      when(assetMock.getById)
        .calledWith(assetStub.primaryImage.id, {
          faces: {
            person: true,
          },
          library: true,
          stack: true,
        })
        .mockResolvedValue(assetStub.primaryImage as AssetEntity);

      await sut.updateStackParent(authStub.user1, {
        oldParentId: assetStub.primaryImage.id,
        newParentId: 'new',
      });

      expect(assetMock.updateAll).toBeCalledWith(
        [assetStub.primaryImage.id, 'stack-child-asset-1', 'stack-child-asset-2'],
        {
          stackParentId: 'new',
        },
      );
    });
  });

  it('get assets by device id', async () => {
    const assets = [assetStub.image, assetStub.image1];

    assetMock.getAllByDeviceId.mockImplementation(() =>
      Promise.resolve<string[]>(Array.from(assets.map((asset) => asset.deviceAssetId))),
    );

    const deviceId = 'device-id';
    const result = await sut.getUserAssetsByDeviceId(authStub.user1, deviceId);

    expect(result.length).toEqual(2);
    expect(result).toEqual(assets.map((asset) => asset.deviceAssetId));
  });
});
