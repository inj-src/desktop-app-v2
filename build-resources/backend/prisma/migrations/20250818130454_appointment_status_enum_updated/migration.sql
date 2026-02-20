-- AlterEnum
-- This migration adds more than one value to an enum.
-- With PostgreSQL versions 11 and earlier, this is not possible
-- in a single migration. This can be worked around by creating
-- multiple migrations, each migration adding only one value to
-- the enum.


ALTER TYPE "AppointmentStatus" ADD VALUE 'MISSED';
ALTER TYPE "AppointmentStatus" ADD VALUE 'RESERVED';

-- CreateIndex
CREATE INDEX "DoctorAppointment_diagnosticId_doctorChamberId_slotId_idx" ON "DoctorAppointment"("diagnosticId", "doctorChamberId", "slotId");

-- CreateIndex
CREATE INDEX "DoctorAppointment_diagnosticId_timeOf_idx" ON "DoctorAppointment"("diagnosticId", "timeOf");

-- CreateIndex
CREATE INDEX "DoctorAppointment_status_idx" ON "DoctorAppointment"("status");
