export interface EmployeeType {
  slNo: number;
  id: number;
  employeeCode: string;
  employeeName: string;
  fatherName: string;
  gender: number;
  dob: string;
  email: string;
  address: string;
  permanantAddress: string | null;
  cityName: string;
  stateName: string;
  pinCode: string;
  emergencyContactNo: string;
  joiningDate: string;
  confirmationDate: string;
  jobType: number;
  branch: number;
  pfNumber: string;
  pfDate: string;
  bankName: string;
  accountNo: string;
  panNumber: string;
  esiNo: string;
  departmentName: string;
  designation: string;
  reportingManagerName: string;
  passportNo: string;
  passportExpiry: string;
  alternatePhone: string;
  phone: string;
  personalEmail: string;
  bloodGroup: string;
  maritalStatus: number;
  uanNo: string;
  hasPF: boolean;
  hasESI: boolean;
  adharNumber: number;
  employeeStatus: number;
}

// Filter interface for internal use (camelCase)
export interface EmployeeSearchFilter {
  employeeCode?: string;
  employeeName?: string;
  departmentId: number;
  designationId: number;
  roleId: number;
  employeeStatus: number;
  employmentStatus: number;
  branchId: number;
  dojFrom: string | null;
  dojTo: string | null;
  countryId: number;
}

// Filter interface for API request (PascalCase for .NET)
export interface EmployeeSearchFilterRequest {
  EmployeeCode?: string;
  EmployeeName?: string;
  DepartmentId: number;
  DesignationId: number;
  RoleId: number;
  EmployeeStatus: number;
  EmploymentStatus: number;
  BranchId: number;
  DOJFrom: string | null;
  DOJTo: string | null;
  CountryId: number;
}

export interface GetEmployeeListResponse {
  statusCode: number;
  message: string;
  modelErrors: string[];
  result: {
    employeeList: EmployeeType[];
    totalRecords: number;
  };
}

export interface GetEmployeeListArgs {
  SortColumnName: string;
  SortDirection: string;
  StartIndex: number;
  PageSize: number;
  Filters: EmployeeSearchFilterRequest;
}

export interface DepartmentType {
  id: number;
  name: string;
}

export interface GetDepartmentListResponse {
  statusCode: number;
  message: string;
  modelErrors: string[];
  result: DepartmentType[];
}

export interface DesignationType {
  id: number;
  name: string;
}

export interface GetDesignationListResponse {
  statusCode: number;
  message: string;
  modelErrors: string[];
  result: DesignationType[];
}

export interface StatusType {
  id: number;
  name: string;
}

export interface GetStatusListResponse {
  statusCode: number;
  message: string;
  modelErrors: string[];
  result: StatusType[];
}

export interface TeamType {
  id: number;
  name: string;
}

export interface GetTeamListResponse {
  statusCode: number;
  message: string;
  modelErrors: string[];
  result: TeamType[];
}

export interface ExportEmployeesDataArgs {
  SortColumnName: string;
  SortDirection: string;
  StartIndex: number;
  PageSize: number;
  Filters: EmployeeSearchFilterRequest;
}

export interface ImportEmployeesDataResponse {
  statusCode: number;
  message: string;
  result: number;
}

export interface GetEmployeeDetailResponse {
  statusCode: number;
  message: string;
  modelErrors: string[];
  result: EmployeeType;
}

// =============================================================================
// Employee Create/Update Types
// =============================================================================

export interface CreateEmployeeRequest {
  firstName: string;
  middleName?: string;
  lastName: string;
  employeeCode: string;
  email: string;
  joiningDate: string; // YYYY-MM-DD format
  branchId: number;
  teamId: number;
  designationId: number;
  reportingManagerId: number;
  employmentStatus: number;
  backgroundVerificationstatus: number;
  criminalVerification: boolean;
  departmentId: number;
  totalExperienceYear: number;
  totalExperienceMonth: number;
  relevantExperienceYear: number;
  relevantExperienceMonth: number;
  jobType: number;
  probationMonths: number;
  timeDoctorUserId: string | null;
}

export interface UpdateEmployeeRequest {
  id: number;
  employeeId: number;
  employeeCode: string;
  email: string;
  joiningDate: string | null; // YYYY-MM-DD format
  branchId: number;
  teamId: number;
  designationId: number;
  reportingManagerId: number | null;
  employmentStatus: number | null;
  linkedInUrl: string;
  backgroundVerificationstatus: number | null;
  criminalVerification: boolean | null;
  departmentId: number;
  totalExperienceYear: number;
  totalExperienceMonth: number;
  relevantExperienceYear: number;
  relevantExperienceMonth: number;
  jobType: number | null;
  isProbExtended: boolean;
  probationMonths: number;
  timeDoctorUserId: string | null;
}

export interface CreateOrUpdateEmployeeResponse {
  statusCode: number;
  message: string;
  modelErrors: string[];
  result: any;
}

export interface GetLatestEmployeeCodeResponse {
  statusCode: number;
  message: string;
  modelErrors: string[];
  result: string; // Latest employee code
}

// Branch Type
export interface BranchType {
  id: number;
  name: string;
  countryId?: number;
}

export interface GetBranchListResponse {
  statusCode: number;
  message: string;
  modelErrors: string[];
  result: BranchType[];
}

// Reporting Manager Type
export interface ReportingManagerType {
  id: number;
  employeeCode: string;
  employeeName: string;
  designation?: string;
}

export interface GetReportingManagerListResponse {
  statusCode: number;
  message: string;
  modelErrors: string[];
  result: ReportingManagerType[];
}

// Employment Status Options (matching .NET enum)
export const EMPLOYMENT_STATUS = {
  PERMANENT: 1,
  CONTRACT: 2,
  INTERNSHIP: 3,
  PROBATION: 4,
} as const;

export const EMPLOYMENT_STATUS_OPTIONS = [
  { id: EMPLOYMENT_STATUS.PERMANENT, label: 'Permanent' },
  { id: EMPLOYMENT_STATUS.CONTRACT, label: 'Contract' },
  { id: EMPLOYMENT_STATUS.INTERNSHIP, label: 'Internship' },
  { id: EMPLOYMENT_STATUS.PROBATION, label: 'Probation' },
];

// Job Type Options (matching legacy)
export const JOB_TYPE = {
  FULL_TIME: 1,
  PART_TIME: 2,
  FREELANCE: 3,
} as const;

export const JOB_TYPE_OPTIONS = [
  { id: JOB_TYPE.FULL_TIME, label: 'Full Time' },
  { id: JOB_TYPE.PART_TIME, label: 'Part Time' },
  { id: JOB_TYPE.FREELANCE, label: 'Freelance' },
];

// Background Verification Status
export const BACKGROUND_VERIFICATION_STATUS = {
  PENDING: 1,
  IN_PROGRESS: 2,
  COMPLETED: 3,
  FAILED: 4,
} as const;

export const BACKGROUND_VERIFICATION_OPTIONS = [
  { id: BACKGROUND_VERIFICATION_STATUS.PENDING, label: 'Pending' },
  { id: BACKGROUND_VERIFICATION_STATUS.IN_PROGRESS, label: 'In Progress' },
  { id: BACKGROUND_VERIFICATION_STATUS.COMPLETED, label: 'Completed' },
  { id: BACKGROUND_VERIFICATION_STATUS.FAILED, label: 'Failed' },
];

// Criminal Verification Status
export const CRIMINAL_VERIFICATION_STATUS = {
  PENDING: 'Pending',
  COMPLETED: 'Completed',
  NOT_APPLICABLE: 'Not Applicable',
} as const;

export const CRIMINAL_VERIFICATION_OPTIONS = [
  { id: CRIMINAL_VERIFICATION_STATUS.PENDING, label: 'Pending' },
  { id: CRIMINAL_VERIFICATION_STATUS.COMPLETED, label: 'Completed' },
  { id: CRIMINAL_VERIFICATION_STATUS.NOT_APPLICABLE, label: 'Not Applicable' },
];
