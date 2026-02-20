-- CreateTable
CREATE TABLE "BedCategory" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "diagnosticId" TEXT NOT NULL,

    CONSTRAINT "BedCategory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BedSubCategory" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "bedCategoryId" TEXT NOT NULL,

    CONSTRAINT "BedSubCategory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Bed" (
    "id" TEXT NOT NULL,
    "bedNumber" TEXT NOT NULL,
    "roomNo" TEXT NOT NULL,
    "price" INTEGER NOT NULL DEFAULT 0,
    "bedSubCategoryId" TEXT NOT NULL,
    "isBooked" BOOLEAN NOT NULL DEFAULT false,
    "bookingStatus" TEXT NOT NULL DEFAULT 'available',

    CONSTRAINT "Bed_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BedBooking" (
    "id" TEXT NOT NULL,
    "bedId" TEXT NOT NULL,
    "startDate" TIMESTAMP(3) NOT NULL,
    "endDate" TIMESTAMP(3),
    "patientId" TEXT NOT NULL,
    "HospitalBillId" TEXT NOT NULL,
    "note" TEXT,

    CONSTRAINT "BedBooking_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "BedCategory" ADD CONSTRAINT "BedCategory_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "Diagnostic"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BedSubCategory" ADD CONSTRAINT "BedSubCategory_bedCategoryId_fkey" FOREIGN KEY ("bedCategoryId") REFERENCES "BedCategory"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Bed" ADD CONSTRAINT "Bed_bedSubCategoryId_fkey" FOREIGN KEY ("bedSubCategoryId") REFERENCES "BedSubCategory"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BedBooking" ADD CONSTRAINT "BedBooking_bedId_fkey" FOREIGN KEY ("bedId") REFERENCES "Bed"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BedBooking" ADD CONSTRAINT "BedBooking_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "Patient"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BedBooking" ADD CONSTRAINT "BedBooking_HospitalBillId_fkey" FOREIGN KEY ("HospitalBillId") REFERENCES "HospitalBill"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
