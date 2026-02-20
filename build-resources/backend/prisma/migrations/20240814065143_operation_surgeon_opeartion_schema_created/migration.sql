-- AlterTable
ALTER TABLE "Diagnostic" ADD COLUMN     "canChangeServiceChargeSettings" BOOLEAN;

-- CreateTable
CREATE TABLE "Operation" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "price" INTEGER NOT NULL,
    "discount" INTEGER NOT NULL DEFAULT 0,
    "discountType" TEXT NOT NULL DEFAULT 'amount',
    "diagnosticId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "Operation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SurgeonOperation" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "price" INTEGER NOT NULL,
    "discount" INTEGER NOT NULL DEFAULT 0,
    "discountType" TEXT NOT NULL DEFAULT 'amount',
    "surgeonAmount" INTEGER NOT NULL DEFAULT 0,
    "anesthesiologistAmount" INTEGER NOT NULL DEFAULT 0,
    "isSurgeonPaid" BOOLEAN NOT NULL DEFAULT false,
    "isAnesthesiologistPaid" BOOLEAN NOT NULL DEFAULT false,
    "operationType" TEXT,
    "status" TEXT NOT NULL DEFAULT 'pending',
    "priority" TEXT NOT NULL DEFAULT 'routine',
    "operationDate" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" TIMESTAMP(3),
    "diagnosticId" TEXT NOT NULL,
    "operationId" TEXT NOT NULL,
    "surgeonId" TEXT,
    "anesthesiologistId" TEXT,
    "patientId" TEXT,
    "hospitalBillId" TEXT NOT NULL,

    CONSTRAINT "SurgeonOperation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Surgeon" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "designation" TEXT,
    "image" TEXT,
    "diagnosticId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "Surgeon_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Anesthesiologist" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "designation" TEXT,
    "image" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "diagnosticId" TEXT NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "Anesthesiologist_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SurgeonOperationFee" (
    "id" TEXT NOT NULL,
    "surgeonId" TEXT NOT NULL,
    "operationId" TEXT NOT NULL,
    "surgeonFeeAmount" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "SurgeonOperationFee_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AnesthesiologistOperationFee" (
    "id" TEXT NOT NULL,
    "anesthesiologistId" TEXT NOT NULL,
    "operationId" TEXT NOT NULL,
    "anesthesiologistFeeAmount" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "AnesthesiologistOperationFee_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "Operation_id_idx" ON "Operation"("id");

-- CreateIndex
CREATE INDEX "SurgeonOperation_id_status_priority_idx" ON "SurgeonOperation"("id", "status", "priority");

-- CreateIndex
CREATE INDEX "Surgeon_id_diagnosticId_idx" ON "Surgeon"("id", "diagnosticId");

-- CreateIndex
CREATE INDEX "Anesthesiologist_id_diagnosticId_idx" ON "Anesthesiologist"("id", "diagnosticId");

-- CreateIndex
CREATE INDEX "SurgeonOperationFee_id_surgeonId_idx" ON "SurgeonOperationFee"("id", "surgeonId");

-- CreateIndex
CREATE UNIQUE INDEX "SurgeonOperationFee_surgeonId_operationId_key" ON "SurgeonOperationFee"("surgeonId", "operationId");

-- CreateIndex
CREATE INDEX "AnesthesiologistOperationFee_id_anesthesiologistId_idx" ON "AnesthesiologistOperationFee"("id", "anesthesiologistId");

-- CreateIndex
CREATE UNIQUE INDEX "AnesthesiologistOperationFee_anesthesiologistId_operationId_key" ON "AnesthesiologistOperationFee"("anesthesiologistId", "operationId");

-- AddForeignKey
ALTER TABLE "Operation" ADD CONSTRAINT "Operation_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SurgeonOperation" ADD CONSTRAINT "SurgeonOperation_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SurgeonOperation" ADD CONSTRAINT "SurgeonOperation_operationId_fkey" FOREIGN KEY ("operationId") REFERENCES "Operation"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SurgeonOperation" ADD CONSTRAINT "SurgeonOperation_surgeonId_fkey" FOREIGN KEY ("surgeonId") REFERENCES "Surgeon"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SurgeonOperation" ADD CONSTRAINT "SurgeonOperation_anesthesiologistId_fkey" FOREIGN KEY ("anesthesiologistId") REFERENCES "Anesthesiologist"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SurgeonOperation" ADD CONSTRAINT "SurgeonOperation_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "Patient"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SurgeonOperation" ADD CONSTRAINT "SurgeonOperation_hospitalBillId_fkey" FOREIGN KEY ("hospitalBillId") REFERENCES "HospitalBill"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Surgeon" ADD CONSTRAINT "Surgeon_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "Diagnostic"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Anesthesiologist" ADD CONSTRAINT "Anesthesiologist_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "Diagnostic"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SurgeonOperationFee" ADD CONSTRAINT "SurgeonOperationFee_surgeonId_fkey" FOREIGN KEY ("surgeonId") REFERENCES "Surgeon"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SurgeonOperationFee" ADD CONSTRAINT "SurgeonOperationFee_operationId_fkey" FOREIGN KEY ("operationId") REFERENCES "Operation"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AnesthesiologistOperationFee" ADD CONSTRAINT "AnesthesiologistOperationFee_anesthesiologistId_fkey" FOREIGN KEY ("anesthesiologistId") REFERENCES "Anesthesiologist"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AnesthesiologistOperationFee" ADD CONSTRAINT "AnesthesiologistOperationFee_operationId_fkey" FOREIGN KEY ("operationId") REFERENCES "Operation"("id") ON DELETE CASCADE ON UPDATE CASCADE;
