import { IsNumber } from 'class-validator';
import { IProvider } from 'src/interfaces';
import { InstanceDetailsDto } from './instanceDetails.dto';

export class CreateInstanceDto {
  providerSelected: IProvider;

  instanceDetails: InstanceDetailsDto;

  @IsNumber()
  visionId: number;

  @IsNumber()
  scopeId: number;
}
