import { Injectable } from '@nestjs/common';
import { DatabaseService } from 'src/database/database.service';
import { InstanceService } from 'src/instance/instance.service';
import { CreateScopeDto } from './dto/createScope.dto';
import { UpdateScopeDto } from './dto/update-scope.dto';

@Injectable()
export class ScopeService {
  constructor(
    private readonly databaseService: DatabaseService,
    private readonly instanceService: InstanceService,
  ) {}

  create(createScopeDto: CreateScopeDto) {
    return this.databaseService.scope.create({
      data: createScopeDto,
    });
  }

  async findAll(visionId: number, isFetchInstances = false, modeId: string) {
    const includedRelations = {};

    if (isFetchInstances) {
      Object.assign(includedRelations, {
        instances: true,
      });
    }

    const scopes = await this.databaseService.scope.findMany({
      relationLoadStrategy: 'join',
      include: includedRelations,
      where: {
        visionId,
        modeId,
      },
      orderBy: {
        updatedAt: 'desc',
      },
    });
    return { data: scopes };
  }

  async getAllInstances(scopeId: number) {
    const allInstances = await this.instanceService.getAllInstances(scopeId);
    return { data: allInstances };
  }

  findOne(visionId: number, scopeId: number) {
    return this.databaseService.scope.findUnique({
      where: {
        id: scopeId,
        visionId,
      },
    });
  }

  updateScope(scopeId: number, updateScopeDto: UpdateScopeDto) {
    return this.databaseService.scope.update({
      where: {
        id: scopeId,
      },
      data: updateScopeDto,
    });
  }

  async deleteScope(visionId: number, scopeId: number) {
    // await this.databaseService.instance.deleteMany({
    //   where: {
    //     scopeId,
    //     visionId,
    //   },
    // });
    return this.databaseService.scope.delete({
      where: {
        id: scopeId,
        visionId,
      },
    });
  }
}
