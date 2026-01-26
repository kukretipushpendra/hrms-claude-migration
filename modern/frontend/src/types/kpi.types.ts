// KPI Enums (using const object pattern)
export const KPIStatus = {
  NotCreated: 0,
  Assigned: 1,
  Submitted: 2,
  Reviewed: 3,
} as const;

export type KPIStatusType = (typeof KPIStatus)[keyof typeof KPIStatus];

export const Quarter = {
  Q1: 'Q1',
  Q2: 'Q2',
  Q3: 'Q3',
  Q4: 'Q4',
} as const;

export type QuarterType = (typeof Quarter)[keyof typeof Quarter];

// Goal Rating (per goal in a plan)
export interface GoalRating {
  employeeCode: string;
  employeeId: number;
  planId: number;
  goalId: number;
  goalTitle: string;
  lastAppraisal: string | null;
  nextAppraisal: string | null;
  q1_Rating: number | null;
  q2_Rating: number | null;
  q3_Rating: number | null;
  q4_Rating: number | null;
  q1_Note: string | null;
  q2_Note: string | null;
  q3_Note: string | null;
  q4_Note: string | null;
  managerRating: number | null;
  managerNote: string | null;
  targetExpected: number | null;
  status: null | boolean;
  allowedQuarter: string; // comma-separated quarters
}

// Plan Rating (KPI Plan with goals)
export interface PlanRating {
  planId: number;
  reviewDate: string;
  isReviewed: boolean;
  joiningDate: string;
  lastAppraisal: string;
  nextAppraisal: string;
  goals: GoalRating[];
}

// Employee Self Rating Response
export interface GetEmployeeSelfRatingResponse {
  statusCode: number;
  message: string;
  result: [
    {
      employeeCode: string;
      employeeId: number;
      employeeName: string;
      isReviewed: boolean | null;
      email: string;
      joiningDate: string;
      planId: number;
      reviewDate: string | null;
      lastReviewDate: string | null;
      nextAppraisal: string | null;
      ratings: GoalRating[];
    },
  ];
}

// Goal Data
export interface GoalData {
  title: string;
  description: string;
  departmentId: number;
  employeeId: number;
  goalId: number;
  employeeIds: string; // comma-separated
}

// Goal List Item
export interface GoalList {
  id: string;
  title: string;
  description: string;
  department: string;
  createdOn: Date;
  createdBy: string;
}

// Employee Goal List (Manager Dashboard)
export interface EmployeesGoalList {
  employeeId: number;
  employeeName: string;
  email: string;
  reviewDate: string | null;
  isReviewed: boolean | null;
  joiningDate: string;
  lastReviewDate?: string;
  nextAppraisal?: string;
  planId: number;
  employeeCode: string;
}

// Update Self Rating
export interface UpdateSelfRatingPayload {
  goalId: number;
  planId: number;
  note: string | null;
  quarter: QuarterType;
  rating: number;
}

// Update Manager Rating
export interface UpdateManagerRatingRequest {
  planId: number;
  goalId: number;
  managerRating: number;
  managerNote: string | null;
}

// Assign Goal
export interface AssignGoalByManagerRequest {
  goalId: number;
  employeeId: number;
  allowedQuarter?: string; // comma-separated
  targetExpected?: string;
  planId?: number | null;
}

// Manager Rating History
export interface ManagerRatingHistory {
  managerId: number;
  managerName?: string;
  managerRating?: number;
  managerComment?: string;
  createdOn: string;
}

// Filters
export interface KPIGoalRequestFilter {
  title?: string | null;
  departmentId?: number | null;
  createdOnFrom?: string | null;
  createdOnTo?: string | null;
  createdBy?: string | null;
}

export interface EmployeesGoalListFilter {
  appraisalDateFrom?: string;
  appraisalDateTo?: string;
  reviewDateFrom?: string;
  reviewDateTo?: string;
  employeeCode?: string;
  statusFilter: number | null; // null, 0=Not Created, 1=Assigned, 2=Submitted, 3=Reviewed
}

// Upsert Goal Request
export interface UpsertRequestGoal {
  title: string;
  description: string;
  departmentId: number;
  employeeId: number;
  id: number;
  employeeIds: string;
}

// API Response Types
export interface UpsertGoalResponse {
  statusCode: number;
  message: string;
  result: number;
}

export interface GetGoalByIdResponse {
  statusCode: number;
  message: string;
  result: GoalData;
}

export interface GetGoalListResponse {
  statusCode: number;
  message: string;
  result: {
    totalRecords: number;
    goalList: GoalList[];
  };
}

export interface GetGoalListArgs {
  sortColumnName: string;
  sortDirection: string;
  startIndex: number;
  pageSize: number;
  filters: KPIGoalRequestFilter;
}

export interface DeleteGoalResponse {
  statusCode: number;
  message: string;
  result: number;
}

export interface GetEmployeesGoalResponse {
  statusCode: number;
  message: string;
  result: {
    totalRecords: number;
    goalList: EmployeesGoalList[];
  };
}

export interface GetEmployeesGoalArgs {
  sortColumnName: string;
  sortDirection: string;
  startIndex: number;
  pageSize: number;
  filters: EmployeesGoalListFilter;
}

export interface GetEmployeesByManagerResponse {
  statusCode: number;
  message: string;
  result: {
    id: number;
    email: string;
    firstName: string;
    middleName: string;
    lastName: string;
    employeeCode: string;
  }[];
}

export interface UpdateSelfRatingResponse {
  statusCode: number;
  message: string;
  result: number;
}

export interface UpdateManagerRatingResponse {
  statusCode: number;
  message: string;
  result: number;
}

export interface SubmitKPIPlanResponse {
  statusCode: number;
  message: string;
  result: number;
}

export interface SubmitManagerReviewResponse {
  statusCode: number;
  message: string;
  result: number;
}

export interface AssignGoalByManagerResponse {
  statusCode: number;
  message: string;
  result: number;
}

export interface ManagerRatingHistoryRequest {
  planId: number;
  goalId: number;
}

export interface GetManagerRatingHistoryResponse {
  statusCode: number;
  message: string;
  result: ManagerRatingHistory[];
}

export interface GetEmployeeRatingByManager {
  employeeCode: string;
  employeeName: string;
  joiningDate: string;
  email: string;
  employeeId: number;
  ratings: PlanRating[];
}

export interface GetEmployeeRatingByManagerResponse {
  statusCode: number;
  message: string;
  result: GetEmployeeRatingByManager[];
}

// Cell action type for employee KPI view
export type CellAction = 'view' | 'edit' | 'add';

// Employee autocomplete type
export interface EmployeeOption {
  id: number;
  label: string;
  email: string;
}

// Goal autocomplete type
export interface GoalOption {
  id: number;
  label: string;
  description: string;
}
