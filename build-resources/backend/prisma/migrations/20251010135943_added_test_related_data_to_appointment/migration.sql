-- AlterTable
ALTER TABLE "public"."BillTest" ADD COLUMN     "appointmentId" TEXT;

-- AlterTable
ALTER TABLE "public"."DoctorAppointment" ADD COLUMN     "totalTestFee" INTEGER NOT NULL DEFAULT 0;

-- AddForeignKey
ALTER TABLE "public"."BillTest" ADD CONSTRAINT "BillTest_appointmentId_fkey" FOREIGN KEY ("appointmentId") REFERENCES "public"."DoctorAppointment"("id") ON DELETE SET NULL ON UPDATE CASCADE;
