import { Injectable } from '@nestjs/common';
import { createObjectCsvWriter } from 'csv-writer';

@Injectable()
export class CsvService {
  async writeCsvWithHeaders(
    filePath: string,
    headers: string[],
    records: any[],
  ): Promise<void> {
    const csvWriter = createObjectCsvWriter({
      path: filePath,
      header: headers.map((header) => ({ id: header, title: header })),
    });

    await csvWriter.writeRecords(records);
  }
}
