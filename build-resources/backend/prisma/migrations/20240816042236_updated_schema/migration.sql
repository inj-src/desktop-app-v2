-- AlterTable
ALTER TABLE "SurgeonOperation" ADD COLUMN     "referralDiscount" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "referralDiscountType" TEXT NOT NULL DEFAULT 'amount',
ADD COLUMN     "referredBy" TEXT;
