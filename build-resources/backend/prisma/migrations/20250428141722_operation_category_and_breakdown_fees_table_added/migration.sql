-- AlterTable
ALTER TABLE "Operation" ADD COLUMN     "operationCategoryId" TEXT;

-- CreateTable
CREATE TABLE "OperationCategory" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "price" INTEGER NOT NULL,
    "discount" INTEGER NOT NULL DEFAULT 0,
    "discountType" TEXT NOT NULL DEFAULT 'amount',
    "diagnosticId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "OperationCategory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OperationCategoryBreakdownFeeTemplate" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "amount" INTEGER NOT NULL,
    "operationCategoryId" TEXT NOT NULL,
    "diagnosticId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "OperationCategoryBreakdownFeeTemplate_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OperationBreakdownFee" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "amount" INTEGER NOT NULL,
    "operationId" TEXT NOT NULL,
    "diagnosticId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" TIMESTAMP(3),
    "categoryTemplateId" TEXT,

    CONSTRAINT "OperationBreakdownFee_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SurgeonOperationBreakdownFee" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "amount" INTEGER NOT NULL,
    "discount" INTEGER NOT NULL DEFAULT 0,
    "discountType" TEXT NOT NULL DEFAULT 'amount',
    "surgeonOperationId" TEXT NOT NULL,
    "diagnosticId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" TIMESTAMP(3),
    "operationTemplateId" TEXT,

    CONSTRAINT "SurgeonOperationBreakdownFee_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "OperationCategory_id_idx" ON "OperationCategory"("id");

-- CreateIndex
CREATE INDEX "OperationCategoryBreakdownFeeTemplate_operationCategoryId_idx" ON "OperationCategoryBreakdownFeeTemplate"("operationCategoryId");

-- CreateIndex
CREATE INDEX "OperationBreakdownFee_operationId_idx" ON "OperationBreakdownFee"("operationId");

-- CreateIndex
CREATE INDEX "SurgeonOperationBreakdownFee_surgeonOperationId_idx" ON "SurgeonOperationBreakdownFee"("surgeonOperationId");

-- AddForeignKey
ALTER TABLE "OperationCategory" ADD CONSTRAINT "OperationCategory_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Operation" ADD CONSTRAINT "Operation_operationCategoryId_fkey" FOREIGN KEY ("operationCategoryId") REFERENCES "OperationCategory"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OperationCategoryBreakdownFeeTemplate" ADD CONSTRAINT "OperationCategoryBreakdownFeeTemplate_operationCategoryId_fkey" FOREIGN KEY ("operationCategoryId") REFERENCES "OperationCategory"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OperationCategoryBreakdownFeeTemplate" ADD CONSTRAINT "OperationCategoryBreakdownFeeTemplate_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OperationBreakdownFee" ADD CONSTRAINT "OperationBreakdownFee_operationId_fkey" FOREIGN KEY ("operationId") REFERENCES "Operation"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OperationBreakdownFee" ADD CONSTRAINT "OperationBreakdownFee_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SurgeonOperationBreakdownFee" ADD CONSTRAINT "SurgeonOperationBreakdownFee_surgeonOperationId_fkey" FOREIGN KEY ("surgeonOperationId") REFERENCES "SurgeonOperation"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SurgeonOperationBreakdownFee" ADD CONSTRAINT "SurgeonOperationBreakdownFee_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;
