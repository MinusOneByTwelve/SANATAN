/*
  Warnings:

  - You are about to drop the `StackOption` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropTable
DROP TABLE "StackOption";

-- CreateTable
CREATE TABLE "Mode" (
    "id" SERIAL NOT NULL,
    "visionId" INTEGER NOT NULL,
    "secretId" TEXT NOT NULL,
    "label" TEXT NOT NULL,
    "color" TEXT NOT NULL,

    CONSTRAINT "Mode_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Apps" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "version" TEXT,
    "documentationUrl" TEXT,
    "downloadUrl" TEXT,
    "iconUrl" TEXT,
    "identifier" TEXT,
    "identifierId" SERIAL NOT NULL,
    "suite" TEXT,
    "suiteVersion" TEXT,
    "properties" JSONB,
    "isOpen" BOOLEAN,

    CONSTRAINT "Apps_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "Mode" ADD CONSTRAINT "Mode_visionId_fkey" FOREIGN KEY ("visionId") REFERENCES "Vision"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
