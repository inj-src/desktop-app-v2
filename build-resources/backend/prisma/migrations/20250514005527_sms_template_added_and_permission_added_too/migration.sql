-- CreateEnum
CREATE TYPE "SMSEventType" AS ENUM ('BILL_CREATED', 'LAB_REPORT_COMPLETED', 'LAB_REPORT_SINGLE_COMPLETED', 'PATIENT_ADMITTED', 'BILL_PAYMENT_RECEIVED', 'INDOOR_BILL_PAYMENT_RECEIVED', 'APPOINTMENT_REMINDER', 'EMPLOYEE_ABSENT', 'SALARY_DISBURSEMENT', 'SALARY_ADVANCE', 'SALARY_REVISION');

-- AlterTable
ALTER TABLE "Diagnostic" ADD COLUMN     "sendSMSForAppointmentReminder" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "sendSMSForBillCreation" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "sendSMSForBillPayment" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "sendSMSForIndoorBillPayment" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "sendSMSForLabReportCompletion" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "sendSMSForPatientAdmission" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "sendSMSForSingleLabReportCompletion" BOOLEAN NOT NULL DEFAULT false;

-- CreateTable
CREATE TABLE "SMSTemplate" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "eventType" "SMSEventType" NOT NULL,
    "englishMessage" TEXT,
    "bengaliMessage" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "senderId" TEXT,
    "sendInBengali" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),
    "diagnosticId" TEXT NOT NULL,

    CONSTRAINT "SMSTemplate_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "SMSTemplate_diagnosticId_idx" ON "SMSTemplate"("diagnosticId");

-- CreateIndex
CREATE INDEX "SMSTemplate_eventType_idx" ON "SMSTemplate"("eventType");

-- AddForeignKey
ALTER TABLE "SMSTemplate" ADD CONSTRAINT "SMSTemplate_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;
