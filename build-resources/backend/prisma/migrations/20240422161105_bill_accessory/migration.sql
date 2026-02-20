/*
  Warnings:

  - You are about to drop the column `accessoryId` on the `BillTest` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE "BillTest" DROP CONSTRAINT "BillTest_accessoryId_fkey";

-- AlterTable
ALTER TABLE "BillTest" DROP COLUMN "accessoryId";


-- CreateTable
CREATE TABLE "BillAccessory" (
    "id" SERIAL NOT NULL,
    "billId" INTEGER NOT NULL,
    "accessoryId" INTEGER NOT NULL,
    "quantity" INTEGER NOT NULL DEFAULT 1,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "BillAccessory_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "BillAccessory" ADD CONSTRAINT "BillAccessory_billId_fkey" FOREIGN KEY ("billId") REFERENCES "Bill"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BillAccessory" ADD CONSTRAINT "BillAccessory_accessoryId_fkey" FOREIGN KEY ("accessoryId") REFERENCES "Accessory"("id") ON DELETE CASCADE ON UPDATE CASCADE;
