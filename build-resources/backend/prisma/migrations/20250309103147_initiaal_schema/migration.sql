CREATE EXTENSION IF NOT EXISTS pg_trgm;


-- CreateTable
CREATE TABLE "publicDoctor" (
    "id" TEXT NOT NULL,
    "smallId" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "designation" TEXT NOT NULL,
    "specialties" TEXT,
    "qualifications" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "searchVector" tsvector
);

-- CreateTable
CREATE TABLE "publicHospital" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "smallId" INTEGER NOT NULL,
    "location" TEXT,
    "services" TEXT NOT NULL,
    "introduction" TEXT NOT NULL,
    "webLink" TEXT,
    "fbLink" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "searchVector" tsvector
);

-- CreateTable
CREATE TABLE "publicDoctorHospital" (
    "id" TEXT NOT NULL,
    "doctorId" TEXT NOT NULL,
    "hospitalId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "publicDoctor_id_key" ON "publicDoctor"("id");

-- CreateIndex
CREATE INDEX "publicDoctor_name_idx" ON "publicDoctor"("name");

-- CreateIndex
CREATE INDEX "publicDoctor_designation_idx" ON "publicDoctor"("designation");

-- CreateIndex
CREATE INDEX "publicDoctor_specialties_idx" ON "publicDoctor"("specialties");

-- CreateIndex
CREATE UNIQUE INDEX "publicHospital_id_key" ON "publicHospital"("id");

-- CreateIndex
CREATE INDEX "publicHospital_name_idx" ON "publicHospital"("name");

-- CreateIndex
CREATE UNIQUE INDEX "publicDoctorHospital_id_key" ON "publicDoctorHospital"("id");

-- CreateIndex
CREATE INDEX "publicDoctorHospital_doctorId_hospitalId_idx" ON "publicDoctorHospital"("doctorId", "hospitalId");

-- CreateIndex
CREATE UNIQUE INDEX "publicDoctorHospital_doctorId_hospitalId_key" ON "publicDoctorHospital"("doctorId", "hospitalId");
CREATE INDEX publicDoctor_searchVector_idx ON "publicDoctor" USING GIST ("searchVector");
CREATE INDEX publicHospital_searchVector_idx ON "publicHospital" USING GIST ("searchVector");
-- AddForeignKey
ALTER TABLE "publicDoctorHospital" ADD CONSTRAINT "publicDoctorHospital_doctorId_fkey" FOREIGN KEY ("doctorId") REFERENCES "publicDoctor"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "publicDoctorHospital" ADD CONSTRAINT "publicDoctorHospital_hospitalId_fkey" FOREIGN KEY ("hospitalId") REFERENCES "publicHospital"("id") ON DELETE CASCADE ON UPDATE CASCADE;
