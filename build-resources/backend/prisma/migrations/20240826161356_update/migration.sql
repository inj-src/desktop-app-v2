/*
  Warnings:

  - You are about to drop the column `anesthesisologistId` on the `IndoorFieldVisibility` table. All the data in the column will be lost.
  - You are about to drop the column `suregonId` on the `IndoorFieldVisibility` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "IndoorFieldVisibility" DROP COLUMN "anesthesisologistId",
DROP COLUMN "suregonId",
ADD COLUMN     "anesthesiologistId" BOOLEAN NOT NULL DEFAULT true,
ADD COLUMN     "surgeonId" BOOLEAN NOT NULL DEFAULT true;
