-- AlterTable
ALTER TABLE "public"."Bill" ADD COLUMN     "hospitalBillId" TEXT;

-- AlterTable
ALTER TABLE "public"."Diagnostic" ADD COLUMN     "allowOutdoorBillClearanceFromIndoor" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "isDutyDoctorSameAsReferredDoctor" BOOLEAN DEFAULT false;

-- AlterTable
ALTER TABLE "public"."HospitalBill" ADD COLUMN     "outdoorBillIds" TEXT[] DEFAULT ARRAY[]::TEXT[];
