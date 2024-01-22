import { AssetCreate } from '@app/domain';
import { AssetEntity, ExifEntity } from '@app/infra/entities';
import { OptionalBetween } from '@app/infra/infra.utils';
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In } from 'typeorm/find-options/operator/In';
import { Repository } from 'typeorm/repository/Repository';
import { AssetSearchDto } from './dto/asset-search.dto';
import { CheckExistingAssetsDto } from './dto/check-existing-assets.dto';
import { SearchPropertiesDto } from './dto/search-properties.dto';
import { CuratedLocationsResponseDto } from './response-dto/curated-locations-response.dto';
import { CuratedObjectsResponseDto } from './response-dto/curated-objects-response.dto';

export interface AssetCheck {
  id: string;
  checksum: Buffer;
}

export interface AssetOwnerCheck extends AssetCheck {
  ownerId: string;
}

export interface IAssetRepository {
  get(id: string): Promise<AssetEntity | null>;
  create(asset: AssetCreate): Promise<AssetEntity>;
  upsertExif(exif: Partial<ExifEntity>): Promise<void>;
  getAllByUserId(userId: string, dto: AssetSearchDto): Promise<AssetEntity[]>;
  getAllByDeviceId(userId: string, deviceId: string): Promise<string[]>;
  getById(assetId: string): Promise<AssetEntity>;
  getLocationsByUserId(userId: string): Promise<CuratedLocationsResponseDto[]>;
  getDetectedObjectsByUserId(userId: string): Promise<CuratedObjectsResponseDto[]>;
  getSearchPropertiesByUserId(userId: string): Promise<SearchPropertiesDto[]>;
  getAssetsByChecksums(userId: string, checksums: Buffer[]): Promise<AssetCheck[]>;
  getExistingAssets(userId: string, checkDuplicateAssetDto: CheckExistingAssetsDto): Promise<string[]>;
  getByOriginalPath(originalPath: string): Promise<AssetOwnerCheck | null>;
}

export const IAssetRepository = 'IAssetRepository';

@Injectable()
export class AssetRepository implements IAssetRepository {
  constructor(
    @InjectRepository(AssetEntity) private assetRepository: Repository<AssetEntity>,
    @InjectRepository(ExifEntity) private exifRepository: Repository<ExifEntity>,
  ) {}

  getSearchPropertiesByUserId(userId: string): Promise<SearchPropertiesDto[]> {
    return this.assetRepository
      .createQueryBuilder('asset')
      .where('asset.ownerId = :userId', { userId: userId })
      .andWhere('asset.isVisible = true')
      .leftJoin('asset.exifInfo', 'ei')
      .leftJoin('asset.smartInfo', 'si')
      .select('si.tags', 'tags')
      .addSelect('si.objects', 'objects')
      .addSelect('asset.type', 'assetType')
      .addSelect('ei.orientation', 'orientation')
      .addSelect('ei."lensModel"', 'lensModel')
      .addSelect('ei.make', 'make')
      .addSelect('ei.model', 'model')
      .addSelect('ei.city', 'city')
      .addSelect('ei.state', 'state')
      .addSelect('ei.country', 'country')
      .distinctOn(['si.tags'])
      .getRawMany();
  }

  getDetectedObjectsByUserId(userId: string): Promise<CuratedObjectsResponseDto[]> {
    return this.assetRepository.query(
      `
        SELECT DISTINCT ON (unnest(si.objects)) a.id, unnest(si.objects) as "object", a."resizePath", a."deviceAssetId", a."deviceId"
        FROM assets a
        LEFT JOIN smart_info si ON a.id = si."assetId"
        WHERE a."ownerId" = $1
        AND a."isVisible" = true
        AND si.objects IS NOT NULL
      `,
      [userId],
    );
  }

  getLocationsByUserId(userId: string): Promise<CuratedLocationsResponseDto[]> {
    return this.assetRepository.query(
      `
        SELECT DISTINCT ON (e.city) a.id, e.city, a."resizePath", a."deviceAssetId", a."deviceId"
        FROM assets a
        LEFT JOIN exif e ON a.id = e."assetId"
        WHERE a."ownerId" = $1
        AND a."isVisible" = true
        AND e.city IS NOT NULL
        AND a.type = 'IMAGE';
      `,
      [userId],
    );
  }

  /**
   * Get a single asset information by its ID
   * - include exif info
   * @param assetId
   */
  getById(assetId: string): Promise<AssetEntity> {
    return this.assetRepository.findOneOrFail({
      where: {
        id: assetId,
      },
      relations: {
        exifInfo: true,
        tags: true,
        sharedLinks: true,
        smartInfo: true,
        owner: true,
        faces: {
          person: true,
        },
        stack: {
          exifInfo: true,
        },
      },
      // We are specifically asking for this asset. Return it even if it is soft deleted
      withDeleted: true,
    });
  }

  /**
   * Get all assets belong to the user on the database
   * @param ownerId
   */
  getAllByUserId(ownerId: string, dto: AssetSearchDto): Promise<AssetEntity[]> {
    return this.assetRepository.find({
      where: {
        ownerId,
        isVisible: true,
        isFavorite: dto.isFavorite,
        isArchived: dto.isArchived,
        updatedAt: OptionalBetween(dto.updatedAfter, dto.updatedBefore),
      },
      relations: {
        exifInfo: true,
        tags: true,
        stack: true,
      },
      skip: dto.skip || 0,
      take: dto.take,
      order: {
        fileCreatedAt: 'DESC',
      },
      withDeleted: true,
    });
  }

  get(id: string): Promise<AssetEntity | null> {
    return this.assetRepository.findOne({
      where: { id },
      relations: {
        faces: {
          person: true,
        },
        library: true,
      },
      withDeleted: true,
    });
  }

  create(asset: AssetCreate): Promise<AssetEntity> {
    return this.assetRepository.save(asset);
  }

  async upsertExif(exif: Partial<ExifEntity>): Promise<void> {
    await this.exifRepository.upsert(exif, { conflictPaths: ['assetId'] });
  }

  /**
   * Get assets by device's Id on the database
   * @param ownerId
   * @param deviceId
   *
   * @returns Promise<string[]> - Array of assetIds belong to the device
   */
  async getAllByDeviceId(ownerId: string, deviceId: string): Promise<string[]> {
    const items = await this.assetRepository.find({
      select: { deviceAssetId: true },
      where: {
        ownerId,
        deviceId,
        isVisible: true,
      },
      withDeleted: true,
    });

    return items.map((asset) => asset.deviceAssetId);
  }

  /**
   * Get assets by checksums on the database
   * @param ownerId
   * @param checksums
   *
   */
  getAssetsByChecksums(ownerId: string, checksums: Buffer[]): Promise<AssetCheck[]> {
    return this.assetRepository.find({
      select: {
        id: true,
        checksum: true,
      },
      where: {
        ownerId,
        checksum: In(checksums),
      },
      withDeleted: true,
    });
  }

  async getExistingAssets(ownerId: string, checkDuplicateAssetDto: CheckExistingAssetsDto): Promise<string[]> {
    const assets = await this.assetRepository.find({
      select: { deviceAssetId: true },
      where: {
        deviceAssetId: In(checkDuplicateAssetDto.deviceAssetIds),
        deviceId: checkDuplicateAssetDto.deviceId,
        ownerId,
      },
      withDeleted: true,
    });
    return assets.map((asset) => asset.deviceAssetId);
  }

  getByOriginalPath(originalPath: string): Promise<AssetOwnerCheck | null> {
    return this.assetRepository.findOne({
      select: {
        id: true,
        ownerId: true,
        checksum: true,
      },
      where: {
        originalPath,
      },
    });
  }
}
