import { Injectable } from '@nestjs/common';
import { DatabaseService } from 'src/database/database.service';
import { CreateVisionDto } from './dto/createVision.dto';

@Injectable()
export class VisionService {
  constructor(private readonly databaseService: DatabaseService) {}
  async getAllVisions() {
    const visions = await this.databaseService.vision.findMany({
      relationLoadStrategy: 'join',
      include: {
        modes: {
          select: {
            color: true,
            id: true,
            label: true,
            modeId: true,
          },
        },
      },
      orderBy: {
        updatedAt: 'desc',
      },
    });
    return { data: visions };
  }

  async getVision(visionId: number, isFetchScopes = false, modeId: string) {
    const includedRelations = {
      modes: {
        select: {
          color: true,
          id: true,
          label: true,
          modeId: true,
        },
      },
    };

    if (isFetchScopes) {
      Object.assign(includedRelations, {
        scopes: {
          where: {
            modeId,
          },
        },
      });
    }
    const details = await this.databaseService.vision.findUnique({
      relationLoadStrategy: 'join',
      include: includedRelations,
      where: {
        id: visionId,
      },
    });

    return { data: details };
  }

  async createVision(createVisionDto: CreateVisionDto) {
    return this.databaseService.vision.create({
      data: {
        name: createVisionDto.name,
        description: createVisionDto.description,
        modes: {
          createMany: {
            data: [...createVisionDto.modes],
          },
        },
      },
    });
  }

  async updateVision(
    visionId: number,
    updateVisionDto: Partial<CreateVisionDto>,
  ) {
    return this.databaseService.vision.update({
      where: {
        id: visionId,
      },
      data: {
        name: updateVisionDto.name,
        description: updateVisionDto.description,
      },
    });
  }

  async deleteVision(visionId: number) {
    // await this.databaseService.mode.deleteMany({
    //   where: {
    //     visionId,
    //   },
    // });
    return this.databaseService.vision.delete({
      where: {
        id: visionId,
      },
    });
  }
}
