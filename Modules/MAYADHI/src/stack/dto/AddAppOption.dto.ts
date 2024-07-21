import { IsBoolean, IsString } from 'class-validator';

export class AddAppOptionDto {
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

  @IsString()
  suite?: string;

  @IsString()
  suiteVersion?: string;

  properties?: { name: string; value: string; type: string }[];

  @IsBoolean()
  isOpen?: boolean;
}
