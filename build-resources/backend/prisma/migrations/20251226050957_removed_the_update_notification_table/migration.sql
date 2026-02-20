/*
  Warnings:

  - You are about to drop the `UpdateNotification` table. If the table is not empty, all the data it contains will be lost.
  - Added the required column `serviceId` to the `Notification` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "public"."UpdateNotification" DROP CONSTRAINT "UpdateNotification_diagnosticId_fkey";

-- DropForeignKey
ALTER TABLE "public"."UpdateNotification" DROP CONSTRAINT "UpdateNotification_serviceId_fkey";

-- DropForeignKey
ALTER TABLE "public"."UpdateNotification" DROP CONSTRAINT "UpdateNotification_versionId_fkey";

-- AlterTable
ALTER TABLE "public"."Notification" ADD COLUMN     "serviceId" TEXT NOT NULL,
ADD COLUMN     "versionId" TEXT;

-- DropTable
DROP TABLE "public"."UpdateNotification";

-- AddForeignKey
ALTER TABLE "public"."Notification" ADD CONSTRAINT "Notification_versionId_fkey" FOREIGN KEY ("versionId") REFERENCES "public"."VersionRelease"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Notification" ADD CONSTRAINT "Notification_serviceId_fkey" FOREIGN KEY ("serviceId") REFERENCES "public"."Services"("id") ON DELETE CASCADE ON UPDATE CASCADE;
