/*
  Warnings:

  - The primary key for the `Accessory` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The primary key for the `Bill` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The primary key for the `BillAccessory` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The primary key for the `BillTest` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The primary key for the `DailyExpenseCategory` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The primary key for the `HospitalBill` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The primary key for the `HospitalBillService` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The primary key for the `Lab` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The primary key for the `Service` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The primary key for the `Test` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The primary key for the `TestCategory` table will be changed. If it partially fails, the table could be left without primary key constraint.

*/
-- DropForeignKey
ALTER TABLE "BillAccessory" DROP CONSTRAINT "BillAccessory_accessoryId_fkey";

-- DropForeignKey
ALTER TABLE "BillAccessory" DROP CONSTRAINT "BillAccessory_billId_fkey";

-- DropForeignKey
ALTER TABLE "BillTest" DROP CONSTRAINT "BillTest_billId_fkey";

-- DropForeignKey
ALTER TABLE "BillTest" DROP CONSTRAINT "BillTest_testId_fkey";

-- DropForeignKey
ALTER TABLE "DailyExpense" DROP CONSTRAINT "DailyExpense_dailyExpenseCategoryId_fkey";

-- DropForeignKey
ALTER TABLE "HospitalBillService" DROP CONSTRAINT "HospitalBillService_hospitalBillId_fkey";

-- DropForeignKey
ALTER TABLE "HospitalBillService" DROP CONSTRAINT "HospitalBillService_serviceId_fkey";

-- DropForeignKey
ALTER TABLE "PCTestCategoryPercentage" DROP CONSTRAINT "PCTestCategoryPercentage_testCategoryId_fkey";

-- DropForeignKey
ALTER TABLE "Test" DROP CONSTRAINT "Test_testCategoryId_fkey";

-- DropForeignKey
ALTER TABLE "TestTemplate" DROP CONSTRAINT "TestTemplate_testId_fkey";

-- AlterTable
ALTER TABLE "Accessory" DROP CONSTRAINT "Accessory_pkey",
ALTER COLUMN "id" DROP DEFAULT,
ALTER COLUMN "id" SET DATA TYPE TEXT,
ADD CONSTRAINT "Accessory_pkey" PRIMARY KEY ("id");
DROP SEQUENCE "Accessory_id_seq";

-- AlterTable
ALTER TABLE "Bill" DROP CONSTRAINT "Bill_pkey",
ALTER COLUMN "id" DROP DEFAULT,
ALTER COLUMN "id" SET DATA TYPE TEXT,
ADD CONSTRAINT "Bill_pkey" PRIMARY KEY ("id");
DROP SEQUENCE "Bill_id_seq";

-- AlterTable
ALTER TABLE "BillAccessory" DROP CONSTRAINT "BillAccessory_pkey",
ALTER COLUMN "id" DROP DEFAULT,
ALTER COLUMN "id" SET DATA TYPE TEXT,
ALTER COLUMN "billId" SET DATA TYPE TEXT,
ALTER COLUMN "accessoryId" SET DATA TYPE TEXT,
ADD CONSTRAINT "BillAccessory_pkey" PRIMARY KEY ("id");
DROP SEQUENCE "BillAccessory_id_seq";

-- AlterTable
ALTER TABLE "BillTest" DROP CONSTRAINT "BillTest_pkey",
ALTER COLUMN "id" DROP DEFAULT,
ALTER COLUMN "id" SET DATA TYPE TEXT,
ALTER COLUMN "testId" SET DATA TYPE TEXT,
ALTER COLUMN "billId" SET DATA TYPE TEXT,
ADD CONSTRAINT "BillTest_pkey" PRIMARY KEY ("id");
DROP SEQUENCE "BillTest_id_seq";

-- AlterTable
ALTER TABLE "DailyExpense" ALTER COLUMN "dailyExpenseCategoryId" SET DATA TYPE TEXT;

-- AlterTable
ALTER TABLE "DailyExpenseCategory" DROP CONSTRAINT "DailyExpenseCategory_pkey",
ALTER COLUMN "id" DROP DEFAULT,
ALTER COLUMN "id" SET DATA TYPE TEXT,
ADD CONSTRAINT "DailyExpenseCategory_pkey" PRIMARY KEY ("id");
DROP SEQUENCE "DailyExpenseCategory_id_seq";

-- AlterTable
ALTER TABLE "HospitalBill" DROP CONSTRAINT "HospitalBill_pkey",
ALTER COLUMN "id" DROP DEFAULT,
ALTER COLUMN "id" SET DATA TYPE TEXT,
ADD CONSTRAINT "HospitalBill_pkey" PRIMARY KEY ("id");
DROP SEQUENCE "HospitalBill_id_seq";

-- AlterTable
ALTER TABLE "HospitalBillService" DROP CONSTRAINT "HospitalBillService_pkey",
ALTER COLUMN "id" DROP DEFAULT,
ALTER COLUMN "id" SET DATA TYPE TEXT,
ALTER COLUMN "serviceId" SET DATA TYPE TEXT,
ALTER COLUMN "hospitalBillId" SET DATA TYPE TEXT,
ADD CONSTRAINT "HospitalBillService_pkey" PRIMARY KEY ("id");
DROP SEQUENCE "HospitalBillService_id_seq";

-- AlterTable
ALTER TABLE "Lab" DROP CONSTRAINT "Lab_pkey",
ALTER COLUMN "id" DROP DEFAULT,
ALTER COLUMN "id" SET DATA TYPE TEXT,
ADD CONSTRAINT "Lab_pkey" PRIMARY KEY ("id");
DROP SEQUENCE "Lab_id_seq";

-- AlterTable
ALTER TABLE "PCTestCategoryPercentage" ALTER COLUMN "testCategoryId" SET DATA TYPE TEXT;

-- AlterTable
ALTER TABLE "Service" DROP CONSTRAINT "Service_pkey",
ALTER COLUMN "id" DROP DEFAULT,
ALTER COLUMN "id" SET DATA TYPE TEXT,
ADD CONSTRAINT "Service_pkey" PRIMARY KEY ("id");
DROP SEQUENCE "Service_id_seq";

-- AlterTable
ALTER TABLE "Test" DROP CONSTRAINT "Test_pkey",
ALTER COLUMN "id" DROP DEFAULT,
ALTER COLUMN "id" SET DATA TYPE TEXT,
ALTER COLUMN "testCategoryId" SET DATA TYPE TEXT,
ADD CONSTRAINT "Test_pkey" PRIMARY KEY ("id");
DROP SEQUENCE "Test_id_seq";

-- AlterTable
ALTER TABLE "TestCategory" DROP CONSTRAINT "TestCategory_pkey",
ALTER COLUMN "id" DROP DEFAULT,
ALTER COLUMN "id" SET DATA TYPE TEXT,
ADD CONSTRAINT "TestCategory_pkey" PRIMARY KEY ("id");
DROP SEQUENCE "TestCategory_id_seq";

-- AlterTable
ALTER TABLE "TestTemplate" ALTER COLUMN "testId" SET DATA TYPE TEXT;

-- AddForeignKey
ALTER TABLE "PCTestCategoryPercentage" ADD CONSTRAINT "PCTestCategoryPercentage_testCategoryId_fkey" FOREIGN KEY ("testCategoryId") REFERENCES "TestCategory"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Test" ADD CONSTRAINT "Test_testCategoryId_fkey" FOREIGN KEY ("testCategoryId") REFERENCES "TestCategory"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TestTemplate" ADD CONSTRAINT "TestTemplate_testId_fkey" FOREIGN KEY ("testId") REFERENCES "Test"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BillTest" ADD CONSTRAINT "BillTest_testId_fkey" FOREIGN KEY ("testId") REFERENCES "Test"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BillTest" ADD CONSTRAINT "BillTest_billId_fkey" FOREIGN KEY ("billId") REFERENCES "Bill"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BillAccessory" ADD CONSTRAINT "BillAccessory_billId_fkey" FOREIGN KEY ("billId") REFERENCES "Bill"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BillAccessory" ADD CONSTRAINT "BillAccessory_accessoryId_fkey" FOREIGN KEY ("accessoryId") REFERENCES "Accessory"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DailyExpense" ADD CONSTRAINT "DailyExpense_dailyExpenseCategoryId_fkey" FOREIGN KEY ("dailyExpenseCategoryId") REFERENCES "DailyExpenseCategory"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "HospitalBillService" ADD CONSTRAINT "HospitalBillService_serviceId_fkey" FOREIGN KEY ("serviceId") REFERENCES "Service"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "HospitalBillService" ADD CONSTRAINT "HospitalBillService_hospitalBillId_fkey" FOREIGN KEY ("hospitalBillId") REFERENCES "HospitalBill"("id") ON DELETE CASCADE ON UPDATE CASCADE;
