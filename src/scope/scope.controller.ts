import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  ParseIntPipe,
  Patch,
  Post,
  Query,
} from '@nestjs/common';
import { IdTransformerPipe } from 'src/id-transformer/id-transformer.pipe';
import { CreateScopeDto } from './dto/createScope.dto';
import { UpdateScopeDto } from './dto/update-scope.dto';
import { ScopeService } from './scope.service';

@Controller('scope')
export class ScopeController {
  constructor(private readonly scopeService: ScopeService) {}

  @Post()
  create(@Body('data', IdTransformerPipe) createScopeDto: CreateScopeDto) {
    return this.scopeService.create(createScopeDto);
  }

  @Get(':visionId/getAllScopes')
  findAll(
    @Param('visionId', ParseIntPipe) visionId: number,
    @Query('fetchInstances') fetchInstances?: boolean,
    @Query('modeId') modeId?: string,
  ) {
    return this.scopeService.findAll(visionId, Boolean(fetchInstances), modeId);
  }

  @Get(':scopeId/allInstances/')
  findAllInstances(@Param('scopeId', ParseIntPipe) scopeId: number) {
    return this.scopeService.getAllInstances(scopeId);
  }

  @Get(':visionId/:scopeId')
  findOne(
    @Param('visionId', ParseIntPipe) visionId: number,
    @Param('scopeId', ParseIntPipe) scopeId: number,
  ) {
    return this.scopeService.findOne(visionId, scopeId);
  }

  @Patch(':scopeId')
  updateScope(
    @Param('scopeId', ParseIntPipe) scopeId: number,
    @Body('data') updateScopeDto: UpdateScopeDto,
  ) {
    return this.scopeService.updateScope(scopeId, updateScopeDto);
  }

  @Delete(':visionId/:scopeId')
  deleteScope(
    @Param('visionId', ParseIntPipe) visionId: number,
    @Param('scopeId', ParseIntPipe) scopeId: number,
  ) {
    return this.scopeService.deleteScope(visionId, scopeId);
  }
}
