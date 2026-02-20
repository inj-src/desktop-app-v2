-- AlterTable
ALTER TABLE "BillTest" ADD COLUMN     "reportDelayInDays" INTEGER DEFAULT 0,
ADD COLUMN     "reportDelayInHours" INTEGER DEFAULT 0,
ADD COLUMN     "reportDelayInMinutes" INTEGER DEFAULT 0;

-- AlterTable
ALTER TABLE "Test" ADD COLUMN     "reportDelayInDays" INTEGER DEFAULT 0,
ADD COLUMN     "reportDelayInHours" INTEGER DEFAULT 0,
ADD COLUMN     "reportDelayInMinutes" INTEGER DEFAULT 0;
