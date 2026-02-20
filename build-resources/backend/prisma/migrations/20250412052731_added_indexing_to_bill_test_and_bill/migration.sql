-- CreateIndex
CREATE INDEX "Bill_doctorId_idx" ON "Bill"("doctorId");

-- CreateIndex
CREATE INDEX "Bill_labId_idx" ON "Bill"("labId");

-- CreateIndex
CREATE INDEX "Bill_doctorId_diagnosticId_idx" ON "Bill"("doctorId", "diagnosticId");

-- CreateIndex
CREATE INDEX "Bill_labId_diagnosticId_idx" ON "Bill"("labId", "diagnosticId");

-- CreateIndex
CREATE INDEX "Bill_billId_diagnosticId_idx" ON "Bill"("billId", "diagnosticId");

-- CreateIndex
CREATE INDEX "BillTest_diagnosticId_deletedAt_isShowInLab_idx" ON "BillTest"("diagnosticId", "deletedAt", "isShowInLab");

-- CreateIndex
CREATE INDEX "BillTest_billId_idx" ON "BillTest"("billId");

-- CreateIndex
CREATE INDEX "BillTest_testId_idx" ON "BillTest"("testId");

-- CreateIndex
CREATE INDEX "BillTest_createdAt_idx" ON "BillTest"("createdAt");

-- CreateIndex
CREATE INDEX "BillTest_updatedAt_idx" ON "BillTest"("updatedAt");

-- CreateIndex
CREATE INDEX "BillTest_diagnosticId_createdAt_idx" ON "BillTest"("diagnosticId", "createdAt");

-- CreateIndex
CREATE INDEX "BillTest_diagnosticId_updatedAt_idx" ON "BillTest"("diagnosticId", "updatedAt");

-- CreateIndex
CREATE INDEX "BillTest_template_idx" ON "BillTest"("template");

-- CreateIndex
CREATE INDEX "BillTest_collectedByUserId_idx" ON "BillTest"("collectedByUserId");

-- CreateIndex
CREATE INDEX "BillTest_preparedByUserId_idx" ON "BillTest"("preparedByUserId");

-- CreateIndex
CREATE INDEX "BillTest_testTemplateId_idx" ON "BillTest"("testTemplateId");
