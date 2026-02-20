-- DropIndex
DROP INDEX "public"."Bill_branchId_departmentId_idx";

-- DropIndex
DROP INDEX "public"."Bill_branchId_idx";

-- DropIndex
DROP INDEX "public"."Bill_departmentId_idx";

-- DropIndex
DROP INDEX "public"."Bill_diagnosticId_branchId_idx";

-- DropIndex
DROP INDEX "public"."Bill_diagnosticId_createdAt_idx";

-- DropIndex
DROP INDEX "public"."Bill_diagnosticId_departmentId_idx";

-- DropIndex
DROP INDEX "public"."Bill_doctorId_idx";

-- DropIndex
DROP INDEX "public"."Bill_labId_idx";

-- DropIndex
DROP INDEX "public"."BillTest_createdAt_idx";

-- DropIndex
DROP INDEX "public"."BillTest_updatedAt_idx";

-- DropIndex
DROP INDEX "public"."Commission_diagnosticId_createdAt_idx";

-- DropIndex
DROP INDEX "public"."DailyExpense_diagnosticId_createdAt_idx";

-- DropIndex
DROP INDEX "public"."DailyExtraIncome_createdAt_idx";

-- DropIndex
DROP INDEX "public"."DailyExtraIncome_diagnosticId_idx";

-- DropIndex
DROP INDEX "public"."DoctorAppointment_branchId_departmentId_idx";

-- DropIndex
DROP INDEX "public"."DoctorAppointment_branchId_idx";

-- DropIndex
DROP INDEX "public"."DoctorAppointment_departmentId_idx";

-- DropIndex
DROP INDEX "public"."DoctorAppointment_diagnosticId_branchId_idx";

-- DropIndex
DROP INDEX "public"."DoctorAppointment_diagnosticId_departmentId_idx";

-- DropIndex
DROP INDEX "public"."Employee_branchId_departmentId_idx";

-- DropIndex
DROP INDEX "public"."Employee_branchId_idx";

-- DropIndex
DROP INDEX "public"."Employee_departmentId_idx";

-- DropIndex
DROP INDEX "public"."Employee_diagnosticId_branchId_idx";

-- DropIndex
DROP INDEX "public"."Employee_diagnosticId_departmentId_idx";

-- DropIndex
DROP INDEX "public"."HospitalBill_branchId_departmentId_idx";

-- DropIndex
DROP INDEX "public"."HospitalBill_branchId_idx";

-- DropIndex
DROP INDEX "public"."HospitalBill_departmentId_idx";

-- DropIndex
DROP INDEX "public"."HospitalBill_diagnosticId_branchId_idx";

-- DropIndex
DROP INDEX "public"."HospitalBill_diagnosticId_createdAt_idx";

-- DropIndex
DROP INDEX "public"."HospitalBill_diagnosticId_departmentId_idx";

-- DropIndex
DROP INDEX "public"."HospitalBill_diagnosticId_idx";

-- DropIndex
DROP INDEX "public"."MonthlyExpense_diagnosticId_idx";

-- DropIndex
DROP INDEX "public"."MonthlyExpense_id_diagnosticId_idx";

-- DropIndex
DROP INDEX "public"."MonthlyExpense_id_monthlyExpenseCategoryId_idx";

-- DropIndex
DROP INDEX "public"."MonthlyExpense_id_paidById_idx";

-- DropIndex
DROP INDEX "public"."MonthlyExpense_monthlyExpenseCategoryId_diagnosticId_expens_idx";

-- DropIndex
DROP INDEX "public"."MonthlyExpense_monthlyExpenseCategoryId_diagnosticId_idx";

-- DropIndex
DROP INDEX "public"."MonthlyExpense_monthlyExpenseCategoryId_idx";

-- DropIndex
DROP INDEX "public"."MonthlyExpense_paidById_idx";

-- DropIndex
DROP INDEX "public"."MonthlyExpense_paidById_monthlyExpenseCategoryId_idx";

-- DropIndex
DROP INDEX "public"."MonthlyExpense_updatedAt_idx";

-- DropIndex
DROP INDEX "public"."MonthlyExpenseCategory_id_diagnosticId_idx";

-- DropIndex
DROP INDEX "public"."MonthlyExpenseCategory_name_idx";

-- AlterTable
ALTER TABLE "public"."Diagnostic" ADD COLUMN     "enableBranch" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "enableDepartment" BOOLEAN NOT NULL DEFAULT false;

-- CreateIndex
CREATE INDEX "Accessory_diagnosticId_idx" ON "public"."Accessory"("diagnosticId");

-- CreateIndex
CREATE INDEX "Accessory_diagnosticId_branchId_departmentId_idx" ON "public"."Accessory"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "AdvanceRepayment_diagnosticId_idx" ON "public"."AdvanceRepayment"("diagnosticId");

-- CreateIndex
CREATE INDEX "AdvanceRepayment_diagnosticId_branchId_departmentId_idx" ON "public"."AdvanceRepayment"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "AllowanceType_diagnosticId_branchId_departmentId_idx" ON "public"."AllowanceType"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "Anesthesiologist_diagnosticId_idx" ON "public"."Anesthesiologist"("diagnosticId");

-- CreateIndex
CREATE INDEX "Anesthesiologist_diagnosticId_branchId_departmentId_idx" ON "public"."Anesthesiologist"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "AnesthesiologistOperationFee_diagnosticId_idx" ON "public"."AnesthesiologistOperationFee"("diagnosticId");

-- CreateIndex
CREATE INDEX "AnesthesiologistOperationFee_diagnosticId_branchId_departme_idx" ON "public"."AnesthesiologistOperationFee"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "Attendance_diagnosticId_branchId_departmentId_idx" ON "public"."Attendance"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "AttendanceLog_diagnosticId_branchId_departmentId_idx" ON "public"."AttendanceLog"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "Bed_diagnosticId_idx" ON "public"."Bed"("diagnosticId");

-- CreateIndex
CREATE INDEX "Bed_diagnosticId_branchId_departmentId_idx" ON "public"."Bed"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "BedBooking_diagnosticId_idx" ON "public"."BedBooking"("diagnosticId");

-- CreateIndex
CREATE INDEX "BedBooking_diagnosticId_branchId_departmentId_idx" ON "public"."BedBooking"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "BedCategory_diagnosticId_idx" ON "public"."BedCategory"("diagnosticId");

-- CreateIndex
CREATE INDEX "BedCategory_diagnosticId_branchId_departmentId_idx" ON "public"."BedCategory"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "BedSubCategory_diagnosticId_idx" ON "public"."BedSubCategory"("diagnosticId");

-- CreateIndex
CREATE INDEX "BedSubCategory_diagnosticId_branchId_departmentId_idx" ON "public"."BedSubCategory"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "Bill_diagnosticId_branchId_departmentId_idx" ON "public"."Bill"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "BillAccessory_diagnosticId_idx" ON "public"."BillAccessory"("diagnosticId");

-- CreateIndex
CREATE INDEX "BillAccessory_diagnosticId_branchId_departmentId_idx" ON "public"."BillAccessory"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "BillInventoryItem_diagnosticId_idx" ON "public"."BillInventoryItem"("diagnosticId");

-- CreateIndex
CREATE INDEX "BillInventoryItem_diagnosticId_branchId_departmentId_idx" ON "public"."BillInventoryItem"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "BillTest_diagnosticId_branchId_departmentId_idx" ON "public"."BillTest"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "Bonus_diagnosticId_branchId_departmentId_idx" ON "public"."Bonus"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "Commission_diagnosticId_branchId_departmentId_idx" ON "public"."Commission"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "DailyExpense_diagnosticId_branchId_departmentId_idx" ON "public"."DailyExpense"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "DailyExpenseCategory_diagnosticId_idx" ON "public"."DailyExpenseCategory"("diagnosticId");

-- CreateIndex
CREATE INDEX "DailyExpenseCategory_diagnosticId_branchId_departmentId_idx" ON "public"."DailyExpenseCategory"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "DailyExtraIncome_diagnosticId_branchId_departmentId_idx" ON "public"."DailyExtraIncome"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "DailyIncomeCategory_diagnosticId_idx" ON "public"."DailyIncomeCategory"("diagnosticId");

-- CreateIndex
CREATE INDEX "DailyIncomeCategory_diagnosticId_branchId_departmentId_idx" ON "public"."DailyIncomeCategory"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "DeductionType_diagnosticId_branchId_departmentId_idx" ON "public"."DeductionType"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "DiagnosticTemplate_diagnosticId_idx" ON "public"."DiagnosticTemplate"("diagnosticId");

-- CreateIndex
CREATE INDEX "DiagnosticTemplate_diagnosticId_branchId_departmentId_idx" ON "public"."DiagnosticTemplate"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "DiscountReferrer_diagnosticId_idx" ON "public"."DiscountReferrer"("diagnosticId");

-- CreateIndex
CREATE INDEX "DiscountReferrer_diagnosticId_branchId_departmentId_idx" ON "public"."DiscountReferrer"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "Doctor_diagnosticId_idx" ON "public"."Doctor"("diagnosticId");

-- CreateIndex
CREATE INDEX "Doctor_diagnosticId_branchId_departmentId_idx" ON "public"."Doctor"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "DoctorAppointment_diagnosticId_branchId_departmentId_idx" ON "public"."DoctorAppointment"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "DoctorChamber_diagnosticId_branchId_departmentId_idx" ON "public"."DoctorChamber"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "DoctorSession_diagnosticId_branchId_departmentId_idx" ON "public"."DoctorSession"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "DoctorSessionHistory_diagnosticId_branchId_departmentId_idx" ON "public"."DoctorSessionHistory"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "DoctorTestCategoryPercentage_diagnosticId_idx" ON "public"."DoctorTestCategoryPercentage"("diagnosticId");

-- CreateIndex
CREATE INDEX "DoctorTestCategoryPercentage_diagnosticId_branchId_departme_idx" ON "public"."DoctorTestCategoryPercentage"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "DoctorTestPercentage_diagnosticId_idx" ON "public"."DoctorTestPercentage"("diagnosticId");

-- CreateIndex
CREATE INDEX "DoctorTestPercentage_diagnosticId_branchId_departmentId_idx" ON "public"."DoctorTestPercentage"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "DoctorUpdateInfo_diagnosticId_idx" ON "public"."DoctorUpdateInfo"("diagnosticId");

-- CreateIndex
CREATE INDEX "DoctorUpdateInfo_diagnosticId_branchId_departmentId_idx" ON "public"."DoctorUpdateInfo"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "Document_diagnosticId_branchId_departmentId_idx" ON "public"."Document"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "Employee_diagnosticId_branchId_departmentId_idx" ON "public"."Employee"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "EmployeeSalary_diagnosticId_branchId_departmentId_idx" ON "public"."EmployeeSalary"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "EmployeeShift_diagnosticId_branchId_departmentId_idx" ON "public"."EmployeeShift"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "FingerprintDevice_diagnosticId_branchId_departmentId_idx" ON "public"."FingerprintDevice"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "Holiday_diagnosticId_branchId_departmentId_idx" ON "public"."Holiday"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "HospitalBill_diagnosticId_branchId_departmentId_idx" ON "public"."HospitalBill"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "HospitalBillService_diagnosticId_idx" ON "public"."HospitalBillService"("diagnosticId");

-- CreateIndex
CREATE INDEX "HospitalBillService_diagnosticId_branchId_departmentId_idx" ON "public"."HospitalBillService"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "HospitalServiceVersion_branchId_idx" ON "public"."HospitalServiceVersion"("branchId");

-- CreateIndex
CREATE INDEX "HospitalServiceVersion_departmentId_idx" ON "public"."HospitalServiceVersion"("departmentId");

-- CreateIndex
CREATE INDEX "InventoryItem_diagnosticId_idx" ON "public"."InventoryItem"("diagnosticId");

-- CreateIndex
CREATE INDEX "InventoryItem_diagnosticId_branchId_departmentId_idx" ON "public"."InventoryItem"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "InventoryItemDeductionSetting_diagnosticId_branchId_departm_idx" ON "public"."InventoryItemDeductionSetting"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "InventoryPackage_diagnosticId_idx" ON "public"."InventoryPackage"("diagnosticId");

-- CreateIndex
CREATE INDEX "InventoryPackage_diagnosticId_branchId_departmentId_idx" ON "public"."InventoryPackage"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "InventoryPackageItem_diagnosticId_branchId_departmentId_idx" ON "public"."InventoryPackageItem"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "InventoryTransaction_diagnosticId_branchId_departmentId_idx" ON "public"."InventoryTransaction"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "ItemConsumptionTracker_diagnosticId_branchId_departmentId_idx" ON "public"."ItemConsumptionTracker"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "Lab_diagnosticId_idx" ON "public"."Lab"("diagnosticId");

-- CreateIndex
CREATE INDEX "Lab_diagnosticId_branchId_departmentId_idx" ON "public"."Lab"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "Leave_diagnosticId_branchId_departmentId_idx" ON "public"."Leave"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "LeavePolicy_diagnosticId_branchId_departmentId_idx" ON "public"."LeavePolicy"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "LeaveType_diagnosticId_branchId_departmentId_idx" ON "public"."LeaveType"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "Message_diagnosticId_idx" ON "public"."Message"("diagnosticId");

-- CreateIndex
CREATE INDEX "Message_diagnosticId_branchId_departmentId_idx" ON "public"."Message"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "MissedQueueLog_diagnosticId_branchId_departmentId_idx" ON "public"."MissedQueueLog"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "MonthlyExpense_diagnosticId_monthlyExpenseCategoryId_expens_idx" ON "public"."MonthlyExpense"("diagnosticId", "monthlyExpenseCategoryId", "expenseMonth", "expenseYear");

-- CreateIndex
CREATE INDEX "MonthlyExpense_diagnosticId_branchId_departmentId_idx" ON "public"."MonthlyExpense"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "MonthlyExpenseCategory_diagnosticId_branchId_departmentId_idx" ON "public"."MonthlyExpenseCategory"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "Notification_branchId_idx" ON "public"."Notification"("branchId");

-- CreateIndex
CREATE INDEX "Notification_departmentId_idx" ON "public"."Notification"("departmentId");

-- CreateIndex
CREATE INDEX "NotificationPreference_branchId_idx" ON "public"."NotificationPreference"("branchId");

-- CreateIndex
CREATE INDEX "NotificationPreference_departmentId_idx" ON "public"."NotificationPreference"("departmentId");

-- CreateIndex
CREATE INDEX "Nurse_diagnosticId_idx" ON "public"."Nurse"("diagnosticId");

-- CreateIndex
CREATE INDEX "Nurse_diagnosticId_branchId_departmentId_idx" ON "public"."Nurse"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "Operation_diagnosticId_idx" ON "public"."Operation"("diagnosticId");

-- CreateIndex
CREATE INDEX "Operation_diagnosticId_branchId_departmentId_idx" ON "public"."Operation"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "OperationBreakdownFee_diagnosticId_idx" ON "public"."OperationBreakdownFee"("diagnosticId");

-- CreateIndex
CREATE INDEX "OperationBreakdownFee_diagnosticId_branchId_departmentId_idx" ON "public"."OperationBreakdownFee"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "OperationCategory_diagnosticId_branchId_departmentId_idx" ON "public"."OperationCategory"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "OperationCategoryBreakdownFeeTemplate_diagnosticId_idx" ON "public"."OperationCategoryBreakdownFeeTemplate"("diagnosticId");

-- CreateIndex
CREATE INDEX "OperationCategoryBreakdownFeeTemplate_diagnosticId_branchId_idx" ON "public"."OperationCategoryBreakdownFeeTemplate"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "PC_diagnosticId_idx" ON "public"."PC"("diagnosticId");

-- CreateIndex
CREATE INDEX "PC_diagnosticId_branchId_departmentId_idx" ON "public"."PC"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "PCGroup_diagnosticId_idx" ON "public"."PCGroup"("diagnosticId");

-- CreateIndex
CREATE INDEX "PCGroup_diagnosticId_branchId_departmentId_idx" ON "public"."PCGroup"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "PCGroupMember_diagnosticId_idx" ON "public"."PCGroupMember"("diagnosticId");

-- CreateIndex
CREATE INDEX "PCGroupMember_diagnosticId_branchId_departmentId_idx" ON "public"."PCGroupMember"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "PCTestCategoryPercentage_diagnosticId_idx" ON "public"."PCTestCategoryPercentage"("diagnosticId");

-- CreateIndex
CREATE INDEX "PCTestCategoryPercentage_diagnosticId_branchId_departmentId_idx" ON "public"."PCTestCategoryPercentage"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "PCTestPercentage_diagnosticId_idx" ON "public"."PCTestPercentage"("diagnosticId");

-- CreateIndex
CREATE INDEX "PCTestPercentage_diagnosticId_branchId_departmentId_idx" ON "public"."PCTestPercentage"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "Patient_diagnosticId_idx" ON "public"."Patient"("diagnosticId");

-- CreateIndex
CREATE INDEX "Patient_diagnosticId_branchId_departmentId_idx" ON "public"."Patient"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "PatientFollowupHistory_diagnosticId_idx" ON "public"."PatientFollowupHistory"("diagnosticId");

-- CreateIndex
CREATE INDEX "PatientFollowupHistory_diagnosticId_branchId_departmentId_idx" ON "public"."PatientFollowupHistory"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "PayrollPeriod_diagnosticId_branchId_departmentId_idx" ON "public"."PayrollPeriod"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "Payslip_diagnosticId_branchId_departmentId_idx" ON "public"."Payslip"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "ReportQueue_diagnosticId_branchId_departmentId_idx" ON "public"."ReportQueue"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "SMSPackagePurchase_diagnosticId_idx" ON "public"."SMSPackagePurchase"("diagnosticId");

-- CreateIndex
CREATE INDEX "SMSPackagePurchase_diagnosticId_branchId_departmentId_idx" ON "public"."SMSPackagePurchase"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "SMSTemplate_diagnosticId_branchId_departmentId_idx" ON "public"."SMSTemplate"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "SalaryAdvance_diagnosticId_branchId_departmentId_idx" ON "public"."SalaryAdvance"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "SalaryRevision_diagnosticId_branchId_departmentId_idx" ON "public"."SalaryRevision"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "SalaryStructure_diagnosticId_branchId_departmentId_idx" ON "public"."SalaryStructure"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "ScheduledSummaryConfig_branchId_idx" ON "public"."ScheduledSummaryConfig"("branchId");

-- CreateIndex
CREATE INDEX "ScheduledSummaryConfig_departmentId_idx" ON "public"."ScheduledSummaryConfig"("departmentId");

-- CreateIndex
CREATE INDEX "Service_diagnosticId_idx" ON "public"."Service"("diagnosticId");

-- CreateIndex
CREATE INDEX "Service_diagnosticId_branchId_departmentId_idx" ON "public"."Service"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "ServiceChargeTrx_diagnosticId_idx" ON "public"."ServiceChargeTrx"("diagnosticId");

-- CreateIndex
CREATE INDEX "ServiceChargeTrx_diagnosticId_branchId_departmentId_idx" ON "public"."ServiceChargeTrx"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "ServiceVersion_diagnosticId_idx" ON "public"."ServiceVersion"("diagnosticId");

-- CreateIndex
CREATE INDEX "ServiceVersion_diagnosticId_branchId_departmentId_idx" ON "public"."ServiceVersion"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "SessionNotice_diagnosticId_branchId_departmentId_idx" ON "public"."SessionNotice"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "Shift_diagnosticId_branchId_departmentId_idx" ON "public"."Shift"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "Signatures_diagnosticId_idx" ON "public"."Signatures"("diagnosticId");

-- CreateIndex
CREATE INDEX "Signatures_diagnosticId_branchId_departmentId_idx" ON "public"."Signatures"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "Slot_diagnosticId_idx" ON "public"."Slot"("diagnosticId");

-- CreateIndex
CREATE INDEX "Slot_diagnosticId_branchId_departmentId_idx" ON "public"."Slot"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "Store_diagnosticId_branchId_departmentId_idx" ON "public"."Store"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "StoreInventoryItems_diagnosticId_branchId_departmentId_idx" ON "public"."StoreInventoryItems"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "StoreTag_diagnosticId_branchId_departmentId_idx" ON "public"."StoreTag"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "SubTestCategory_diagnosticId_idx" ON "public"."SubTestCategory"("diagnosticId");

-- CreateIndex
CREATE INDEX "SubTestCategory_diagnosticId_branchId_departmentId_idx" ON "public"."SubTestCategory"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "Surgeon_diagnosticId_idx" ON "public"."Surgeon"("diagnosticId");

-- CreateIndex
CREATE INDEX "Surgeon_diagnosticId_branchId_departmentId_idx" ON "public"."Surgeon"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "SurgeonOperation_diagnosticId_idx" ON "public"."SurgeonOperation"("diagnosticId");

-- CreateIndex
CREATE INDEX "SurgeonOperation_diagnosticId_branchId_departmentId_idx" ON "public"."SurgeonOperation"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "SurgeonOperationBreakdownFee_diagnosticId_idx" ON "public"."SurgeonOperationBreakdownFee"("diagnosticId");

-- CreateIndex
CREATE INDEX "SurgeonOperationBreakdownFee_diagnosticId_branchId_departme_idx" ON "public"."SurgeonOperationBreakdownFee"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "SurgeonOperationFee_diagnosticId_idx" ON "public"."SurgeonOperationFee"("diagnosticId");

-- CreateIndex
CREATE INDEX "SurgeonOperationFee_diagnosticId_branchId_departmentId_idx" ON "public"."SurgeonOperationFee"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "SurgeonOperationTrx_diagnosticId_idx" ON "public"."SurgeonOperationTrx"("diagnosticId");

-- CreateIndex
CREATE INDEX "SurgeonOperationTrx_diagnosticId_branchId_departmentId_idx" ON "public"."SurgeonOperationTrx"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "Tag_diagnosticId_branchId_departmentId_idx" ON "public"."Tag"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "TemplateCategory_diagnosticId_idx" ON "public"."TemplateCategory"("diagnosticId");

-- CreateIndex
CREATE INDEX "TemplateCategory_diagnosticId_branchId_departmentId_idx" ON "public"."TemplateCategory"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "Test_diagnosticId_idx" ON "public"."Test"("diagnosticId");

-- CreateIndex
CREATE INDEX "Test_diagnosticId_branchId_departmentId_idx" ON "public"."Test"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "TestAccessories_diagnosticId_idx" ON "public"."TestAccessories"("diagnosticId");

-- CreateIndex
CREATE INDEX "TestAccessories_diagnosticId_branchId_departmentId_idx" ON "public"."TestAccessories"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "TestCategory_diagnosticId_idx" ON "public"."TestCategory"("diagnosticId");

-- CreateIndex
CREATE INDEX "TestCategory_diagnosticId_branchId_departmentId_idx" ON "public"."TestCategory"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "TestTemplate_diagnosticId_idx" ON "public"."TestTemplate"("diagnosticId");

-- CreateIndex
CREATE INDEX "TestTemplate_diagnosticId_branchId_departmentId_idx" ON "public"."TestTemplate"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "TriggerEvent_diagnosticId_branchId_departmentId_idx" ON "public"."TriggerEvent"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "UserInventoryStore_diagnosticId_branchId_departmentId_idx" ON "public"."UserInventoryStore"("diagnosticId", "branchId", "departmentId");

-- CreateIndex
CREATE INDEX "patientFollowups_diagnosticId_idx" ON "public"."patientFollowups"("diagnosticId");

-- CreateIndex
CREATE INDEX "patientFollowups_diagnosticId_branchId_departmentId_idx" ON "public"."patientFollowups"("diagnosticId", "branchId", "departmentId");
