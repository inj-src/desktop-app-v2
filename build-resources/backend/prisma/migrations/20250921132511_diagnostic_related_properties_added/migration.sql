/*
  Warnings:

  - Added the required column `diagnosticId` to the `DoctorSession` table without a default value. This is not possible if the table is not empty.
  - Added the required column `diagnosticId` to the `DoctorSessionHistory` table without a default value. This is not possible if the table is not empty.
  - Added the required column `diagnosticId` to the `SessionNotice` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "public"."DoctorSession" ADD COLUMN     "diagnosticId" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "public"."DoctorSessionHistory" ADD COLUMN     "diagnosticId" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "public"."SessionNotice" ADD COLUMN     "diagnosticId" TEXT NOT NULL;

-- AddForeignKey
ALTER TABLE "public"."DoctorSession" ADD CONSTRAINT "DoctorSession_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "public"."Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."DoctorSessionHistory" ADD CONSTRAINT "DoctorSessionHistory_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "public"."Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."SessionNotice" ADD CONSTRAINT "SessionNotice_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "public"."Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;
