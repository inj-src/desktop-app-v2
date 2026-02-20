-- AlterTable
ALTER TABLE "public"."Diagnostic" ADD COLUMN     "canReceptionistAddToInventory" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "canReceptionistManageInventory" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "deductInventoryOnBillCreation" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "deductInventoryOnHospitalBill" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "deductInventoryOnTestCompletion" BOOLEAN NOT NULL DEFAULT false;
