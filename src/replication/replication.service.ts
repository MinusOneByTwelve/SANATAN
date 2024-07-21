import { Injectable } from '@nestjs/common';
import { DatabaseService } from 'src/database/database.service';
import { SameScopeNameResolutionOptions } from 'src/interfaces';
import { ScopeModeReplicationDto } from './dto/ScopeModeReplication.dto';

@Injectable()
export class ReplicationService {
  constructor(private readonly databaseService: DatabaseService) {}

  async replicateScopeAcrossMode(
    scopeModeReplicationDto: ScopeModeReplicationDto,
  ) {
    const {
      replicationData,
      replicateFromMode,
      replicateToMode,
      sameScopeNameResolutionOption,
    } = scopeModeReplicationDto;
    for (const scopeKey of Object.keys(replicationData)) {
      const scopeReplicationChosen = replicationData[scopeKey];
      if (scopeReplicationChosen.isSelected) {
        const instancesSelected = scopeReplicationChosen.selectedInstanceIds;

        const scopeDetails = await this.databaseService.scope.findFirst({
          select: {
            name: true,
            description: true,
            isProcessed: true,
            isMixed: true,
            xPos: true,
            yPos: true,
            visionId: true,
            instances: {
              where: {
                id: {
                  in: instancesSelected,
                },
              },
              select: {
                visionId: true,
                providerId: true,
                name: true,
                configurationDetails: true,
                secretId: true,
              },
            },
          },
          where: {
            id: +scopeKey,
            modeId: replicateFromMode,
          },
        });

        const {
          name,
          description,
          isProcessed,
          isMixed,
          xPos,
          yPos,
          visionId,
          instances,
        } = scopeDetails;

        const scopeCreation = async () => {
          await this.databaseService.scope.create({
            data: {
              name,
              description,
              isProcessed,
              isMixed,
              xPos,
              yPos,
              visionId,
              modeId: replicateToMode,
              instances: {
                create: instances.map((instance) => ({
                  ...instance,
                  ip: 'N.A',
                })),
              },
            },
          });
        };

        const existingScope = await this.getExistingScope(
          name,
          replicateToMode,
        );

        switch (sameScopeNameResolutionOption) {
          case SameScopeNameResolutionOptions.OVERWRITE:
            // Check if a scope exists with the same name in the replicateToMode
            if (existingScope) {
              await this.databaseService.scope.delete({
                where: {
                  id: existingScope.id,
                },
              });
            }
            await scopeCreation();
            break;
          case SameScopeNameResolutionOptions.MERGE:
            if (existingScope) {
              await this.databaseService.scope.update({
                where: {
                  id: existingScope.id,
                },
                data: {
                  instances: {
                    createMany: {
                      data: instances.map((instance) => ({
                        ...instance,
                        ip: 'N.A',
                      })),
                    },
                  },
                },
              });
            } else {
              await scopeCreation();
            }
            break;
          case SameScopeNameResolutionOptions.COPY:
          default:
            await scopeCreation();
            break;
        }
      }
    }
  }

  async getExistingScope(name: string, modeId: string) {
    return this.databaseService.scope.findFirst({
      where: {
        name,
        modeId,
      },
    });
  }
}
