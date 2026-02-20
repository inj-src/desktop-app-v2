-- AlterTable
ALTER TABLE "IndoorFieldVisibility" ADD COLUMN     "contactCard" BOOLEAN NOT NULL DEFAULT true,
ADD COLUMN     "doctorCard" BOOLEAN NOT NULL DEFAULT true,
ADD COLUMN     "patientCard" BOOLEAN NOT NULL DEFAULT true,
ADD COLUMN     "wardCard" BOOLEAN NOT NULL DEFAULT true;

-- AlterTable
ALTER TABLE "Patient" ADD COLUMN     "address" TEXT NOT NULL DEFAULT '',
ADD COLUMN     "district" TEXT NOT NULL DEFAULT '',
ADD COLUMN     "thana" TEXT NOT NULL DEFAULT '';
