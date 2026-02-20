-- CreateEnum
CREATE TYPE "public"."CommissionSettings" AS ENUM ('INCLUDE_BOTH', 'EXCLUDE_BOTH', 'INCLUDE_PC_ONLY', 'INCLUDE_DOCTOR_ONLY');

-- AlterTable
ALTER TABLE "public"."Diagnostic" ADD COLUMN     "canLabAssistantManageInventory" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "commissionSettings" "public"."CommissionSettings" NOT NULL DEFAULT 'INCLUDE_BOTH',
ADD COLUMN     "includeDiscountInDoctorCommission" BOOLEAN DEFAULT false;
