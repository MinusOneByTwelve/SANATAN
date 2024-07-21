/*
  Warnings:

  - You are about to drop the column `secretId` on the `Mode` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "Mode" DROP COLUMN "secretId",
ADD COLUMN     "encryptionKey" TEXT;
