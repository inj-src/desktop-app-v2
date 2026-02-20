/*
  Warnings:

  - You are about to drop the column `leaveType` on the `Leave` table. All the data in the column will be lost.
  - Added the required column `leaveTypeId` to the `Leave` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "public"."Leavetype" AS ENUM ('CASUAL', 'SICK', 'ANNUAL', 'MATERNITY', 'PATERNITY', 'UNPAID', 'BONUS', 'COMPENSATORY', 'OTHER');

-- AlterTable
ALTER TABLE "public"."Leave" DROP COLUMN "leaveType",
ADD COLUMN     "leaveTypeId" TEXT DEFAULT NULL;

-- DropEnum
DROP TYPE "public"."LeaveType";

-- CreateTable
CREATE TABLE "public"."LeaveType" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "maxDaysPerYear" INTEGER,
    "isPaid" BOOLEAN NOT NULL DEFAULT true,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),
    "diagnosticId" TEXT NOT NULL,

    CONSTRAINT "LeaveType_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."LeavePolicy" (
    "id" TEXT NOT NULL,
    "accrualRate" DOUBLE PRECISION,
    "accrualPeriod" TEXT,
    "carryForwardMax" INTEGER,
    "approvalRequired" BOOLEAN NOT NULL DEFAULT true,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),
    "leaveTypeId" TEXT NOT NULL,
    "diagnosticId" TEXT NOT NULL,

    CONSTRAINT "LeavePolicy_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "LeaveType_diagnosticId_idx" ON "public"."LeaveType"("diagnosticId");

-- CreateIndex
CREATE UNIQUE INDEX "LeaveType_name_diagnosticId_deletedAt_key" ON "public"."LeaveType"("name", "diagnosticId", "deletedAt");

-- CreateIndex
CREATE INDEX "LeavePolicy_leaveTypeId_idx" ON "public"."LeavePolicy"("leaveTypeId");

-- CreateIndex
CREATE INDEX "LeavePolicy_diagnosticId_idx" ON "public"."LeavePolicy"("diagnosticId");

-- AddForeignKey
ALTER TABLE "public"."Leave" ADD CONSTRAINT "Leave_leaveTypeId_fkey" FOREIGN KEY ("leaveTypeId") REFERENCES "public"."LeaveType"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."LeaveType" ADD CONSTRAINT "LeaveType_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "public"."Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."LeavePolicy" ADD CONSTRAINT "LeavePolicy_leaveTypeId_fkey" FOREIGN KEY ("leaveTypeId") REFERENCES "public"."LeaveType"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."LeavePolicy" ADD CONSTRAINT "LeavePolicy_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "public"."Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;
