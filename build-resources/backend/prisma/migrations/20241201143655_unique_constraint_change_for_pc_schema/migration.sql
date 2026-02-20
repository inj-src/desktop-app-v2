/*
  Warnings:

  - A unique constraint covering the columns `[name,diagnosticId,deletedAt]` on the table `PC` will be added. If there are existing duplicate values, this will fail.

*/
-- DropIndex
DROP INDEX "PC_name_diagnosticId_key";

-- CreateIndex
CREATE UNIQUE INDEX "PC_name_diagnosticId_deletedAt_key" ON "PC"("name", "diagnosticId", "deletedAt");
