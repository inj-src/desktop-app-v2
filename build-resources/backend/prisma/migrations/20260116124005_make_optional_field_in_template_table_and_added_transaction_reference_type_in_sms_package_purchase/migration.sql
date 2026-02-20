-- AlterTable
ALTER TABLE "public"."SMSPackagePurchase" ADD COLUMN     "transactionReference" TEXT;

-- AlterTable
ALTER TABLE "public"."Template" ALTER COLUMN "transformFunction" DROP NOT NULL,
ALTER COLUMN "pageHeight" DROP NOT NULL,
ALTER COLUMN "pageWidth" DROP NOT NULL,
ALTER COLUMN "dummyData" DROP NOT NULL;
