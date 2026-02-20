-- DropForeignKey
ALTER TABLE "DoctorAppointment" DROP CONSTRAINT "DoctorAppointment_patientId_fkey";

-- AlterTable
ALTER TABLE "DoctorAppointment" ALTER COLUMN "patientId" DROP NOT NULL;

-- AddForeignKey
ALTER TABLE "DoctorAppointment" ADD CONSTRAINT "DoctorAppointment_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "Patient"("id") ON DELETE SET NULL ON UPDATE CASCADE;
