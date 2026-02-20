-- AlterTable
ALTER TABLE "public"."Diagnostic" ADD COLUMN     "isInventoryManagement" BOOLEAN,
ADD COLUMN     "isMarketingManagement" BOOLEAN,
ADD COLUMN     "isSMSManagement" BOOLEAN;
