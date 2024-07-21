/*
  Warnings:

  - You are about to drop the column `provider` on the `Instance` table. All the data in the column will be lost.
  - You are about to drop the column `providerAcronym` on the `Secrets` table. All the data in the column will be lost.
  - Added the required column `providerId` to the `Instance` table without a default value. This is not possible if the table is not empty.
  - Added the required column `providerId` to the `Secrets` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "Instance" DROP COLUMN "provider",
ADD COLUMN     "providerId" INTEGER NOT NULL;

-- AlterTable
ALTER TABLE "Secrets" DROP COLUMN "providerAcronym",
ADD COLUMN     "providerId" INTEGER NOT NULL;

-- AddForeignKey
ALTER TABLE "Secrets" ADD CONSTRAINT "Secrets_providerId_fkey" FOREIGN KEY ("providerId") REFERENCES "Provider"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Instance" ADD CONSTRAINT "Instance_providerId_fkey" FOREIGN KEY ("providerId") REFERENCES "Provider"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
