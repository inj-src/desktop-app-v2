-- AlterTable
ALTER TABLE "Bill" ADD COLUMN     "isTestSample" BOOLEAN NOT NULL DEFAULT false;

-- AlterTable
ALTER TABLE "BillTest" ADD COLUMN     "template" TEXT;
