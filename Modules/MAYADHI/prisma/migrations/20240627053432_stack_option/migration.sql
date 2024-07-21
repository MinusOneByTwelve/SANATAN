-- CreateTable
CREATE TABLE "StackOption" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "version" TEXT,
    "downloadUrl" TEXT NOT NULL,
    "iconUrl" TEXT NOT NULL,
    "identifier" TEXT,
    "suite" TEXT,
    "suiteVersion" TEXT,
    "properties" JSONB,
    "isOpen" BOOLEAN,

    CONSTRAINT "StackOption_pkey" PRIMARY KEY ("id")
);
