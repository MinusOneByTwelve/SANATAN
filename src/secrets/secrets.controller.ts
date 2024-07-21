import {
  Body,
  Controller,
  Get,
  Param,
  ParseIntPipe,
  Post,
} from '@nestjs/common';
import { CreateSecretDto } from './createSecret.dto';
import { SecretsService } from './secrets.service';

@Controller('secrets')
export class SecretsController {
  constructor(private readonly secretsService: SecretsService) {}

  @Get(':visionId')
  getAllSecrets(@Param('visionId', ParseIntPipe) visionId: number) {
    return this.secretsService.getAllSecrets(visionId);
  }

  @Post(':visionId')
  addSecret(
    @Param('visionId', ParseIntPipe) visionId: number,
    @Body('data') createSecretDto: CreateSecretDto,
  ) {
    return this.secretsService.addSecret(visionId, createSecretDto);
  }
}
