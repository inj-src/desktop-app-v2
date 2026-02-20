/*
  Warnings:

  - A unique constraint covering the columns `[name,diagnosticId,deletedAt]` on the table `MonthlyExpenseCategory` will be added. If there are existing duplicate values, this will fail.

*/
-- DropIndex
DROP INDEX "MonthlyExpenseCategory_name_diagnosticId_key";

-- AlterTable
ALTER TABLE "MonthlyExpense" ADD COLUMN     "isIndoorExpense" BOOLEAN NOT NULL DEFAULT false;

-- AlterTable
ALTER TABLE "MonthlyExpenseCategory" ADD COLUMN     "isIndoorExpense" BOOLEAN NOT NULL DEFAULT false;
