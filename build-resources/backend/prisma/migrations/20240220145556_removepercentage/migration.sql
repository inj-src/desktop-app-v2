/*
  Warnings:

  - You are about to drop the column `percentage` on the `PCTestCategoryPercentage` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "PCTestCategoryPercentage" DROP COLUMN "percentage",
ADD COLUMN     "discount" DOUBLE PRECISION,
ADD COLUMN     "discountType" TEXT NOT NULL DEFAULT 'percentage';
