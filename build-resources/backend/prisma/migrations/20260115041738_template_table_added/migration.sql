-- CreateEnum
CREATE TYPE "public"."TemplateCategory" AS ENUM ('OUTDOOR_SUMMARY', 'INDOOR_SUMMARY', 'LAB_REPORT', 'RECEPTIONIST_SUMMARY', 'MONTHLY_SUMMARY', 'OUTDOOR_TOTAL_BILL', 'OUTDOOR_BILL', 'INDOOR_BILL_SUMMARY', 'INDOOR_ADMISSION', 'INDOOR_BILL_DETAILS', 'TEST_SUMMARY', 'OPD_SUMMARY', 'APPOINTMENT_SUMMARY', 'APPOINTMENT_TICKET', 'INVENTORY_TRANSACTION_REPORT', 'TEST_CATEGORY_STATEMENT', 'TEST_WISE_STATEMENT', 'BILL_BY_PC_STATEMENT', 'BILL_BY_DOCTOR_STATEMENT', 'PC_WISE_STATEMENT', 'DOCTOR_WISE_STATEMENT', 'PC_COMMISSION_CATEGORY_WISE_STATEMENT', 'DOCTOR_COMMISSION_CATEGORY_WISE_STATEMENT', 'PC_COMMISSION_TEST_WISE_STATEMENT', 'DOCTOR_COMMISSION_TEST_WISE_STATEMENT', 'DAILY_EXTRA_INCOME_STATEMENT', 'DAILY_EXPENSE_STATEMENT');

-- CreateTable
CREATE TABLE "public"."Template" (
    "id" TEXT NOT NULL,
    "transformFunction" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "html" TEXT NOT NULL,
    "previewImage" TEXT,
    "pageHeight" INTEGER NOT NULL,
    "pageWidth" INTEGER NOT NULL,
    "category" "public"."TemplateCategory" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "Template_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."DiagnosticTemplate" (
    "id" TEXT NOT NULL,
    "diagnosticId" TEXT NOT NULL,
    "templateId" TEXT NOT NULL,
    "isDefault" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "DiagnosticTemplate_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "DiagnosticTemplate_diagnosticId_templateId_key" ON "public"."DiagnosticTemplate"("diagnosticId", "templateId");

-- AddForeignKey
ALTER TABLE "public"."DiagnosticTemplate" ADD CONSTRAINT "DiagnosticTemplate_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "public"."Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."DiagnosticTemplate" ADD CONSTRAINT "DiagnosticTemplate_templateId_fkey" FOREIGN KEY ("templateId") REFERENCES "public"."Template"("id") ON DELETE CASCADE ON UPDATE CASCADE;
