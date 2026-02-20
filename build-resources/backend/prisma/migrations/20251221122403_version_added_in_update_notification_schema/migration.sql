-- AlterTable
ALTER TABLE "public"."UpdateNotification" ADD COLUMN     "versionId" TEXT;

-- AddForeignKey
ALTER TABLE "public"."UpdateNotification" ADD CONSTRAINT "UpdateNotification_versionId_fkey" FOREIGN KEY ("versionId") REFERENCES "public"."VersionRelease"("id") ON DELETE SET NULL ON UPDATE CASCADE;
