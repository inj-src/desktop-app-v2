/*
  Warnings:

  - Added the required column `packageId` to the `SMSPackagePurchase` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "SMSPackagePurchase" ADD COLUMN     "packageId" TEXT NOT NULL;

-- AddForeignKey
ALTER TABLE "SMSPackagePurchase" ADD CONSTRAINT "SMSPackagePurchase_packageId_fkey" FOREIGN KEY ("packageId") REFERENCES "SMSPackage"("id") ON DELETE CASCADE ON UPDATE CASCADE;
