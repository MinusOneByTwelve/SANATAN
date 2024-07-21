import { Injectable } from '@nestjs/common';
import { DatabaseService } from 'src/database/database.service';
import { AddAppOptionDto } from './dto/AddAppOption.dto';
import { UpdateAppOptionDto } from './dto/UpdateAppOption.dto';

@Injectable()
export class SoftwareAppService {
  constructor(private readonly databaseService: DatabaseService) {}

  async getAllStackOptions() {
    const stackOptions = await this.databaseService.apps.findMany();
    return { data: stackOptions };
  }

  async updateStackOption(updateAppOptionDto: UpdateAppOptionDto) {
    if (updateAppOptionDto.identifierId) {
      this.databaseService.apps.update({
        where: {
          id: updateAppOptionDto.id,
          identifierId: updateAppOptionDto.identifierId,
        },
        data: {
          ...updateAppOptionDto,
          properties: JSON.stringify(updateAppOptionDto.properties ?? {}),
        },
      });
    }
  }

  async createNewStackOption(addAppOptionDto: AddAppOptionDto) {
    this.databaseService.apps.create({
      data: {
        ...addAppOptionDto,
        properties: JSON.stringify(addAppOptionDto.properties ?? {}),
      },
    });
  }
}
