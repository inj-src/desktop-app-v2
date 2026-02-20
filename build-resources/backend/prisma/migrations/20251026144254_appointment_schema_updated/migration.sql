-- AlterTable
ALTER TABLE "public"."DoctorAppointment" ADD COLUMN     "expectedEndTime" TIMESTAMP(3),
ADD COLUMN     "expectedStartTime" TIMESTAMP(3);

-- AlterTable
ALTER TABLE "public"."DoctorSession" ADD COLUMN     "averageConsultationTimeInMinutes" INTEGER DEFAULT 10;
