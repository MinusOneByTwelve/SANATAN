-- DropForeignKey
ALTER TABLE "Instance" DROP CONSTRAINT "Instance_scopeId_fkey";

-- AddForeignKey
ALTER TABLE "Instance" ADD CONSTRAINT "Instance_scopeId_fkey" FOREIGN KEY ("scopeId") REFERENCES "Scope"("id") ON DELETE CASCADE ON UPDATE CASCADE;
