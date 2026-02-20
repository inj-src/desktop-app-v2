-- AlterTable
ALTER TABLE "Bill" ADD COLUMN     "serviceCharge" INTEGER NOT NULL DEFAULT 0;

-- AlterTable
ALTER TABLE "Diagnostic" ADD COLUMN     "serviceCharge" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "serviceChargePaymentDate" TIMESTAMP(3),
ADD COLUMN     "serviceChargePaymentPeriod" INTEGER NOT NULL DEFAULT 7;

-- AlterTable
ALTER TABLE "Test" ADD COLUMN     "subTestCategoryId" TEXT;

-- CreateTable
CREATE TABLE "SubTestCategory" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "diagnosticId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "SubTestCategory_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "Test" ADD CONSTRAINT "Test_subTestCategoryId_fkey" FOREIGN KEY ("subTestCategoryId") REFERENCES "SubTestCategory"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SubTestCategory" ADD CONSTRAINT "SubTestCategory_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;
