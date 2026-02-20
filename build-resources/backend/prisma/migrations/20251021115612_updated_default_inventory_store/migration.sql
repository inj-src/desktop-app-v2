-- CreateEnum
CREATE TYPE "public"."BillType" AS ENUM ('INDOOR', 'OUTDOOR', 'APPOINTMENT');

-- CreateTable
CREATE TABLE "public"."defaultInventoryStore" (
    "id" TEXT NOT NULL,
    "diagnosticId" TEXT NOT NULL,
    "storeId" TEXT NOT NULL,
    "billType" "public"."BillType" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "defaultInventoryStore_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "defaultInventoryStore_diagnosticId_storeId_billType_idx" ON "public"."defaultInventoryStore"("diagnosticId", "storeId", "billType");

-- CreateIndex
CREATE UNIQUE INDEX "defaultInventoryStore_diagnosticId_storeId_billType_deleted_key" ON "public"."defaultInventoryStore"("diagnosticId", "storeId", "billType", "deletedAt");

-- AddForeignKey
ALTER TABLE "public"."defaultInventoryStore" ADD CONSTRAINT "defaultInventoryStore_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "public"."Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."defaultInventoryStore" ADD CONSTRAINT "defaultInventoryStore_storeId_fkey" FOREIGN KEY ("storeId") REFERENCES "public"."Store"("id") ON DELETE CASCADE ON UPDATE CASCADE;
