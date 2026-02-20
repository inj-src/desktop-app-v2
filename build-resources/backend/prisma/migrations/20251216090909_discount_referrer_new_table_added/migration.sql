-- AlterTable
ALTER TABLE "public"."Bill" ADD COLUMN     "discountReferrerId" TEXT;

-- AlterTable
ALTER TABLE "public"."HospitalBill" ADD COLUMN     "discountReferrerId" TEXT;

-- CreateTable
CREATE TABLE "public"."DiscountReferrer" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "designation" TEXT,
    "phone" TEXT,
    "diagnosticId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "DiscountReferrer_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "DiscountReferrer_name_diagnosticId_idx" ON "public"."DiscountReferrer"("name", "diagnosticId");

-- AddForeignKey
ALTER TABLE "public"."Bill" ADD CONSTRAINT "Bill_discountReferrerId_fkey" FOREIGN KEY ("discountReferrerId") REFERENCES "public"."DiscountReferrer"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."DiscountReferrer" ADD CONSTRAINT "DiscountReferrer_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "public"."Diagnostic"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."HospitalBill" ADD CONSTRAINT "HospitalBill_discountReferrerId_fkey" FOREIGN KEY ("discountReferrerId") REFERENCES "public"."DiscountReferrer"("id") ON DELETE SET NULL ON UPDATE CASCADE;
