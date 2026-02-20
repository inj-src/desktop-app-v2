-- AlterTable
ALTER TABLE "public"."InventoryItemDeductionSetting" ALTER COLUMN "completionThreshold" SET DEFAULT 1,
ALTER COLUMN "completionThreshold" SET DATA TYPE DOUBLE PRECISION;
