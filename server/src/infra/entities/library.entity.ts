import {
  Column,
  CreateDateColumn,
  DeleteDateColumn,
  Entity,
  JoinTable,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm';
import { AssetEntity } from './asset.entity';
import { UserEntity } from './user.entity';

@Entity('libraries')
export class LibraryEntity {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column()
  name!: string;

  @OneToMany(() => AssetEntity, (asset) => asset.library)
  @JoinTable()
  assets!: AssetEntity[];

  @ManyToOne(() => UserEntity, { onDelete: 'CASCADE', onUpdate: 'CASCADE', nullable: false })
  owner!: UserEntity;

  @Column()
  ownerId!: string;

  @Column()
  type!: LibraryType;

  @Column('text', { array: true })
  importPaths!: string[];

  @Column('text', { array: true })
  exclusionPatterns!: string[];

  @CreateDateColumn({ type: 'timestamptz' })
  createdAt!: Date;

  @UpdateDateColumn({ type: 'timestamptz' })
  updatedAt!: Date;

  @DeleteDateColumn({ type: 'timestamptz' })
  deletedAt?: Date;

  @Column({ type: 'timestamptz', nullable: true })
  refreshedAt!: Date | null;

  @Column({ type: 'boolean', default: true })
  isVisible!: boolean;
}

export enum LibraryType {
  UPLOAD = 'UPLOAD',
  EXTERNAL = 'EXTERNAL',
}
