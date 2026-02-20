-- DropForeignKey
ALTER TABLE "Patient" DROP CONSTRAINT "Patient_diagnosticId_fkey";

-- AlterTable
ALTER TABLE "Patient" ALTER COLUMN "gender" DROP NOT NULL,
ALTER COLUMN "diagnosticId" DROP NOT NULL;

-- AddForeignKey
ALTER TABLE "Patient" ADD CONSTRAINT "Patient_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "Diagnostic"("id") ON DELETE SET NULL ON UPDATE CASCADE;
