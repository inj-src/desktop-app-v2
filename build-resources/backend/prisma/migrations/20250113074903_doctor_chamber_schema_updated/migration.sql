/*
  Warnings:

  - A unique constraint covering the columns `[diagnosticId,userId,doctorId,deletedAt]` on the table `DoctorChamber` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[diagnosticId,uniqueId]` on the table `DoctorChamber` will be added. If there are existing duplicate values, this will fail.
  - Made the column `diagnosticId` on table `DoctorChamber` required. This step will fail if there are existing NULL values in that column.

*/
-- DropForeignKey
ALTER TABLE "DoctorChamber" DROP CONSTRAINT "DoctorChamber_diagnosticId_fkey";

-- AlterTable
ALTER TABLE "DoctorChamber" ADD COLUMN     "uniqueId" INTEGER,
ADD COLUMN     "userId" TEXT,
ALTER COLUMN "diagnosticId" SET NOT NULL;

-- CreateIndex
CREATE INDEX "DoctorChamber_doctorId_diagnosticId_idx" ON "DoctorChamber"("doctorId", "diagnosticId");

-- CreateIndex
CREATE INDEX "DoctorChamber_userId_diagnosticId_idx" ON "DoctorChamber"("userId", "diagnosticId");

-- CreateIndex
CREATE INDEX "DoctorChamber_diagnosticId_idx" ON "DoctorChamber"("diagnosticId");

-- CreateIndex
CREATE UNIQUE INDEX "DoctorChamber_diagnosticId_userId_doctorId_deletedAt_key" ON "DoctorChamber"("diagnosticId", "userId", "doctorId", "deletedAt");

-- CreateIndex
CREATE UNIQUE INDEX "DoctorChamber_diagnosticId_uniqueId_key" ON "DoctorChamber"("diagnosticId", "uniqueId");

-- AddForeignKey
ALTER TABLE "DoctorChamber" ADD CONSTRAINT "DoctorChamber_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DoctorChamber" ADD CONSTRAINT "DoctorChamber_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;
