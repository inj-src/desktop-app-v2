-- AlterTable
ALTER TABLE "Bill" ADD COLUMN     "deliveryDate" TIMESTAMP(3);

-- AlterTable
ALTER TABLE "Diagnostic" ADD COLUMN     "firstDeliveryDate" TIMESTAMP(3),
ADD COLUMN     "middleDate" TIMESTAMP(3),
ADD COLUMN     "secondDeliveryDate" TIMESTAMP(3);
