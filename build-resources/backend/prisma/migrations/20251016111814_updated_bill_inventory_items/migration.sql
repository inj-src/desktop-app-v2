-- AlterTable
ALTER TABLE "public"."BillInventoryItem" ADD COLUMN     "inventoryItemsId" TEXT[] DEFAULT ARRAY[]::TEXT[];
