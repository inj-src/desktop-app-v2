/*
  Warnings:

  - You are about to drop the column `ageDay` on the `HospitalBill` table. All the data in the column will be lost.
  - You are about to drop the column `ageMonth` on the `HospitalBill` table. All the data in the column will be lost.
  - You are about to drop the column `ageYear` on the `HospitalBill` table. All the data in the column will be lost.
  - You are about to drop the column `gender` on the `HospitalBill` table. All the data in the column will be lost.
  - You are about to drop the column `name` on the `HospitalBill` table. All the data in the column will be lost.
  - You are about to drop the column `phone` on the `HospitalBill` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "HospitalBill" DROP COLUMN "ageDay",
DROP COLUMN "ageMonth",
DROP COLUMN "ageYear",
DROP COLUMN "gender",
DROP COLUMN "name",
DROP COLUMN "phone";
