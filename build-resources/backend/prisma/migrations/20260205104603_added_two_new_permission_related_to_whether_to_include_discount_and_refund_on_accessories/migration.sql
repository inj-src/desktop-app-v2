-- AlterTable
ALTER TABLE "public"."Diagnostic" ADD COLUMN     "isAccessoriesIncludedInDiscountCalculation" BOOLEAN DEFAULT false,
ADD COLUMN     "isAccessoriesIncludedInRefundCalculation" BOOLEAN DEFAULT false;
