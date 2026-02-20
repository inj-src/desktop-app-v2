-- AlterTable
ALTER TABLE "BillAccessory" ADD COLUMN     "diagnosticId" TEXT;

-- AlterTable
ALTER TABLE "PCTestCategoryPercentage" ADD COLUMN     "diagnosticId" TEXT;

-- AddForeignKey
ALTER TABLE "PCTestCategoryPercentage" ADD CONSTRAINT "PCTestCategoryPercentage_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BillAccessory" ADD CONSTRAINT "BillAccessory_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;
