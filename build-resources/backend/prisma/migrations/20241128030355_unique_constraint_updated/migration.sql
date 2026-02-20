/*
  Warnings:

  - A unique constraint covering the columns `[diagnosticId,name,designation,deletedAt]` on the table `Doctor` will be added. If there are existing duplicate values, this will fail.

*/
-- DropIndex
DROP INDEX "Doctor_diagnosticId_name_designation_key";

-- CreateIndex
CREATE UNIQUE INDEX "Doctor_diagnosticId_name_designation_deletedAt_key" ON "Doctor"("diagnosticId", "name", "designation", "deletedAt");
