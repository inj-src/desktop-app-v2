-- AlterTable
ALTER TABLE "TestAccessories" ADD COLUMN     "diagnosticId" TEXT;

-- AddForeignKey
ALTER TABLE "TestAccessories" ADD CONSTRAINT "TestAccessories_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;
