-- AlterTable
ALTER TABLE "Bill" ADD COLUMN     "isServiceChargePaid" BOOLEAN NOT NULL DEFAULT false;

-- CreateTable
CREATE TABLE "ServiceChargeTrx" (
    "id" TEXT NOT NULL,
    "totalAmount" DOUBLE PRECISION NOT NULL,
    "paidAmount" DOUBLE PRECISION NOT NULL,
    "isApproved" BOOLEAN NOT NULL DEFAULT false,
    "info" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "diagnosticId" TEXT NOT NULL,
    "userId" TEXT,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ServiceChargeTrx_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "ServiceChargeTrx" ADD CONSTRAINT "ServiceChargeTrx_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ServiceChargeTrx" ADD CONSTRAINT "ServiceChargeTrx_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;
