/*
  Warnings:

  - You are about to drop the column `isTestSample` on the `Bill` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "Bill" DROP COLUMN "isTestSample";

-- AlterTable
ALTER TABLE "BillTest" ADD COLUMN     "isTestSample" BOOLEAN NOT NULL DEFAULT false;
