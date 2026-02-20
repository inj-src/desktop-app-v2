-- CreateEnum
CREATE TYPE "public"."BedDaySource" AS ENUM ('SYSTEM', 'MANUAL');

-- AlterTable
ALTER TABLE "public"."Diagnostic" ADD COLUMN     "allowManualBedDayOverride" BOOLEAN NOT NULL DEFAULT false;

-- AlterTable
ALTER TABLE "public"."HospitalBill" ADD COLUMN     "bedDayCalculationSource" "public"."BedDaySource" NOT NULL DEFAULT 'SYSTEM',
ADD COLUMN     "manualBedDayCount" INTEGER,
ADD COLUMN     "manualBedDayOverrideAt" TIMESTAMP(3),
ADD COLUMN     "manualBedDayOverrideBy" TEXT,
ADD COLUMN     "manualBedDayReason" TEXT;
