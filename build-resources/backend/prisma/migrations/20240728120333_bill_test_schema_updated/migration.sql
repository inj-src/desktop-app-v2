-- AlterTable
ALTER TABLE "BillTest" ADD COLUMN     "isRefunded" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "isShowInLab" BOOLEAN NOT NULL DEFAULT true;
