import { GeodataAdmin2Entity } from '@app/infra/entities/geodata-admin2.entity';
import { ActivityEntity } from './activity.entity';
import { AlbumEntity } from './album.entity';
import { APIKeyEntity } from './api-key.entity';
import { AssetFaceEntity } from './asset-face.entity';
import { AssetJobStatusEntity } from './asset-job-status.entity';
import { AssetEntity } from './asset.entity';
import { AuditEntity } from './audit.entity';
import { ExifEntity } from './exif.entity';
import { GeodataAdmin1Entity } from './geodata-admin1.entity';
import { GeodataPlacesEntity } from './geodata-places.entity';
import { LibraryEntity } from './library.entity';
import { MoveEntity } from './move.entity';
import { PartnerEntity } from './partner.entity';
import { PersonEntity } from './person.entity';
import { SharedLinkEntity } from './shared-link.entity';
import { SmartInfoEntity } from './smart-info.entity';
import { SmartSearchEntity } from './smart-search.entity';
import { SystemConfigEntity } from './system-config.entity';
import { SystemMetadataEntity } from './system-metadata.entity';
import { TagEntity } from './tag.entity';
import { UserTokenEntity } from './user-token.entity';
import { UserEntity } from './user.entity';

export * from './activity.entity';
export * from './album.entity';
export * from './api-key.entity';
export * from './asset-face.entity';
export * from './asset-job-status.entity';
export * from './asset.entity';
export * from './audit.entity';
export * from './exif.entity';
export * from './geodata-admin1.entity';
export * from './geodata-admin2.entity';
export * from './geodata-places.entity';
export * from './library.entity';
export * from './move.entity';
export * from './partner.entity';
export * from './person.entity';
export * from './shared-link.entity';
export * from './smart-info.entity';
export * from './smart-search.entity';
export * from './system-config.entity';
export * from './system-metadata.entity';
export * from './tag.entity';
export * from './user-token.entity';
export * from './user.entity';

export const databaseEntities = [
  ActivityEntity,
  AlbumEntity,
  APIKeyEntity,
  AssetEntity,
  AssetFaceEntity,
  AssetJobStatusEntity,
  AuditEntity,
  ExifEntity,
  GeodataPlacesEntity,
  GeodataAdmin1Entity,
  GeodataAdmin2Entity,
  MoveEntity,
  PartnerEntity,
  PersonEntity,
  SharedLinkEntity,
  SmartInfoEntity,
  SmartSearchEntity,
  SystemConfigEntity,
  SystemMetadataEntity,
  TagEntity,
  UserEntity,
  UserTokenEntity,
  LibraryEntity,
];
