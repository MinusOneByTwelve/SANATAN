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
import { CreateVisionDto } from './dto/createVision.dto';
import { VisionService } from './vision.service';

@Controller('vision')
export class VisionController {
  constructor(private readonly visionService: VisionService) {}
  @Get()
  getAllVisions() {
    return this.visionService.getAllVisions();
  }

  @Get('/:id')
  getVision(
    @Param('id', ParseIntPipe) visionId: number,
    @Query('scopes') fetchScopes?: boolean,
    @Query('modeId') modeId?: string,
  ) {
    return this.visionService.getVision(visionId, Boolean(fetchScopes), modeId);
  }

  @Post()
  createVision(@Body('data') createVisionDto: CreateVisionDto) {
    return this.visionService.createVision(createVisionDto);
  }

  @Patch('/:id')
  updateVision(
    @Param('id', ParseIntPipe) visionId: number,
    @Body('data') updateVisionDto: Partial<CreateVisionDto>,
  ) {
    return this.visionService.updateVision(visionId, updateVisionDto);
  }

  @Delete('/:id')
  deleteVision(@Param('id', ParseIntPipe) visionId: number) {
    return this.visionService.deleteVision(visionId);
  }
}
