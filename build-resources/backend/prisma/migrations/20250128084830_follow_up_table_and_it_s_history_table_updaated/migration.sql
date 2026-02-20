/*
  Warnings:

  - The `previousStatus` column on the `PatientFollowupHistory` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The `status` column on the `patientFollowups` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - Changed the type of `newStatus` on the `PatientFollowupHistory` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.

*/
-- CreateEnum
CREATE TYPE "FollowUpStatus" AS ENUM ('PENDING', 'CONFIRMED', 'CANCELLED');

-- AlterTable
ALTER TABLE "PatientFollowupHistory" ADD COLUMN     "newFollowUpMsg" TEXT,
ADD COLUMN     "previousFollowUpMsg" TEXT,
DROP COLUMN "previousStatus",
ADD COLUMN     "previousStatus" "FollowUpStatus",
DROP COLUMN "newStatus",
ADD COLUMN     "newStatus" "FollowUpStatus" NOT NULL;

-- AlterTable
ALTER TABLE "patientFollowups" ADD COLUMN     "followUpMsg" TEXT,
DROP COLUMN "status",
ADD COLUMN     "status" "FollowUpStatus" NOT NULL DEFAULT 'PENDING';
