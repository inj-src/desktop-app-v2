/*
  Warnings:

  - A unique constraint covering the columns `[monthlyExpenseCategoryId,diagnosticId,expenseMonth,expenseYear]` on the table `MonthlyExpense` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateIndex
CREATE INDEX "MonthlyExpense_monthlyExpenseCategoryId_diagnosticId_expens_idx" ON "MonthlyExpense"("monthlyExpenseCategoryId", "diagnosticId", "expenseMonth", "expenseYear");

-- CreateIndex
CREATE UNIQUE INDEX "MonthlyExpense_monthlyExpenseCategoryId_diagnosticId_expens_key" ON "MonthlyExpense"("monthlyExpenseCategoryId", "diagnosticId", "expenseMonth", "expenseYear");
