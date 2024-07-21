import { IsBoolean, IsNumber, IsString } from 'class-validator';

export class UpdateAppOptionDto {
  @IsNumber()
  id?: number;

  @IsString()
  name: string;

  @IsString()
  version?: string;

  @IsString()
  documentationUrl?: string;

  @IsString()
  downloadUrl?: string;

  @IsString()
  iconUrl: string;

  @IsString()
  identifier: string;

  @IsNumber()
  identifierId?: number;

  @IsString()
  suite?: string;

  @IsString()
  suiteVersion?: string;

  properties?: { name: string; value: string; type: string }[];

  @IsBoolean()
  isOpen?: boolean;
}
