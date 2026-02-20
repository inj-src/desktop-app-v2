-- CreateEnum
CREATE TYPE "ReportStatus" AS ENUM ('PENDING', 'IN_PROGRESS', 'FINALIZED', 'REJECTED', 'CANCELLED', 'ON_HOLD', 'AMENDED', 'CRITICAL', 'REFERRED', 'VERIFIED', 'RELEASED', 'ARCHIVED', 'DELETED');

-- AlterTable
ALTER TABLE "BillTest" ADD COLUMN     "collectedByUserId" TEXT,
ADD COLUMN     "preparedByUserId" TEXT,
ADD COLUMN     "remarks" TEXT,
ADD COLUMN     "reportGeneratedAt" TIMESTAMP(3),
ADD COLUMN     "reportStatus" "ReportStatus" NOT NULL DEFAULT 'PENDING',
ADD COLUMN     "sampleCollectedAt" TIMESTAMP(3),
ADD COLUMN     "savedWithoutValue" BOOLEAN NOT NULL DEFAULT false;

-- AddForeignKey
ALTER TABLE "BillTest" ADD CONSTRAINT "BillTest_collectedByUserId_fkey" FOREIGN KEY ("collectedByUserId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BillTest" ADD CONSTRAINT "BillTest_preparedByUserId_fkey" FOREIGN KEY ("preparedByUserId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
