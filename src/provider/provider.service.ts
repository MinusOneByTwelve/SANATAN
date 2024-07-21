import { Injectable } from '@nestjs/common';
import { DatabaseService } from 'src/database/database.service';

@Injectable()
export class ProviderService {
  constructor(private readonly databaseService: DatabaseService) {}

  async getAllProviders() {
    const providersList = await this.databaseService.provider.findMany();
    return { data: providersList };
  }
}
