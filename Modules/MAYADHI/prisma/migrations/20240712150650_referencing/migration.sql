/*
  Warnings:

  - A unique constraint covering the columns `[identifierId]` on the table `Apps` will be added. If there are existing duplicate values, this will fail.

*/
-- DropForeignKey
ALTER TABLE "InstanceApps" DROP CONSTRAINT "InstanceApps_appId_fkey";

-- CreateIndex
CREATE UNIQUE INDEX "Apps_identifierId_key" ON "Apps"("identifierId");

-- AddForeignKey
ALTER TABLE "InstanceApps" ADD CONSTRAINT "InstanceApps_appId_fkey" FOREIGN KEY ("appId") REFERENCES "Apps"("identifierId") ON DELETE RESTRICT ON UPDATE CASCADE;
