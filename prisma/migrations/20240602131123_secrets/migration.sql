-- CreateTable
CREATE TABLE "Secrets" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "visionId" INTEGER NOT NULL,
    "fileName" TEXT NOT NULL,
    "key" TEXT NOT NULL,
    "instanceAcronym" "ACRONYM" NOT NULL,

    CONSTRAINT "Secrets_pkey" PRIMARY KEY ("id")
);
