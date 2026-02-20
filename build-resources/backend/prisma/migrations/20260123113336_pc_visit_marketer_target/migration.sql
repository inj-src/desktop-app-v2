-- CreateEnum
CREATE TYPE "public"."TargetType" AS ENUM ('DAILY', 'WEEKLY', 'MONTHLY', 'YEARLY');

-- CreateTable
CREATE TABLE "public"."PCVisit" (
    "id" TEXT NOT NULL,
    "imageUrl" TEXT NOT NULL,
    "deviceLocation" TEXT NOT NULL,
    "userLocation" TEXT NOT NULL,
    "pcId" TEXT NOT NULL,
    "marketerId" TEXT NOT NULL,
    "diagnosticId" TEXT NOT NULL,
    "visitedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "PCVisit_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."MarketerTarget" (
    "id" TEXT NOT NULL,
    "marketerId" TEXT NOT NULL,
    "diagnosticId" TEXT NOT NULL,
    "targetType" "public"."TargetType" NOT NULL,
    "targetValue" INTEGER NOT NULL,
    "startDate" TIMESTAMP(3) NOT NULL,
    "endDate" TIMESTAMP(3) NOT NULL,
    "createdById" TEXT,
    "createdBy" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "MarketerTarget_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "PCVisit_pcId_marketerId_visitedAt_idx" ON "public"."PCVisit"("pcId", "marketerId", "visitedAt");

-- CreateIndex
CREATE INDEX "PCVisit_diagnosticId_visitedAt_idx" ON "public"."PCVisit"("diagnosticId", "visitedAt");

-- CreateIndex
CREATE INDEX "MarketerTarget_marketerId_diagnosticId_targetType_idx" ON "public"."MarketerTarget"("marketerId", "diagnosticId", "targetType");

-- AddForeignKey
ALTER TABLE "public"."PCVisit" ADD CONSTRAINT "PCVisit_pcId_fkey" FOREIGN KEY ("pcId") REFERENCES "public"."PC"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."PCVisit" ADD CONSTRAINT "PCVisit_marketerId_fkey" FOREIGN KEY ("marketerId") REFERENCES "public"."User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."PCVisit" ADD CONSTRAINT "PCVisit_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "public"."Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."MarketerTarget" ADD CONSTRAINT "MarketerTarget_marketerId_fkey" FOREIGN KEY ("marketerId") REFERENCES "public"."User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."MarketerTarget" ADD CONSTRAINT "MarketerTarget_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "public"."Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;
