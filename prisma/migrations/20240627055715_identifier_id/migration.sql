/*
  Warnings:

  - Added the required column `identifierId` to the `StackOption` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "StackOption" ADD COLUMN     "identifierId" INTEGER NOT NULL;
