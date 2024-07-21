import { Module } from '@nestjs/common';
import { SoftwareAppController } from './softwareApp.controller';
import { SoftwareAppService } from './softwareApp.service';

@Module({
  controllers: [SoftwareAppController],
  providers: [SoftwareAppService],
})
export class SoftwareAppModule {}
