-- AlterEnum
ALTER TYPE "AppointmentStatus" ADD VALUE 'VACANT';

-- AlterTable
ALTER TABLE "DoctorAppointment" ADD COLUMN     "isVacant" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "originalAppointmentId" TEXT,
ADD COLUMN     "vacancyReason" TEXT;

-- AddForeignKey
ALTER TABLE "DoctorAppointment" ADD CONSTRAINT "DoctorAppointment_originalAppointmentId_fkey" FOREIGN KEY ("originalAppointmentId") REFERENCES "DoctorAppointment"("id") ON DELETE SET NULL ON UPDATE CASCADE;
