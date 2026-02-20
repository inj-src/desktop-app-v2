-- DropForeignKey
ALTER TABLE "BillAccessory" DROP CONSTRAINT "BillAccessory_billId_fkey";

-- AddForeignKey
ALTER TABLE "BillAccessory" ADD CONSTRAINT "BillAccessory_billId_fkey" FOREIGN KEY ("billId") REFERENCES "Bill"("id") ON DELETE CASCADE ON UPDATE CASCADE;
