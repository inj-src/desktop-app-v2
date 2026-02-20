/*
  Warnings:

  - A unique constraint covering the columns `[diagnosticId,doctorId,deletedAt]` on the table `DoctorChamber` will be added. If there are existing duplicate values, this will fail.

*/
-- DropIndex
DROP INDEX "DoctorChamber_diagnosticId_doctorId_key";

-- CreateIndex
CREATE UNIQUE INDEX "DoctorChamber_diagnosticId_doctorId_deletedAt_key" ON "DoctorChamber"("diagnosticId", "doctorId", "deletedAt");
