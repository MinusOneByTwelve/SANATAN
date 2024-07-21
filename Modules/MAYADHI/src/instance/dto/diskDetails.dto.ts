import { IsBoolean, IsEnum, IsNumber, IsString } from 'class-validator';

export enum DiskType {
  SSD = 'SSD',
  HDD = 'HDD',
}

export class DiskDetailsDto {
  @IsEnum(DiskType)
  diskType: DiskType;

  @IsString()
  id: string;

  @IsNumber()
  index: number;

  @IsString()
  internalDiskName: string;

  @IsBoolean()
  isOS: boolean;

  @IsNumber()
  size: number;
}
