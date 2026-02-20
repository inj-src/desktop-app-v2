-- AlterTable
ALTER TABLE "Diagnostic" ADD COLUMN     "printAdmissionTemplate" INTEGER NOT NULL DEFAULT 1,
ADD COLUMN     "printIndoorTemplate" INTEGER NOT NULL DEFAULT 1;
