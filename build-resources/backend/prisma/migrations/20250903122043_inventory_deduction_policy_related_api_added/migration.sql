/*
  Warnings:

  - You are about to drop the column `batchNumber` on the `InventoryTransaction` table. All the data in the column will be lost.
  - You are about to drop the column `expiryDate` on the `InventoryTransaction` table. All the data in the column will be lost.

*/
-- CreateEnum
CREATE TYPE "public"."TriggerType" AS ENUM ('TEST_COMPLETION', 'OPERATION', 'OUTDOOR_BILL', 'CUSTOM');

-- CreateEnum
CREATE TYPE "public"."BillContext" AS ENUM ('OUTDOOR', 'INDOOR', 'LAB');

-- AlterTable
ALTER TABLE "public"."InventoryTransaction" DROP COLUMN "batchNumber",
DROP COLUMN "expiryDate";

-- CreateTable
CREATE TABLE "public"."InventoryItemDeductionSetting" (
    "id" TEXT NOT NULL,
    "itemId" TEXT NOT NULL,
    "triggerType" "public"."TriggerType" NOT NULL,
    "testId" TEXT,
    "operationId" TEXT,
    "completionThreshold" INTEGER NOT NULL DEFAULT 1,
    "deductionQuantity" DOUBLE PRECISION NOT NULL DEFAULT 1,
    "storeId" TEXT,
    "storeTagId" TEXT,
    "billContext" "public"."BillContext",
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "description" TEXT,
    "diagnosticId" TEXT NOT NULL,
    "userId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "InventoryItemDeductionSetting_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."ItemConsumptionTracker" (
    "id" TEXT NOT NULL,
    "settingId" TEXT NOT NULL,
    "currentCount" INTEGER NOT NULL DEFAULT 0,
    "storeId" TEXT,
    "lastUpdated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lastReset" TIMESTAMP(3),
    "diagnosticId" TEXT NOT NULL,

    CONSTRAINT "ItemConsumptionTracker_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."TriggerEvent" (
    "id" TEXT NOT NULL,
    "trackerId" TEXT NOT NULL,
    "triggerType" "public"."TriggerType" NOT NULL,
    "testId" TEXT,
    "operationId" TEXT,
    "storeId" TEXT,
    "triggeredAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "countAfter" INTEGER NOT NULL,
    "wasDeductionTriggered" BOOLEAN NOT NULL DEFAULT false,
    "quantityDeducted" DOUBLE PRECISION,
    "fromStoreId" TEXT,
    "transactionId" TEXT,
    "deductionSuccess" BOOLEAN,
    "errorMessage" TEXT,
    "notes" TEXT,
    "diagnosticId" TEXT NOT NULL,
    "userId" TEXT,

    CONSTRAINT "TriggerEvent_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "InventoryItemDeductionSetting_itemId_idx" ON "public"."InventoryItemDeductionSetting"("itemId");

-- CreateIndex
CREATE INDEX "InventoryItemDeductionSetting_triggerType_idx" ON "public"."InventoryItemDeductionSetting"("triggerType");

-- CreateIndex
CREATE INDEX "InventoryItemDeductionSetting_testId_idx" ON "public"."InventoryItemDeductionSetting"("testId");

-- CreateIndex
CREATE INDEX "InventoryItemDeductionSetting_operationId_idx" ON "public"."InventoryItemDeductionSetting"("operationId");

-- CreateIndex
CREATE INDEX "InventoryItemDeductionSetting_diagnosticId_idx" ON "public"."InventoryItemDeductionSetting"("diagnosticId");

-- CreateIndex
CREATE INDEX "InventoryItemDeductionSetting_isActive_idx" ON "public"."InventoryItemDeductionSetting"("isActive");

-- CreateIndex
CREATE INDEX "InventoryItemDeductionSetting_deletedAt_idx" ON "public"."InventoryItemDeductionSetting"("deletedAt");

-- CreateIndex
CREATE UNIQUE INDEX "InventoryItemDeductionSetting_itemId_triggerType_testId_ope_key" ON "public"."InventoryItemDeductionSetting"("itemId", "triggerType", "testId", "operationId", "storeId", "storeTagId");

-- CreateIndex
CREATE INDEX "ItemConsumptionTracker_settingId_idx" ON "public"."ItemConsumptionTracker"("settingId");

-- CreateIndex
CREATE INDEX "ItemConsumptionTracker_currentCount_idx" ON "public"."ItemConsumptionTracker"("currentCount");

-- CreateIndex
CREATE UNIQUE INDEX "ItemConsumptionTracker_settingId_storeId_key" ON "public"."ItemConsumptionTracker"("settingId", "storeId");

-- CreateIndex
CREATE INDEX "TriggerEvent_trackerId_idx" ON "public"."TriggerEvent"("trackerId");

-- CreateIndex
CREATE INDEX "TriggerEvent_triggerType_idx" ON "public"."TriggerEvent"("triggerType");

-- CreateIndex
CREATE INDEX "TriggerEvent_triggeredAt_idx" ON "public"."TriggerEvent"("triggeredAt");

-- CreateIndex
CREATE INDEX "TriggerEvent_diagnosticId_idx" ON "public"."TriggerEvent"("diagnosticId");

-- CreateIndex
CREATE INDEX "TriggerEvent_testId_idx" ON "public"."TriggerEvent"("testId");

-- CreateIndex
CREATE INDEX "TriggerEvent_operationId_idx" ON "public"."TriggerEvent"("operationId");

-- CreateIndex
CREATE INDEX "TriggerEvent_wasDeductionTriggered_idx" ON "public"."TriggerEvent"("wasDeductionTriggered");

-- CreateIndex
CREATE INDEX "TriggerEvent_deductionSuccess_idx" ON "public"."TriggerEvent"("deductionSuccess");

-- AddForeignKey
ALTER TABLE "public"."InventoryItemDeductionSetting" ADD CONSTRAINT "InventoryItemDeductionSetting_itemId_fkey" FOREIGN KEY ("itemId") REFERENCES "public"."InventoryItem"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."InventoryItemDeductionSetting" ADD CONSTRAINT "InventoryItemDeductionSetting_testId_fkey" FOREIGN KEY ("testId") REFERENCES "public"."Test"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."InventoryItemDeductionSetting" ADD CONSTRAINT "InventoryItemDeductionSetting_operationId_fkey" FOREIGN KEY ("operationId") REFERENCES "public"."Operation"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."InventoryItemDeductionSetting" ADD CONSTRAINT "InventoryItemDeductionSetting_storeId_fkey" FOREIGN KEY ("storeId") REFERENCES "public"."Store"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."InventoryItemDeductionSetting" ADD CONSTRAINT "InventoryItemDeductionSetting_storeTagId_fkey" FOREIGN KEY ("storeTagId") REFERENCES "public"."StoreTag"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."InventoryItemDeductionSetting" ADD CONSTRAINT "InventoryItemDeductionSetting_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "public"."Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."InventoryItemDeductionSetting" ADD CONSTRAINT "InventoryItemDeductionSetting_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."ItemConsumptionTracker" ADD CONSTRAINT "ItemConsumptionTracker_settingId_fkey" FOREIGN KEY ("settingId") REFERENCES "public"."InventoryItemDeductionSetting"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."ItemConsumptionTracker" ADD CONSTRAINT "ItemConsumptionTracker_storeId_fkey" FOREIGN KEY ("storeId") REFERENCES "public"."Store"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."ItemConsumptionTracker" ADD CONSTRAINT "ItemConsumptionTracker_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "public"."Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."TriggerEvent" ADD CONSTRAINT "TriggerEvent_trackerId_fkey" FOREIGN KEY ("trackerId") REFERENCES "public"."ItemConsumptionTracker"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."TriggerEvent" ADD CONSTRAINT "TriggerEvent_testId_fkey" FOREIGN KEY ("testId") REFERENCES "public"."Test"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."TriggerEvent" ADD CONSTRAINT "TriggerEvent_operationId_fkey" FOREIGN KEY ("operationId") REFERENCES "public"."Operation"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."TriggerEvent" ADD CONSTRAINT "TriggerEvent_storeId_fkey" FOREIGN KEY ("storeId") REFERENCES "public"."Store"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."TriggerEvent" ADD CONSTRAINT "TriggerEvent_fromStoreId_fkey" FOREIGN KEY ("fromStoreId") REFERENCES "public"."Store"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."TriggerEvent" ADD CONSTRAINT "TriggerEvent_transactionId_fkey" FOREIGN KEY ("transactionId") REFERENCES "public"."InventoryTransaction"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."TriggerEvent" ADD CONSTRAINT "TriggerEvent_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "public"."Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."TriggerEvent" ADD CONSTRAINT "TriggerEvent_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;
