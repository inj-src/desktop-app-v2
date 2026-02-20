/*
  Warnings:

  - You are about to drop the column `labStartDate` on the `Diagnostic` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "Diagnostic" DROP COLUMN "labStartDate",
ADD COLUMN     "isShowAccessoryInBill" BOOLEAN,
ADD COLUMN     "isTestDiscountIncludeInBill" BOOLEAN;
