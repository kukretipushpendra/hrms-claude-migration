/**
 * Leave Management Service
 * API calls to .NET backend for leave-related operations
 */

import httpClient from '@/services/api/http-client';
import type {
  EmployeeLeaveBalance,
  EmployeeLeaveApplyRequest,
  CrudResult,
  LeaveHistoryResponse,
  AppliedLeavesResponse,
  LeaveApprovalDto,
  EmployeeLeaveRequest,
  GetLeaveBalancesResponse,
  SearchRequestDto,
  LeaveHistoryFilter,
  AppliedLeaveSearchRequest,
} from '@/types/leave.types';

const BASE_ROUTE_LEAVE_MGMT = '/LeaveManagement';
const BASE_ROUTE_EMPLOYEE_LEAVE = '/EmployeeLeave';

/**
 * Get employee leave balance by ID
 */
export async function getEmployeeLeaveById(
  employeeId: number
): Promise<{ statusCode: number; message: string; data: EmployeeLeaveBalance }> {
  const response = await httpClient.get(
    `${BASE_ROUTE_LEAVE_MGMT}/GetEmployeeLeaveById/${employeeId}`
  );
  return response.data;
}

/**
 * Get employee leave balances (for the leave type cards)
 */
export async function getLeaveBalances(
  employeeId: number
): Promise<{ statusCode: number; message: string; result: GetLeaveBalancesResponse }> {
  const response = await httpClient.get(
    `${BASE_ROUTE_LEAVE_MGMT}/GetEmployeeLeaveBalanceById/${employeeId}`
  );
  return response.data;
}

/**
 * Apply for leave
 */
export async function applyLeave(
  payload: EmployeeLeaveApplyRequest
): Promise<{ statusCode: number; message: string; data: CrudResult }> {
  const response = await httpClient.post(`${BASE_ROUTE_EMPLOYEE_LEAVE}/ApplyLeave`, payload);
  return response.data;
}

/**
 * Get leave history by employee ID with pagination and filters
 */
export async function getLeaveHistory(
  employeeId: number,
  searchRequest: SearchRequestDto<LeaveHistoryFilter>
): Promise<{ statusCode: number; message: string; result: LeaveHistoryResponse }> {
  const response = await httpClient.post(
    `${BASE_ROUTE_EMPLOYEE_LEAVE}/GetLeaveHistoryByEmployeeId/${employeeId}`,
    searchRequest
  );
  return response.data;
}

/**
 * Get applied leaves (for manager approval) with pagination and filters
 */
export async function getAppliedLeaves(
  searchRequest: SearchRequestDto<AppliedLeaveSearchRequest>
): Promise<{ statusCode: number; message: string; data: AppliedLeavesResponse }> {
  const response = await httpClient.post(
    `${BASE_ROUTE_LEAVE_MGMT}/GetAppliedLeaves`,
    searchRequest
  );
  return response.data;
}

/**
 * Approve or reject a leave request
 */
export async function approveOrRejectLeave(
  payload: LeaveApprovalDto
): Promise<{ statusCode: number; message: string; data: CrudResult }> {
  const response = await httpClient.post(`${BASE_ROUTE_LEAVE_MGMT}/ApproveOrRejectLeave`, payload);
  return response.data;
}

/**
 * Update employee leave balance
 */
export async function updateLeaves(
  payload: EmployeeLeaveRequest
): Promise<{ statusCode: number; message: string; data: CrudResult }> {
  const response = await httpClient.post(`${BASE_ROUTE_LEAVE_MGMT}/UpdateLeaves`, payload);
  return response.data;
}

/**
 * Get employee leave balance details by leave type
 */
export async function getEmployeeLeaveBalanceByType(employeeId: number, leaveTypeId: number) {
  const response = await httpClient.post(
    `${BASE_ROUTE_EMPLOYEE_LEAVE}/GetEmployeeLeaveBalanceByType`,
    {
      EmployeeId: employeeId,
      LeaveTypeId: leaveTypeId,
    }
  );
  return response.data;
}
