import {
  IsArray,
  IsBoolean,
  IsNumber,
  IsOptional,
  ValidateNested,
} from 'class-validator';

export class AppsDataDto {
  @ValidateNested()
  apps: AppsDto[];

  @IsArray()
  deletedAppIds: number[];
}

export class AppsDto {
  @IsOptional()
  id?: number;

  @IsNumber()
  cores: number;

  @IsNumber()
  identifierId: number;

  @IsBoolean()
  isNewlyAdded: boolean;

  @IsNumber()
  memory: number;

  @ValidateNested()
  properties: { name: string; value: string; type: string }[];
}
