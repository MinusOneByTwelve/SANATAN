import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  ParseIntPipe,
  Post,
} from '@nestjs/common';
import { IdTransformerPipe } from 'src/id-transformer/id-transformer.pipe';
import { AppsDataDto } from './dto/appsData.dto';
import { CreateInstanceDto } from './dto/create-instance.dto';
import { InstanceService } from './instance.service';

@Controller('instance')
export class InstanceController {
  constructor(private readonly instanceService: InstanceService) {}

  @Post()
  create(
    @Body('data', IdTransformerPipe) createInstanceDto: CreateInstanceDto,
  ) {
    return this.instanceService.create(createInstanceDto);
  }

  @Get(':instanceId')
  findOne(@Param('instanceId', ParseIntPipe) instanceId: number) {
    return this.instanceService.findInstanceDetails(instanceId);
  }

  // @Patch(':instanceId')
  // update(
  //   @Param('instanceId', ParseIntPipe) instanceId: number,
  //   @Body() updateInstanceDto: UpdateInstanceDto,
  // ) {
  //   return this.instanceService.update(instanceId, updateInstanceDto);
  // }

  @Delete(':instanceId')
  remove(@Param('instanceId', ParseIntPipe) instanceId: number) {
    return this.instanceService.remove(instanceId);
  }

  @Post(':instanceId')
  modifyApps(
    @Param('instanceId', ParseIntPipe) instanceId: number,
    @Body('data') appsDataDto: AppsDataDto,
  ) {
    return this.instanceService.modifyApps(instanceId, appsDataDto);
  }
}
