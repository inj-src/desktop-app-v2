/*
  Warnings:

  - The values [CANCELLED] on the enum `FollowUpStatus` will be removed. If these variants are still used in the database, this will fail.

*/
-- AlterEnum
BEGIN;
CREATE TYPE "FollowUpStatus_new" AS ENUM ('PENDING', 'CONFIRMED', 'COMPLETED');
ALTER TABLE "patientFollowups" ALTER COLUMN "status" DROP DEFAULT;
ALTER TABLE "patientFollowups" ALTER COLUMN "status" TYPE "FollowUpStatus_new" USING ("status"::text::"FollowUpStatus_new");
ALTER TABLE "PatientFollowupHistory" ALTER COLUMN "previousStatus" TYPE "FollowUpStatus_new" USING ("previousStatus"::text::"FollowUpStatus_new");
ALTER TABLE "PatientFollowupHistory" ALTER COLUMN "newStatus" TYPE "FollowUpStatus_new" USING ("newStatus"::text::"FollowUpStatus_new");
ALTER TYPE "FollowUpStatus" RENAME TO "FollowUpStatus_old";
ALTER TYPE "FollowUpStatus_new" RENAME TO "FollowUpStatus";
DROP TYPE "FollowUpStatus_old";
ALTER TABLE "patientFollowups" ALTER COLUMN "status" SET DEFAULT 'PENDING';
COMMIT;
