-- AlterTable
ALTER TABLE "public"."InventoryItem" ADD COLUMN     "expiryAlertDays" INTEGER DEFAULT 30,
ADD COLUMN     "maximumStock" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "minimumStock" DOUBLE PRECISION DEFAULT 100;
