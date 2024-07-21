import { Module } from '@nestjs/common';
import { InstanceModule } from 'src/instance/instance.module';
import { ScopeController } from './scope.controller';
import { ScopeService } from './scope.service';

@Module({
  imports: [InstanceModule],
  controllers: [ScopeController],
  providers: [ScopeService],
})
export class ScopeModule {}
