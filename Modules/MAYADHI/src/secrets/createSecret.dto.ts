import { IsInt, IsString } from 'class-validator';

export class CreateSecretDto {
  @IsString()
  fileName: string;

  @IsString()
  key: string;

  @IsInt()
  providerId: number;
}
