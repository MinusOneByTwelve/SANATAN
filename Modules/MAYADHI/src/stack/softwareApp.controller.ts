import { Body, Controller, Get, Patch, Post } from '@nestjs/common';
import { AddAppOptionDto } from './dto/AddAppOption.dto';
import { UpdateAppOptionDto } from './dto/UpdateAppOption.dto';
import { SoftwareAppService } from './softwareApp.service';

@Controller('stack')
export class SoftwareAppController {
  constructor(private softwareAppService: SoftwareAppService) {}

  @Get('/options')
  getStackOptionList() {
    return this.softwareAppService.getAllStackOptions();
  }

  @Patch('/options')
  updateStackOption(@Body('data') updateAppOptionDto: UpdateAppOptionDto) {
    return this.softwareAppService.updateStackOption(updateAppOptionDto);
  }

  @Post('/options')
  createNewStackOption(@Body('data') addAppOptionDto: AddAppOptionDto) {
    return this.softwareAppService.createNewStackOption(addAppOptionDto);
  }
}
