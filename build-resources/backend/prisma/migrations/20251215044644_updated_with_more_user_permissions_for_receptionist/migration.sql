-- AlterTable
ALTER TABLE "public"."Bill" ADD COLUMN     "discountReference" TEXT;

-- AlterTable
ALTER TABLE "public"."HospitalBill" ADD COLUMN     "discountReference" TEXT;

-- AlterTable
ALTER TABLE "public"."UserPermissions" ADD COLUMN     "canGiveIndoorDiscount" BOOLEAN NOT NULL DEFAULT true,
ADD COLUMN     "canGiveIndoorDiscountInAmount" BOOLEAN NOT NULL DEFAULT true,
ADD COLUMN     "canGiveOutdoorDiscount" BOOLEAN NOT NULL DEFAULT true,
ADD COLUMN     "canGiveOutdoorDiscountInAmount" BOOLEAN NOT NULL DEFAULT true,
ADD COLUMN     "maximumIndoorDiscountPercent" DOUBLE PRECISION,
ADD COLUMN     "maximumOutdoorDiscountPercent" DOUBLE PRECISION;
