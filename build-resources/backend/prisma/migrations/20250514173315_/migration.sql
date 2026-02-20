/*
  Warnings:

  - You are about to drop the column `smsPackageId` on the `SMSPackagePurchase` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE "SMSPackagePurchase" DROP CONSTRAINT "SMSPackagePurchase_smsPackageId_fkey";

-- AlterTable
ALTER TABLE "SMSPackagePurchase" DROP COLUMN "smsPackageId";
