/*
  Warnings:

  - A unique constraint covering the columns `[pcCode,diagnosticId,deletedAt]` on the table `PC` will be added. If there are existing duplicate values, this will fail.

*/
-- AlterTable
ALTER TABLE "public"."Diagnostic" ADD COLUMN     "pcCodeFormat" TEXT NOT NULL DEFAULT 'numeric',
ADD COLUMN     "pcCodeLength" INTEGER NOT NULL DEFAULT 4,
ADD COLUMN     "pcCodePrefix" TEXT NOT NULL DEFAULT '',
ADD COLUMN     "pcCodeStartFrom" INTEGER NOT NULL DEFAULT 1;

-- AlterTable
ALTER TABLE "public"."PC" ADD COLUMN     "pcCode" TEXT;

-- CreateIndex
CREATE UNIQUE INDEX "PC_pcCode_diagnosticId_deletedAt_key" ON "public"."PC"("pcCode", "diagnosticId", "deletedAt");
