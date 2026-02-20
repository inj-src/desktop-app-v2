-- CreateIndex
CREATE INDEX "Bill_diagnosticId_createdAt_idx" ON "public"."Bill"("diagnosticId", "createdAt");

-- CreateIndex
CREATE INDEX "Bill_diagnosticId_createdAt_type_deletedAt_idx" ON "public"."Bill"("diagnosticId", "createdAt", "type", "deletedAt");

-- CreateIndex
CREATE INDEX "Bill_diagnosticId_type_deletedAt_idx" ON "public"."Bill"("diagnosticId", "type", "deletedAt");

-- CreateIndex
CREATE INDEX "Bill_diagnosticId_deletedAt_idx" ON "public"."Bill"("diagnosticId", "deletedAt");

-- CreateIndex
CREATE INDEX "Commission_diagnosticId_createdAt_idx" ON "public"."Commission"("diagnosticId", "createdAt");

-- CreateIndex
CREATE INDEX "Commission_diagnosticId_createdAt_isIndoorCommission_delete_idx" ON "public"."Commission"("diagnosticId", "createdAt", "isIndoorCommission", "deletedAt");

-- CreateIndex
CREATE INDEX "Commission_diagnosticId_isIndoorCommission_pCId_deletedAt_idx" ON "public"."Commission"("diagnosticId", "isIndoorCommission", "pCId", "deletedAt");

-- CreateIndex
CREATE INDEX "Commission_diagnosticId_isIndoorCommission_doctorId_deleted_idx" ON "public"."Commission"("diagnosticId", "isIndoorCommission", "doctorId", "deletedAt");

-- CreateIndex
CREATE INDEX "DailyExpense_diagnosticId_createdAt_idx" ON "public"."DailyExpense"("diagnosticId", "createdAt");

-- CreateIndex
CREATE INDEX "DailyExpense_diagnosticId_createdAt_deletedAt_isIndoorExpen_idx" ON "public"."DailyExpense"("diagnosticId", "createdAt", "deletedAt", "isIndoorExpense");

-- CreateIndex
CREATE INDEX "DailyExtraIncome_diagnosticId_createdAt_deletedAt_idx" ON "public"."DailyExtraIncome"("diagnosticId", "createdAt", "deletedAt");

-- CreateIndex
CREATE INDEX "HospitalBill_diagnosticId_idx" ON "public"."HospitalBill"("diagnosticId");

-- CreateIndex
CREATE INDEX "HospitalBill_diagnosticId_createdAt_idx" ON "public"."HospitalBill"("diagnosticId", "createdAt");

-- CreateIndex
CREATE INDEX "HospitalBill_diagnosticId_createdAt_type_deletedAt_idx" ON "public"."HospitalBill"("diagnosticId", "createdAt", "type", "deletedAt");

-- CreateIndex
CREATE INDEX "HospitalBill_diagnosticId_type_deletedAt_idx" ON "public"."HospitalBill"("diagnosticId", "type", "deletedAt");

-- CreateIndex
CREATE INDEX "HospitalBill_diagnosticId_deletedAt_idx" ON "public"."HospitalBill"("diagnosticId", "deletedAt");

-- CreateIndex
CREATE INDEX "HospitalBill_diagnosticId_status_deletedAt_idx" ON "public"."HospitalBill"("diagnosticId", "status", "deletedAt");

-- CreateIndex
CREATE INDEX "HospitalBill_diagnosticId_type_status_deletedAt_idx" ON "public"."HospitalBill"("diagnosticId", "type", "status", "deletedAt");

-- CreateIndex
CREATE INDEX "SurgeonOperationTrx_diagnosticId_createdAt_idx" ON "public"."SurgeonOperationTrx"("diagnosticId", "createdAt");

-- CreateIndex
CREATE INDEX "SurgeonOperationTrx_diagnosticId_createdAt_surgeonId_idx" ON "public"."SurgeonOperationTrx"("diagnosticId", "createdAt", "surgeonId");

-- CreateIndex
CREATE INDEX "SurgeonOperationTrx_diagnosticId_createdAt_anesthesiologist_idx" ON "public"."SurgeonOperationTrx"("diagnosticId", "createdAt", "anesthesiologistId");
