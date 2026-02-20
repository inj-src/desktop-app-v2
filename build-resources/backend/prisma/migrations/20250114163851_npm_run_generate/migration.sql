/*
  Warnings:

  - Added the required column `doctorChamberId` to the `DoctorAppointment` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "DoctorAppointment" ADD COLUMN     "doctorChamberId" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "Slot" ADD COLUMN     "maxAppointmentNumber" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "reserveAppointment" INTEGER NOT NULL DEFAULT 0;

-- AddForeignKey
ALTER TABLE "DoctorAppointment" ADD CONSTRAINT "DoctorAppointment_doctorChamberId_fkey" FOREIGN KEY ("doctorChamberId") REFERENCES "DoctorChamber"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
