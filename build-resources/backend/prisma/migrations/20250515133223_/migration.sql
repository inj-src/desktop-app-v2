-- AlterTable
ALTER TABLE "Diagnostic" ADD COLUMN     "email" TEXT,
ADD COLUMN     "isEmailVerified" BOOLEAN NOT NULL DEFAULT false;
