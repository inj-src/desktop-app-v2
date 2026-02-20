-- AlterTable
ALTER TABLE "AnesthesiologistOperationFee" ADD COLUMN     "diagnosticId" TEXT;

-- AlterTable
ALTER TABLE "SurgeonOperationFee" ADD COLUMN     "diagnosticId" TEXT;

-- AddForeignKey
ALTER TABLE "SurgeonOperationFee" ADD CONSTRAINT "SurgeonOperationFee_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "Diagnostic"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AnesthesiologistOperationFee" ADD CONSTRAINT "AnesthesiologistOperationFee_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "Diagnostic"("id") ON DELETE SET NULL ON UPDATE CASCADE;
