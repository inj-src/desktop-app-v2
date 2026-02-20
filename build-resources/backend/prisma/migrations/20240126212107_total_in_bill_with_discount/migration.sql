-- AlterTable
ALTER TABLE "Bill" ADD COLUMN     "totalInAmountWithDiscount" DOUBLE PRECISION NOT NULL DEFAULT 0;

-- AlterTable
ALTER TABLE "HospitalBill" ADD COLUMN     "totalInAmountWithDiscount" DOUBLE PRECISION NOT NULL DEFAULT 0;
