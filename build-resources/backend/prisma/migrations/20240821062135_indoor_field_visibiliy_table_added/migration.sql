-- CreateTable
CREATE TABLE "IndoorFieldVisibility" (
    "id" TEXT NOT NULL,
    "phone" BOOLEAN NOT NULL DEFAULT true,
    "name" BOOLEAN NOT NULL DEFAULT true,
    "address" BOOLEAN NOT NULL DEFAULT true,
    "thana" BOOLEAN NOT NULL DEFAULT true,
    "district" BOOLEAN NOT NULL DEFAULT true,
    "diseaseName" BOOLEAN NOT NULL DEFAULT true,
    "gender" BOOLEAN NOT NULL DEFAULT true,
    "ageYear" BOOLEAN NOT NULL DEFAULT true,
    "ageMonth" BOOLEAN NOT NULL DEFAULT true,
    "ageDay" BOOLEAN NOT NULL DEFAULT true,
    "bed" BOOLEAN NOT NULL DEFAULT true,
    "admissionFee" BOOLEAN NOT NULL DEFAULT true,
    "advance" BOOLEAN NOT NULL DEFAULT true,
    "operationId" BOOLEAN NOT NULL DEFAULT true,
    "doctorId" BOOLEAN NOT NULL DEFAULT true,
    "nurseId" BOOLEAN NOT NULL DEFAULT true,
    "pcId" BOOLEAN NOT NULL DEFAULT true,
    "suregonId" BOOLEAN NOT NULL DEFAULT true,
    "anesthesisologistId" BOOLEAN NOT NULL DEFAULT true,
    "contactRelation" BOOLEAN NOT NULL DEFAULT true,
    "contactName" BOOLEAN NOT NULL DEFAULT true,
    "contactNumber" BOOLEAN NOT NULL DEFAULT true,
    "diagnosticId" TEXT NOT NULL,

    CONSTRAINT "IndoorFieldVisibility_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "IndoorFieldVisibility_diagnosticId_key" ON "IndoorFieldVisibility"("diagnosticId");

-- AddForeignKey
ALTER TABLE "IndoorFieldVisibility" ADD CONSTRAINT "IndoorFieldVisibility_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "Diagnostic"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
