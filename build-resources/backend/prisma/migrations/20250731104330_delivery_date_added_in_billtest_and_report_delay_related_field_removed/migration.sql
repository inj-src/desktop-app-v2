/*
  Warnings:

  - You are about to drop the column `reportDelayInDays` on the `BillTest` table. All the data in the column will be lost.
  - You are about to drop the column `reportDelayInHours` on the `BillTest` table. All the data in the column will be lost.
  - You are about to drop the column `reportDelayInMinutes` on the `BillTest` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "BillTest" DROP COLUMN "reportDelayInDays",
DROP COLUMN "reportDelayInHours",
DROP COLUMN "reportDelayInMinutes",
ADD COLUMN     "deliveryDate" TIMESTAMP(3);
