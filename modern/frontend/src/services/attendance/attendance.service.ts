/**
 * Attendance Service
 * Maps to legacy: /legacy/Frontend/HRMS-Frontend/source/src/services/Attendence/AttendenceService.ts
 */

import httpClient from '@/services/api/http-client';
import type {
  AttendanceResponse,
  AttendanceConfig,
  AttendanceConfigFilter,
  EmployeeReportResult,
  EmployeeReportSearchFilter,
  TimeInFormData,
} from '@/types/attendance.types';

const baseRoute = '/Attendance';

// Get attendance records for an employee
export async function getAttendanceReport(
  userId: string,
  params: {
    dateFrom?: string;
    dateTo?: string;
    pageIndex?: number;
    pageSize?: number;
  }
) {
  const response = await httpClient.get<{
    statusCode: number;
    message: string;
    result: AttendanceResponse;
  }>(`${baseRoute}/GetAttendance/${userId}`, { params });
  return response.data;
}

// Add attendance record
export async function addAttendanceReport(userId: string, payload: TimeInFormData) {
  // CRITICAL: .NET expects PascalCase properties
  const response = await httpClient.post<{
    statusCode: number;
    message: string;
    result: unknown;
  }>(`${baseRoute}/AddAttendance/${userId}`, {
    Date: payload.date,
    StartTime: payload.startTime,
    EndTime: payload.endTime,
    Location: payload.location,
    Note: payload.note,
    Reason: payload.reason,
  });
  return response.data;
}

// Update attendance record
export async function updateAttendanceReport(userId: string, id: number, payload: TimeInFormData) {
  // CRITICAL: .NET expects PascalCase properties
  const response = await httpClient.put<{
    statusCode: number;
    message: string;
    result: unknown;
  }>(`${baseRoute}/UpdateAttendance/${userId}/${id}`, {
    Date: payload.date,
    StartTime: payload.startTime,
    EndTime: payload.endTime,
    Location: payload.location,
    Note: payload.note,
    Reason: payload.reason,
  });
  return response.data;
}

// Get attendance configuration list
export async function getAllAttendanceConfig(
  startIndex: number,
  pageSize: number,
  filters: AttendanceConfigFilter
) {
  // CRITICAL: .NET expects PascalCase properties
  const response = await httpClient.post<{
    statusCode: number;
    message: string;
    result: AttendanceConfig;
  }>(`${baseRoute}/GetAttendanceConfigList`, {
    StartIndex: startIndex,
    PageSize: pageSize,
    Filters: {
      EmployeeName: filters.employeeName,
      EmployeeId: filters.employeeId,
      EmployeeCode: filters.employeeCode,
    },
  });
  return response.data;
}

// Update attendance configuration (toggle manual attendance)
export async function updateAttendanceConfig(employeeId: number) {
  const response = await httpClient.put<{
    statusCode: number;
    message: string;
    result: unknown;
  }>(`${baseRoute}/UpdateConfig`, null, {
    params: { employeeId },
  });
  return response.data;
}

// Get employee attendance report
export async function getAllEmployeeReport(
  startIndex: number,
  pageSize: number,
  filters: EmployeeReportSearchFilter
) {
  // CRITICAL: .NET expects PascalCase properties
  const response = await httpClient.post<{
    statusCode: number;
    message: string;
    result: EmployeeReportResult;
  }>(`${baseRoute}/GetEmployeeReport`, {
    StartIndex: startIndex,
    PageSize: pageSize,
    Filters: {
      EmployeeCode: filters.employeeCode,
      DateFrom: filters.dateFrom,
      DateTo: filters.dateTo,
      BranchId: filters.branchId,
      DepartmentId: filters.departmentId,
    },
  });
  return response.data;
}

// Export employee report to Excel
export async function exportEmployeeReport(
  startIndex: number,
  pageSize: number,
  filters: EmployeeReportSearchFilter
) {
  // CRITICAL: responseType 'blob' for file downloads
  const response = await httpClient.post(
    `${baseRoute}/ExportEmployeeReportExcel`,
    {
      StartIndex: startIndex,
      PageSize: pageSize,
      Filters: {
        EmployeeCode: filters.employeeCode,
        DateFrom: filters.dateFrom,
        DateTo: filters.dateTo,
        BranchId: filters.branchId,
        DepartmentId: filters.departmentId,
      },
    },
    {
      responseType: 'blob',
    }
  );
  return response.data as Blob;
}

// Get employee code and name list for search
export async function getEmployeeCodeAndNameList(
  employeeCode?: string,
  employeeName?: string,
  exEmployee?: boolean
) {
  const response = await httpClient.get<{
    statusCode: number;
    message: string;
    result: Array<{ id: string; name: string }>;
  }>(`${baseRoute}/GetEmployeeCodeAndNameList`, {
    params: { employeeCode, employeeName, exEmployee },
  });
  return response.data;
}
