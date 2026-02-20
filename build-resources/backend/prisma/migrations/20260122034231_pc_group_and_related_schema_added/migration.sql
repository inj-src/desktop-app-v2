-- CreateTable
CREATE TABLE "public"."PCGroup" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "code" TEXT,
    "diagnosticId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "PCGroup_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."PCGroupMember" (
    "id" TEXT NOT NULL,
    "pcGroupId" TEXT NOT NULL,
    "pcId" TEXT NOT NULL,
    "marketerId" TEXT,
    "diagnosticId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "PCGroupMember_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "PCGroupMember_pcGroupId_pcId_key" ON "public"."PCGroupMember"("pcGroupId", "pcId");

-- AddForeignKey
ALTER TABLE "public"."PCGroup" ADD CONSTRAINT "PCGroup_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "public"."Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."PCGroupMember" ADD CONSTRAINT "PCGroupMember_pcGroupId_fkey" FOREIGN KEY ("pcGroupId") REFERENCES "public"."PCGroup"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."PCGroupMember" ADD CONSTRAINT "PCGroupMember_pcId_fkey" FOREIGN KEY ("pcId") REFERENCES "public"."PC"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."PCGroupMember" ADD CONSTRAINT "PCGroupMember_marketerId_fkey" FOREIGN KEY ("marketerId") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."PCGroupMember" ADD CONSTRAINT "PCGroupMember_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "public"."Diagnostic"("id") ON DELETE CASCADE ON UPDATE CASCADE;
