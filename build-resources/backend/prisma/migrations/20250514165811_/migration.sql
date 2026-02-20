-- CreateEnum
CREATE TYPE "SMSPackageStatus" AS ENUM ('ACTIVE', 'EXPIRED', 'DEPLETED', 'CANCELLED');

-- AlterTable
ALTER TABLE "Message" ADD COLUMN     "charCount" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "inBengali" BOOLEAN NOT NULL DEFAULT false;

-- CreateTable
CREATE TABLE "SMSPackage" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "totalSMS" INTEGER NOT NULL,
    "price" DOUBLE PRECISION NOT NULL,
    "discount" INTEGER,
    "discountType" TEXT,
    "validityDays" INTEGER,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "SMSPackage_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SMSPackagePurchase" (
    "id" TEXT NOT NULL,
    "purchaseDate" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expiryDate" TIMESTAMP(3),
    "totalSMS" INTEGER NOT NULL,
    "remainingSMS" INTEGER NOT NULL,
    "price" DOUBLE PRECISION NOT NULL,
    "status" "SMSPackageStatus" NOT NULL DEFAULT 'ACTIVE',
    "transactionId" TEXT,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),
    "smsPackageId" TEXT NOT NULL,
    "diagnosticId" TEXT NOT NULL,

    CONSTRAINT "SMSPackagePurchase_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "SMSPackagePurchase_status_idx" ON "SMSPackagePurchase"("status");

-- CreateIndex
CREATE INDEX "SMSPackagePurchase_purchaseDate_idx" ON "SMSPackagePurchase"("purchaseDate");

-- CreateIndex
CREATE INDEX "SMSPackagePurchase_expiryDate_idx" ON "SMSPackagePurchase"("expiryDate");

-- AddForeignKey
ALTER TABLE "SMSPackagePurchase" ADD CONSTRAINT "SMSPackagePurchase_smsPackageId_fkey" FOREIGN KEY ("smsPackageId") REFERENCES "SMSPackage"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SMSPackagePurchase" ADD CONSTRAINT "SMSPackagePurchase_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;
