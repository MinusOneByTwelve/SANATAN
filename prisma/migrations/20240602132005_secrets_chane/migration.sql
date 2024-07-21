/*
  Warnings:

  - You are about to drop the column `instanceAcronym` on the `Secrets` table. All the data in the column will be lost.
  - Added the required column `providerAcronym` to the `Secrets` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "Secrets" DROP COLUMN "instanceAcronym",
ADD COLUMN     "providerAcronym" "ACRONYM" NOT NULL;
