/*
  Warnings:

  - You are about to drop the column `appointmentId` on the `Bill` table. All the data in the column will be lost.
  - You are about to drop the `Appointment` table. If the table is not empty, all the data it contains will be lost.
  - Added the required column `diagnosticId` to the `DoctorAppointment` table without a default value. This is not possible if the table is not empty.
  - Added the required column `diagnosticId` to the `Slot` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "Appointment" DROP CONSTRAINT "Appointment_diagnosticId_fkey";

-- DropForeignKey
ALTER TABLE "Appointment" DROP CONSTRAINT "Appointment_doctorId_fkey";

-- DropForeignKey
ALTER TABLE "Appointment" DROP CONSTRAINT "Appointment_patientId_fkey";

-- DropForeignKey
ALTER TABLE "Bill" DROP CONSTRAINT "Bill_appointmentId_fkey";

-- AlterTable
ALTER TABLE "Bill" DROP COLUMN "appointmentId";

-- AlterTable
ALTER TABLE "DoctorAppointment" ADD COLUMN     "diagnosticId" TEXT NOT NULL,
ADD COLUMN     "src" TEXT NOT NULL DEFAULT 'online';

-- AlterTable
ALTER TABLE "Message" ADD COLUMN     "deletedAt" TIMESTAMP(3);

-- AlterTable
ALTER TABLE "Slot" ADD COLUMN     "diagnosticId" TEXT NOT NULL;

-- DropTable
DROP TABLE "Appointment";

-- AddForeignKey
ALTER TABLE "Slot" ADD CONSTRAINT "Slot_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DoctorAppointment" ADD CONSTRAINT "DoctorAppointment_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;
