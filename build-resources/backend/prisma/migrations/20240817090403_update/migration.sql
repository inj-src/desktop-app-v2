-- AlterTable
ALTER TABLE "Bed" ADD COLUMN     "bedDescription" TEXT,
ADD COLUMN     "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "deletedAt" TIMESTAMP(3),
ADD COLUMN     "floorNumber" INTEGER,
ADD COLUMN     "isOutOfService" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "lastMaintenanceDate" TIMESTAMP(3),
ADD COLUMN     "note" TEXT,
ADD COLUMN     "outOfServiceReason" TEXT,
ADD COLUMN     "roomType" TEXT,
ADD COLUMN     "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "wing" TEXT,
ALTER COLUMN "isAvailableForBooking" SET DEFAULT true;

-- AlterTable
ALTER TABLE "BedBooking" ADD COLUMN     "bookingSource" TEXT NOT NULL DEFAULT 'walk-in',
ADD COLUMN     "bookingStatus" TEXT NOT NULL DEFAULT 'active',
ADD COLUMN     "canceledBy" TEXT,
ADD COLUMN     "cancellationReason" TEXT,
ADD COLUMN     "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "deletedAt" TIMESTAMP(3),
ADD COLUMN     "depositAmount" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "isDischarged" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "paymentStatus" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "totalCost" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "BedCategory" ADD COLUMN     "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "deletedAt" TIMESTAMP(3),
ADD COLUMN     "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "BedSubCategory" ADD COLUMN     "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "deletedAt" TIMESTAMP(3),
ADD COLUMN     "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- CreateTable
CREATE TABLE "AuditLog" (
    "id" TEXT NOT NULL,
    "action" TEXT NOT NULL,
    "model" TEXT NOT NULL,
    "modelId" TEXT NOT NULL,
    "changes" JSONB NOT NULL,
    "performedBy" TEXT NOT NULL,
    "timestamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "note" TEXT,

    CONSTRAINT "AuditLog_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "Bed_roomNo_bedSubCategoryId_idx" ON "Bed"("roomNo", "bedSubCategoryId");

-- CreateIndex
CREATE INDEX "BedBooking_id_startDate_endDate_paymentStatus_bookingStatus_idx" ON "BedBooking"("id", "startDate", "endDate", "paymentStatus", "bookingStatus");
