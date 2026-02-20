/*
  Warnings:

  - A unique constraint covering the columns `[slotId,timeOf,deletedAt]` on the table `DoctorAppointment` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[slotId,serialNo,timeOf,deletedAt]` on the table `DoctorAppointment` will be added. If there are existing duplicate values, this will fail.

*/
-- DropIndex
DROP INDEX "DoctorAppointment_slotId_serialNo_timeOf_key";

-- DropIndex
DROP INDEX "DoctorAppointment_slotId_timeOf_key";

-- DropIndex
DROP INDEX "Slot_doctorChamberId_startTime_endTime_key";

-- CreateIndex
CREATE UNIQUE INDEX "DoctorAppointment_slotId_timeOf_deletedAt_key" ON "DoctorAppointment"("slotId", "timeOf", "deletedAt");

-- CreateIndex
CREATE UNIQUE INDEX "DoctorAppointment_slotId_serialNo_timeOf_deletedAt_key" ON "DoctorAppointment"("slotId", "serialNo", "timeOf", "deletedAt");
