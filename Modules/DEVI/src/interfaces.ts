export interface ISelectorOption {
  id: number | string;
  label: string;
  value: number | string;
  color?: string;
}

export interface IUser {
  accessToken: string;
  name: string;
  email: string;
}

export interface ISession {
  user: IUser;
}

export interface IVision {
  id: number;
  name: string;
  description: string;
  modes?: IMode[];
  scopes?: IScope[];
}

export interface IMode {
  modeId: string;
  label: string;
  color: string;
}

/************ SCOPE *******************/
export interface IScope {
  id: number;
  visionId: number;
  name: string;
  description: string;
  identityCount: number;
  isProcessed: boolean;
  isMixed: boolean;
  xPos: number;
  yPos: number;
  prevPos: { xPos: number; yPos: number };
  instances: IInstance[];
}

export interface IVisionForm {
  visionName: string;
  visionDescription: string;
  modes: IMode[];
}

export interface IScopeForm {
  scopeName: string;
  scopeDescription: string;
}
/************** SCOPE *****************/

export enum ProviderAcronym {
  AWS = "AWS",
  GCP = "GCP",
  AZURE = "AZURE",
  E2E = "E2E",
  OP = "OP",
}

export enum SecretType {
  SECRET = "SECRET",
  SERVICE_ACCOUNT = "SERVICE_ACCOUNT",
}

export enum SameScopeNameResolutionOptions {
  COPY = "copy",
  MERGE = "merge",
  OVERWRITE = "overwrite",
}

export const NA = "N.A";

export interface IProvider {
  id: number;
  icon: string;
  name: string;
  acronym: ProviderAcronym;
  providerColor: string;
  showName: boolean;
  needsSecretKey: boolean;
  needsServiceAccount: boolean;
}

export interface IInstanceConfigurationForm {}

export interface ISecret {
  id: number;
  visionId: number;
  userId: string;
  fileName: string;
  type: SecretType;
  providerId: number;
}

export interface IInstance {
  id: number;
  visionId: number;
  scopeId: number;
  providerId: number;
  name: string;
  ip: string;
  configurationDetails: IConfigurationDetails;
  isRunning: boolean;
  secretId: number;
  createdAt: string;
  updatedAt: string;
  cores: number;
  memory: number;
  reservedCores: number;
  reservedMemory: number;
  apps: IInstanceApp[];
  isSelected?: boolean; // only for UI - starts as false
  isMarkedForDeletion?: boolean; // only for UI - starts as false
  isMarkedForStop?: boolean; // only for UI - starts as false
  isMarkedForStart?: boolean; // only for UI - starts as false
}

export interface IConfigurationDetails {
  instanceType: string;
  region?: string;
  zone?: string;
}

export interface ICardDimensions {
  width: number;
  height: number;
}

export interface IAppOption {
  id?: number;
  name: string;
  version?: string;
  documentationUrl?: string;
  downloadUrl?: string;
  iconUrl?: string;
  identifier?: string;
  identifierId?: number;
  suite?: string;
  suiteVersion?: string;
  properties?: IProperty[];
  isOpen?: boolean;
  isEditMode?: boolean;
  isNewlyAdded?: boolean;
  uiId?: string;
  defaultMemory?: number;
  defaultCores?: number;
}

export interface IInstanceApp {
  id: number;
  appId: number;
  memory: number;
  cores: number;
  isUnfulfilled: boolean;
  isManager: boolean;
  isWorker: boolean;
  properties?: IProperty[];
}

export type IUIAppDisplay = Partial<IAppOption> &
  Partial<IInstanceApp> & { currentAppId: number };

export interface IReplicationDetails {
  isSelected: boolean;
  selectedInstanceIds: number[];
}

export interface IDeploymentDetails {
  scopeId: number;
  deployInstanceIds: number[];
  restartInstanceIds: number[];
  stopInstanceIds: number[];
  deleteInstanceIds: number[];
}

export enum IInterfaceTabOptions {
  PROPERTIES = "properties",
  REPLICATE = "replicate",
}

export interface IProperty {
  name: string;
  value: string;
  type: string;
  propertyId?: string;
  isNewlyAdded?: boolean;
}
