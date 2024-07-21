import { IsOptional, IsString } from 'class-validator';
import { IMode } from 'src/interfaces';

export class CreateVisionDto {
  @IsString()
  name: string;

  @IsOptional()
  description?: string;

  @IsOptional()
  modes: IMode[];
}
