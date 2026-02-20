-- AlterTable
ALTER TABLE "SurgeonOperation" ADD COLUMN     "userId" TEXT;

-- AddForeignKey
ALTER TABLE "SurgeonOperation" ADD CONSTRAINT "SurgeonOperation_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;
