/*
  Warnings:

  - You are about to drop the column `totalAmout` on the `HospitalBill` table. All the data in the column will be lost.
  - Added the required column `totalAmount` to the `HospitalBill` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "HospitalBill" DROP COLUMN "totalAmout",
ADD COLUMN     "nurseId" TEXT,
ADD COLUMN     "totalAmount" DOUBLE PRECISION NOT NULL,
ALTER COLUMN "cabinNo" DROP NOT NULL,
ALTER COLUMN "cabinNo" SET DATA TYPE TEXT,
ALTER COLUMN "floor" DROP NOT NULL,
ALTER COLUMN "floor" SET DATA TYPE TEXT,
ALTER COLUMN "diagnosis" DROP NOT NULL,
ALTER COLUMN "admissionFee" SET DEFAULT 0,
ALTER COLUMN "advanceFee" SET DEFAULT 0,
ALTER COLUMN "contactRelation" DROP NOT NULL,
ALTER COLUMN "contactName" DROP NOT NULL,
ALTER COLUMN "contactNumber" DROP NOT NULL;

-- CreateTable
CREATE TABLE "Nurse" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "diagnosticId" TEXT NOT NULL,

    CONSTRAINT "Nurse_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Nurse_name_diagnosticId_key" ON "Nurse"("name", "diagnosticId");

-- AddForeignKey
ALTER TABLE "Nurse" ADD CONSTRAINT "Nurse_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "HospitalBill" ADD CONSTRAINT "HospitalBill_nurseId_fkey" FOREIGN KEY ("nurseId") REFERENCES "Nurse"("id") ON DELETE SET NULL ON UPDATE CASCADE;
