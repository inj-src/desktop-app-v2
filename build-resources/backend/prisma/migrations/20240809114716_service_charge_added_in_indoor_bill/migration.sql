-- AlterTable
ALTER TABLE "Diagnostic" ADD COLUMN     "indoorServiceCharge" INTEGER NOT NULL DEFAULT 0;

-- AlterTable
ALTER TABLE "HospitalBill" ADD COLUMN     "isServiceChargePaid" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "serviceCharge" INTEGER NOT NULL DEFAULT 0;
