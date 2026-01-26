import type { KPIGoalRequestFilter, EmployeesGoalListFilter } from '@/types/kpi.types';

export const DEFAULT_KPI_GOAL_FILTERS: KPIGoalRequestFilter = {
  title: null,
  departmentId: null,
  createdOnFrom: null,
  createdOnTo: null,
  createdBy: null,
};

export const DEFAULT_MANAGER_DASHBOARD_FILTERS: EmployeesGoalListFilter = {
  appraisalDateFrom: undefined,
  appraisalDateTo: undefined,
  reviewDateFrom: undefined,
  reviewDateTo: undefined,
  employeeCode: undefined,
  statusFilter: null,
};

export const QUARTER_OPTIONS = [
  { value: 'Q1', label: 'Q1' },
  { value: 'Q2', label: 'Q2' },
  { value: 'Q3', label: 'Q3' },
  { value: 'Q4', label: 'Q4' },
];

export const KPI_STATUS_OPTIONS = [
  { value: null, label: 'All' },
  { value: 0, label: 'Not Created' },
  { value: 1, label: 'Assigned' },
  { value: 2, label: 'Submitted' },
  { value: 3, label: 'Reviewed' },
];

export const MIN_RATING = 1;
export const MAX_RATING = 10;
