-- CreateTable
CREATE TABLE "Scope" (
    "id" SERIAL NOT NULL,
    "visionId" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "identityCount" INTEGER NOT NULL,
    "isProcessed" BOOLEAN NOT NULL DEFAULT true,
    "isMixed" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "Scope_pkey" PRIMARY KEY ("id")
);
