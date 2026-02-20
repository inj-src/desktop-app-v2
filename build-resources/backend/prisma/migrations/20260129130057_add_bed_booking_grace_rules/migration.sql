-- AlterTable
ALTER TABLE "public"."Diagnostic" ADD COLUMN     "allowIndoorToAddOPD" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "bedDurationGraceMinutes" INTEGER,
ADD COLUMN     "bedGraceCheckoutFrom" TIMESTAMP(3),
ADD COLUMN     "bedGraceCheckoutTo" TIMESTAMP(3),
ADD COLUMN     "enableBedDurationGrace" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "enableBedGraceCheckout" BOOLEAN NOT NULL DEFAULT false;
