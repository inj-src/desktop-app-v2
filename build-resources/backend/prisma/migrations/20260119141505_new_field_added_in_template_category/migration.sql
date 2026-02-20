-- AlterTable
ALTER TABLE "public"."DiagnosticTemplate" ADD COLUMN     "expressionMap" JSONB;

-- AlterTable
ALTER TABLE "public"."Template" ADD COLUMN     "expressionMap" JSONB;
