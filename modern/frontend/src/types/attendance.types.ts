/**
 * Attendance Types
 * Matching legacy types from /legacy/Frontend/HRMS-Frontend/source/src/pages/Attendance/types.ts
 */

export interface AttendanceAudit {
  action: string;
  time: string;
  comment: string;
  reason?: string;
}

export interface AttendanceRow {
  id: number;
  date: string;
  startTime: string;
  endTime: string | null;
  day: string;
  location: string;
  totalHours: string;
  audit: AttendanceAudit[];
  createdBy: string;
  modifiedBy: string | null;
  attendanceType: string;
}

export interface AttendanceResponse {
  attendaceReport: AttendanceRow[];
  dates: string[];
  isManualAttendance: boolean;
  totalRecords: number;
  isTimedIn: boolean;
}

export interface TimeInFormData {
  date: string;
  startTime: string;
  endTime: string;
  location: string;
  note: string;
  reason: string;
}

export interface EditDetails {
  id: number;
  date: string;
  startTime?: string;
  endTime?: string;
  location: string;
  note?: string;
  reason?: string;
  totalHours: string | null;
}

// Attendance Configuration Types
export interface AttendanceConfigResponse {
  employeeId: number;
  employeeCode: string;
  employeeName: string;
  department: string;
  designation: string;
  branch: string;
  country: string;
  isManualAttendance: boolean;
  timeDoctorUserId: string | null;
  joiningDate: string | null;
}

export interface AttendanceConfig {
  attendanceConfigList: AttendanceConfigResponse[];
  totalRecords: number;
}

export interface AttendanceConfigFilter {
  employeeName?: string;
  employeeId?: number;
  employeeCode?: string;
}

// Employee Report Types
export interface EmployeeReport {
  employeeCode: string;
  employeeName: string;
  totalHour: string;
  branch: string;
  department: string;
  workedHoursByDate: Record<string, string>;
}

export interface EmployeeReportResult {
  totalRecords: number;
  employeeReports: EmployeeReport[];
}

export interface EmployeeReportTableRow {
  employeeCode: string;
  employeeName: string;
  totalHour: string;
  branch: string;
  department: string;
  timeEntries: Record<string, number | undefined>;
}

export interface EmployeeReportSearchFilter {
  employeeCode?: string;
  dateFrom: string | null;
  dateTo: string | null;
  branchId?: number | null;
  departmentId?: number | null;
}
