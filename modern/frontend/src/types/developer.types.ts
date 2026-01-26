// Log Level
export const LogLevel = {
  Warning: 'Warning',
  Error: 'Error',
} as const;

export type LogLevelType = (typeof LogLevel)[keyof typeof LogLevel];

// Cron Types
export const CronType = {
  FetchTimeDoctorTimeSheetStats: 1,
  MonthlyLeaveCredit: 2,
} as const;

export type CronTypeValue = (typeof CronType)[keyof typeof CronType];

export const CRON_TYPE_LABEL: Record<CronTypeValue, string> = {
  [CronType.FetchTimeDoctorTimeSheetStats]: 'Timedoctor timesheet stats',
  [CronType.MonthlyLeaveCredit]: 'Monthly leave credit',
};

// Interfaces
export interface DeveloperLog {
  id: number;
  message: string;
  logLevel: LogLevelType;
  timestamp: string;
  requestId: string;
  logEvent: string;
  exception: string;
}

export interface CronTypeOption {
  id: CronTypeValue;
  name: string;
}

export interface CronLog {
  id: number;
  cronId: CronTypeValue;
  cronName: string;
  logId: number;
  payload: string;
  startedAt: string;
  completedAt: string;
  status: string;
}

// Request DTOs
export interface DeveloperLogsFilter {
  message?: string;
  requestId?: string;
  logLevel?: LogLevelType | null;
  fromDate?: string | null;
  toDate?: string | null;
}

export interface DeveloperLogsPaginationRequest {
  searchValue?: string;
  pageNumber: number;
  pageSize: number;
  sortColumn?: string;
  sortDirection?: 'asc' | 'desc';
  filter: DeveloperLogsFilter;
}

export interface CronLogsFilter {
  cronId?: CronTypeValue | null;
  fromDate?: string | null;
  toDate?: string | null;
}

export interface CronLogsPaginationRequest {
  searchValue?: string;
  pageNumber: number;
  pageSize: number;
  sortColumn?: string;
  sortDirection?: 'asc' | 'desc';
  filter: CronLogsFilter;
}

export interface RunCronRequest {
  cronId: CronTypeValue;
  payload?: Record<string, unknown>;
}

// Response DTOs
export interface DeveloperLogsResponse {
  totalRecords: number;
  logs: DeveloperLog[];
}

export interface CronLogsResponse {
  totalRecords: number;
  cronLogs: CronLog[];
}

export interface RunCronResponse {
  executionId: number;
  status: string;
}

// Date range preset type
export type DateRangePreset =
  | 'last-15-min'
  | 'last-1-hour'
  | 'today'
  | 'yesterday'
  | 'last-7-days'
  | 'custom';

export interface DateRangePresetOption {
  value: DateRangePreset;
  label: string;
}
