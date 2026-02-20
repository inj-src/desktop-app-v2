-- CreateTable
CREATE TABLE "public"."UpdateNotification" (
    "id" TEXT NOT NULL,
    "diagnosticId" TEXT NOT NULL,
    "serviceId" TEXT NOT NULL,
    "fromVersion" TEXT NOT NULL,
    "toVersion" TEXT NOT NULL,
    "isDelivered" BOOLEAN NOT NULL DEFAULT false,
    "deliveredAt" TIMESTAMP(3),
    "isRead" BOOLEAN NOT NULL DEFAULT false,
    "readAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "UpdateNotification_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "UpdateNotification_diagnosticId_idx" ON "public"."UpdateNotification"("diagnosticId");

-- CreateIndex
CREATE INDEX "UpdateNotification_serviceId_idx" ON "public"."UpdateNotification"("serviceId");

-- CreateIndex
CREATE INDEX "UpdateNotification_fromVersion_idx" ON "public"."UpdateNotification"("fromVersion");

-- CreateIndex
CREATE INDEX "UpdateNotification_toVersion_idx" ON "public"."UpdateNotification"("toVersion");

-- AddForeignKey
ALTER TABLE "public"."UpdateNotification" ADD CONSTRAINT "UpdateNotification_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "public"."Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."UpdateNotification" ADD CONSTRAINT "UpdateNotification_serviceId_fkey" FOREIGN KEY ("serviceId") REFERENCES "public"."Services"("id") ON DELETE CASCADE ON UPDATE CASCADE;
