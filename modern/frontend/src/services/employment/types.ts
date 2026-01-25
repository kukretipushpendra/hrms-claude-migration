export interface EmployeeDetailsType {
  id: number;
  employeeId: number;
  employeeCode: string;
  email: string;
  joiningDate: string | null;
  teamId: number;
  teamName: string;
  designation: string;
  designationId: number;
  linkedInUrl: string;
  branchId: number;
  departmentId: number;
  departmentName: string;
  backgroundVerificationstatus: number | null;
  criminalVerification: boolean | null;
  jobType: number | null;
  branch: string;
  employmentStatus: number | null;
  totalExperienceYear: number;
  totalExperienceMonth: number;
  relevantExperienceYear: number;
  relevantExperienceMonth: number;
  confirmationDate: string | null;
  extendedConfirmationDate: string | null;
  isProbExtended: boolean;
  probExtendedWeeks: number;
  isConfirmed: boolean;
  probationMonths: number;
  reportingManagerName: string;
  reportingManagerId: number | null;
  roleId: number;
  isReportingManager: boolean;
  employeeStatus: number | null;
  timeDoctorUserId: string | null;
}

export interface GetEmploymentDetailByIdResponse {
  statusCode: number;
  message: string;
  modelErrors: string[];
  result: EmployeeDetailsType;
}

export interface AddEmploymentDetailArgs {
  firstName: string;
  middleName?: string;
  lastName: string;
  employeeCode: string;
  email: string;
  joiningDate: string;
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

export interface UpdateEmploymentDetailArgs {
  id: number;
  employeeId: number;
  employeeCode: string;
  email: string;
  joiningDate: string | null;
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
  probExtendedWeeks?: number;
  probationMonths: number;
  confirmationDate: string | null;
  extendedConfirmationDate?: string | null;
  roleId: number;
  isReportingManager: boolean;
  employeeStatus: number | null;
  timeDoctorUserId: string | null;
}

export interface AddOrUpdateEmploymentDetailResponse {
  statusCode: number;
  message: string;
  modelErrors: string[];
  result: number;
}

export interface ReportingManagerType {
  id: number;
  email: string;
  firstName: string;
  middleName: string;
  lastName: string;
}

export interface GetReportingManagerListResponse {
  statusCode: number;
  message: string;
  result: ReportingManagerType[];
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

export interface DepartmentType {
  id: number;
  name: string;
}

export interface GetDepartmentListResponse {
  statusCode: number;
  message: string;
  modelErrors: string[];
  result: {
    departmentList: DepartmentType[];
    totalRecords: number;
  };
}

export interface GetDepartmentListArgs {
  SortColumnName: string;
  SortDirection: string;
  StartIndex: number;
  PageSize: number;
  Filters: {
    Name: string;
  };
}

export interface TeamType {
  id: number;
  name: string;
}

export interface GetTeamListResponse {
  statusCode: number;
  message: string;
  modelErrors: string[];
  result: {
    teamList: TeamType[];
    totalRecords: number;
  };
}

export interface GetTeamListArgs {
  SortColumnName: string;
  SortDirection: string;
  StartIndex: number;
  PageSize: number;
  Filters: {
    Name: string;
  };
}

export interface GetLatestEmployeeCodeResponse {
  statusCode: number;
  message: string;
  result: string;
}

export interface RoleType {
  id: number;
  name: string;
}

export interface GetRoleListResponse {
  statusCode: number;
  message: string;
  modelErrors: string[];
  result: RoleType[];
}

// Note: Branch and Employee Status use constants (see views/employment/utils.ts)
// - BRANCH_LOCATION_OPTIONS for branch dropdown
// - EMPLOYEE_STATUS_OPTIONS for employee status dropdown
