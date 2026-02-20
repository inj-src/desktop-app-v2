-- CreateEnum
CREATE TYPE "ReservedSerialStrategy" AS ENUM ('NONE', 'FIRST_N', 'LAST_N', 'MULTIPLE');

-- AlterTable
ALTER TABLE "DoctorAppointment" ADD COLUMN     "fullSerial" TEXT NOT NULL DEFAULT '',
ADD COLUMN     "isReservedSerial" BOOLEAN NOT NULL DEFAULT false;

-- AlterTable
ALTER TABLE "DoctorChamber" ADD COLUMN     "enableReservedSerials" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "reservedSerialCount" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "reservedSerialLeftOffset" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "reservedSerialMultiple" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "reservedSerialRightOffset" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "reservedSerialStrategy" "ReservedSerialStrategy" NOT NULL DEFAULT 'NONE';
