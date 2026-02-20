/*
  Warnings:

  - A unique constraint covering the columns `[service,diagnosticId]` on the table `ServiceVersion` will be added. If there are existing duplicate values, this will fail.

*/
-- DropIndex
DROP INDEX "ServiceVersion_service_key";

-- AlterTable
ALTER TABLE "ServiceVersion" ADD COLUMN     "diagnosticId" TEXT;

-- CreateIndex
CREATE INDEX "ServiceVersion_service_diagnosticId_idx" ON "ServiceVersion"("service", "diagnosticId");

-- CreateIndex
CREATE UNIQUE INDEX "ServiceVersion_service_diagnosticId_key" ON "ServiceVersion"("service", "diagnosticId");

-- AddForeignKey
ALTER TABLE "ServiceVersion" ADD CONSTRAINT "ServiceVersion_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;
