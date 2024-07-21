/*
  Warnings:

  - Added the required column `modeId` to the `Mode` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "Mode" ADD COLUMN     "modeId" TEXT NOT NULL,
ALTER COLUMN "secretId" DROP NOT NULL;
