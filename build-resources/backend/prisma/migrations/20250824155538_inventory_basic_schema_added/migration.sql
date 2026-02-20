-- CreateEnum
CREATE TYPE "public"."TransactionType" AS ENUM ('IN', 'OUT', 'TRANSFER', 'ADJUSTMENT');

-- AlterTable
ALTER TABLE "public"."Diagnostic" ADD COLUMN     "inExpenseManagement" BOOLEAN NOT NULL DEFAULT true,
ADD COLUMN     "isIncomeManagement" BOOLEAN NOT NULL DEFAULT true,
ADD COLUMN     "isOutdoorManagement" BOOLEAN NOT NULL DEFAULT true,
ADD COLUMN     "showStatements" BOOLEAN NOT NULL DEFAULT true,
ALTER COLUMN "isPCManagement" SET DEFAULT true;

-- CreateTable
CREATE TABLE "public"."Store" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "code" TEXT,
    "description" TEXT,
    "location" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "diagnosticId" TEXT NOT NULL,
    "userId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "Store_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."StoreTag" (
    "id" TEXT NOT NULL,
    "storeId" TEXT NOT NULL,
    "tagId" TEXT NOT NULL,
    "diagnosticId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "StoreTag_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Tag" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "category" TEXT,
    "color" TEXT,
    "diagnosticId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "Tag_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."InventoryItem" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "code" TEXT,
    "description" TEXT,
    "category" TEXT,
    "unit" TEXT NOT NULL DEFAULT 'pcs',
    "availableStock" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "isSellable" BOOLEAN NOT NULL DEFAULT true,
    "isConsumable" BOOLEAN NOT NULL DEFAULT false,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "costPrice" DOUBLE PRECISION,
    "sellingPrice" DOUBLE PRECISION,
    "manufacturer" TEXT,
    "expiryTracked" BOOLEAN NOT NULL DEFAULT false,
    "batchTracked" BOOLEAN NOT NULL DEFAULT false,
    "diagnosticId" TEXT NOT NULL,
    "storeId" TEXT NOT NULL,
    "userId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "InventoryItem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."StoreInventoryItems" (
    "id" TEXT NOT NULL,
    "currentStock" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "reservedStock" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "availableStock" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "initialStock" DOUBLE PRECISION DEFAULT 0,
    "minimumStock" DOUBLE PRECISION DEFAULT 100,
    "maximumStock" DOUBLE PRECISION DEFAULT 0,
    "batchNumber" TEXT,
    "expiryDate" TIMESTAMP(3),
    "storeId" TEXT NOT NULL,
    "itemId" TEXT NOT NULL,
    "diagnosticId" TEXT NOT NULL,
    "userId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "StoreInventoryItems_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."InventoryTransaction" (
    "id" TEXT NOT NULL,
    "type" "public"."TransactionType" NOT NULL,
    "quantity" DOUBLE PRECISION NOT NULL,
    "unitCost" DOUBLE PRECISION,
    "totalCost" DOUBLE PRECISION,
    "reason" TEXT,
    "referenceType" TEXT,
    "referenceId" TEXT,
    "batchNumber" TEXT,
    "expiryDate" TIMESTAMP(3),
    "storeId" TEXT NOT NULL,
    "itemId" TEXT NOT NULL,
    "storeInventoryId" TEXT,
    "userId" TEXT,
    "diagnosticId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "InventoryTransaction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."InventoryPackage" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "code" TEXT,
    "description" TEXT,
    "category" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "isTemplate" BOOLEAN NOT NULL DEFAULT false,
    "totalCost" DOUBLE PRECISION,
    "sellingPrice" DOUBLE PRECISION,
    "diagnosticId" TEXT NOT NULL,
    "userId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "InventoryPackage_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."InventoryPackageItem" (
    "id" TEXT NOT NULL,
    "quantity" DOUBLE PRECISION NOT NULL,
    "isOptional" BOOLEAN NOT NULL DEFAULT false,
    "canSubstitute" BOOLEAN NOT NULL DEFAULT false,
    "notes" TEXT,
    "packageId" TEXT NOT NULL,
    "itemId" TEXT NOT NULL,
    "diagnosticId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "InventoryPackageItem_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "Store_diagnosticId_idx" ON "public"."Store"("diagnosticId");

-- CreateIndex
CREATE INDEX "Store_isActive_idx" ON "public"."Store"("isActive");

-- CreateIndex
CREATE INDEX "Store_code_idx" ON "public"."Store"("code");

-- CreateIndex
CREATE INDEX "Store_deletedAt_idx" ON "public"."Store"("deletedAt");

-- CreateIndex
CREATE INDEX "Store_diagnosticId_isActive_deletedAt_idx" ON "public"."Store"("diagnosticId", "isActive", "deletedAt");

-- CreateIndex
CREATE UNIQUE INDEX "StoreTag_storeId_key" ON "public"."StoreTag"("storeId");

-- CreateIndex
CREATE UNIQUE INDEX "StoreTag_tagId_key" ON "public"."StoreTag"("tagId");

-- CreateIndex
CREATE INDEX "StoreTag_diagnosticId_idx" ON "public"."StoreTag"("diagnosticId");

-- CreateIndex
CREATE INDEX "StoreTag_deletedAt_idx" ON "public"."StoreTag"("deletedAt");

-- CreateIndex
CREATE UNIQUE INDEX "StoreTag_storeId_tagId_key" ON "public"."StoreTag"("storeId", "tagId");

-- CreateIndex
CREATE INDEX "Tag_diagnosticId_idx" ON "public"."Tag"("diagnosticId");

-- CreateIndex
CREATE INDEX "Tag_category_idx" ON "public"."Tag"("category");

-- CreateIndex
CREATE INDEX "Tag_deletedAt_idx" ON "public"."Tag"("deletedAt");

-- CreateIndex
CREATE UNIQUE INDEX "Tag_name_diagnosticId_key" ON "public"."Tag"("name", "diagnosticId");

-- CreateIndex
CREATE INDEX "InventoryItem_diagnosticId_category_idx" ON "public"."InventoryItem"("diagnosticId", "category");

-- CreateIndex
CREATE INDEX "InventoryItem_storeId_idx" ON "public"."InventoryItem"("storeId");

-- CreateIndex
CREATE INDEX "InventoryItem_isActive_idx" ON "public"."InventoryItem"("isActive");

-- CreateIndex
CREATE INDEX "InventoryItem_isSellable_idx" ON "public"."InventoryItem"("isSellable");

-- CreateIndex
CREATE INDEX "InventoryItem_isConsumable_idx" ON "public"."InventoryItem"("isConsumable");

-- CreateIndex
CREATE INDEX "InventoryItem_deletedAt_idx" ON "public"."InventoryItem"("deletedAt");

-- CreateIndex
CREATE INDEX "InventoryItem_diagnosticId_isActive_deletedAt_idx" ON "public"."InventoryItem"("diagnosticId", "isActive", "deletedAt");

-- CreateIndex
CREATE INDEX "InventoryItem_storeId_isActive_deletedAt_idx" ON "public"."InventoryItem"("storeId", "isActive", "deletedAt");

-- CreateIndex
CREATE INDEX "InventoryItem_category_isActive_idx" ON "public"."InventoryItem"("category", "isActive");

-- CreateIndex
CREATE UNIQUE INDEX "InventoryItem_code_diagnosticId_key" ON "public"."InventoryItem"("code", "diagnosticId");

-- CreateIndex
CREATE INDEX "StoreInventoryItems_storeId_itemId_idx" ON "public"."StoreInventoryItems"("storeId", "itemId");

-- CreateIndex
CREATE INDEX "StoreInventoryItems_expiryDate_idx" ON "public"."StoreInventoryItems"("expiryDate");

-- CreateIndex
CREATE INDEX "StoreInventoryItems_diagnosticId_idx" ON "public"."StoreInventoryItems"("diagnosticId");

-- CreateIndex
CREATE INDEX "StoreInventoryItems_deletedAt_idx" ON "public"."StoreInventoryItems"("deletedAt");

-- CreateIndex
CREATE INDEX "StoreInventoryItems_currentStock_idx" ON "public"."StoreInventoryItems"("currentStock");

-- CreateIndex
CREATE INDEX "StoreInventoryItems_minimumStock_idx" ON "public"."StoreInventoryItems"("minimumStock");

-- CreateIndex
CREATE INDEX "StoreInventoryItems_storeId_currentStock_idx" ON "public"."StoreInventoryItems"("storeId", "currentStock");

-- CreateIndex
CREATE INDEX "StoreInventoryItems_diagnosticId_deletedAt_idx" ON "public"."StoreInventoryItems"("diagnosticId", "deletedAt");

-- CreateIndex
CREATE INDEX "StoreInventoryItems_expiryDate_deletedAt_idx" ON "public"."StoreInventoryItems"("expiryDate", "deletedAt");

-- CreateIndex
CREATE UNIQUE INDEX "StoreInventoryItems_storeId_itemId_batchNumber_key" ON "public"."StoreInventoryItems"("storeId", "itemId", "batchNumber");

-- CreateIndex
CREATE INDEX "InventoryTransaction_storeId_itemId_idx" ON "public"."InventoryTransaction"("storeId", "itemId");

-- CreateIndex
CREATE INDEX "InventoryTransaction_referenceType_referenceId_idx" ON "public"."InventoryTransaction"("referenceType", "referenceId");

-- CreateIndex
CREATE INDEX "InventoryTransaction_createdAt_idx" ON "public"."InventoryTransaction"("createdAt");

-- CreateIndex
CREATE INDEX "InventoryTransaction_diagnosticId_idx" ON "public"."InventoryTransaction"("diagnosticId");

-- CreateIndex
CREATE INDEX "InventoryTransaction_type_idx" ON "public"."InventoryTransaction"("type");

-- CreateIndex
CREATE INDEX "InventoryTransaction_userId_idx" ON "public"."InventoryTransaction"("userId");

-- CreateIndex
CREATE INDEX "InventoryTransaction_diagnosticId_type_idx" ON "public"."InventoryTransaction"("diagnosticId", "type");

-- CreateIndex
CREATE INDEX "InventoryTransaction_storeId_type_createdAt_idx" ON "public"."InventoryTransaction"("storeId", "type", "createdAt");

-- CreateIndex
CREATE INDEX "InventoryTransaction_diagnosticId_createdAt_idx" ON "public"."InventoryTransaction"("diagnosticId", "createdAt");

-- CreateIndex
CREATE INDEX "InventoryPackage_diagnosticId_category_idx" ON "public"."InventoryPackage"("diagnosticId", "category");

-- CreateIndex
CREATE INDEX "InventoryPackage_isActive_idx" ON "public"."InventoryPackage"("isActive");

-- CreateIndex
CREATE INDEX "InventoryPackage_isTemplate_idx" ON "public"."InventoryPackage"("isTemplate");

-- CreateIndex
CREATE INDEX "InventoryPackage_deletedAt_idx" ON "public"."InventoryPackage"("deletedAt");

-- CreateIndex
CREATE INDEX "InventoryPackage_diagnosticId_isActive_deletedAt_idx" ON "public"."InventoryPackage"("diagnosticId", "isActive", "deletedAt");

-- CreateIndex
CREATE UNIQUE INDEX "InventoryPackage_code_diagnosticId_key" ON "public"."InventoryPackage"("code", "diagnosticId");

-- CreateIndex
CREATE INDEX "InventoryPackageItem_packageId_idx" ON "public"."InventoryPackageItem"("packageId");

-- CreateIndex
CREATE INDEX "InventoryPackageItem_itemId_idx" ON "public"."InventoryPackageItem"("itemId");

-- CreateIndex
CREATE INDEX "InventoryPackageItem_diagnosticId_idx" ON "public"."InventoryPackageItem"("diagnosticId");

-- CreateIndex
CREATE INDEX "InventoryPackageItem_isOptional_idx" ON "public"."InventoryPackageItem"("isOptional");

-- CreateIndex
CREATE INDEX "InventoryPackageItem_canSubstitute_idx" ON "public"."InventoryPackageItem"("canSubstitute");

-- CreateIndex
CREATE UNIQUE INDEX "InventoryPackageItem_packageId_itemId_key" ON "public"."InventoryPackageItem"("packageId", "itemId");

-- AddForeignKey
ALTER TABLE "public"."Store" ADD CONSTRAINT "Store_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "public"."Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Store" ADD CONSTRAINT "Store_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."StoreTag" ADD CONSTRAINT "StoreTag_storeId_fkey" FOREIGN KEY ("storeId") REFERENCES "public"."Store"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."StoreTag" ADD CONSTRAINT "StoreTag_tagId_fkey" FOREIGN KEY ("tagId") REFERENCES "public"."Tag"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."StoreTag" ADD CONSTRAINT "StoreTag_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "public"."Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Tag" ADD CONSTRAINT "Tag_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "public"."Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."InventoryItem" ADD CONSTRAINT "InventoryItem_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "public"."Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."InventoryItem" ADD CONSTRAINT "InventoryItem_storeId_fkey" FOREIGN KEY ("storeId") REFERENCES "public"."Store"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."InventoryItem" ADD CONSTRAINT "InventoryItem_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."StoreInventoryItems" ADD CONSTRAINT "StoreInventoryItems_storeId_fkey" FOREIGN KEY ("storeId") REFERENCES "public"."Store"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."StoreInventoryItems" ADD CONSTRAINT "StoreInventoryItems_itemId_fkey" FOREIGN KEY ("itemId") REFERENCES "public"."InventoryItem"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."StoreInventoryItems" ADD CONSTRAINT "StoreInventoryItems_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "public"."Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."StoreInventoryItems" ADD CONSTRAINT "StoreInventoryItems_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."InventoryTransaction" ADD CONSTRAINT "InventoryTransaction_storeId_fkey" FOREIGN KEY ("storeId") REFERENCES "public"."Store"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."InventoryTransaction" ADD CONSTRAINT "InventoryTransaction_itemId_fkey" FOREIGN KEY ("itemId") REFERENCES "public"."InventoryItem"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."InventoryTransaction" ADD CONSTRAINT "InventoryTransaction_storeInventoryId_fkey" FOREIGN KEY ("storeInventoryId") REFERENCES "public"."StoreInventoryItems"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."InventoryTransaction" ADD CONSTRAINT "InventoryTransaction_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."InventoryTransaction" ADD CONSTRAINT "InventoryTransaction_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "public"."Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."InventoryPackage" ADD CONSTRAINT "InventoryPackage_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "public"."Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."InventoryPackage" ADD CONSTRAINT "InventoryPackage_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."InventoryPackageItem" ADD CONSTRAINT "InventoryPackageItem_packageId_fkey" FOREIGN KEY ("packageId") REFERENCES "public"."InventoryPackage"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."InventoryPackageItem" ADD CONSTRAINT "InventoryPackageItem_itemId_fkey" FOREIGN KEY ("itemId") REFERENCES "public"."InventoryItem"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."InventoryPackageItem" ADD CONSTRAINT "InventoryPackageItem_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "public"."Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;
