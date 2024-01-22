import { IsNotEmpty, IsString } from 'class-validator';
import { Optional } from '../domain.util';
export class APIKeyCreateDto {
  @IsString()
  @IsNotEmpty()
  @Optional()
  name?: string;
}

export class APIKeyUpdateDto {
  @IsString()
  @IsNotEmpty()
  name!: string;
}

export class APIKeyCreateResponseDto {
  secret!: string;
  apiKey!: APIKeyResponseDto;
}

export class APIKeyResponseDto {
  id!: string;
  name!: string;
  createdAt!: Date;
  updatedAt!: Date;
}
