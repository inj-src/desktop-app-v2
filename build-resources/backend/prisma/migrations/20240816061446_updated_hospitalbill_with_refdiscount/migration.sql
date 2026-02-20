-- AlterTable
ALTER TABLE "HospitalBill" ADD COLUMN     "referralDiscount" INTEGER NOT NULL DEFAULT 0;

-- AlterTable
ALTER TABLE "SurgeonOperation" ADD COLUMN     "referredById" TEXT;
