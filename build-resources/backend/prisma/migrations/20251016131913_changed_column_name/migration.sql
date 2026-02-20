/*
  Warnings:

  - You are about to drop the column `inventoryItemsId` on the `BillInventoryItem` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "public"."BillInventoryItem" DROP COLUMN "inventoryItemsId",
ADD COLUMN     "inventoryItems" JSONB;
