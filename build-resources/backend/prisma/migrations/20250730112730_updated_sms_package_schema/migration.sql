/*
  Warnings:

  - You are about to alter the column `price` on the `SMSPackage` table. The data in that column could be lost. The data in that column will be cast from `DoublePrecision` to `Integer`.
  - Made the column `discount` on table `SMSPackage` required. This step will fail if there are existing NULL values in that column.
  - Added the required column `expiresAt` to the `SMSPackagePurchase` table without a default value. This is not possible if the table is not empty.

*/
-- AlterEnum
ALTER TYPE "SMSPackageStatus" ADD VALUE 'PENDING';

-- AlterTable
ALTER TABLE "SMSPackage" ADD COLUMN     "features" JSONB,
ALTER COLUMN "price" SET DATA TYPE INTEGER,
ALTER COLUMN "discount" SET NOT NULL,
ALTER COLUMN "discount" SET DEFAULT 0,
ALTER COLUMN "discountType" SET DEFAULT 'amount';

-- AlterTable
ALTER TABLE "SMSPackagePurchase" ADD COLUMN     "expiresAt" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "features" JSONB;
