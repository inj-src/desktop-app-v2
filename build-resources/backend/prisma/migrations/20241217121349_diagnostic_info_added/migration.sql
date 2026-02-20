-- AlterTable
ALTER TABLE "Bill" ADD COLUMN     "src" TEXT NOT NULL DEFAULT 'online';

-- AlterTable
ALTER TABLE "Diagnostic" ADD COLUMN     "ckEditorFreePlanDuration" INTEGER NOT NULL DEFAULT 14,
ADD COLUMN     "ckEditorToken" TEXT,
ADD COLUMN     "ckEditorUpdateDate" TIMESTAMP(3),
ADD COLUMN     "lastSyncedWithCloud" TIMESTAMP(3);

-- AlterTable
ALTER TABLE "HospitalBill" ADD COLUMN     "src" TEXT NOT NULL DEFAULT 'online';
