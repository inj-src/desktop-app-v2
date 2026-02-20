-- AlterTable
ALTER TABLE "Bill" ADD COLUMN     "customId" TEXT;

-- AlterTable
ALTER TABLE "Diagnostic" ADD COLUMN     "canReceptionistChangePcCommission" BOOLEAN DEFAULT true,
ADD COLUMN     "showCustomFieldInBillCreation" BOOLEAN;
