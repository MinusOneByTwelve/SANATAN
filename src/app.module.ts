import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { DatabaseModule } from './database/database.module';
import { InstanceModule } from './instance/instance.module';
import { ProviderModule } from './provider/provider.module';
import { ScopeModule } from './scope/scope.module';
import { SecretsModule } from './secrets/secrets.module';
import { SoftwareAppModule } from './stack/softwareApp.module';
import { VisionModule } from './vision/vision.module';
import { ReplicationModule } from './replication/replication.module';
import { CsvModule } from './csv/csv.module';

@Module({
  imports: [
    VisionModule,
    DatabaseModule,
    ScopeModule,
    ProviderModule,
    SecretsModule,
    InstanceModule,
    SoftwareAppModule,
    ReplicationModule,
    CsvModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
