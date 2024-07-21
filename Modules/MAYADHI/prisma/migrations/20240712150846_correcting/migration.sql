/*
  Warnings:

  - You are about to drop the column `isUnfulfiled` on the `InstanceApps` table. All the data in the column will be lost.
  - Added the required column `isUnfulfilled` to the `InstanceApps` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "InstanceApps" DROP COLUMN "isUnfulfiled",
ADD COLUMN     "isUnfulfilled" BOOLEAN NOT NULL;
