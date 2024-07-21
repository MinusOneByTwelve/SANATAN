import { ArgumentMetadata, Injectable, PipeTransform } from '@nestjs/common';

@Injectable()
export class IdTransformerPipe implements PipeTransform {
  transform(value: any, metadata: ArgumentMetadata) {
    if (
      typeof value === 'object' &&
      value.hasOwnProperty('visionId') &&
      typeof value.visionId === 'string'
    ) {
      value.visionId = Number(value.visionId);
    }

    if (
      typeof value === 'object' &&
      value.hasOwnProperty('scopeId') &&
      typeof value.scopeId === 'string'
    ) {
      value.scopeId = Number(value.scopeId);
    }

    return value;
  }
}
