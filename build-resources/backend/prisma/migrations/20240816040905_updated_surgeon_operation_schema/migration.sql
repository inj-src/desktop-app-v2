-- AlterTable
ALTER TABLE "SurgeonOperation" ADD COLUMN     "pCId" TEXT,
ADD COLUMN     "type" TEXT NOT NULL DEFAULT 'new';

-- AddForeignKey
ALTER TABLE "SurgeonOperation" ADD CONSTRAINT "SurgeonOperation_pCId_fkey" FOREIGN KEY ("pCId") REFERENCES "PC"("id") ON DELETE CASCADE ON UPDATE CASCADE;
