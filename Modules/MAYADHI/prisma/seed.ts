import { PrismaClient } from '@prisma/client';
import { IStackOption } from 'src/interfaces';

const prisma = new PrismaClient();

async function main() {
  await prisma.provider.upsert({
    where: { acronym: 'OP' },
    update: {
      needsSecretKey: false,
      needsServiceAccount: false,
    },
    create: {
      icon: 'onPremise.png',
      acronym: 'OP',
      providerColor: '#E580FF',
      showName: true,
      name: 'On premise',
      needsSecretKey: false,
      needsServiceAccount: false,
    },
  });
  await prisma.provider.upsert({
    where: { acronym: 'AWS' },
    update: {
      needsSecretKey: true,
      needsServiceAccount: false,
    },
    create: {
      icon: 'amazon_aws_logo_icon.svg',
      acronym: 'AWS',
      providerColor: '#FF9F10',
      showName: false,
      name: 'AWS',
      needsSecretKey: true,
      needsServiceAccount: false,
    },
  });
  await prisma.provider.upsert({
    where: { acronym: 'GCP' },
    update: {
      needsSecretKey: true,
      needsServiceAccount: true,
    },
    create: {
      icon: 'google_cloud_logo_icon.svg',
      acronym: 'GCP',
      providerColor: '#4285F4',
      showName: false,
      name: 'Google Cloud',
      needsSecretKey: true,
      needsServiceAccount: true,
    },
  });
  await prisma.provider.upsert({
    where: { acronym: 'AZURE' },
    update: {
      needsSecretKey: true,
      needsServiceAccount: false,
    },
    create: {
      icon: 'microsoft_azure_logo_icon.svg',
      acronym: 'AZURE',
      providerColor: '#035BDA',
      showName: false,
      name: 'Azure',
      needsSecretKey: true,
      needsServiceAccount: false,
    },
  });
  await prisma.provider.upsert({
    where: { acronym: 'E2E' },
    update: {
      needsSecretKey: true,
      needsServiceAccount: false,
    },
    create: {
      icon: 'e2e-networks-logo.png',
      acronym: 'E2E',
      providerColor: '#1399D5',
      showName: false,
      name: 'E2E Networks',
      needsSecretKey: true,
      needsServiceAccount: false,
    },
  });

  try {
    const data = await import('./apps.json');
    const stackOptions: IStackOption[] = data.stackOptions;
    // const data = JSON.parse(await readFile('stack.json', 'utf8'));
    // console.log(stackOptions);
    await prisma.apps.deleteMany();
    await prisma.apps.createMany({
      data: stackOptions,
    });
  } catch (err) {
    console.log(err);
  }
}
main()
  .then(async () => {
    await prisma.$disconnect();
  })
  .catch(async (e) => {
    console.error(e);
    await prisma.$disconnect();
    process.exit(1);
  });
