/*
  Warnings:

  - You are about to drop the column `expiresAt` on the `SMSPackagePurchase` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "SMSPackagePurchase" DROP COLUMN "expiresAt",
ALTER COLUMN "status" SET DEFAULT 'PENDING';
