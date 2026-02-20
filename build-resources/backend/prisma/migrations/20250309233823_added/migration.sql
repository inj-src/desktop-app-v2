/*
  Warnings:

  - Made the column `createdAt` on table `publicDoctor` required. This step will fail if there are existing NULL values in that column.

*/
-- AlterTable
ALTER TABLE "publicDoctor" ADD COLUMN     "internalDoctorId" TEXT,
ALTER COLUMN "createdAt" SET NOT NULL,
ADD CONSTRAINT "publicDoctor_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "publicDoctorHospital" ADD CONSTRAINT "publicDoctorHospital_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "publicHospital" ADD COLUMN     "diagnosticId" TEXT,
ADD CONSTRAINT "publicHospital_pkey" PRIMARY KEY ("id");

-- CreateTable
CREATE TABLE "publicSpecialty" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "publicSpecialty_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "publicDoctorSpecialty" (
    "id" TEXT NOT NULL,
    "doctorId" TEXT NOT NULL,
    "specialtyId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "publicDoctorSpecialty_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "publicSpecialty_name_key" ON "publicSpecialty"("name");

-- CreateIndex
CREATE INDEX "publicDoctorSpecialty_doctorId_specialtyId_idx" ON "publicDoctorSpecialty"("doctorId", "specialtyId");

-- CreateIndex
CREATE UNIQUE INDEX "publicDoctorSpecialty_doctorId_specialtyId_key" ON "publicDoctorSpecialty"("doctorId", "specialtyId");

-- AddForeignKey
ALTER TABLE "publicDoctor" ADD CONSTRAINT "publicDoctor_internalDoctorId_fkey" FOREIGN KEY ("internalDoctorId") REFERENCES "Doctor"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "publicHospital" ADD CONSTRAINT "publicHospital_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "Diagnostic"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "publicDoctorSpecialty" ADD CONSTRAINT "publicDoctorSpecialty_doctorId_fkey" FOREIGN KEY ("doctorId") REFERENCES "publicDoctor"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "publicDoctorSpecialty" ADD CONSTRAINT "publicDoctorSpecialty_specialtyId_fkey" FOREIGN KEY ("specialtyId") REFERENCES "publicSpecialty"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- RenameIndex
ALTER INDEX "publicdoctor_searchvector_idx" RENAME TO "publicDoctor_searchVector_idx";

-- RenameIndex
ALTER INDEX "publichospital_searchvector_idx" RENAME TO "publicHospital_searchVector_idx";
