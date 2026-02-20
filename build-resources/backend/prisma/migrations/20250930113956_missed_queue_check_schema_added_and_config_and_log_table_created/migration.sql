-- AlterEnum
ALTER TYPE "public"."AppointmentStatus" ADD VALUE 'WAITING';

-- AlterTable
ALTER TABLE "public"."DoctorChamber" ADD COLUMN     "checkIntervalSecondsForMissedQueue" INTEGER NOT NULL DEFAULT 60,
ADD COLUMN     "enableMissedQueueAutomation" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "missedQueueConfig" JSONB NOT NULL DEFAULT '[]';

-- CreateTable
CREATE TABLE "public"."missedQueueConfig" (
    "id" TEXT NOT NULL,
    "enabled" BOOLEAN NOT NULL DEFAULT false,
    "checkIntervalSeconds" INTEGER NOT NULL DEFAULT 60,
    "strategies" JSONB NOT NULL DEFAULT '[]',

    CONSTRAINT "missedQueueConfig_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."MissedQueueLog" (
    "id" TEXT NOT NULL,
    "doctorChamberId" TEXT NOT NULL,
    "slotId" TEXT NOT NULL,
    "doctorSessionId" TEXT NOT NULL,
    "diagnosticId" TEXT NOT NULL,
    "processedDate" TIMESTAMP(3) NOT NULL,
    "strategiesUsed" JSONB NOT NULL,
    "totalProcessed" INTEGER NOT NULL DEFAULT 0,
    "results" JSONB NOT NULL,
    "lastProcessedPosition" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "MissedQueueLog_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "MissedQueueLog_doctorChamberId_slotId_processedDate_idx" ON "public"."MissedQueueLog"("doctorChamberId", "slotId", "processedDate");

-- CreateIndex
CREATE INDEX "MissedQueueLog_processedDate_idx" ON "public"."MissedQueueLog"("processedDate");

-- AddForeignKey
ALTER TABLE "public"."MissedQueueLog" ADD CONSTRAINT "MissedQueueLog_doctorChamberId_fkey" FOREIGN KEY ("doctorChamberId") REFERENCES "public"."DoctorChamber"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."MissedQueueLog" ADD CONSTRAINT "MissedQueueLog_slotId_fkey" FOREIGN KEY ("slotId") REFERENCES "public"."Slot"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."MissedQueueLog" ADD CONSTRAINT "MissedQueueLog_doctorSessionId_fkey" FOREIGN KEY ("doctorSessionId") REFERENCES "public"."DoctorSession"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."MissedQueueLog" ADD CONSTRAINT "MissedQueueLog_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "public"."Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;
