-- CreateTable
CREATE TABLE "public"."Services" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "displayName" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "Services_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."VersionRelease" (
    "id" TEXT NOT NULL,
    "serviceId" TEXT NOT NULL,
    "serviceName" TEXT NOT NULL,
    "version" TEXT NOT NULL,
    "dockerImage" TEXT NOT NULL,
    "ecrRepository" TEXT,
    "imageDigest" TEXT,
    "imageSizeMb" DECIMAL(65,30),
    "port" INTEGER,
    "isExposed" BOOLEAN NOT NULL DEFAULT false,
    "allowed" BOOLEAN NOT NULL DEFAULT true,
    "releaseNotes" TEXT,
    "changelog" JSONB,
    "releasedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "releasedBy" TEXT,
    "isMandatory" BOOLEAN NOT NULL DEFAULT false,
    "isStable" BOOLEAN NOT NULL DEFAULT true,
    "isDeprecated" BOOLEAN NOT NULL DEFAULT false,
    "minAppVersion" TEXT,
    "useServiceEnv" BOOLEAN NOT NULL DEFAULT true,
    "useServiceVolumes" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "VersionRelease_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."HospitalServiceVersion" (
    "id" TEXT NOT NULL,
    "serviceId" TEXT NOT NULL,
    "version" TEXT NOT NULL,
    "dockerImage" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'active',
    "deployedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lastCheckedAt" TIMESTAMP(3),
    "updateAvailable" BOOLEAN NOT NULL DEFAULT false,
    "latestVersion" TEXT,
    "autoUpdateEnabled" BOOLEAN NOT NULL DEFAULT false,
    "versionReleaseId" TEXT,
    "diagnosticId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "HospitalServiceVersion_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."VersionUpdateLog" (
    "id" TEXT NOT NULL,
    "hospitalId" TEXT NOT NULL,
    "serviceId" TEXT NOT NULL,
    "fromVersion" TEXT,
    "toVersion" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "errorMessage" TEXT,
    "startedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "completedAt" TIMESTAMP(3),
    "durationSeconds" INTEGER,
    "triggeredBy" TEXT,
    "synchroniserAppVersion" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "VersionUpdateLog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."ServiceEnvironmentVariable" (
    "id" TEXT NOT NULL,
    "serviceId" TEXT NOT NULL,
    "key" TEXT NOT NULL,
    "value" TEXT NOT NULL,
    "description" TEXT,
    "isSecret" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "ServiceEnvironmentVariable_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."ServiceVolume" (
    "id" TEXT NOT NULL,
    "serviceId" TEXT NOT NULL,
    "hostPath" TEXT NOT NULL,
    "containerPath" TEXT NOT NULL,
    "description" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "ServiceVolume_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."VersionReleaseEnvironmentVariable" (
    "id" TEXT NOT NULL,
    "versionReleaseId" TEXT NOT NULL,
    "key" TEXT NOT NULL,
    "value" TEXT NOT NULL,
    "description" TEXT,
    "isSecret" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "VersionReleaseEnvironmentVariable_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."VersionReleaseVolume" (
    "id" TEXT NOT NULL,
    "versionReleaseId" TEXT NOT NULL,
    "hostPath" TEXT NOT NULL,
    "containerPath" TEXT NOT NULL,
    "description" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "VersionReleaseVolume_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."VersionAdminSession" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "ipAddress" TEXT,
    "userAgent" TEXT,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lastUsedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "VersionAdminSession_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Services_name_key" ON "public"."Services"("name");

-- CreateIndex
CREATE INDEX "Services_name_idx" ON "public"."Services"("name");

-- CreateIndex
CREATE INDEX "VersionRelease_serviceId_idx" ON "public"."VersionRelease"("serviceId");

-- CreateIndex
CREATE INDEX "VersionRelease_version_idx" ON "public"."VersionRelease"("version");

-- CreateIndex
CREATE INDEX "VersionRelease_releasedAt_idx" ON "public"."VersionRelease"("releasedAt");

-- CreateIndex
CREATE UNIQUE INDEX "VersionRelease_serviceId_version_key" ON "public"."VersionRelease"("serviceId", "version");

-- CreateIndex
CREATE INDEX "HospitalServiceVersion_diagnosticId_idx" ON "public"."HospitalServiceVersion"("diagnosticId");

-- CreateIndex
CREATE INDEX "HospitalServiceVersion_serviceId_idx" ON "public"."HospitalServiceVersion"("serviceId");

-- CreateIndex
CREATE INDEX "HospitalServiceVersion_status_idx" ON "public"."HospitalServiceVersion"("status");

-- CreateIndex
CREATE UNIQUE INDEX "HospitalServiceVersion_diagnosticId_serviceId_key" ON "public"."HospitalServiceVersion"("diagnosticId", "serviceId");

-- CreateIndex
CREATE INDEX "VersionUpdateLog_hospitalId_idx" ON "public"."VersionUpdateLog"("hospitalId");

-- CreateIndex
CREATE INDEX "VersionUpdateLog_serviceId_idx" ON "public"."VersionUpdateLog"("serviceId");

-- CreateIndex
CREATE INDEX "VersionUpdateLog_status_idx" ON "public"."VersionUpdateLog"("status");

-- CreateIndex
CREATE INDEX "VersionUpdateLog_createdAt_idx" ON "public"."VersionUpdateLog"("createdAt");

-- CreateIndex
CREATE INDEX "ServiceEnvironmentVariable_serviceId_idx" ON "public"."ServiceEnvironmentVariable"("serviceId");

-- CreateIndex
CREATE INDEX "ServiceEnvironmentVariable_key_idx" ON "public"."ServiceEnvironmentVariable"("key");

-- CreateIndex
CREATE UNIQUE INDEX "ServiceEnvironmentVariable_serviceId_key_key" ON "public"."ServiceEnvironmentVariable"("serviceId", "key");

-- CreateIndex
CREATE INDEX "ServiceVolume_serviceId_idx" ON "public"."ServiceVolume"("serviceId");

-- CreateIndex
CREATE UNIQUE INDEX "ServiceVolume_serviceId_containerPath_key" ON "public"."ServiceVolume"("serviceId", "containerPath");

-- CreateIndex
CREATE INDEX "VersionReleaseEnvironmentVariable_versionReleaseId_idx" ON "public"."VersionReleaseEnvironmentVariable"("versionReleaseId");

-- CreateIndex
CREATE INDEX "VersionReleaseEnvironmentVariable_key_idx" ON "public"."VersionReleaseEnvironmentVariable"("key");

-- CreateIndex
CREATE UNIQUE INDEX "VersionReleaseEnvironmentVariable_versionReleaseId_key_key" ON "public"."VersionReleaseEnvironmentVariable"("versionReleaseId", "key");

-- CreateIndex
CREATE INDEX "VersionReleaseVolume_versionReleaseId_idx" ON "public"."VersionReleaseVolume"("versionReleaseId");

-- CreateIndex
CREATE UNIQUE INDEX "VersionReleaseVolume_versionReleaseId_containerPath_key" ON "public"."VersionReleaseVolume"("versionReleaseId", "containerPath");

-- CreateIndex
CREATE UNIQUE INDEX "VersionAdminSession_token_key" ON "public"."VersionAdminSession"("token");

-- CreateIndex
CREATE INDEX "VersionAdminSession_userId_idx" ON "public"."VersionAdminSession"("userId");

-- CreateIndex
CREATE INDEX "VersionAdminSession_token_idx" ON "public"."VersionAdminSession"("token");

-- CreateIndex
CREATE INDEX "VersionAdminSession_expiresAt_idx" ON "public"."VersionAdminSession"("expiresAt");

-- AddForeignKey
ALTER TABLE "public"."VersionRelease" ADD CONSTRAINT "VersionRelease_serviceId_fkey" FOREIGN KEY ("serviceId") REFERENCES "public"."Services"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."HospitalServiceVersion" ADD CONSTRAINT "HospitalServiceVersion_versionReleaseId_fkey" FOREIGN KEY ("versionReleaseId") REFERENCES "public"."VersionRelease"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."HospitalServiceVersion" ADD CONSTRAINT "HospitalServiceVersion_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "public"."Diagnostic"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."ServiceEnvironmentVariable" ADD CONSTRAINT "ServiceEnvironmentVariable_serviceId_fkey" FOREIGN KEY ("serviceId") REFERENCES "public"."Services"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."ServiceVolume" ADD CONSTRAINT "ServiceVolume_serviceId_fkey" FOREIGN KEY ("serviceId") REFERENCES "public"."Services"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."VersionReleaseEnvironmentVariable" ADD CONSTRAINT "VersionReleaseEnvironmentVariable_versionReleaseId_fkey" FOREIGN KEY ("versionReleaseId") REFERENCES "public"."VersionRelease"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."VersionReleaseVolume" ADD CONSTRAINT "VersionReleaseVolume_versionReleaseId_fkey" FOREIGN KEY ("versionReleaseId") REFERENCES "public"."VersionRelease"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."VersionAdminSession" ADD CONSTRAINT "VersionAdminSession_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
