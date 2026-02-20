-- CreateEnum
CREATE TYPE "AppointmentLabel" AS ENUM ('VIP', 'GENERAL', 'PC', 'URGENT');

-- AlterTable
ALTER TABLE "DoctorAppointment" ADD COLUMN     "label" "AppointmentLabel" NOT NULL DEFAULT 'GENERAL';
