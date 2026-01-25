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
