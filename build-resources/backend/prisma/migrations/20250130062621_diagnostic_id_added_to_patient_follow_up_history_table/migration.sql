-- AlterTable
ALTER TABLE "PatientFollowupHistory" ADD COLUMN     "diagnosticId" TEXT;

-- AddForeignKey
ALTER TABLE "PatientFollowupHistory" ADD CONSTRAINT "PatientFollowupHistory_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;
