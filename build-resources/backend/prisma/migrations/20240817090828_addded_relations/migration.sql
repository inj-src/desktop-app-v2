/*
  Warnings:

  - Added the required column `diagnosticId` to the `Bed` table without a default value. This is not possible if the table is not empty.
  - Added the required column `diagnosticId` to the `BedBooking` table without a default value. This is not possible if the table is not empty.
  - Added the required column `diagnosticId` to the `BedSubCategory` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "Bed" ADD COLUMN     "diagnosticId" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "BedBooking" ADD COLUMN     "diagnosticId" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "BedSubCategory" ADD COLUMN     "diagnosticId" TEXT NOT NULL;

-- AddForeignKey
ALTER TABLE "BedSubCategory" ADD CONSTRAINT "BedSubCategory_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "Diagnostic"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Bed" ADD CONSTRAINT "Bed_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "Diagnostic"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BedBooking" ADD CONSTRAINT "BedBooking_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "Diagnostic"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
