-- AlterTable
ALTER TABLE "public"."Diagnostic" ADD COLUMN     "filterDoctorCommissionByReferenceType" BOOLEAN DEFAULT false,
ADD COLUMN     "filterPcCommissionByReferenceType" BOOLEAN DEFAULT false;
