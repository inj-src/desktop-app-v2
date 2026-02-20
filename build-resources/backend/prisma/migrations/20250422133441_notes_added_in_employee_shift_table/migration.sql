/*
  Warnings:

  - Made the column `department` on table `Employee` required. This step will fail if there are existing NULL values in that column.

*/
-- AlterTable
ALTER TABLE "Employee" ALTER COLUMN "department" SET NOT NULL;

-- AlterTable
ALTER TABLE "EmployeeShift" ADD COLUMN     "notes" TEXT;
