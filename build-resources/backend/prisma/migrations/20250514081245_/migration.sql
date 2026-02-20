-- CreateTable
CREATE TABLE "DailyIncomeCategory" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "diagnosticId" TEXT,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "DailyIncomeCategory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DailyExtraIncome" (
    "id" TEXT NOT NULL,
    "receivedFrom" TEXT NOT NULL,
    "amount" INTEGER NOT NULL,
    "type" TEXT,
    "description" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "diagnosticId" TEXT NOT NULL,
    "userId" TEXT,
    "dailyIncomeCategoryId" TEXT,
    "isIndoorIncome" BOOLEAN NOT NULL DEFAULT false,
    "invoiceNumber" TEXT,
    "paymentMethod" TEXT,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "DailyExtraIncome_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "DailyExtraIncome_diagnosticId_idx" ON "DailyExtraIncome"("diagnosticId");

-- CreateIndex
CREATE INDEX "DailyExtraIncome_userId_idx" ON "DailyExtraIncome"("userId");

-- CreateIndex
CREATE INDEX "DailyExtraIncome_dailyIncomeCategoryId_idx" ON "DailyExtraIncome"("dailyIncomeCategoryId");

-- CreateIndex
CREATE INDEX "DailyExtraIncome_createdAt_idx" ON "DailyExtraIncome"("createdAt");

-- AddForeignKey
ALTER TABLE "DailyIncomeCategory" ADD CONSTRAINT "DailyIncomeCategory_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DailyExtraIncome" ADD CONSTRAINT "DailyExtraIncome_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "Diagnostic"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DailyExtraIncome" ADD CONSTRAINT "DailyExtraIncome_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DailyExtraIncome" ADD CONSTRAINT "DailyExtraIncome_dailyIncomeCategoryId_fkey" FOREIGN KEY ("dailyIncomeCategoryId") REFERENCES "DailyIncomeCategory"("id") ON DELETE SET NULL ON UPDATE CASCADE;
