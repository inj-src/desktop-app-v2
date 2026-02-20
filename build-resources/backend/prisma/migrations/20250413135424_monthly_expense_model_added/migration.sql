-- AlterTable
ALTER TABLE "Diagnostic" ADD COLUMN     "canReceptionistPayMonthlyExpenses" BOOLEAN DEFAULT true;

-- CreateTable
CREATE TABLE "MonthlyExpenseCategory" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "amount" INTEGER NOT NULL DEFAULT 0,
    "diagnosticId" TEXT NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "MonthlyExpenseCategory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MonthlyExpense" (
    "id" TEXT NOT NULL,
    "amount" INTEGER NOT NULL,
    "type" TEXT,
    "diagnosticId" TEXT NOT NULL,
    "monthlyExpenseCategoryId" TEXT NOT NULL,
    "paidById" TEXT,
    "paidAt" TIMESTAMP(3),
    "expenseMonth" INTEGER NOT NULL,
    "expenseYear" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" TIMESTAMP(3),
    "notes" TEXT,

    CONSTRAINT "MonthlyExpense_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "MonthlyExpenseCategory_diagnosticId_idx" ON "MonthlyExpenseCategory"("diagnosticId");

-- CreateIndex
CREATE INDEX "MonthlyExpenseCategory_name_idx" ON "MonthlyExpenseCategory"("name");

-- CreateIndex
CREATE INDEX "MonthlyExpenseCategory_name_diagnosticId_idx" ON "MonthlyExpenseCategory"("name", "diagnosticId");

-- CreateIndex
CREATE INDEX "MonthlyExpenseCategory_id_diagnosticId_idx" ON "MonthlyExpenseCategory"("id", "diagnosticId");

-- CreateIndex
CREATE UNIQUE INDEX "MonthlyExpenseCategory_name_diagnosticId_key" ON "MonthlyExpenseCategory"("name", "diagnosticId") WHERE "deletedAt" IS NULL;

-- CreateIndex
CREATE INDEX "MonthlyExpense_diagnosticId_idx" ON "MonthlyExpense"("diagnosticId");

-- CreateIndex
CREATE INDEX "MonthlyExpense_monthlyExpenseCategoryId_idx" ON "MonthlyExpense"("monthlyExpenseCategoryId");

-- CreateIndex
CREATE INDEX "MonthlyExpense_paidById_idx" ON "MonthlyExpense"("paidById");

-- CreateIndex
CREATE INDEX "MonthlyExpense_id_diagnosticId_idx" ON "MonthlyExpense"("id", "diagnosticId");

-- CreateIndex
CREATE INDEX "MonthlyExpense_id_monthlyExpenseCategoryId_idx" ON "MonthlyExpense"("id", "monthlyExpenseCategoryId");

-- CreateIndex
CREATE INDEX "MonthlyExpense_id_paidById_idx" ON "MonthlyExpense"("id", "paidById");

-- CreateIndex
CREATE INDEX "MonthlyExpense_monthlyExpenseCategoryId_diagnosticId_idx" ON "MonthlyExpense"("monthlyExpenseCategoryId", "diagnosticId");

-- CreateIndex
CREATE INDEX "MonthlyExpense_paidById_diagnosticId_idx" ON "MonthlyExpense"("paidById", "diagnosticId");

-- CreateIndex
CREATE INDEX "MonthlyExpense_paidById_monthlyExpenseCategoryId_idx" ON "MonthlyExpense"("paidById", "monthlyExpenseCategoryId");

-- CreateIndex
CREATE INDEX "MonthlyExpense_paidAt_idx" ON "MonthlyExpense"("paidAt");

-- CreateIndex
CREATE INDEX "MonthlyExpense_updatedAt_idx" ON "MonthlyExpense"("updatedAt");

-- CreateIndex
CREATE UNIQUE INDEX "MonthlyExpense_monthlyExpenseCategoryId_diagnosticId_expens_key" ON "MonthlyExpense"("monthlyExpenseCategoryId", "diagnosticId", "expenseMonth", "expenseYear");

-- AddForeignKey
ALTER TABLE "MonthlyExpenseCategory" ADD CONSTRAINT "MonthlyExpenseCategory_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MonthlyExpense" ADD CONSTRAINT "MonthlyExpense_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "Diagnostic"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MonthlyExpense" ADD CONSTRAINT "MonthlyExpense_monthlyExpenseCategoryId_fkey" FOREIGN KEY ("monthlyExpenseCategoryId") REFERENCES "MonthlyExpenseCategory"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MonthlyExpense" ADD CONSTRAINT "MonthlyExpense_paidById_fkey" FOREIGN KEY ("paidById") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;
