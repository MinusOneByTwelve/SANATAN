import { SameScopeNameResolutionOptions } from 'src/interfaces';

export class ScopeModeReplicationDto {
  replicationData: {
    [key: string]: { isSelected: boolean; selectedInstanceIds: number[] };
  };

  replicateToMode: string;

  replicateFromMode: string;

  sameScopeNameResolutionOption: SameScopeNameResolutionOptions;
}
