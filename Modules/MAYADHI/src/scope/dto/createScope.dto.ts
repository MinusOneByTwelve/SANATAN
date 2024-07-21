import { IsNumber, IsOptional, IsString } from 'class-validator';

export class CreateScopeDto {
  @IsNumber()
  visionId: number;

  @IsString()
  modeId: string;

  @IsString()
  name: string;

  @IsOptional()
  description?: string;
}
