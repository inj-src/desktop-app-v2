/*
  Warnings:

  - You are about to drop the column `pcId` on the `DoctorAppointment` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE "DoctorAppointment" DROP CONSTRAINT "DoctorAppointment_pcId_fkey";

-- DropIndex
DROP INDEX "DoctorAppointment_pcId_pcPaymentDate_idx";

-- AlterTable
ALTER TABLE "DoctorAppointment" DROP COLUMN "pcId",
ADD COLUMN     "pCId" TEXT;

-- CreateIndex
CREATE INDEX "DoctorAppointment_pCId_pcPaymentDate_idx" ON "DoctorAppointment"("pCId", "pcPaymentDate");

-- CreateIndex
CREATE INDEX "DoctorAppointment_pCId_idx" ON "DoctorAppointment"("pCId");

-- AddForeignKey
ALTER TABLE "DoctorAppointment" ADD CONSTRAINT "DoctorAppointment_pCId_fkey" FOREIGN KEY ("pCId") REFERENCES "PC"("id") ON DELETE SET NULL ON UPDATE CASCADE;
