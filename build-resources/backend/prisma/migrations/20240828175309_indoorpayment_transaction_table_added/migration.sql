-- CreateTable
CREATE TABLE "SurgeonOperationTrx" (
    "id" TEXT NOT NULL,
    "totalAmount" DOUBLE PRECISION NOT NULL,
    "paidAmount" DOUBLE PRECISION NOT NULL,
    "info" JSONB,
    "diagnosticId" TEXT NOT NULL,
    "userId" TEXT,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "dailyExpenseId" TEXT,
    "surgeonOperationId" TEXT,
    "surgeonId" TEXT,
    "anesthesiologistId" TEXT,

    CONSTRAINT "SurgeonOperationTrx_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "SurgeonOperationTrx_dailyExpenseId_key" ON "SurgeonOperationTrx"("dailyExpenseId");

-- CreateIndex
CREATE UNIQUE INDEX "SurgeonOperationTrx_surgeonOperationId_key" ON "SurgeonOperationTrx"("surgeonOperationId");

-- AddForeignKey
ALTER TABLE "SurgeonOperationTrx" ADD CONSTRAINT "SurgeonOperationTrx_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SurgeonOperationTrx" ADD CONSTRAINT "SurgeonOperationTrx_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SurgeonOperationTrx" ADD CONSTRAINT "SurgeonOperationTrx_dailyExpenseId_fkey" FOREIGN KEY ("dailyExpenseId") REFERENCES "DailyExpense"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SurgeonOperationTrx" ADD CONSTRAINT "SurgeonOperationTrx_surgeonOperationId_fkey" FOREIGN KEY ("surgeonOperationId") REFERENCES "SurgeonOperation"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SurgeonOperationTrx" ADD CONSTRAINT "SurgeonOperationTrx_surgeonId_fkey" FOREIGN KEY ("surgeonId") REFERENCES "Surgeon"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SurgeonOperationTrx" ADD CONSTRAINT "SurgeonOperationTrx_anesthesiologistId_fkey" FOREIGN KEY ("anesthesiologistId") REFERENCES "Anesthesiologist"("id") ON DELETE CASCADE ON UPDATE CASCADE;
