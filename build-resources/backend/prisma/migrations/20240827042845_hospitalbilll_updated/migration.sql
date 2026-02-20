/*
  Warnings:

  - You are about to drop the column `anethesiologistId` on the `HospitalBill` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE "HospitalBill" DROP CONSTRAINT "HospitalBill_anethesiologistId_fkey";

-- AlterTable
ALTER TABLE "HospitalBill" DROP COLUMN "anethesiologistId",
ADD COLUMN     "anesthesiologistId" TEXT;

-- AddForeignKey
ALTER TABLE "HospitalBill" ADD CONSTRAINT "HospitalBill_anesthesiologistId_fkey" FOREIGN KEY ("anesthesiologistId") REFERENCES "Anesthesiologist"("id") ON DELETE SET NULL ON UPDATE CASCADE;
