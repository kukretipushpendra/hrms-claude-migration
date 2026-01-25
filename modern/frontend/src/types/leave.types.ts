/**
 * Leave Management TypeScript Types
 * Generated from API contracts in /migration/api-contracts/leave-management/
 */

// Leave Balance Types
export interface EmployeeLeaveBalance {
  employeeId: number;
  casualLeave: number;
  sickLeave: number;
  earnedLeave: number;
  compOff: number;
  totalLeaves: number;
}

export interface LeaveBalanceItem {
  leaveId: number;
  title: string;
  closingBalance: number;
  openingBalance: number;
  creditedBalance: number;
  leavesTaken: number;
}

export interface GetLeaveBalancesResponse {
  data: LeaveBalanceItem[];
}

// Leave Application Types
export interface EmployeeLeaveApplyRequest {
  EmployeeId: number;
  LeaveTypeId: number;
  FromDate: string;
  ToDate: string;
  Reason: string;
  IsHalfDay?: boolean;
}

export interface CrudResult {
  isSuccess: boolean;
  message: string;
}

// Leave History Types
export interface LeaveHistoryFilter {
  startDate?: string | null;
  endDate?: string | null;
  leaveType?: number | null;
}

export interface LeaveHistoryItem {
  appliedLeaveId: number;
  leaveType: string;
  fromDate: string;
  toDate: string;
  totalDays: number;
  status: string;
  appliedDate: string;
  reason: string;
}

export interface LeaveHistoryResponse {
  leaveHistory: LeaveHistoryItem[];
  totalRecords: number;
}

// Applied Leaves Types (for manager approval)
export interface AppliedLeaveSearchRequest {
  employeeId?: number;
  leaveType?: string;
  status?: string;
  fromDate?: string;
  toDate?: string;
}

export interface AppliedLeaveItem {
  appliedLeaveId: number;
  employeeId: number;
  employeeName: string;
  leaveType: string;
  fromDate: string;
  toDate: string;
  totalDays: number;
  status: string;
  reason: string;
}

export interface AppliedLeavesResponse {
  appliedLeavesList: AppliedLeaveItem[];
  totalRecords: number;
}

// Leave Approval Types
export interface LeaveApprovalDto {
  AppliedLeaveId: number;
  Status: 'Approved' | 'Rejected';
  Remarks?: string;
}

// Employee Leave Update Types
export interface EmployeeLeaveRequest {
  EmployeeId: number;
  CasualLeave: number;
  SickLeave: number;
  EarnedLeave: number;
  CompOff: number;
}

// Leave Stats for Apply Leave form
export interface LeaveStats {
  openingBalance: number;
  creditedBalance: number;
  leavesTaken: number;
  closingBalance: number;
}

// Search Request DTO wrapper (used by .NET backend)
export interface SearchRequestDto<T> {
  StartIndex: number;
  PageSize: number;
  SortColumnName?: string;
  SortDirection?: string;
  Filters?: T;
}

// Leave Status Enum
export enum LeaveStatus {
  Pending = 0,
  Approved = 1,
  Rejected = 2,
}

// Day Slot Enum (for half-day leaves)
export enum DaySlot {
  FullDay = 0,
  FirstHalf = 1,
  SecondHalf = 2,
}

export const DAY_SLOT_LABELS: Record<DaySlot, string> = {
  [DaySlot.FullDay]: 'Full Day',
  [DaySlot.FirstHalf]: 'First Half',
  [DaySlot.SecondHalf]: 'Second Half',
};
