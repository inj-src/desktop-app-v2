-- CreateEnum
CREATE TYPE "public"."COMMISSION_BASE" AS ENUM ('TEST_WISE', 'CATEGORY_WISE', 'SUBCATEGORY_WISE', 'PERSONAL');

-- AlterTable
ALTER TABLE "public"."Diagnostic" ADD COLUMN     "doctorCommissionBasis" "public"."COMMISSION_BASE",
ADD COLUMN     "isDoctorCommissionEnabled" BOOLEAN DEFAULT false;

-- AlterTable
ALTER TABLE "public"."Test" ADD COLUMN     "doctorCommissionAmount" DOUBLE PRECISION NOT NULL DEFAULT 0,
ADD COLUMN     "doctorCommissionType" TEXT NOT NULL DEFAULT 'amount';

-- CreateTable
CREATE TABLE "public"."DoctorTestCategoryPercentage" (
    "id" TEXT NOT NULL,
    "discount" DOUBLE PRECISION,
    "discountType" TEXT NOT NULL DEFAULT 'percentage',
    "doctorId" TEXT NOT NULL,
    "testCategoryId" TEXT NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "diagnosticId" TEXT,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "DoctorTestCategoryPercentage_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."DoctorTestPercentage" (
    "id" TEXT NOT NULL,
    "discount" DOUBLE PRECISION,
    "discountType" TEXT NOT NULL DEFAULT 'percentage',
    "doctorId" TEXT NOT NULL,
    "testId" TEXT NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "diagnosticId" TEXT,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "DoctorTestPercentage_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "DoctorTestCategoryPercentage_doctorId_testCategoryId_key" ON "public"."DoctorTestCategoryPercentage"("doctorId", "testCategoryId");

-- CreateIndex
CREATE UNIQUE INDEX "DoctorTestPercentage_doctorId_testId_key" ON "public"."DoctorTestPercentage"("doctorId", "testId");

-- AddForeignKey
ALTER TABLE "public"."DoctorTestCategoryPercentage" ADD CONSTRAINT "DoctorTestCategoryPercentage_doctorId_fkey" FOREIGN KEY ("doctorId") REFERENCES "public"."Doctor"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."DoctorTestCategoryPercentage" ADD CONSTRAINT "DoctorTestCategoryPercentage_testCategoryId_fkey" FOREIGN KEY ("testCategoryId") REFERENCES "public"."TestCategory"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."DoctorTestCategoryPercentage" ADD CONSTRAINT "DoctorTestCategoryPercentage_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "public"."Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."DoctorTestPercentage" ADD CONSTRAINT "DoctorTestPercentage_doctorId_fkey" FOREIGN KEY ("doctorId") REFERENCES "public"."Doctor"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."DoctorTestPercentage" ADD CONSTRAINT "DoctorTestPercentage_testId_fkey" FOREIGN KEY ("testId") REFERENCES "public"."Test"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."DoctorTestPercentage" ADD CONSTRAINT "DoctorTestPercentage_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "public"."Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;
