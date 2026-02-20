/*
  Warnings:

  - The `deviceInfo` column on the `ActiveToken` table would be dropped and recreated. This will lead to data loss if there is data in the column.

*/
-- AlterTable
ALTER TABLE "ActiveToken" ADD COLUMN     "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
DROP COLUMN "deviceInfo",
ADD COLUMN     "deviceInfo" JSONB;
