-- CreateEnum
CREATE TYPE "public"."NotificationType" AS ENUM ('VERSION_UPDATE', 'VERSION_MANDATORY', 'SESSION_REVOKED', 'SESSION_EXPIRED', 'DEVICE_BLOCKED', 'DEVICE_UNBLOCKED', 'DEVICE_TRUST_ADDED', 'DEVICE_TRUST_REMOVED', 'NEW_DEVICE_LOGIN', 'SUSPICIOUS_LOGIN', 'PAYMENT_LATE', 'PAYMENT_REMINDER', 'PAYMENT_RECEIVED', 'PAYMENT_FAILED', 'SALARY_PROCESSED', 'SALARY_ADVANCE_APPROVED', 'SALARY_ADVANCE_REJECTED', 'BONUS_AWARDED', 'DIAGNOSTIC_BLOCKED', 'DIAGNOSTIC_UNBLOCKED', 'DIAGNOSTIC_SUSPENDED', 'DIAGNOSTIC_ACTIVATED', 'LEAVE_APPROVED', 'LEAVE_REJECTED', 'ATTENDANCE_MARKED', 'SHIFT_CHANGED', 'OVERTIME_APPROVED', 'PROMOTIONAL_OFFER', 'SEASONAL_WISHES', 'THANKSGIVING', 'ANNOUNCEMENT', 'NEWS_UPDATE', 'SYSTEM_MAINTENANCE', 'SYSTEM_ALERT', 'BACKUP_COMPLETED', 'BACKUP_FAILED', 'CUSTOM');

-- CreateEnum
CREATE TYPE "public"."NotificationPriority" AS ENUM ('LOW', 'MEDIUM', 'HIGH', 'URGENT');

-- CreateEnum
CREATE TYPE "public"."NotificationCategory" AS ENUM ('SECURITY', 'FINANCIAL', 'SYSTEM', 'HR', 'PROMOTIONAL', 'ADMINISTRATIVE', 'OPERATIONAL');

-- DropForeignKey
ALTER TABLE "public"."Leave" DROP CONSTRAINT "Leave_leaveTypeId_fkey";

-- CreateTable
CREATE TABLE "public"."Notification" (
    "id" TEXT NOT NULL,
    "type" "public"."NotificationType" NOT NULL,
    "category" "public"."NotificationCategory" NOT NULL,
    "priority" "public"."NotificationPriority" NOT NULL DEFAULT 'MEDIUM',
    "title" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "shortText" TEXT,
    "data" JSONB,
    "actionUrl" TEXT,
    "actionLabel" TEXT,
    "imageUrl" TEXT,
    "diagnosticId" TEXT,
    "userId" TEXT,
    "employeeId" TEXT,
    "versionAdminId" TEXT,
    "isBroadcast" BOOLEAN NOT NULL DEFAULT false,
    "targetAudience" TEXT,
    "isDelivered" BOOLEAN NOT NULL DEFAULT false,
    "deliveredAt" TIMESTAMP(3),
    "isRead" BOOLEAN NOT NULL DEFAULT false,
    "readAt" TIMESTAMP(3),
    "scheduledFor" TIMESTAMP(3),
    "expiresAt" TIMESTAMP(3),
    "isRevoked" BOOLEAN NOT NULL DEFAULT false,
    "revokedAt" TIMESTAMP(3),
    "revokedReason" TEXT,
    "revokedById" TEXT,
    "sourceType" TEXT,
    "sourceId" TEXT,
    "sentById" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Notification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."NotificationTemplate" (
    "id" TEXT NOT NULL,
    "type" "public"."NotificationType" NOT NULL,
    "category" "public"."NotificationCategory" NOT NULL,
    "titleTemplate" TEXT NOT NULL,
    "messageTemplate" TEXT NOT NULL,
    "defaultPriority" "public"."NotificationPriority" NOT NULL DEFAULT 'MEDIUM',
    "defaultActionUrl" TEXT,
    "defaultActionLabel" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "canCustomize" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "NotificationTemplate_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."NotificationPreference" (
    "id" TEXT NOT NULL,
    "userId" TEXT,
    "employeeId" TEXT,
    "diagnosticId" TEXT,
    "category" "public"."NotificationCategory" NOT NULL,
    "enablePush" BOOLEAN NOT NULL DEFAULT true,
    "enableEmail" BOOLEAN NOT NULL DEFAULT true,
    "enableSMS" BOOLEAN NOT NULL DEFAULT false,
    "enableInApp" BOOLEAN NOT NULL DEFAULT true,
    "enableInstant" BOOLEAN NOT NULL DEFAULT true,
    "enableDaily" BOOLEAN NOT NULL DEFAULT false,
    "enableWeekly" BOOLEAN NOT NULL DEFAULT false,
    "quietHoursStart" TEXT,
    "quietHoursEnd" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "NotificationPreference_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."NotificationDeliveryLog" (
    "id" TEXT NOT NULL,
    "notificationId" TEXT NOT NULL,
    "channel" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "recipient" TEXT NOT NULL,
    "errorMessage" TEXT,
    "retryCount" INTEGER NOT NULL DEFAULT 0,
    "sentAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "NotificationDeliveryLog_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "Notification_diagnosticId_idx" ON "public"."Notification"("diagnosticId");

-- CreateIndex
CREATE INDEX "Notification_userId_idx" ON "public"."Notification"("userId");

-- CreateIndex
CREATE INDEX "Notification_employeeId_idx" ON "public"."Notification"("employeeId");

-- CreateIndex
CREATE INDEX "Notification_versionAdminId_idx" ON "public"."Notification"("versionAdminId");

-- CreateIndex
CREATE INDEX "Notification_type_idx" ON "public"."Notification"("type");

-- CreateIndex
CREATE INDEX "Notification_category_idx" ON "public"."Notification"("category");

-- CreateIndex
CREATE INDEX "Notification_priority_idx" ON "public"."Notification"("priority");

-- CreateIndex
CREATE INDEX "Notification_isDelivered_idx" ON "public"."Notification"("isDelivered");

-- CreateIndex
CREATE INDEX "Notification_isRead_idx" ON "public"."Notification"("isRead");

-- CreateIndex
CREATE INDEX "Notification_scheduledFor_idx" ON "public"."Notification"("scheduledFor");

-- CreateIndex
CREATE INDEX "Notification_expiresAt_idx" ON "public"."Notification"("expiresAt");

-- CreateIndex
CREATE INDEX "Notification_createdAt_idx" ON "public"."Notification"("createdAt");

-- CreateIndex
CREATE UNIQUE INDEX "NotificationTemplate_type_key" ON "public"."NotificationTemplate"("type");

-- CreateIndex
CREATE INDEX "NotificationTemplate_type_idx" ON "public"."NotificationTemplate"("type");

-- CreateIndex
CREATE INDEX "NotificationTemplate_category_idx" ON "public"."NotificationTemplate"("category");

-- CreateIndex
CREATE INDEX "NotificationPreference_userId_idx" ON "public"."NotificationPreference"("userId");

-- CreateIndex
CREATE INDEX "NotificationPreference_employeeId_idx" ON "public"."NotificationPreference"("employeeId");

-- CreateIndex
CREATE INDEX "NotificationPreference_diagnosticId_idx" ON "public"."NotificationPreference"("diagnosticId");

-- CreateIndex
CREATE INDEX "NotificationPreference_category_idx" ON "public"."NotificationPreference"("category");

-- CreateIndex
CREATE UNIQUE INDEX "NotificationPreference_userId_category_key" ON "public"."NotificationPreference"("userId", "category");

-- CreateIndex
CREATE UNIQUE INDEX "NotificationPreference_employeeId_category_key" ON "public"."NotificationPreference"("employeeId", "category");

-- CreateIndex
CREATE UNIQUE INDEX "NotificationPreference_diagnosticId_category_key" ON "public"."NotificationPreference"("diagnosticId", "category");

-- CreateIndex
CREATE INDEX "NotificationDeliveryLog_notificationId_idx" ON "public"."NotificationDeliveryLog"("notificationId");

-- CreateIndex
CREATE INDEX "NotificationDeliveryLog_channel_idx" ON "public"."NotificationDeliveryLog"("channel");

-- CreateIndex
CREATE INDEX "NotificationDeliveryLog_status_idx" ON "public"."NotificationDeliveryLog"("status");

-- CreateIndex
CREATE INDEX "NotificationDeliveryLog_createdAt_idx" ON "public"."NotificationDeliveryLog"("createdAt");

-- AddForeignKey
ALTER TABLE "public"."Leave" ADD CONSTRAINT "Leave_leaveTypeId_fkey" FOREIGN KEY ("leaveTypeId") REFERENCES "public"."LeaveType"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Notification" ADD CONSTRAINT "Notification_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "public"."Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Notification" ADD CONSTRAINT "Notification_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Notification" ADD CONSTRAINT "Notification_employeeId_fkey" FOREIGN KEY ("employeeId") REFERENCES "public"."Employee"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Notification" ADD CONSTRAINT "Notification_versionAdminId_fkey" FOREIGN KEY ("versionAdminId") REFERENCES "public"."User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Notification" ADD CONSTRAINT "Notification_revokedById_fkey" FOREIGN KEY ("revokedById") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Notification" ADD CONSTRAINT "Notification_sentById_fkey" FOREIGN KEY ("sentById") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."NotificationPreference" ADD CONSTRAINT "NotificationPreference_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."NotificationPreference" ADD CONSTRAINT "NotificationPreference_employeeId_fkey" FOREIGN KEY ("employeeId") REFERENCES "public"."Employee"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."NotificationPreference" ADD CONSTRAINT "NotificationPreference_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "public"."Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;
