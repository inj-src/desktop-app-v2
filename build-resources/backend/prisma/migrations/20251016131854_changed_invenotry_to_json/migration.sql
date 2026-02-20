/*
  Warnings:

  - The `inventoryItemsId` column on the `BillInventoryItem` table would be dropped and recreated. This will lead to data loss if there is data in the column.

*/
-- AlterTable
ALTER TABLE "public"."BillInventoryItem" DROP COLUMN "inventoryItemsId",
ADD COLUMN     "inventoryItemsId" JSONB;
