-- AlterTable
ALTER TABLE "Diagnostic" ADD COLUMN     "isHospitalManagement" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "isPCManagement" BOOLEAN NOT NULL DEFAULT false;
