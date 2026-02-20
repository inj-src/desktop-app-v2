-- AlterTable
ALTER TABLE "Diagnostic" ADD COLUMN     "isSerialManagement" BOOLEAN;

-- CreateTable
CREATE TABLE "patientFollowups" (
    "id" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'Pending',
    "followUpDate" TIMESTAMP(3),
    "isPregnancyPatient" BOOLEAN NOT NULL DEFAULT false,
    "deliveryDate" TIMESTAMP(3),
    "diagnosticId" TEXT NOT NULL,
    "patientId" TEXT NOT NULL,
    "hospitalBillId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "patientFollowups_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "patientFollowups" ADD CONSTRAINT "patientFollowups_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "patientFollowups" ADD CONSTRAINT "patientFollowups_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "Patient"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "patientFollowups" ADD CONSTRAINT "patientFollowups_hospitalBillId_fkey" FOREIGN KEY ("hospitalBillId") REFERENCES "HospitalBill"("id") ON DELETE CASCADE ON UPDATE CASCADE;
