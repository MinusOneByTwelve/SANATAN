import { Body, Controller, Post } from '@nestjs/common';
import { ScopeModeReplicationDto } from './dto/ScopeModeReplication.dto';
import { ReplicationService } from './replication.service';

@Controller('replication')
export class ReplicationController {
  constructor(private replicationService: ReplicationService) {}
  @Post('scope')
  replicateScopeAcrossMode(
    @Body('data') scopeModeReplicationDto: ScopeModeReplicationDto,
  ) {
    return this.replicationService.replicateScopeAcrossMode(
      scopeModeReplicationDto,
    );
  }
}
