/*
  Warnings:

  - You are about to drop the column `CanManagePathologists` on the `UserPermissions` table. All the data in the column will be lost.
  - You are about to drop the column `CanManageSMS` on the `UserPermissions` table. All the data in the column will be lost.
  - You are about to drop the column `CanManageSerialManagers` on the `UserPermissions` table. All the data in the column will be lost.
  - You are about to drop the column `CanManageStatements` on the `UserPermissions` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "public"."UserPermissions" DROP COLUMN "CanManagePathologists",
DROP COLUMN "CanManageSMS",
DROP COLUMN "CanManageSerialManagers",
DROP COLUMN "CanManageStatements",
ADD COLUMN     "canManagePathologists" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "canManageSMS" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "canManageSerialManagers" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "canManageStatements" BOOLEAN NOT NULL DEFAULT false;
