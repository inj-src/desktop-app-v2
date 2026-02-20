-- AlterEnum
ALTER TYPE "public"."CheckInStatus" ADD VALUE 'RECHECK_IN';

-- AlterEnum
ALTER TYPE "public"."CheckOutStatus" ADD VALUE 'SECONDARY_CHECK_OUT';

-- AlterTable
ALTER TABLE "public"."Attendance" ADD COLUMN     "shiftId" TEXT;

-- AddForeignKey
ALTER TABLE "public"."Attendance" ADD CONSTRAINT "Attendance_shiftId_fkey" FOREIGN KEY ("shiftId") REFERENCES "public"."Shift"("id") ON DELETE SET NULL ON UPDATE CASCADE;
