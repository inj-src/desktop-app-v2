/*
  Warnings:

  - You are about to drop the column `reservedSerialCount` on the `DoctorChamber` table. All the data in the column will be lost.
  - You are about to drop the column `reservedSerialEndNumber` on the `DoctorChamber` table. All the data in the column will be lost.
  - You are about to drop the column `reservedSerialLeftOffset` on the `DoctorChamber` table. All the data in the column will be lost.
  - You are about to drop the column `reservedSerialMultiple` on the `DoctorChamber` table. All the data in the column will be lost.
  - You are about to drop the column `reservedSerialRightOffset` on the `DoctorChamber` table. All the data in the column will be lost.
  - You are about to drop the column `reservedSerialStartNumber` on the `DoctorChamber` table. All the data in the column will be lost.
  - You are about to drop the column `reservedSerialStrategy` on the `DoctorChamber` table. All the data in the column will be lost.
  - You are about to drop the column `reservedSpecificSerial` on the `DoctorChamber` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "DoctorChamber" DROP COLUMN "reservedSerialCount",
DROP COLUMN "reservedSerialEndNumber",
DROP COLUMN "reservedSerialLeftOffset",
DROP COLUMN "reservedSerialMultiple",
DROP COLUMN "reservedSerialRightOffset",
DROP COLUMN "reservedSerialStartNumber",
DROP COLUMN "reservedSerialStrategy",
DROP COLUMN "reservedSpecificSerial";
