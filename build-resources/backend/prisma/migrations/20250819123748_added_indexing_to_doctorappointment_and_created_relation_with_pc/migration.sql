-- AlterTable
ALTER TABLE "DoctorAppointment" ADD COLUMN     "isPcPaid" BOOLEAN DEFAULT false,
ADD COLUMN     "pcAmount" INTEGER DEFAULT 0,
ADD COLUMN     "pcId" TEXT,
ADD COLUMN     "pcPaymentDate" TIMESTAMP(3);

-- CreateIndex
CREATE INDEX "DoctorAppointment_diagnosticId_doctorChamberId_timeOf_delet_idx" ON "DoctorAppointment"("diagnosticId", "doctorChamberId", "timeOf", "deletedAt");

-- CreateIndex
CREATE INDEX "DoctorAppointment_diagnosticId_status_timeOf_idx" ON "DoctorAppointment"("diagnosticId", "status", "timeOf");

-- CreateIndex
CREATE INDEX "DoctorAppointment_patientId_timeOf_idx" ON "DoctorAppointment"("patientId", "timeOf");

-- CreateIndex
CREATE INDEX "DoctorAppointment_status_timeOf_idx" ON "DoctorAppointment"("status", "timeOf");

-- CreateIndex
CREATE INDEX "DoctorAppointment_doctorChamberId_timeOf_status_idx" ON "DoctorAppointment"("doctorChamberId", "timeOf", "status");

-- CreateIndex
CREATE INDEX "DoctorAppointment_isPaid_finalFee_idx" ON "DoctorAppointment"("isPaid", "finalFee");

-- CreateIndex
CREATE INDEX "DoctorAppointment_type_timeOf_idx" ON "DoctorAppointment"("type", "timeOf");

-- CreateIndex
CREATE INDEX "DoctorAppointment_label_timeOf_idx" ON "DoctorAppointment"("label", "timeOf");

-- CreateIndex
CREATE INDEX "DoctorAppointment_pcId_pcPaymentDate_idx" ON "DoctorAppointment"("pcId", "pcPaymentDate");

-- CreateIndex
CREATE INDEX "DoctorAppointment_serialNo_timeOf_idx" ON "DoctorAppointment"("serialNo", "timeOf");

-- AddForeignKey
ALTER TABLE "DoctorAppointment" ADD CONSTRAINT "DoctorAppointment_pcId_fkey" FOREIGN KEY ("pcId") REFERENCES "PC"("id") ON DELETE SET NULL ON UPDATE CASCADE;
