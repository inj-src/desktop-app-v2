-- CreateEnum
CREATE TYPE "public"."ReportQueueStatus" AS ENUM ('WAITING', 'MISSED', 'ON_GOING', 'COMPLETED', 'CANCELLED');

-- CreateTable
CREATE TABLE "public"."ReportQueue" (
    "id" TEXT NOT NULL,
    "appointmentId" TEXT NOT NULL,
    "doctorChamberId" TEXT NOT NULL,
    "slotId" TEXT NOT NULL,
    "sessionId" TEXT NOT NULL,
    "diagnosticId" TEXT NOT NULL,
    "userId" TEXT,
    "queuePosition" INTEGER NOT NULL,
    "timeOf" TIMESTAMP(3) NOT NULL,
    "status" "public"."ReportQueueStatus" NOT NULL DEFAULT 'WAITING',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "ReportQueue_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "ReportQueue_sessionId_diagnosticId_deletedAt_idx" ON "public"."ReportQueue"("sessionId", "diagnosticId", "deletedAt");

-- AddForeignKey
ALTER TABLE "public"."ReportQueue" ADD CONSTRAINT "ReportQueue_appointmentId_fkey" FOREIGN KEY ("appointmentId") REFERENCES "public"."DoctorAppointment"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."ReportQueue" ADD CONSTRAINT "ReportQueue_doctorChamberId_fkey" FOREIGN KEY ("doctorChamberId") REFERENCES "public"."DoctorChamber"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."ReportQueue" ADD CONSTRAINT "ReportQueue_slotId_fkey" FOREIGN KEY ("slotId") REFERENCES "public"."Slot"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."ReportQueue" ADD CONSTRAINT "ReportQueue_sessionId_fkey" FOREIGN KEY ("sessionId") REFERENCES "public"."DoctorSession"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."ReportQueue" ADD CONSTRAINT "ReportQueue_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "public"."Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."ReportQueue" ADD CONSTRAINT "ReportQueue_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;
