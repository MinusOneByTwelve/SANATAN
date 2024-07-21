/*
  Warnings:

  - A unique constraint covering the columns `[acronym]` on the table `Provider` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateIndex
CREATE UNIQUE INDEX "Provider_acronym_key" ON "Provider"("acronym");
