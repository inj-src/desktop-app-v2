-- DropIndex
DROP INDEX "Patient_phone_idx";

-- CreateIndex
CREATE INDEX "Patient_phone_patientId_idx" ON "Patient"("phone", "patientId");
