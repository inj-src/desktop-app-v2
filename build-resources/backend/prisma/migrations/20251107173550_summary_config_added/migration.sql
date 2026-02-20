-- CreateEnum
CREATE TYPE "public"."SummaryType" AS ENUM ('INDOOR', 'OUTDOOR', 'RECEPTIONIST', 'EXPENSE', 'MONTHLY');

-- CreateEnum
CREATE TYPE "public"."ScheduleFrequency" AS ENUM ('DAILY', 'WEEKLY', 'MONTHLY', 'CUSTOM_INTERVAL');

-- CreateEnum
CREATE TYPE "public"."SummaryPeriod" AS ENUM ('SINCE_LAST_SEND', 'LAST_24_HOURS', 'LAST_7_DAYS', 'LAST_30_DAYS', 'CURRENT_MONTH', 'PREVIOUS_MONTH', 'CUSTOM');

-- CreateTable
CREATE TABLE "public"."ScheduledSummaryConfig" (
    "id" TEXT NOT NULL,
    "name" TEXT,
    "summaryType" "public"."SummaryType"[],
    "isEnabled" BOOLEAN NOT NULL DEFAULT true,
    "scheduleType" "public"."ScheduleFrequency" NOT NULL,
    "sendTime" TEXT,
    "intervalDays" INTEGER,
    "excludeDaysOfWeek" INTEGER[],
    "excludeDaysOfMonth" INTEGER[],
    "excludeSpecificDates" TIMESTAMP(3)[],
    "sendOnDaysOfWeek" INTEGER[],
    "sendOnDayOfMonth" INTEGER,
    "sendOnLastDayOfMonth" BOOLEAN NOT NULL DEFAULT false,
    "diagnosticId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "ScheduledSummaryConfig_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."ScheduledSummaryRecipientConfig" (
    "id" TEXT NOT NULL,
    "email" TEXT,
    "phone" TEXT,
    "whatsappNumber" TEXT,
    "isEmailVerified" BOOLEAN NOT NULL DEFAULT false,
    "emailVerifiedAt" TIMESTAMP(3),
    "isPhoneVerified" BOOLEAN NOT NULL DEFAULT false,
    "phoneVerifiedAt" TIMESTAMP(3),
    "isWhatsAppVerified" BOOLEAN NOT NULL DEFAULT false,
    "whatsappVerifiedAt" TIMESTAMP(3),
    "sendViaEmail" BOOLEAN NOT NULL DEFAULT false,
    "sendViaPhone" BOOLEAN NOT NULL DEFAULT false,
    "sendViaWhatsApp" BOOLEAN NOT NULL DEFAULT false,
    "diagnosticId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "ScheduledSummaryRecipientConfig_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "ScheduledSummaryConfig_diagnosticId_idx" ON "public"."ScheduledSummaryConfig"("diagnosticId");

-- CreateIndex
CREATE INDEX "ScheduledSummaryConfig_isEnabled_idx" ON "public"."ScheduledSummaryConfig"("isEnabled");

-- CreateIndex
CREATE UNIQUE INDEX "ScheduledSummaryConfig_diagnosticId_name_deletedAt_key" ON "public"."ScheduledSummaryConfig"("diagnosticId", "name", "deletedAt");

-- CreateIndex
CREATE UNIQUE INDEX "ScheduledSummaryRecipientConfig_diagnosticId_key" ON "public"."ScheduledSummaryRecipientConfig"("diagnosticId");

-- CreateIndex
CREATE INDEX "ScheduledSummaryRecipientConfig_diagnosticId_idx" ON "public"."ScheduledSummaryRecipientConfig"("diagnosticId");

-- CreateIndex
CREATE INDEX "ScheduledSummaryRecipientConfig_email_idx" ON "public"."ScheduledSummaryRecipientConfig"("email");

-- CreateIndex
CREATE INDEX "ScheduledSummaryRecipientConfig_phone_idx" ON "public"."ScheduledSummaryRecipientConfig"("phone");

-- CreateIndex
CREATE INDEX "ScheduledSummaryRecipientConfig_whatsappNumber_idx" ON "public"."ScheduledSummaryRecipientConfig"("whatsappNumber");

-- AddForeignKey
ALTER TABLE "public"."ScheduledSummaryConfig" ADD CONSTRAINT "ScheduledSummaryConfig_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "public"."Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."ScheduledSummaryRecipientConfig" ADD CONSTRAINT "ScheduledSummaryRecipientConfig_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "public"."Diagnostic"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
