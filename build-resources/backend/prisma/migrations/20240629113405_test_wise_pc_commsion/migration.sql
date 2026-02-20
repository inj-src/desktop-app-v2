-- AlterTable
ALTER TABLE "Diagnostic" ADD COLUMN     "isPCPaymentPerTest" BOOLEAN;

-- AlterTable
ALTER TABLE "Test" ADD COLUMN     "pcAmount" DOUBLE PRECISION NOT NULL DEFAULT 0,
ADD COLUMN     "pcAmountType" TEXT NOT NULL DEFAULT 'percentage';

-- CreateTable
CREATE TABLE "PCTestPercentage" (
    "id" TEXT NOT NULL,
    "discount" DOUBLE PRECISION,
    "discountType" TEXT NOT NULL DEFAULT 'percentage',
    "pCId" TEXT NOT NULL,
    "testId" TEXT NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "diagnosticId" TEXT,

    CONSTRAINT "PCTestPercentage_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "PCTestPercentage_pCId_testId_key" ON "PCTestPercentage"("pCId", "testId");

-- AddForeignKey
ALTER TABLE "PCTestPercentage" ADD CONSTRAINT "PCTestPercentage_pCId_fkey" FOREIGN KEY ("pCId") REFERENCES "PC"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PCTestPercentage" ADD CONSTRAINT "PCTestPercentage_testId_fkey" FOREIGN KEY ("testId") REFERENCES "Test"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PCTestPercentage" ADD CONSTRAINT "PCTestPercentage_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;
