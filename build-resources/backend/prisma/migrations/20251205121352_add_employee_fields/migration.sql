/*
  Warnings:

  - You are about to drop the column `address` on the `Employee` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "public"."Employee" DROP COLUMN "address",
ADD COLUMN     "accountHolderName" TEXT,
ADD COLUMN     "accountNumber" TEXT,
ADD COLUMN     "addressLine1" TEXT,
ADD COLUMN     "addressLine2" TEXT,
ADD COLUMN     "bankBranch" TEXT,
ADD COLUMN     "bankIdentifierCode" TEXT,
ADD COLUMN     "bankName" TEXT,
ADD COLUMN     "branch" TEXT,
ADD COLUMN     "city" TEXT,
ADD COLUMN     "country" TEXT,
ADD COLUMN     "dateOfBirth" TIMESTAMP(3),
ADD COLUMN     "documentsId" TEXT,
ADD COLUMN     "emergencyContactName" TEXT,
ADD COLUMN     "emergencyContactPhoneNumber" TEXT,
ADD COLUMN     "emergencyContactRelationship" TEXT,
ADD COLUMN     "employmentType" TEXT,
ADD COLUMN     "gender" TEXT,
ADD COLUMN     "postalCode" TEXT,
ADD COLUMN     "state" TEXT,
ADD COLUMN     "taxPayerId" TEXT;
