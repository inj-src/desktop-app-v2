-- CreateTable
CREATE TABLE "Signatures" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "designationn" TEXT,
    "image" TEXT NOT NULL,
    "diagnosticId" TEXT,

    CONSTRAINT "Signatures_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "Signatures" ADD CONSTRAINT "Signatures_diagnosticId_fkey" FOREIGN KEY ("diagnosticId") REFERENCES "Diagnostic"("id") ON DELETE SET NULL ON UPDATE CASCADE;
