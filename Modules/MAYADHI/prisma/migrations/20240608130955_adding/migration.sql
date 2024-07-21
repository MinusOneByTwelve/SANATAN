/*
  Warnings:

  - Added the required column `provider` to the `Instance` table without a default value. This is not possible if the table is not empty.
  - Changed the type of `instanceType` on the `Instance` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.

*/
-- AlterTable
ALTER TABLE "Instance" ADD COLUMN     "provider" "PROVIDER_ACRONYM" NOT NULL,
DROP COLUMN "instanceType",
ADD COLUMN     "instanceType" TEXT NOT NULL;
