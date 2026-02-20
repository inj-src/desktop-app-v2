/*
  Warnings:

  - A unique constraint covering the columns `[pharmacyId]` on the table `Diagnostic` will be added. If there are existing duplicate values, this will fail.

*/
-- AlterTable
ALTER TABLE "Diagnostic" ADD COLUMN     "pharmacyId" TEXT;

-- AlterTable
ALTER TABLE "HospitalBill" ADD COLUMN     "isIntegratedWithPharmacy" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "lastPharmacySyncDate" TIMESTAMP(3),
ADD COLUMN     "lastPharmacySyncStatus" TEXT,
ADD COLUMN     "pharmacyDueAmount" DOUBLE PRECISION NOT NULL DEFAULT 0,
ADD COLUMN     "pharmacyOrder" JSONB,
ADD COLUMN     "pharmacyOrderStatus" TEXT;

-- CreateIndex
CREATE UNIQUE INDEX "Diagnostic_pharmacyId_key" ON "Diagnostic"("pharmacyId");
