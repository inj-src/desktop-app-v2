/*
  Warnings:

  - You are about to drop the column `isBooked` on the `Bed` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE "BedBooking" DROP CONSTRAINT "BedBooking_patientId_fkey";

-- AlterTable
ALTER TABLE "Bed" DROP COLUMN "isBooked",
ADD COLUMN     "discount" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "discountType" TEXT NOT NULL DEFAULT 'amount',
ADD COLUMN     "isAvailableForBooking" BOOLEAN NOT NULL DEFAULT false;

-- AlterTable
ALTER TABLE "BedBooking" ADD COLUMN     "discount" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "discountType" TEXT NOT NULL DEFAULT 'amount',
ADD COLUMN     "price" INTEGER NOT NULL DEFAULT 0,
ALTER COLUMN "startDate" SET DEFAULT CURRENT_TIMESTAMP,
ALTER COLUMN "patientId" DROP NOT NULL;

-- AddForeignKey
ALTER TABLE "BedBooking" ADD CONSTRAINT "BedBooking_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "Patient"("id") ON DELETE SET NULL ON UPDATE CASCADE;
