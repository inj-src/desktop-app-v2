-- CreateTable
CREATE TABLE "public"."UserInventoryStore" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "storeId" TEXT NOT NULL,
    "diagnosticId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "UserInventoryStore_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "UserInventoryStore_userId_idx" ON "public"."UserInventoryStore"("userId");

-- CreateIndex
CREATE INDEX "UserInventoryStore_storeId_idx" ON "public"."UserInventoryStore"("storeId");

-- CreateIndex
CREATE INDEX "UserInventoryStore_diagnosticId_idx" ON "public"."UserInventoryStore"("diagnosticId");

-- CreateIndex
CREATE INDEX "UserInventoryStore_deletedAt_idx" ON "public"."UserInventoryStore"("deletedAt");

-- CreateIndex
CREATE UNIQUE INDEX "UserInventoryStore_userId_storeId_diagnosticId_key" ON "public"."UserInventoryStore"("userId", "storeId", "diagnosticId");

-- AddForeignKey
ALTER TABLE "public"."UserInventoryStore" ADD CONSTRAINT "UserInventoryStore_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."UserInventoryStore" ADD CONSTRAINT "UserInventoryStore_storeId_fkey" FOREIGN KEY ("storeId") REFERENCES "public"."Store"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."UserInventoryStore" ADD CONSTRAINT "UserInventoryStore_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "public"."Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;
