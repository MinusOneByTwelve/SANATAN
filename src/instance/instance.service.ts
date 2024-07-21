import { BadRequestException, Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { DatabaseService } from 'src/database/database.service';
import { NA, PROVIDER_ACRONYM } from 'src/interfaces';
import { SecretsService } from 'src/secrets/secrets.service';
import { AppsDataDto } from './dto/appsData.dto';
import { CreateInstanceDto } from './dto/create-instance.dto';

@Injectable()
export class InstanceService {
  constructor(
    private readonly databaseService: DatabaseService,
    private readonly secretService: SecretsService,
  ) {}

  async create(createInstanceDto: CreateInstanceDto) {
    const { providerSelected, instanceDetails, scopeId, visionId } =
      createInstanceDto;

    // console.log(instanceDetails);

    const {
      copies,
      disks,
      namingConvention,
      instanceType,
      region,
      zone,
      isNewSecret,
      secretFileLocation,
      secretsEncryptionKey,
    } = instanceDetails;

    let secretIdToMap = 0;

    if (!Number(copies)) {
      throw new BadRequestException(
        'Number of instances creation should be > 0',
      );
    }

    return this.databaseService.$transaction(
      async (tx) => {
        const secretFound = await this.secretService.findSecret(
          visionId,
          secretFileLocation,
          providerSelected.id,
        );

        if (secretFound) {
          secretIdToMap = secretFound.id;
        } else {
          if (isNewSecret) {
            // Persist an entry in the Secrets table
            const secretCreated = await this.secretService.addSecret(visionId, {
              fileName: secretFileLocation,
              key: secretsEncryptionKey,
              providerId: providerSelected.id,
            });
            secretIdToMap = secretCreated.id;
          }
        }

        if (!secretIdToMap) {
          throw new BadRequestException(
            'No matching secret file found. Please provide a new one.!!',
          );
        }

        const instancesCreated = [];
        if (providerSelected.acronym === PROVIDER_ACRONYM.AWS) {
          for (let index = 0; index < +copies; index++) {
            const instanceObject: Prisma.InstanceCreateInput = {
              provider: {
                connect: {
                  id: providerSelected.id,
                },
              },
              scope: {
                connect: {
                  id: scopeId,
                },
              },
              visionId,
              secrets: {
                connect: {
                  id: secretIdToMap,
                },
              },
              configurationDetails: JSON.stringify({
                instanceType,
                region,
                zone,
                disks,
              }),
              name: NA,
              ip: NA,
            };

            const instanceCreated = await tx.instance.create({
              data: instanceObject,
            });

            instanceCreated.name = `${namingConvention}-${instanceCreated.id}`;
            const instanceUpdated = await tx.instance.update({
              where: {
                id: instanceCreated.id,
              },
              data: instanceCreated,
            });

            instancesCreated.push(instanceUpdated);
            // instancesToCreate.push(instanceObject);
          }

          // const instancesCreated = await tx.instance.createManyAndReturn({
          //   data: instancesToCreate,
          // });
          // console.log(instancesCreated);
          return instancesCreated;
        }
      },
      {
        maxWait: 5000, // 5 seconds max wait to connect to prisma
        timeout: 20000, // 20 seconds
        isolationLevel: Prisma.TransactionIsolationLevel.Serializable,
      },
    );
  }

  async getAllInstances(scopeId: number) {
    return this.databaseService.instance.findMany({
      relationLoadStrategy: 'join',
      include: {
        apps: {
          select: {
            appId: true,
            isUnfulfilled: true,
            id: true,
          },
        },
      },
      where: {
        scopeId,
      },
    });
  }

  findInstanceDetails(instanceId: number) {
    return this.databaseService.instance.findUnique({
      relationLoadStrategy: 'join',
      include: {
        apps: true,
      },
      where: {
        id: instanceId,
      },
    });
  }

  // update(instanceId: number, updateInstanceDto: UpdateInstanceDto) {
  //   return `This action updates a #${id} instance`;
  // }
  async modifyApps(instanceId: number, appsDataDto: AppsDataDto) {
    const { apps, deletedAppIds = [] } = appsDataDto;

    const newInstanceAppPromises = [];
    const updateInstanceAppPromises = [];
    const deleteInstanceAppPromises = [];

    for (const app of apps) {
      if (app.isNewlyAdded) {
        const instanceAppObject: Prisma.InstanceAppsCreateInput = {
          instance: {
            connect: {
              id: instanceId,
            },
          },
          app: {
            connect: {
              identifierId: app.identifierId,
            },
          },
          cores: app.cores,
          memory: app.memory,
          properties: JSON.stringify(app.properties),
          isUnfulfilled: true,
          isManager: false,
          isWorker: true,
        };
        newInstanceAppPromises.push(
          this.databaseService.instanceApps.create({
            data: instanceAppObject,
          }),
        );
        // newInstanceAppObjects.push(instanceAppObject);
      } else {
        updateInstanceAppPromises.push(
          this.databaseService.instanceApps.update({
            where: {
              id: app.id,
            },
            data: {
              cores: app.cores,
              memory: app.memory,
              properties: JSON.stringify(app.properties),
            },
          }),
        );
      }
    }

    for (const deletedAppId of deletedAppIds) {
      deleteInstanceAppPromises.push(
        this.databaseService.instanceApps.delete({
          where: {
            id: deletedAppId,
          },
        }),
      );
    }

    if (updateInstanceAppPromises.length > 0) {
      await Promise.all(updateInstanceAppPromises);
    }

    if (newInstanceAppPromises.length > 0) {
      await Promise.all(newInstanceAppPromises);
    }

    if (deleteInstanceAppPromises.length > 0) {
      await Promise.all(deleteInstanceAppPromises);
    }

    return this.findInstanceDetails(instanceId);
  }

  remove(instanceId: number) {
    return this.databaseService.instance.delete({
      where: {
        id: instanceId,
      },
    });
  }
}
