import { IsString } from 'class-validator';

export class SystemConfigServerDto {
  @IsString()
  externalDomain!: string;

  @IsString()
  loginPageMessage!: string;
}
