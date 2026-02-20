-- AlterTable
ALTER TABLE "Diagnostic" ADD COLUMN     "isPCSamePayment" BOOLEAN;

-- AlterTable
ALTER TABLE "TestCategory" ADD COLUMN     "pcAmount" DOUBLE PRECISION NOT NULL DEFAULT 0,
ADD COLUMN     "pcAmountType" TEXT NOT NULL DEFAULT 'percentage';
