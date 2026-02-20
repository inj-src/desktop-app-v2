-- AlterTable
ALTER TABLE "public"."UpdateNotification" ADD COLUMN     "isRevoked" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "revokedAt" TIMESTAMP(3),
ADD COLUMN     "revokedReason" TEXT,
ALTER COLUMN "readAt" DROP NOT NULL,
ALTER COLUMN "readAt" DROP DEFAULT;
