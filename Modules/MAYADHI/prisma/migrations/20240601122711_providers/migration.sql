-- CreateEnum
CREATE TYPE "ACRONYM" AS ENUM ('AWS', 'GCP', 'AZURE', 'E2E', 'OP');

-- CreateTable
CREATE TABLE "Provider" (
    "id" SERIAL NOT NULL,
    "icon" TEXT NOT NULL,
    "acronym" "ACRONYM" NOT NULL,
    "providerColor" TEXT NOT NULL,
    "showName" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "Provider_pkey" PRIMARY KEY ("id")
);
