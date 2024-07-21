-- DropForeignKey
ALTER TABLE "Mode" DROP CONSTRAINT "Mode_visionId_fkey";

-- AddForeignKey
ALTER TABLE "Mode" ADD CONSTRAINT "Mode_visionId_fkey" FOREIGN KEY ("visionId") REFERENCES "Vision"("id") ON DELETE CASCADE ON UPDATE CASCADE;
