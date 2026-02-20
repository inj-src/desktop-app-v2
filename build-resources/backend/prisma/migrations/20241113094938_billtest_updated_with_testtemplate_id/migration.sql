-- AlterTable
ALTER TABLE "BillTest" ADD COLUMN     "testTemplateId" TEXT;

-- AddForeignKey
ALTER TABLE "BillTest" ADD CONSTRAINT "BillTest_testTemplateId_fkey" FOREIGN KEY ("testTemplateId") REFERENCES "TestTemplate"("id") ON DELETE CASCADE ON UPDATE CASCADE;
