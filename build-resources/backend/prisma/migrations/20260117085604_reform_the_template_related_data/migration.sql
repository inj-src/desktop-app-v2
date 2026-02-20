/*
  Warnings:

  - You are about to drop the column `category` on the `Template` table. All the data in the column will be lost.
  - You are about to drop the column `dummyData` on the `Template` table. All the data in the column will be lost.
  - Added the required column `html` to the `DiagnosticTemplate` table without a default value. This is not possible if the table is not empty.
  - Added the required column `name` to the `DiagnosticTemplate` table without a default value. This is not possible if the table is not empty.
  - Added the required column `categoryId` to the `Template` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "public"."TemplateCategoryType" AS ENUM ('OUTDOOR_SUMMARY', 'INDOOR_SUMMARY', 'LAB_REPORT', 'RECEPTIONIST_SUMMARY', 'MONTHLY_SUMMARY', 'OUTDOOR_TOTAL_BILL', 'OUTDOOR_BILL', 'INDOOR_BILL_SUMMARY', 'INDOOR_ADMISSION', 'INDOOR_BILL_DETAILS', 'TEST_SUMMARY', 'OPD_SUMMARY', 'APPOINTMENT_SUMMARY', 'APPOINTMENT_TICKET', 'INVENTORY_TRANSACTION_REPORT', 'TEST_CATEGORY_STATEMENT', 'TEST_WISE_STATEMENT', 'BILL_BY_PC_STATEMENT', 'BILL_BY_DOCTOR_STATEMENT', 'PC_WISE_STATEMENT', 'DOCTOR_WISE_STATEMENT', 'PC_COMMISSION_CATEGORY_WISE_STATEMENT', 'DOCTOR_COMMISSION_CATEGORY_WISE_STATEMENT', 'PC_COMMISSION_TEST_WISE_STATEMENT', 'DOCTOR_COMMISSION_TEST_WISE_STATEMENT', 'DAILY_EXTRA_INCOME_STATEMENT', 'DAILY_EXPENSE_STATEMENT');

-- AlterTable
ALTER TABLE "public"."DiagnosticTemplate" ADD COLUMN     "html" TEXT NOT NULL,
ADD COLUMN     "name" TEXT NOT NULL,
ADD COLUMN     "pageHeight" INTEGER,
ADD COLUMN     "pageWidth" INTEGER,
ADD COLUMN     "previewImage" TEXT,
ADD COLUMN     "transformFunction" TEXT;

-- AlterTable
ALTER TABLE "public"."Template" DROP COLUMN "category",
DROP COLUMN "dummyData",
ADD COLUMN     "categoryId" TEXT NOT NULL;

-- DropEnum
DROP TYPE "public"."TemplateCategory";

-- CreateTable
CREATE TABLE "public"."TemplateCategory" (
    "id" TEXT NOT NULL,
    "name" "public"."TemplateCategoryType" NOT NULL,
    "dummyData" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),
    "diagnosticId" TEXT NOT NULL,

    CONSTRAINT "TemplateCategory_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "TemplateCategory_diagnosticId_name_idx" ON "public"."TemplateCategory"("diagnosticId", "name");

-- CreateIndex
CREATE INDEX "Template_categoryId_idx" ON "public"."Template"("categoryId");

-- AddForeignKey
ALTER TABLE "public"."Template" ADD CONSTRAINT "Template_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "public"."TemplateCategory"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."TemplateCategory" ADD CONSTRAINT "TemplateCategory_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "public"."Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;
