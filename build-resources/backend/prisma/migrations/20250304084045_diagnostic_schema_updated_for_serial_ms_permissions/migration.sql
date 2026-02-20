-- AlterTable
ALTER TABLE "Diagnostic" ADD COLUMN     "enableBreakSystemInSerialMS" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "enableQueueManagementInSerialMS" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "enableTokenPrintInSerialMS" BOOLEAN NOT NULL DEFAULT false;
