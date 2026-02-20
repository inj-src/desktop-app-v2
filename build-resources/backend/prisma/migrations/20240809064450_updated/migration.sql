/*
  Warnings:

  - You are about to drop the column `serviceChrageLastPaymentDate` on the `ServiceChargeTrx` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "ServiceChargeTrx" DROP COLUMN "serviceChrageLastPaymentDate",
ADD COLUMN     "serviceChargeLastPaymentDate" TIMESTAMP(3);
