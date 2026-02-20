/*
  Warnings:

  - A unique constraint covering the columns `[name,diagnosticId,deletedAt]` on the table `SubTestCategory` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateIndex
CREATE UNIQUE INDEX "SubTestCategory_name_diagnosticId_deletedAt_key" ON "SubTestCategory"("name", "diagnosticId", "deletedAt");
