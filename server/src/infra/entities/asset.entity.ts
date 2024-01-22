import {
  Column,
  CreateDateColumn,
  DeleteDateColumn,
  Entity,
  Index,
  JoinColumn,
  JoinTable,
  ManyToMany,
  ManyToOne,
  OneToMany,
  OneToOne,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm';
import { AlbumEntity } from './album.entity';
import { AssetFaceEntity } from './asset-face.entity';
import { AssetJobStatusEntity } from './asset-job-status.entity';
import { ExifEntity } from './exif.entity';
import { LibraryEntity } from './library.entity';
import { SharedLinkEntity } from './shared-link.entity';
import { SmartInfoEntity } from './smart-info.entity';
import { SmartSearchEntity } from './smart-search.entity';
import { TagEntity } from './tag.entity';
import { UserEntity } from './user.entity';

export const ASSET_CHECKSUM_CONSTRAINT = 'UQ_assets_owner_library_checksum';

@Entity('assets')
// Checksums must be unique per user and library
@Index(ASSET_CHECKSUM_CONSTRAINT, ['owner', 'library', 'checksum'], {
  unique: true,
})
@Index('IDX_day_of_month', { synchronize: false })
@Index('IDX_month', { synchronize: false })
@Index('IDX_originalPath_libraryId', ['originalPath', 'libraryId'])
@Index(['stackParentId'])
// For all assets, each originalpath must be unique per user and library
export class AssetEntity {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column()
  deviceAssetId!: string;

  @ManyToOne(() => UserEntity, { onDelete: 'CASCADE', onUpdate: 'CASCADE', nullable: false })
  owner!: UserEntity;

  @Column()
  ownerId!: string;

  @ManyToOne(() => LibraryEntity, { onDelete: 'CASCADE', onUpdate: 'CASCADE', nullable: false })
  library!: LibraryEntity;

  @Column()
  libraryId!: string;

  @Column()
  deviceId!: string;

  @Column()
  type!: AssetType;

  @Column()
  originalPath!: string;

  @Column({ type: 'varchar', nullable: true })
  resizePath!: string | null;

  @Column({ type: 'varchar', nullable: true, default: '' })
  webpPath!: string | null;

  @Column({ type: 'bytea', nullable: true })
  thumbhash!: Buffer | null;

  @Column({ type: 'varchar', nullable: true, default: '' })
  encodedVideoPath!: string | null;

  @CreateDateColumn({ type: 'timestamptz' })
  createdAt!: Date;

  @UpdateDateColumn({ type: 'timestamptz' })
  updatedAt!: Date;

  @DeleteDateColumn({ type: 'timestamptz', nullable: true })
  deletedAt!: Date | null;

  @Column({ type: 'timestamptz' })
  fileCreatedAt!: Date;

  @Column({ type: 'timestamptz' })
  localDateTime!: Date;

  @Column({ type: 'timestamptz' })
  fileModifiedAt!: Date;

  @Column({ type: 'boolean', default: false })
  isFavorite!: boolean;

  @Column({ type: 'boolean', default: false })
  isArchived!: boolean;

  @Column({ type: 'boolean', default: false })
  isExternal!: boolean;

  @Column({ type: 'boolean', default: false })
  isReadOnly!: boolean;

  @Column({ type: 'boolean', default: false })
  isOffline!: boolean;

  @Column({ type: 'bytea' })
  @Index()
  checksum!: Buffer; // sha1 checksum

  @Column({ type: 'varchar', nullable: true })
  duration!: string | null;

  @Column({ type: 'boolean', default: true })
  isVisible!: boolean;

  @OneToOne(() => AssetEntity, { nullable: true, onUpdate: 'CASCADE', onDelete: 'SET NULL' })
  @JoinColumn()
  livePhotoVideo!: AssetEntity | null;

  @Column({ nullable: true })
  livePhotoVideoId!: string | null;

  @Column({ type: 'varchar' })
  @Index()
  originalFileName!: string;

  @Column({ type: 'varchar', nullable: true })
  sidecarPath!: string | null;

  @OneToOne(() => ExifEntity, (exifEntity) => exifEntity.asset)
  exifInfo?: ExifEntity;

  @OneToOne(() => SmartInfoEntity, (smartInfoEntity) => smartInfoEntity.asset)
  smartInfo?: SmartInfoEntity;

  @OneToOne(() => SmartSearchEntity, (smartSearchEntity) => smartSearchEntity.asset)
  smartSearch?: SmartSearchEntity;

  @ManyToMany(() => TagEntity, (tag) => tag.assets, { cascade: true })
  @JoinTable({ name: 'tag_asset' })
  tags!: TagEntity[];

  @ManyToMany(() => SharedLinkEntity, (link) => link.assets, { cascade: true })
  @JoinTable({ name: 'shared_link__asset' })
  sharedLinks!: SharedLinkEntity[];

  @ManyToMany(() => AlbumEntity, (album) => album.assets, { onDelete: 'CASCADE', onUpdate: 'CASCADE' })
  albums?: AlbumEntity[];

  @OneToMany(() => AssetFaceEntity, (assetFace) => assetFace.asset)
  faces!: AssetFaceEntity[];

  @Column({ nullable: true })
  stackParentId?: string | null;

  @ManyToOne(() => AssetEntity, (asset) => asset.stack, { nullable: true, onDelete: 'SET NULL', onUpdate: 'CASCADE' })
  @JoinColumn({ name: 'stackParentId' })
  stackParent?: AssetEntity | null;

  @OneToMany(() => AssetEntity, (asset) => asset.stackParent)
  stack?: AssetEntity[];

  @OneToOne(() => AssetJobStatusEntity, (jobStatus) => jobStatus.asset, { nullable: true })
  jobStatus?: AssetJobStatusEntity;
}

export enum AssetType {
  IMAGE = 'IMAGE',
  VIDEO = 'VIDEO',
  AUDIO = 'AUDIO',
  OTHER = 'OTHER',
}
