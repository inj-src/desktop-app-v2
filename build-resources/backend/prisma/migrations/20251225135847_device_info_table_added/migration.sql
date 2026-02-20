/*
  Warnings:

  - You are about to drop the column `ipAddress` on the `VersionAdminSession` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "public"."VersionAdminSession" DROP COLUMN "ipAddress",
ADD COLUMN     "deviceId" TEXT,
ADD COLUMN     "publicIP" TEXT;

-- CreateTable
CREATE TABLE "public"."Device" (
    "id" TEXT NOT NULL,
    "deviceId" TEXT NOT NULL,
    "installationId" TEXT NOT NULL,
    "fingerprintHash" TEXT NOT NULL,
    "platform" TEXT NOT NULL,
    "osVersion" TEXT NOT NULL,
    "arch" TEXT NOT NULL,
    "cpuCores" INTEGER NOT NULL,
    "totalMemory" BIGINT NOT NULL,
    "networkInterfaces" JSONB NOT NULL,
    "timezone" TEXT NOT NULL,
    "timezoneOffset" INTEGER NOT NULL,
    "appVersion" TEXT NOT NULL,
    "isTrusted" BOOLEAN NOT NULL DEFAULT false,
    "isBlocked" BOOLEAN NOT NULL DEFAULT false,
    "blockedReason" TEXT,
    "blockedAt" TIMESTAMP(3),
    "firstSeenAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lastSeenAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Device_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Device_deviceId_key" ON "public"."Device"("deviceId");

-- CreateIndex
CREATE INDEX "Device_deviceId_idx" ON "public"."Device"("deviceId");

-- CreateIndex
CREATE INDEX "Device_fingerprintHash_idx" ON "public"."Device"("fingerprintHash");

-- CreateIndex
CREATE INDEX "Device_isTrusted_idx" ON "public"."Device"("isTrusted");

-- CreateIndex
CREATE INDEX "Device_isBlocked_idx" ON "public"."Device"("isBlocked");

-- CreateIndex
CREATE INDEX "Device_lastSeenAt_idx" ON "public"."Device"("lastSeenAt");

-- CreateIndex
CREATE INDEX "VersionAdminSession_deviceId_idx" ON "public"."VersionAdminSession"("deviceId");

-- AddForeignKey
ALTER TABLE "public"."VersionAdminSession" ADD CONSTRAINT "VersionAdminSession_deviceId_fkey" FOREIGN KEY ("deviceId") REFERENCES "public"."Device"("id") ON DELETE SET NULL ON UPDATE CASCADE;
