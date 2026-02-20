/*
  Warnings:

  - You are about to drop the column `designationn` on the `Signatures` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "Signatures" DROP COLUMN "designationn",
ADD COLUMN     "designation" TEXT;

-- CreateIndex
CREATE INDEX "Signatures_id_idx" ON "Signatures"("id");
