-- CreateTable
CREATE TABLE "TestAccessories" (
    "id" TEXT NOT NULL,
    "testId" TEXT NOT NULL,
    "accessoryId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "quantity" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "TestAccessories_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "TestAccessories" ADD CONSTRAINT "TestAccessories_testId_fkey" FOREIGN KEY ("testId") REFERENCES "Test"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TestAccessories" ADD CONSTRAINT "TestAccessories_accessoryId_fkey" FOREIGN KEY ("accessoryId") REFERENCES "Accessory"("id") ON DELETE CASCADE ON UPDATE CASCADE;
