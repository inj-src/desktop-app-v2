-- DropForeignKey
ALTER TABLE "Message" DROP CONSTRAINT "Message_appointmentId_fkey";

-- AlterTable
ALTER TABLE "Message" ALTER COLUMN "appointmentId" DROP NOT NULL;

-- AddForeignKey
ALTER TABLE "Message" ADD CONSTRAINT "Message_appointmentId_fkey" FOREIGN KEY ("appointmentId") REFERENCES "DoctorAppointment"("id") ON DELETE SET NULL ON UPDATE CASCADE;
