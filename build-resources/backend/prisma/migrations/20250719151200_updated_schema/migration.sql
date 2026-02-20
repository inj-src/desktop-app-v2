-- AlterTable
ALTER TABLE "HospitalBill" ADD COLUMN     "pharmacyOrderId" TEXT,
ADD COLUMN     "pharmacyPaidAmount" DOUBLE PRECISION NOT NULL DEFAULT 0,
ADD COLUMN     "pharmacyTotalAmount" DOUBLE PRECISION NOT NULL DEFAULT 0;
