-- AlterTable
ALTER TABLE "public"."HospitalBill" ADD COLUMN     "referredDoctorId" TEXT;

-- AddForeignKey
ALTER TABLE "public"."HospitalBill" ADD CONSTRAINT "HospitalBill_referredDoctorId_fkey" FOREIGN KEY ("referredDoctorId") REFERENCES "public"."Doctor"("id") ON DELETE SET NULL ON UPDATE CASCADE;
