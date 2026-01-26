// Exit Management Types for Vue.js Migration
// Matches .NET API contract exactly

// ============================================================================
// ENUMS (using const object pattern as per Vue.js best practices)
// ============================================================================

export const ResignationStatus = {
  pending: 1,
  revoked: 2,
  accepted: 3,
  cancelled: 4,
  completed: 5,
} as const;

export type ResignationStatusType = (typeof ResignationStatus)[keyof typeof ResignationStatus];

export const JobTypes = {
  probation: 1,
  confirmed: 2,
  training: 3,
} as const;

export type JobType = (typeof JobTypes)[keyof typeof JobTypes];

export const EarlyReleaseStatus = {
  pending: 1,
  accepted: 2,
  rejected: 3,
} as const;

export type EarlyReleaseStatusType = (typeof EarlyReleaseStatus)[keyof typeof EarlyReleaseStatus];

export const AssetCondition = {
  ok: 1,
  damage: 2,
  missing: 3,
} as const;

export type AssetConditionType = (typeof AssetCondition)[keyof typeof AssetCondition];

export const KTStatus = {
  pending: 1,
  inProgress: 2,
  completed: 3,
} as const;

export type KTStatusType = (typeof KTStatus)[keyof typeof KTStatus];

export const EmployeeStatus = {
  active: 1,
  fnfPending: 2,
  onNotice: 3,
  exEmployee: 4,
} as const;

export type EmployeeStatusType = (typeof EmployeeStatus)[keyof typeof EmployeeStatus];

export const EmploymentStatus = {
  fullTime: 1,
  partTime: 2,
  probation: 3,
  internship: 4,
} as const;

export type EmploymentStatusType = (typeof EmploymentStatus)[keyof typeof EmploymentStatus];

// ============================================================================
// EMPLOYEE EXIT TYPES
// ============================================================================

export interface ResignationFormData {
  id: number;
  employeeName: string;
  departmentId: number;
  department: string;
  reportingManagerId: number;
  reportingManagerName: string;
  jobType: JobType;
  status?: ResignationStatusType;
}

export interface AddResignationRequest {
  employeeId: number;
  departmentId: number;
  reason: string;
  reportingManagerId: number;
  jobType: JobType;
}

export interface ResignationExitDetails {
  id: number;
  employeeId: number;
  employeeName: string;
  reason: string;
  department: string;
  reportingManager: string;
  lastWorkingDay: string; // YYYY-MM-DD
  isActive: boolean;
  status: ResignationStatusType;
  earlyReleaseDate: string | null;
  earlyReleaseStatus: EarlyReleaseStatusType;
  rejectResignationReason: string;
  rejectEarlyReleaseReason: string;
  resignationDate: string; // YYYY-MM-DD
}

export interface RequestEarlyReleaseRequest {
  resignationId: number;
  earlyReleaseDate: string; // YYYY-MM-DD
}

export interface ResignationActiveStatusResult {
  resignationId: number;
  resignationStatus: ResignationStatusType;
}

// ============================================================================
// ADMIN EXIT TYPES
// ============================================================================

export interface ExitEmployeeListItem {
  resignationId: number;
  employeeCode: string;
  employeeName: string;
  fnFStatus: boolean;
  departmentName: string;
  resignationDate: string;
  lastWorkingDay: string;
  earlyReleaseDate: string | null;
  resignationStatus: ResignationStatusType;
  employeeStatus: EmployeeStatusType;
  employmentStatus: EmploymentStatusType;
  ktStatus: KTStatusType;
  exitInterviewStatus: boolean;
  earlyReleaseStatus: EarlyReleaseStatusType;
  itNoDue: boolean;
  jobType: number;
  accountsNoDue: boolean;
  reportingManagerName: string;
  rejectEarlyReleaseReason: string;
  rejectResignationReason: string;
  reason: string;
  branchId: number | null;
}

export interface ExitEmployeeSearchFilter {
  employeeCode?: string;
  employeeName?: string | null;
  resignationStatus?: ResignationStatusType | null;
  branchId?: number | null;
  departmentId?: number | null;
  itNoDue?: boolean | null;
  accountsNoDue?: boolean | null;
  lastWorkingDayFrom?: string | null;
  lastWorkingDayTo?: string | null;
  resignationDate?: string | null;
  employeeStatus?: EmployeeStatusType | null;
}

export interface GetResignationListRequest {
  sortColumnName: string;
  sortDirection: string;
  startIndex: number;
  pageSize: number;
  filters: ExitEmployeeSearchFilter;
}

export interface GetResignationListResponse {
  exitEmployeeList: ExitEmployeeListItem[];
  totalRecords: number;
}

export interface AdminRejectionRequest {
  resignationId: number;
  employeeId: number;
  rejectionType: 'Resignation' | 'EarlyRelease';
  rejectReason?: string | null;
}

export interface AcceptEarlyReleaseRequest {
  resignationId: number;
  earlyReleaseDate: string; // YYYY-MM-DD
}

export interface UpdateLastWorkingDayRequest {
  resignationId: number;
  lastWorkingDay: string; // YYYY-MM-DD
}

// ============================================================================
// CLEARANCE TYPES
// ============================================================================

// IT Clearance
export interface ITClearanceDetails {
  resignationId: number;
  accessRevoked: boolean;
  assetReturned: boolean;
  assetCondition: AssetConditionType;
  attachmentUrl: string;
  note: string;
  itClearanceCertification: boolean;
}

export interface UpsertITClearanceRequest {
  employeeId: number;
  resignationId: number;
  accessRevoked: boolean;
  assetReturned: boolean;
  assetCondition: AssetConditionType;
  attachmentUrl: File | string | null;
  note: string;
  itClearanceCertification: boolean;
}

// HR Clearance
export interface HRClearanceDetails {
  resignationId: number;
  advanceBonusRecoveryAmount: number;
  serviceAgreementDetails: string;
  currentEL: number;
  numberOfBuyOutDays: number;
  attachment: string;
  exitInterviewStatus: boolean;
  exitInterviewDetails: string;
}

export interface UpsertHRClearanceRequest {
  employeeId: number;
  resignationId: number;
  advanceBonusRecoveryAmount: number;
  serviceAgreementDetails: string;
  currentEL: number;
  numberOfBuyOutDays: number;
  attachment: File | string | null;
  exitInterviewStatus: boolean;
  exitInterviewDetails: string;
}

// Department Clearance
export interface DepartmentClearanceDetails {
  resignationId: number;
  ktStatus: KTStatusType;
  ktNotes: string;
  attachment: string;
  ktUsers: number[];
}

export interface UpsertDepartmentClearanceRequest {
  employeeId: number;
  resignationId: number;
  ktStatus: KTStatusType;
  ktNotes: string;
  attachment: File | string | null;
  ktUsers: number[];
}

// Account Clearance
export interface AccountClearanceDetails {
  resignationId: number;
  fnFStatus: boolean;
  fnFAmount: number | null;
  issueNoDueCertificate: boolean;
  note: string;
  accountAttachment: string | null;
}

export interface UpsertAccountClearanceRequest {
  employeeId: number;
  resignationId: number;
  fnFStatus: boolean;
  fnFAmount: number | null;
  issueNoDueCertificate: boolean;
  note: string;
  accountAttachment: File | string | null;
}

// ============================================================================
// API RESPONSE TYPES
// ============================================================================

export interface ApiResponse<T> {
  statusCode: number;
  message: string;
  result: T | null;
}

// ============================================================================
// CONSTANTS
// ============================================================================

// Notice period configuration by job type
export const NOTICE_PERIOD_CONFIG: Record<JobType, { amount: number; unit: 'days' | 'months' }> = {
  [JobTypes.probation]: { amount: 15, unit: 'days' },
  [JobTypes.confirmed]: { amount: 3, unit: 'months' },
  [JobTypes.training]: { amount: 15, unit: 'days' },
};

// Resignation status labels
export const RESIGNATION_STATUS_LABELS: Record<ResignationStatusType, string> = {
  [ResignationStatus.pending]: 'Pending',
  [ResignationStatus.revoked]: 'Revoked',
  [ResignationStatus.accepted]: 'Accepted',
  [ResignationStatus.cancelled]: 'Cancelled',
  [ResignationStatus.completed]: 'Completed',
};

// Early release status labels
export const EARLY_RELEASE_STATUS_LABELS: Record<EarlyReleaseStatusType, string> = {
  [EarlyReleaseStatus.pending]: 'Pending',
  [EarlyReleaseStatus.accepted]: 'Accepted',
  [EarlyReleaseStatus.rejected]: 'Rejected',
};

// Asset condition labels
export const ASSET_CONDITION_LABELS: Record<AssetConditionType, string> = {
  [AssetCondition.ok]: 'Good',
  [AssetCondition.damage]: 'Damaged',
  [AssetCondition.missing]: 'Faulty',
};

// KT status labels
export const KT_STATUS_LABELS: Record<KTStatusType, string> = {
  [KTStatus.pending]: 'Pending',
  [KTStatus.inProgress]: 'In Progress',
  [KTStatus.completed]: 'Completed',
};
