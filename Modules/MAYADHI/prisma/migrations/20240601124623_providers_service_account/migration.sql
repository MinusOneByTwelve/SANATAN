/*
  Warnings:

  - You are about to drop the column `needsCredentials` on the `Provider` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "Provider" DROP COLUMN "needsCredentials",
ADD COLUMN     "needsServiceAccount" BOOLEAN NOT NULL DEFAULT false;
