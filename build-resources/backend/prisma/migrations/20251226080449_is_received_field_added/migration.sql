-- AlterTable
ALTER TABLE "public"."Notification" ADD COLUMN     "isReceived" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "receivedAt" TIMESTAMP(3);
