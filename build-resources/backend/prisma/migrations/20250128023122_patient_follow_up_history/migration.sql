-- CreateTable
CREATE TABLE "PatientFollowupHistory" (
    "id" TEXT NOT NULL,
    "followupId" TEXT NOT NULL,
    "previousStatus" TEXT,
    "newStatus" TEXT NOT NULL,
    "previousFollowUpDate" TIMESTAMP(3),
    "newFollowUpDate" TIMESTAMP(3),
    "updatedById" TEXT NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "changeDetails" JSONB,

    CONSTRAINT "PatientFollowupHistory_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "PatientFollowupHistory" ADD CONSTRAINT "PatientFollowupHistory_followupId_fkey" FOREIGN KEY ("followupId") REFERENCES "patientFollowups"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PatientFollowupHistory" ADD CONSTRAINT "PatientFollowupHistory_updatedById_fkey" FOREIGN KEY ("updatedById") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
