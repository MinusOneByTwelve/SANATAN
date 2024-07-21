-- CreateTable
CREATE TABLE "Instance" (
    "id" SERIAL NOT NULL,
    "visionId" INTEGER NOT NULL,
    "scopeId" INTEGER NOT NULL,
    "instanceType" "PROVIDER_ACRONYM" NOT NULL,
    "name" TEXT NOT NULL,
    "ip" TEXT NOT NULL,
    "configurationDetails" JSONB NOT NULL,
    "secretId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Instance_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "Instance" ADD CONSTRAINT "Instance_scopeId_fkey" FOREIGN KEY ("scopeId") REFERENCES "Scope"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Instance" ADD CONSTRAINT "Instance_secretId_fkey" FOREIGN KEY ("secretId") REFERENCES "Secrets"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
