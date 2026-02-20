-- CreateTable
CREATE TABLE "public"."UserPermissions" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "diagnosticId" TEXT NOT NULL,
    "canManageDoctors" BOOLEAN NOT NULL DEFAULT true,
    "canManagePCs" BOOLEAN NOT NULL DEFAULT true,
    "canManageTests" BOOLEAN NOT NULL DEFAULT true,
    "canManageAppointments" BOOLEAN NOT NULL DEFAULT false,
    "canManageOutdoorBills" BOOLEAN NOT NULL DEFAULT true,
    "canManageIndoorBills" BOOLEAN NOT NULL DEFAULT true,
    "canManageExpenses" BOOLEAN NOT NULL DEFAULT true,
    "canManageInventory" BOOLEAN NOT NULL DEFAULT false,
    "canManageIncomes" BOOLEAN NOT NULL DEFAULT false,
    "CanManageStatements" BOOLEAN NOT NULL DEFAULT false,
    "CanManageSMS" BOOLEAN NOT NULL DEFAULT false,
    "CanManagePathologists" BOOLEAN NOT NULL DEFAULT false,
    "CanManageSerialManagers" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "UserPermissions_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "UserPermissions_userId_key" ON "public"."UserPermissions"("userId");

-- CreateIndex
CREATE INDEX "UserPermissions_userId_diagnosticId_idx" ON "public"."UserPermissions"("userId", "diagnosticId");

-- CreateIndex
CREATE UNIQUE INDEX "UserPermissions_userId_diagnosticId_key" ON "public"."UserPermissions"("userId", "diagnosticId");

-- AddForeignKey
ALTER TABLE "public"."UserPermissions" ADD CONSTRAINT "UserPermissions_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."UserPermissions" ADD CONSTRAINT "UserPermissions_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "public"."Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;
