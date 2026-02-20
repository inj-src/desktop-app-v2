/*
  Warnings:

  - You are about to drop the column `time` on the `DoctorChamber` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "DoctorChamber" DROP COLUMN "time",
ADD COLUMN     "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP;
