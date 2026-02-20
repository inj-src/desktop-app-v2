-- AlterTable
ALTER TABLE "Diagnostic" ADD COLUMN     "isRefundBillPermission" BOOLEAN,
ADD COLUMN     "isShowDueWatermark" BOOLEAN,
ADD COLUMN     "isShowPaidWatermark" BOOLEAN,
ADD COLUMN     "isShowRefundedWatermark" BOOLEAN,
ADD COLUMN     "labStartDate" TIMESTAMP(3);
