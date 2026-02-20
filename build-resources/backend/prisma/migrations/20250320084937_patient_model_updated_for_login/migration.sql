/*
  Warnings:

  - Added the required column `patientId` to the `OTPVerification` table without a default value. This is not possible if the table is not empty.

*/
-- AlterEnum
ALTER TYPE "OTP_CREATION_PURPOSE" ADD VALUE 'PASSWORD_RESET';

-- AlterTable
ALTER TABLE "OTPVerification" ADD COLUMN     "patientId" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "Patient" ADD COLUMN     "email" TEXT,
ADD COLUMN     "emailVerified" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "failedLoginAttempts" INTEGER DEFAULT 0,
ADD COLUMN     "isActive" BOOLEAN NOT NULL DEFAULT true,
ADD COLUMN     "lastAdminLoggedIn" TIMESTAMP(3),
ADD COLUMN     "lastAdminLoginIp" TEXT,
ADD COLUMN     "lastFailedLogin" TIMESTAMP(3),
ADD COLUMN     "lastLoggedIn" TIMESTAMP(3),
ADD COLUMN     "lastLoginIp" TEXT,
ADD COLUMN     "password" TEXT,
ADD COLUMN     "resetPasswordExpires" TIMESTAMP(3),
ADD COLUMN     "resetPasswordToken" TEXT,
ADD COLUMN     "temporaryPassword" TEXT,
ADD COLUMN     "temporaryPasswordExpire" TIMESTAMP(3);

-- AddForeignKey
ALTER TABLE "OTPVerification" ADD CONSTRAINT "OTPVerification_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "Patient"("id") ON DELETE CASCADE ON UPDATE CASCADE;
