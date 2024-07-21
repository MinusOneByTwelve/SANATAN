import { Module } from '@nestjs/common';
import { SecretsModule } from 'src/secrets/secrets.module';
import { InstanceController } from './instance.controller';
import { InstanceService } from './instance.service';

@Module({
  imports: [SecretsModule],
  controllers: [InstanceController],
  providers: [InstanceService],
  exports: [InstanceService],
})
export class InstanceModule {}
