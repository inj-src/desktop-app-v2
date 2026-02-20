-- AlterTable
ALTER TABLE "Diagnostic" ADD COLUMN     "canReceptionistEditIndoorBill" BOOLEAN DEFAULT true,
ADD COLUMN     "canReceptionistEditOutdoorBill" BOOLEAN DEFAULT true,
ADD COLUMN     "enableOperationCategoryInOperation" BOOLEAN DEFAULT false;

-- CreateIndex
CREATE INDEX "OperationCategory_diagnosticId_idx" ON "OperationCategory"("diagnosticId");

-- CreateIndex
CREATE INDEX "OperationCategory_name_idx" ON "OperationCategory"("name");

-- CreateIndex
CREATE INDEX "OperationCategory_name_diagnosticId_deletedAt_idx" ON "OperationCategory"("name", "diagnosticId", "deletedAt");
