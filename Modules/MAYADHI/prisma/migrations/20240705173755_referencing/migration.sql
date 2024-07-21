-- AddForeignKey
ALTER TABLE "Scope" ADD CONSTRAINT "Scope_visionId_fkey" FOREIGN KEY ("visionId") REFERENCES "Vision"("id") ON DELETE CASCADE ON UPDATE CASCADE;
