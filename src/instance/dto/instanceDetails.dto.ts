import {
  IsArray,
  IsBoolean,
  IsNumber,
  IsOptional,
  IsString,
} from 'class-validator';
import { DiskDetailsDto } from './diskDetails.dto';

export class InstanceDetailsDto {
  @IsNumber()
  copies: number;

  @IsArray({
    each: true,
  })
  disks: DiskDetailsDto;

  @IsString()
  @IsOptional()
  instanceType?: string;

  @IsString()
  namingConvention: string;

  @IsString()
  region?: string;

  @IsBoolean()
  isNewSecret: boolean;

  @IsString()
  secretFileLocation: string;

  @IsString()
  @IsOptional()
  secretsEncryptionKey?: string;

  @IsBoolean()
  isNewServiceAccount: boolean;

  @IsString()
  serviceAccountFileLocation: string;

  @IsString()
  @IsOptional()
  serviceAccountEncryptionKey?: string;

  @IsString()
  @IsOptional()
  zone?: string;
}
