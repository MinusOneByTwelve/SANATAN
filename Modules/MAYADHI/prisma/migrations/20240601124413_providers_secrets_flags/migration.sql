-- AlterTable
ALTER TABLE "Provider" ADD COLUMN     "needsCredentials" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "needsSecretKey" BOOLEAN NOT NULL DEFAULT false;
