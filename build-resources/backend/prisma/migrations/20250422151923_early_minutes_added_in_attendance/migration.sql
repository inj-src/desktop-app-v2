-- AlterEnum
-- This migration adds more than one value to an enum.
-- With PostgreSQL versions 11 and earlier, this is not possible
-- in a single migration. This can be worked around by creating
-- multiple migrations, each migration adding only one value to
-- the enum.


ALTER TYPE "AttendanceStatus" ADD VALUE 'EARLY';
ALTER TYPE "AttendanceStatus" ADD VALUE 'WORK_FROM_HOME';
ALTER TYPE "AttendanceStatus" ADD VALUE 'LATE_IN_EARLY_OUT';
ALTER TYPE "AttendanceStatus" ADD VALUE 'LATE_IN';
ALTER TYPE "AttendanceStatus" ADD VALUE 'EARLY_OUT';
ALTER TYPE "AttendanceStatus" ADD VALUE 'WORK_FROM_HOME_LATE';
ALTER TYPE "AttendanceStatus" ADD VALUE 'WORK_FROM_HOME_EARLY';
ALTER TYPE "AttendanceStatus" ADD VALUE 'WORK_FROM_HOME_LATE_IN';
ALTER TYPE "AttendanceStatus" ADD VALUE 'WORK_FROM_HOME_EARLY_OUT';
ALTER TYPE "AttendanceStatus" ADD VALUE 'WORK_FROM_HOME_HALF_DAY';
ALTER TYPE "AttendanceStatus" ADD VALUE 'WORK_FROM_HOME_ABSENT';
ALTER TYPE "AttendanceStatus" ADD VALUE 'WORK_FROM_HOME_ON_LEAVE';

-- AlterTable
ALTER TABLE "Attendance" ADD COLUMN     "earlyMinutes" INTEGER;
