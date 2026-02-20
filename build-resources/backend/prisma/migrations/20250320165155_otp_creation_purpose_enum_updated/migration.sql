-- AlterEnum
ALTER TYPE "OTP_CREATION_PURPOSE" ADD VALUE 'GET_PATIENT_CREDENTIALS';

-- CreateIndex
CREATE INDEX "ActiveToken_jti_idx" ON "ActiveToken"("jti");
