export enum PROVIDER_ACRONYM {
  AWS = 'AWS',
  GCP = 'GCP',
  AZURE = 'AZURE',
  E2E = 'E2E',
  OP = 'OP',
}

export enum SECRET_TYPE {
  SECRET = 'SECRET',
  SERVICE_ACCOUNT = 'SERVICE_ACCOUNT',
}

export enum SameScopeNameResolutionOptions {
  COPY = 'copy',
  MERGE = 'merge',
  OVERWRITE = 'overwrite',
}

export interface IMode {
  id?: number;
  modeId: string;
  label: string;
  color: string;
}

export interface IProvider {
  id: number;
  icon: string;
  name: string;
  acronym: PROVIDER_ACRONYM;
  providerColor: string;
  showName: boolean;
  needsSecretKey: boolean;
  needsServiceAccount: boolean;
}

export interface IStackOption {
  id?: number;
  name: string;
  version?: string;
  downloadUrl: string;
  iconUrl: string;
  identifier?: string;
  identifierId: number;
  suite?: string;
  suiteVersion?: string;
  properties?: { name: string; value: string; type: string }[];
  isOpen?: boolean;
  defaultMemory?: number;
  defaultCores?: number;
}

export const NA = 'N.A';
