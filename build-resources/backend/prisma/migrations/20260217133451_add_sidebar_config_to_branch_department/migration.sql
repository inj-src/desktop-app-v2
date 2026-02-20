-- AlterTable
ALTER TABLE "public"."Branch" ADD COLUMN     "sidebarConfig" JSONB DEFAULT '{}';

-- AlterTable
ALTER TABLE "public"."Department" ADD COLUMN     "sidebarConfig" JSONB DEFAULT '{}';
