-- CreateEnum
CREATE TYPE "OperationType" AS ENUM ('CREATE', 'UPDATE', 'DELETE');

-- AlterTable
ALTER TABLE "Diagnostic" ADD COLUMN     "includeDiscountInPcCommission" BOOLEAN DEFAULT true;

-- AlterTable
ALTER TABLE "Doctor" ADD COLUMN     "uniqueId" INTEGER NOT NULL DEFAULT -1;

-- CreateTable
CREATE TABLE "DoctorUpdateInfo" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "doctorUniqueId" INTEGER NOT NULL,
    "operationName" "OperationType" NOT NULL DEFAULT 'UPDATE',
    "isApproved" BOOLEAN NOT NULL DEFAULT false,
    "hasActionTaken" BOOLEAN NOT NULL DEFAULT false,
    "approvedAt" TIMESTAMP(3),
    "previousDoctorName" TEXT,
    "previousDesignation" TEXT,
    "diagnosticId" TEXT,
    "doctorId" TEXT,

    CONSTRAINT "DoctorUpdateInfo_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "DoctorUpdateInfo" ADD CONSTRAINT "DoctorUpdateInfo_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "Diagnostic"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DoctorUpdateInfo" ADD CONSTRAINT "DoctorUpdateInfo_doctorId_fkey" FOREIGN KEY ("doctorId") REFERENCES "Doctor"("id") ON DELETE SET NULL ON UPDATE CASCADE;
