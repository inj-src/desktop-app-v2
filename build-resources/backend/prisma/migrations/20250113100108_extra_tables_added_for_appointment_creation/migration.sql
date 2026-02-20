/*
  Warnings:

  - You are about to drop the column `userId` on the `Appointment` table. All the data in the column will be lost.
  - You are about to drop the column `place` on the `DoctorChamber` table. All the data in the column will be lost.

*/
-- CreateEnum
CREATE TYPE "AppointmentStatus" AS ENUM ('PENDING', 'CONFIRMED', 'COMPLETED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "AppointmentType" AS ENUM ('FIRST_VISIT', 'FOLLOW_UP', 'REPORT_SHOW');

-- DropForeignKey
ALTER TABLE "Appointment" DROP CONSTRAINT "Appointment_userId_fkey";

-- AlterTable
ALTER TABLE "Appointment" DROP COLUMN "userId";

-- AlterTable
ALTER TABLE "DoctorChamber" DROP COLUMN "place",
ADD COLUMN     "room" TEXT,
ADD COLUMN     "timeInterval" INTEGER NOT NULL DEFAULT 5;

-- CreateTable
CREATE TABLE "Slot" (
    "id" TEXT NOT NULL,
    "dayIds" INTEGER[],
    "slotName" TEXT,
    "startTime" TIMESTAMP(3) NOT NULL,
    "endTime" TIMESTAMP(3) NOT NULL,
    "doctorChamberId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" TIMESTAMP(3),
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Slot_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DoctorAppointment" (
    "id" TEXT NOT NULL,
    "slotId" TEXT NOT NULL,
    "patientId" TEXT NOT NULL,
    "serialNo" INTEGER NOT NULL,
    "timeOf" TIMESTAMP(3) NOT NULL,
    "numOfMsgs" INTEGER NOT NULL DEFAULT 0,
    "userId" TEXT,
    "status" "AppointmentStatus" NOT NULL DEFAULT 'PENDING',
    "type" "AppointmentType" NOT NULL DEFAULT 'FIRST_VISIT',
    "cancelReason" TEXT,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" TIMESTAMP(3),
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "DoctorAppointment_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "Slot_doctorChamberId_idx" ON "Slot"("doctorChamberId");

-- CreateIndex
CREATE UNIQUE INDEX "Slot_doctorChamberId_startTime_endTime_key" ON "Slot"("doctorChamberId", "startTime", "endTime");

-- CreateIndex
CREATE INDEX "DoctorAppointment_serialNo_idx" ON "DoctorAppointment"("serialNo");

-- CreateIndex
CREATE INDEX "DoctorAppointment_slotId_idx" ON "DoctorAppointment"("slotId");

-- CreateIndex
CREATE INDEX "DoctorAppointment_userId_idx" ON "DoctorAppointment"("userId");

-- CreateIndex
CREATE INDEX "DoctorAppointment_patientId_idx" ON "DoctorAppointment"("patientId");

-- CreateIndex
CREATE UNIQUE INDEX "DoctorAppointment_slotId_timeOf_key" ON "DoctorAppointment"("slotId", "timeOf");

-- CreateIndex
CREATE UNIQUE INDEX "DoctorAppointment_slotId_serialNo_timeOf_key" ON "DoctorAppointment"("slotId", "serialNo", "timeOf");

-- AddForeignKey
ALTER TABLE "Slot" ADD CONSTRAINT "Slot_doctorChamberId_fkey" FOREIGN KEY ("doctorChamberId") REFERENCES "DoctorChamber"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DoctorAppointment" ADD CONSTRAINT "DoctorAppointment_slotId_fkey" FOREIGN KEY ("slotId") REFERENCES "Slot"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DoctorAppointment" ADD CONSTRAINT "DoctorAppointment_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "Patient"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DoctorAppointment" ADD CONSTRAINT "DoctorAppointment_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;
