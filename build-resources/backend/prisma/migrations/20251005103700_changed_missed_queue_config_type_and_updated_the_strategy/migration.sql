/*
  Warnings:

  - You are about to drop the column `checkIntervalSecondsForMissedQueue` on the `DoctorChamber` table. All the data in the column will be lost.
  - You are about to drop the column `enableMissedQueueAutomation` on the `DoctorChamber` table. All the data in the column will be lost.
  - The `missedQueueConfig` column on the `DoctorChamber` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - You are about to drop the `missedQueueConfig` table. If the table is not empty, all the data it contains will be lost.

*/
-- CreateEnum
CREATE TYPE "public"."MissedQueueStrategyType" AS ENUM ('ORDER_IN_LAST', 'SERIAL_COUNT_BASED', 'COMPLETED_COUNT_BASED', 'MANUAL');

-- AlterTable
ALTER TABLE "public"."DoctorChamber" DROP COLUMN "checkIntervalSecondsForMissedQueue",
DROP COLUMN "enableMissedQueueAutomation",
ADD COLUMN     "missedQueueX" INTEGER NOT NULL DEFAULT 0,
DROP COLUMN "missedQueueConfig",
ADD COLUMN     "missedQueueConfig" "public"."MissedQueueStrategyType" NOT NULL DEFAULT 'MANUAL';

-- DropTable
DROP TABLE "public"."missedQueueConfig";
