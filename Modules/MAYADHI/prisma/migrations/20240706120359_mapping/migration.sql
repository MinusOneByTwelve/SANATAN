/*
  Warnings:

  - A unique constraint covering the columns `[modeId]` on the table `Mode` will be added. If there are existing duplicate values, this will fail.

*/
-- DropForeignKey
ALTER TABLE "Scope" DROP CONSTRAINT "Scope_modeId_fkey";

-- AlterTable
ALTER TABLE "Scope" ALTER COLUMN "modeId" SET DATA TYPE TEXT;

-- CreateIndex
CREATE UNIQUE INDEX "Mode_modeId_key" ON "Mode"("modeId");

-- AddForeignKey
ALTER TABLE "Scope" ADD CONSTRAINT "Scope_modeId_fkey" FOREIGN KEY ("modeId") REFERENCES "Mode"("modeId") ON DELETE SET NULL ON UPDATE CASCADE;
