-- CreateEnum
CREATE TYPE "OTP_CREATION_PURPOSE" AS ENUM ('AUTHENTICATION', 'APPOINTMENT_BOOKING');

-- CreateTable
CREATE TABLE "OTPVerification" (
    "id" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "otp" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "verified" BOOLEAN NOT NULL DEFAULT false,
    "verifiedAt" TIMESTAMP(3),
    "attemptCount" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "purpose" "OTP_CREATION_PURPOSE" NOT NULL DEFAULT 'APPOINTMENT_BOOKING',

    CONSTRAINT "OTPVerification_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "OTPVerification_phone_idx" ON "OTPVerification"("phone");

-- CreateIndex
CREATE INDEX "OTPVerification_otp_idx" ON "OTPVerification"("otp");
