-- AlterTable
ALTER TABLE "DoctorUpdateInfo" ADD COLUMN     "applyAllDiagnostics" BOOLEAN,
ADD COLUMN     "applyToOnlySuperAdmin" BOOLEAN,
ADD COLUMN     "diagnosticIds" TEXT[] DEFAULT ARRAY[]::TEXT[];
