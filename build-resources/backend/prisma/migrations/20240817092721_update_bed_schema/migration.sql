/*
  Warnings:

  - You are about to drop the column `bookingStatus` on the `Bed` table. All the data in the column will be lost.
  - You are about to drop the column `isAvailableForBooking` on the `Bed` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "Bed" DROP COLUMN "bookingStatus",
DROP COLUMN "isAvailableForBooking";
