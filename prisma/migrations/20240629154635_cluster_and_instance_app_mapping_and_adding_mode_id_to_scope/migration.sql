-- AlterTable
ALTER TABLE "Scope" ADD COLUMN     "modeId" INTEGER;

-- CreateTable
CREATE TABLE "Cluster" (
    "id" SERIAL NOT NULL,
    "visionId" INTEGER NOT NULL,
    "modeId" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "color" TEXT NOT NULL,

    CONSTRAINT "Cluster_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Instance_App_Mapper" (
    "id" SERIAL NOT NULL,
    "instanceId" INTEGER NOT NULL,
    "appId" INTEGER NOT NULL,
    "memory" DOUBLE PRECISION NOT NULL,
    "cores" DOUBLE PRECISION NOT NULL,
    "isUnfulfiled" BOOLEAN NOT NULL,
    "isManager" BOOLEAN NOT NULL,
    "isWorker" BOOLEAN NOT NULL,

    CONSTRAINT "Instance_App_Mapper_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "Scope" ADD CONSTRAINT "Scope_modeId_fkey" FOREIGN KEY ("modeId") REFERENCES "Mode"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Cluster" ADD CONSTRAINT "Cluster_visionId_fkey" FOREIGN KEY ("visionId") REFERENCES "Vision"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Cluster" ADD CONSTRAINT "Cluster_modeId_fkey" FOREIGN KEY ("modeId") REFERENCES "Mode"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Instance_App_Mapper" ADD CONSTRAINT "Instance_App_Mapper_instanceId_fkey" FOREIGN KEY ("instanceId") REFERENCES "Instance"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Instance_App_Mapper" ADD CONSTRAINT "Instance_App_Mapper_appId_fkey" FOREIGN KEY ("appId") REFERENCES "Apps"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
