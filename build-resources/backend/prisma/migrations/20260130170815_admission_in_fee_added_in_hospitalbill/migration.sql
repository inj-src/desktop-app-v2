-- AlterTable
ALTER TABLE "public"."HospitalBill" ADD COLUMN     "admissionInFee" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "admissionInFeeTotal" INTEGER NOT NULL DEFAULT 0;
