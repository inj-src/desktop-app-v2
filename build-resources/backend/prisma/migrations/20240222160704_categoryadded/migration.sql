/*
  Warnings:

  - You are about to drop the column `type` on the `DailyExpense` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "DailyExpense" DROP COLUMN "type",
ADD COLUMN     "dailyExpenseCategoryId" INTEGER;

-- CreateTable
CREATE TABLE "DailyExpenseCategory" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "diagnosticId" TEXT,

    CONSTRAINT "DailyExpenseCategory_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "DailyExpenseCategory" ADD CONSTRAINT "DailyExpenseCategory_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DailyExpense" ADD CONSTRAINT "DailyExpense_dailyExpenseCategoryId_fkey" FOREIGN KEY ("dailyExpenseCategoryId") REFERENCES "DailyExpenseCategory"("id") ON DELETE SET NULL ON UPDATE CASCADE;
