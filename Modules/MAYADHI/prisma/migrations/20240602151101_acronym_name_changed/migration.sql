/*
  Warnings:

  - Changed the type of `acronym` on the `Provider` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `providerAcronym` on the `Secrets` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.

*/
-- CreateEnum
CREATE TYPE "PROVIDER_ACRONYM" AS ENUM ('AWS', 'GCP', 'AZURE', 'E2E', 'OP');

-- CreateEnum
CREATE TYPE "SECRET_TYPE" AS ENUM ('SECRET', 'SERVICE_ACCOUNT');

-- AlterTable
ALTER TABLE "Provider" DROP COLUMN "acronym",
ADD COLUMN     "acronym" "PROVIDER_ACRONYM" NOT NULL;

-- AlterTable
ALTER TABLE "Secrets" ADD COLUMN     "type" "SECRET_TYPE" NOT NULL DEFAULT 'SECRET',
DROP COLUMN "providerAcronym",
ADD COLUMN     "providerAcronym" "PROVIDER_ACRONYM" NOT NULL;

-- DropEnum
DROP TYPE "ACRONYM";

-- CreateIndex
CREATE UNIQUE INDEX "Provider_acronym_key" ON "Provider"("acronym");
