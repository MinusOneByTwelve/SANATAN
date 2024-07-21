/*
  Warnings:

  - You are about to drop the `Instance_App_Mapper` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "Instance_App_Mapper" DROP CONSTRAINT "Instance_App_Mapper_appId_fkey";

-- DropForeignKey
ALTER TABLE "Instance_App_Mapper" DROP CONSTRAINT "Instance_App_Mapper_instanceId_fkey";

-- AlterTable
ALTER TABLE "Instance" ADD COLUMN     "cores" INTEGER,
ADD COLUMN     "memory" DOUBLE PRECISION;

-- DropTable
DROP TABLE "Instance_App_Mapper";

-- CreateTable
CREATE TABLE "InstanceApps" (
    "id" SERIAL NOT NULL,
    "instanceId" INTEGER NOT NULL,
    "appId" INTEGER NOT NULL,
    "memory" DOUBLE PRECISION NOT NULL,
    "cores" DOUBLE PRECISION NOT NULL,
    "isUnfulfiled" BOOLEAN NOT NULL,
    "isManager" BOOLEAN NOT NULL,
    "isWorker" BOOLEAN NOT NULL,

    CONSTRAINT "InstanceApps_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "InstanceApps" ADD CONSTRAINT "InstanceApps_instanceId_fkey" FOREIGN KEY ("instanceId") REFERENCES "Instance"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "InstanceApps" ADD CONSTRAINT "InstanceApps_appId_fkey" FOREIGN KEY ("appId") REFERENCES "Apps"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
