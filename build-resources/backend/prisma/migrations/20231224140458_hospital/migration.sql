-- AlterTable
ALTER TABLE "Patient" ADD COLUMN     "patientId" SERIAL NOT NULL;

-- CreateTable
CREATE TABLE "Service" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "price" DOUBLE PRECISION,
    "diagnosticId" TEXT,

    CONSTRAINT "Service_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "HospitalBill" (
    "id" SERIAL NOT NULL,
    "billId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "ageYear" INTEGER,
    "ageMonth" INTEGER,
    "ageDay" INTEGER,
    "gender" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "cabinNo" INTEGER NOT NULL,
    "floor" INTEGER NOT NULL,
    "diagnosis" TEXT NOT NULL,
    "admissionFee" INTEGER NOT NULL,
    "advanceFee" INTEGER NOT NULL,
    "contactRelation" TEXT NOT NULL,
    "contactName" TEXT NOT NULL,
    "contactNumber" TEXT NOT NULL,
    "totalAmout" DOUBLE PRECISION NOT NULL,
    "paidAmount" DOUBLE PRECISION NOT NULL,
    "commissionAmount" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "hospitalDiscount" DOUBLE PRECISION NOT NULL,
    "hospitalDiscountType" TEXT NOT NULL DEFAULT 'percentage',
    "totalAmountWithDiscount" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "pcAmount" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "isPaid" BOOLEAN NOT NULL DEFAULT false,
    "isCommissionPaid" BOOLEAN NOT NULL DEFAULT false,
    "status" TEXT NOT NULL DEFAULT 'created',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "diagnosticId" TEXT,
    "doctorId" TEXT,
    "userId" TEXT,
    "patientId" TEXT,
    "pCId" TEXT,

    CONSTRAINT "HospitalBill_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "HospitalBillService" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "price" DOUBLE PRECISION NOT NULL,
    "discount" DOUBLE PRECISION NOT NULL,
    "unit" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "diagnosticId" TEXT,
    "serviceId" INTEGER,
    "hospitalBillId" INTEGER,

    CONSTRAINT "HospitalBillService_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "HospitalBill_billId_idx" ON "HospitalBill"("billId");

-- AddForeignKey
ALTER TABLE "Service" ADD CONSTRAINT "Service_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "HospitalBill" ADD CONSTRAINT "HospitalBill_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "HospitalBill" ADD CONSTRAINT "HospitalBill_doctorId_fkey" FOREIGN KEY ("doctorId") REFERENCES "Doctor"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "HospitalBill" ADD CONSTRAINT "HospitalBill_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "HospitalBill" ADD CONSTRAINT "HospitalBill_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "Patient"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "HospitalBill" ADD CONSTRAINT "HospitalBill_pCId_fkey" FOREIGN KEY ("pCId") REFERENCES "PC"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "HospitalBillService" ADD CONSTRAINT "HospitalBillService_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "Diagnostic"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "HospitalBillService" ADD CONSTRAINT "HospitalBillService_serviceId_fkey" FOREIGN KEY ("serviceId") REFERENCES "Service"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "HospitalBillService" ADD CONSTRAINT "HospitalBillService_hospitalBillId_fkey" FOREIGN KEY ("hospitalBillId") REFERENCES "HospitalBill"("id") ON DELETE CASCADE ON UPDATE CASCADE;
