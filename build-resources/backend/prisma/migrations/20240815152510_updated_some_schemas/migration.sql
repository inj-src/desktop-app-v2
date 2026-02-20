/*
  Warnings:

  - You are about to drop the column `operationDate` on the `SurgeonOperation` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "HospitalBill" ADD COLUMN     "anethesiologistId" TEXT,
ADD COLUMN     "surgeonId" TEXT;

-- AlterTable
ALTER TABLE "SurgeonOperation" DROP COLUMN "operationDate",
ADD COLUMN     "note" TEXT,
ADD COLUMN     "operationEndTime" TIMESTAMP(3),
ADD COLUMN     "operationStartTime" TIMESTAMP(3);

-- AddForeignKey
ALTER TABLE "HospitalBill" ADD CONSTRAINT "HospitalBill_surgeonId_fkey" FOREIGN KEY ("surgeonId") REFERENCES "Surgeon"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "HospitalBill" ADD CONSTRAINT "HospitalBill_anethesiologistId_fkey" FOREIGN KEY ("anethesiologistId") REFERENCES "Anesthesiologist"("id") ON DELETE SET NULL ON UPDATE CASCADE;
