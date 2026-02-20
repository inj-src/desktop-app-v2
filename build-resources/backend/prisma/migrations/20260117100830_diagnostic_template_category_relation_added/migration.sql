/*
  Warnings:

  - Added the required column `categoryId` to the `DiagnosticTemplate` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "public"."DiagnosticTemplate" ADD COLUMN     "categoryId" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "public"."TemplateCategory" ALTER COLUMN "diagnosticId" DROP NOT NULL;

-- AddForeignKey
ALTER TABLE "public"."DiagnosticTemplate" ADD CONSTRAINT "DiagnosticTemplate_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "public"."TemplateCategory"("id") ON DELETE CASCADE ON UPDATE CASCADE;
