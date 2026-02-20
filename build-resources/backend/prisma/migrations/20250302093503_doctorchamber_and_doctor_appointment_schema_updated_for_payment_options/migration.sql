-- AlterEnum
ALTER TYPE "AppointmentStatus" ADD VALUE 'BOOKED';

-- AlterEnum
ALTER TYPE "AppointmentType" ADD VALUE 'OLD_VISIT';

-- AlterTable
ALTER TABLE "DoctorAppointment" ADD COLUMN     "discount" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "discountType" TEXT NOT NULL DEFAULT 'percentage',
ADD COLUMN     "durationMinutes" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "fee" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "finalFee" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "fullPaymentDate" TIMESTAMP(3),
ADD COLUMN     "isPaid" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "lastPaymentDate" TIMESTAMP(3),
ADD COLUMN     "paidAmount" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "patientFeedback" TEXT,
ADD COLUMN     "patientRating" INTEGER,
ADD COLUMN     "waitTimeMinutes" INTEGER NOT NULL DEFAULT 0;

-- AlterTable
ALTER TABLE "DoctorChamber" ADD COLUMN     "followUpFee" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "followupPeriodDays" INTEGER NOT NULL DEFAULT 7,
ADD COLUMN     "newPatientFee" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "oldPatientFee" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "renewalPeriodDays" INTEGER NOT NULL DEFAULT 30;
