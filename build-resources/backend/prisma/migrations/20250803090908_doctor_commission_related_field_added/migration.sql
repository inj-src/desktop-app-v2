-- AlterTable
ALTER TABLE "BillTest" ADD COLUMN     "doctorAmount" DOUBLE PRECISION NOT NULL DEFAULT 0,
ADD COLUMN     "doctorAmountType" TEXT NOT NULL DEFAULT 'amount',
ADD COLUMN     "doctorCommissionPaidAt" TIMESTAMP(3),
ADD COLUMN     "doctorCommissionPaidById" TEXT,
ADD COLUMN     "isDoctorCommissionPaid" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "isDoctorPayable" BOOLEAN NOT NULL DEFAULT false;

-- AlterTable
ALTER TABLE "Diagnostic" ADD COLUMN     "isDoctorPaymentPerTest" BOOLEAN,
ADD COLUMN     "maximumPercentageReceptionistCanSetInIndoorBill" INTEGER NOT NULL DEFAULT 100,
ADD COLUMN     "maximumPercentageReceptionistCanSetInOutdoorBill" INTEGER NOT NULL DEFAULT 100;

-- AlterTable
ALTER TABLE "Test" ADD COLUMN     "doctorAmount" DOUBLE PRECISION NOT NULL DEFAULT 0,
ADD COLUMN     "doctorAmountType" TEXT NOT NULL DEFAULT 'amount',
ADD COLUMN     "isDoctorPayable" BOOLEAN NOT NULL DEFAULT false;

-- AlterTable
ALTER TABLE "TestCategory" ADD COLUMN     "doctorCommissionAmount" DOUBLE PRECISION NOT NULL DEFAULT 0,
ADD COLUMN     "doctorCommissionType" TEXT NOT NULL DEFAULT 'amount',
ADD COLUMN     "isDoctorCommissionaire" BOOLEAN NOT NULL DEFAULT false;

-- AddForeignKey
ALTER TABLE "BillTest" ADD CONSTRAINT "BillTest_doctorCommissionPaidById_fkey" FOREIGN KEY ("doctorCommissionPaidById") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;
