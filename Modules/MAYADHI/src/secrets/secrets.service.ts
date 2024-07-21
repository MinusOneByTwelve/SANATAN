import { Injectable } from '@nestjs/common';
import { DatabaseService } from 'src/database/database.service';
import { CreateSecretDto } from './createSecret.dto';

@Injectable()
export class SecretsService {
  constructor(private readonly databaseService: DatabaseService) {}

  async getAllSecrets(visionId: number) {
    const allSecrets = await this.databaseService.secrets.findMany({
      where: {
        visionId,
      },
    });
    return { data: allSecrets };
  }

  async addSecret(visionId: number, createSecretDto: CreateSecretDto) {
    return this.databaseService.secrets.create({
      data: {
        ...createSecretDto,
        visionId,
        userId: 0,
      },
    });
  }

  async findSecret(
    visionId: number,
    secretFileLocation: string,
    providerId: number,
  ) {
    return this.databaseService.secrets.findFirst({
      where: {
        fileName: secretFileLocation,
        providerId,
        visionId,
      },
    });
  }
}
