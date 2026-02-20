/*
  Warnings:

  - Added the required column `dummyData` to the `Template` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "public"."Template" ADD COLUMN     "dummyData" JSONB NOT NULL;
