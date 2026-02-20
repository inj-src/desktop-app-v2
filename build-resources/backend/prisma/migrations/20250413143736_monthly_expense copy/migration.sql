-- Drop the existing constraint
DROP INDEX "MonthlyExpense_monthlyExpenseCategoryId_diagnosticId_expens_key";

-- Create a filtered unique constraint
CREATE UNIQUE INDEX "MonthlyExpense_active_unique" 
ON "MonthlyExpense"("monthlyExpenseCategoryId", "diagnosticId", "expenseMonth", "expenseYear") 
WHERE "deletedAt" IS NULL;