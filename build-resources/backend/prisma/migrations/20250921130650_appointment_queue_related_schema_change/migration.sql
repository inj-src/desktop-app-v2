-- CreateEnum
CREATE TYPE "public"."NoticeType" AS ENUM ('BREAK', 'EMERGENCY', 'DELAY_NOTICE', 'GENERAL', 'NAMAZ', 'FOOD', 'OTHER');

-- CreateEnum
CREATE TYPE "public"."DoctorSessionStatus" AS ENUM ('SCHEDULED', 'ACTIVE', 'ON_BREAK', 'DELAYED', 'COMPLETED', 'CANCELLED');

-- AlterTable
ALTER TABLE "public"."DoctorAppointment" ADD COLUMN     "actualEndTime" TIMESTAMP(3),
ADD COLUMN     "actualStartTime" TIMESTAMP(3),
ADD COLUMN     "delayReason" TEXT,
ADD COLUMN     "isDelayed" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "sessionId" TEXT;

-- CreateTable
CREATE TABLE "public"."DoctorSession" (
    "id" TEXT NOT NULL,
    "doctorChamberId" TEXT NOT NULL,
    "slotId" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "startTime" TIMESTAMP(3) NOT NULL,
    "endTime" TIMESTAMP(3),
    "actualStartTime" TIMESTAMP(3),
    "actualEndTime" TIMESTAMP(3),
    "currentDelayInMinutes" INTEGER NOT NULL DEFAULT 0,
    "isOnBreak" BOOLEAN NOT NULL DEFAULT false,
    "breakStartTime" TIMESTAMP(3),
    "estimatedBreakEnd" TIMESTAMP(3),
    "status" "public"."DoctorSessionStatus" NOT NULL DEFAULT 'SCHEDULED',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "DoctorSession_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."DoctorSessionHistory" (
    "id" TEXT NOT NULL,
    "doctorSessionId" TEXT NOT NULL,
    "action" TEXT NOT NULL,
    "timestamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "details" JSONB,
    "userId" TEXT,

    CONSTRAINT "DoctorSessionHistory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."SessionNotice" (
    "id" TEXT NOT NULL,
    "doctorSessionId" TEXT NOT NULL,
    "type" "public"."NoticeType" NOT NULL,
    "message" TEXT NOT NULL,
    "startTime" TIMESTAMP(3) NOT NULL,
    "endTime" TIMESTAMP(3),
    "approximateDurationInMinutes" INTEGER NOT NULL DEFAULT 0,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdBy" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "SessionNotice_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "DoctorSession_doctorChamberId_idx" ON "public"."DoctorSession"("doctorChamberId");

-- CreateIndex
CREATE INDEX "DoctorSession_slotId_idx" ON "public"."DoctorSession"("slotId");

-- CreateIndex
CREATE INDEX "DoctorSession_date_idx" ON "public"."DoctorSession"("date");

-- CreateIndex
CREATE INDEX "DoctorSession_status_idx" ON "public"."DoctorSession"("status");

-- CreateIndex
CREATE UNIQUE INDEX "DoctorSession_doctorChamberId_slotId_date_deletedAt_key" ON "public"."DoctorSession"("doctorChamberId", "slotId", "date", "deletedAt");

-- AddForeignKey
ALTER TABLE "public"."DoctorAppointment" ADD CONSTRAINT "DoctorAppointment_sessionId_fkey" FOREIGN KEY ("sessionId") REFERENCES "public"."DoctorSession"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."DoctorSession" ADD CONSTRAINT "DoctorSession_doctorChamberId_fkey" FOREIGN KEY ("doctorChamberId") REFERENCES "public"."DoctorChamber"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."DoctorSession" ADD CONSTRAINT "DoctorSession_slotId_fkey" FOREIGN KEY ("slotId") REFERENCES "public"."Slot"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."DoctorSessionHistory" ADD CONSTRAINT "DoctorSessionHistory_doctorSessionId_fkey" FOREIGN KEY ("doctorSessionId") REFERENCES "public"."DoctorSession"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."DoctorSessionHistory" ADD CONSTRAINT "DoctorSessionHistory_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."SessionNotice" ADD CONSTRAINT "SessionNotice_doctorSessionId_fkey" FOREIGN KEY ("doctorSessionId") REFERENCES "public"."DoctorSession"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
