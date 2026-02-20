-- AlterTable
ALTER TABLE "public"."ReportQueue" ADD COLUMN     "deletedBy" TEXT;

-- AddForeignKey
ALTER TABLE "public"."ReportQueue" ADD CONSTRAINT "ReportQueue_deletedBy_fkey" FOREIGN KEY ("deletedBy") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;
