/*
  Warnings:

  - The `notes` column on the `DoctorAppointment` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The `src` column on the `DoctorAppointment` table would be dropped and recreated. This will lead to data loss if there is data in the column.

*/
-- CreateEnum
CREATE TYPE "AppointmentSource" AS ENUM ('WEBSITE', 'APP_ONLINE', 'APP_OFFLINE', 'RECEPTIONIST_ONLINE', 'RECEPTIONIST_OFFLINE', 'CALL');

-- AlterEnum
ALTER TYPE "AppointmentStatus" ADD VALUE 'ONLINE_RESERVED';

-- AlterTable
ALTER TABLE "DoctorAppointment" DROP COLUMN "notes",
ADD COLUMN     "notes" JSONB,
DROP COLUMN "src",
ADD COLUMN     "src" "AppointmentSource" NOT NULL DEFAULT 'APP_ONLINE';
