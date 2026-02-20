-- AlterTable
ALTER TABLE "public"."HospitalBill" ADD COLUMN     "inventoryCharge" INTEGER NOT NULL DEFAULT 0;

-- AlterTable
ALTER TABLE "public"."InventoryItem" ADD COLUMN     "reservedStock" DOUBLE PRECISION NOT NULL DEFAULT 0;

-- AlterTable
ALTER TABLE "public"."InventoryTransaction" ADD COLUMN     "billInventoryItemId" TEXT;

-- CreateTable
CREATE TABLE "public"."BillInventoryItem" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "storeName" TEXT NOT NULL,
    "tagName" TEXT NOT NULL,
    "quantity" DOUBLE PRECISION NOT NULL,
    "unitCost" DOUBLE PRECISION,
    "totalCost" DOUBLE PRECISION,
    "billId" TEXT NOT NULL,
    "diagnosticId" TEXT NOT NULL,
    "itemId" TEXT NOT NULL,
    "storeInventoryId" TEXT NOT NULL,
    "storeId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "BillInventoryItem_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "public"."BillInventoryItem" ADD CONSTRAINT "BillInventoryItem_billId_fkey" FOREIGN KEY ("billId") REFERENCES "public"."HospitalBill"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."BillInventoryItem" ADD CONSTRAINT "BillInventoryItem_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "public"."Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."BillInventoryItem" ADD CONSTRAINT "BillInventoryItem_itemId_fkey" FOREIGN KEY ("itemId") REFERENCES "public"."InventoryItem"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."BillInventoryItem" ADD CONSTRAINT "BillInventoryItem_storeInventoryId_fkey" FOREIGN KEY ("storeInventoryId") REFERENCES "public"."StoreInventoryItems"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."BillInventoryItem" ADD CONSTRAINT "BillInventoryItem_storeId_fkey" FOREIGN KEY ("storeId") REFERENCES "public"."Store"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."InventoryTransaction" ADD CONSTRAINT "InventoryTransaction_billInventoryItemId_fkey" FOREIGN KEY ("billInventoryItemId") REFERENCES "public"."BillInventoryItem"("id") ON DELETE SET NULL ON UPDATE CASCADE;
