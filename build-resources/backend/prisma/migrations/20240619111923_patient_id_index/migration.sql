-- DropIndex
DROP INDEX "Patient_phone_patientId_idx";

-- CreateIndex
CREATE INDEX "Patient_phone_idx" ON "Patient"("phone");

-- CreateIndex
CREATE INDEX "Patient_patientId_idx" ON "Patient"("patientId");
