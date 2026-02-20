/*
  Warnings:

  - A unique constraint covering the columns `[name,diagnosticId]` on the table `MonthlyExpenseCategory` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateIndex
CREATE UNIQUE INDEX "MonthlyExpenseCategory_name_diagnosticId_key" ON "MonthlyExpenseCategory"("name", "diagnosticId");
