import { GeodataAdmin1Entity } from '@app/infra/entities/geodata-admin1.entity';
import { GeodataAdmin2Entity } from '@app/infra/entities/geodata-admin2.entity';
import { Column, Entity, ManyToOne, PrimaryColumn } from 'typeorm';

@Entity('geodata_places', { synchronize: false })
export class GeodataPlacesEntity {
  @PrimaryColumn({ type: 'integer' })
  id!: number;

  @Column({ type: 'varchar', length: 200 })
  name!: string;

  @Column({ type: 'float' })
  longitude!: number;

  @Column({ type: 'float' })
  latitude!: number;

  // @Column({
  //   generatedType: 'STORED',
  //   asExpression: 'll_to_earth((latitude)::double precision, (longitude)::double precision)',
  //   type: 'earth',
  // })
  earthCoord!: unknown;

  @Column({ type: 'char', length: 2 })
  countryCode!: string;

  @Column({ type: 'varchar', length: 20, nullable: true })
  admin1Code!: string;

  @Column({ type: 'varchar', length: 80, nullable: true })
  admin2Code!: string;

  @Column({
    type: 'varchar',
    generatedType: 'STORED',
    asExpression: `"countryCode" || '.' || "admin1Code"`,
    nullable: true,
  })
  admin1Key!: string;

  @ManyToOne(() => GeodataAdmin1Entity, { eager: true, nullable: true, createForeignKeyConstraints: false })
  admin1!: GeodataAdmin1Entity;

  @Column({
    type: 'varchar',
    generatedType: 'STORED',
    asExpression: `"countryCode" || '.' || "admin1Code" || '.' || "admin2Code"`,
    nullable: true,
  })
  admin2Key!: string;

  @ManyToOne(() => GeodataAdmin2Entity, { eager: true, nullable: true, createForeignKeyConstraints: false })
  admin2!: GeodataAdmin2Entity;

  @Column({ type: 'date' })
  modificationDate!: Date;
}
