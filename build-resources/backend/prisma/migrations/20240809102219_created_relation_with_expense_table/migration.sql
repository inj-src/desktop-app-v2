/*
  Warnings:

  - A unique constraint covering the columns `[dailyExpenseId]` on the table `ServiceChargeTrx` will be added. If there are existing duplicate values, this will fail.

*/
-- AlterTable
ALTER TABLE "Diagnostic" ADD COLUMN     "serviceChargeExpenseCategoryId" TEXT;

-- AlterTable
ALTER TABLE "ServiceChargeTrx" ADD COLUMN     "dailyExpenseId" TEXT;

-- CreateIndex
CREATE UNIQUE INDEX "ServiceChargeTrx_dailyExpenseId_key" ON "ServiceChargeTrx"("dailyExpenseId");

-- AddForeignKey
ALTER TABLE "ServiceChargeTrx" ADD CONSTRAINT "ServiceChargeTrx_dailyExpenseId_fkey" FOREIGN KEY ("dailyExpenseId") REFERENCES "DailyExpense"("id") ON DELETE SET NULL ON UPDATE CASCADE;
