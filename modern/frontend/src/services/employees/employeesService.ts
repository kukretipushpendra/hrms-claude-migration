import httpClient from '@/services/api/http-client';
import type {
  GetEmployeeListArgs,
  GetEmployeeListResponse,
  GetDepartmentListResponse,
  GetDesignationListResponse,
  GetStatusListResponse,
  GetTeamListResponse,
  ExportEmployeesDataArgs,
  ImportEmployeesDataResponse,
  GetEmployeeDetailResponse,
  EmployeeSearchFilter,
  EmployeeSearchFilterRequest,
  CreateEmployeeRequest,
  UpdateEmployeeRequest,
  CreateOrUpdateEmployeeResponse,
  GetLatestEmployeeCodeResponse,
  GetBranchListResponse,
  GetReportingManagerListResponse,
} from './types';

const baseRoute = '/Employee';
const userProfileRoute = '/UserProfile';

/**
 * Transform camelCase filters to PascalCase for .NET API
 */
export function transformFiltersToRequest(
  filters: EmployeeSearchFilter
): EmployeeSearchFilterRequest {
  return {
    EmployeeCode: filters.employeeCode,
    EmployeeName: filters.employeeName,
    DepartmentId: filters.departmentId,
    DesignationId: filters.designationId,
    RoleId: filters.roleId,
    EmployeeStatus: filters.employeeStatus,
    EmploymentStatus: filters.employmentStatus,
    BranchId: filters.branchId,
    DOJFrom: filters.dojFrom,
    DOJTo: filters.dojTo,
    CountryId: filters.countryId,
  };
}

/**
 * Get paginated employee list with filters
 * POST /Employee/GetEmployees
 * Permission: Read.Employees
 */
export async function getEmployeeList(args: GetEmployeeListArgs) {
  const response = await httpClient.post<GetEmployeeListResponse>(
    `${baseRoute}/GetEmployees`,
    args
  );
  return response.data;
}

/**
 * Get employee details by ID
 * GET /Employee/{id}
 * Permission: Read.Employees
 */
export async function getEmployeeById(id: number) {
  const response = await httpClient.get<GetEmployeeDetailResponse>(`${baseRoute}/${id}`);
  return response.data;
}

/**
 * Get department list for filters
 * GET /Employee/GetDepartmentList
 */
export async function getDepartmentList() {
  const response = await httpClient.get<GetDepartmentListResponse>(
    `${baseRoute}/GetDepartmentList`
  );
  return response.data;
}

/**
 * Get designation list for filters
 * GET /UserProfile/GetDesignationList
 */
export async function getDesignationList() {
  const response = await httpClient.get<GetDesignationListResponse>(
    `/UserProfile/GetDesignationList`
  );
  return response.data;
}

/**
 * Get status list for filters
 * GET /Employee/GetStatusList
 */
export async function getStatusList() {
  const response = await httpClient.get<GetStatusListResponse>(`${baseRoute}/GetStatusList`);
  return response.data;
}

/**
 * Get team list
 * GET /Employee/GetTeamList
 */
export async function getTeamList() {
  const response = await httpClient.get<GetTeamListResponse>(`${baseRoute}/GetTeamList`);
  return response.data;
}

/**
 * Export employee list to Excel
 * POST /Employee/export
 * Permission: View.Employees
 */
export async function exportEmployeesData(args: ExportEmployeesDataArgs) {
  const response = await httpClient.post(`${baseRoute}/export`, args, {
    responseType: 'blob',
  });
  return response.data as Blob;
}

/**
 * Import employees from Excel file
 * POST /Employee/ImportExcel
 * Permission: Create.Employees
 */
export async function importEmployeesData(file: File, importConfirmed: boolean) {
  const formData = new FormData();
  formData.append('excefile', file);

  const response = await httpClient.post<ImportEmployeesDataResponse>(
    `${baseRoute}/ImportExcel?importConfirmed=${importConfirmed}`,
    formData,
    {
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    }
  );
  return response.data;
}

/**
 * Get latest employee code (auto-increment)
 * GET /UserProfile/GetLatestEmployeeCode
 */
export async function getLatestEmployeeCode() {
  const response = await httpClient.get<GetLatestEmployeeCodeResponse>(
    `${userProfileRoute}/GetLatestEmployeeCode`
  );
  return response.data;
}

/**
 * Get branch list for dropdown
 * GET /UserProfile/GetBranchList
 */
export async function getBranchList() {
  const response = await httpClient.get<GetBranchListResponse>(
    `${userProfileRoute}/GetBranchList`
  );
  return response.data;
}

/**
 * Get reporting manager list for dropdown
 * GET /UserProfile/GetReportingManagerList
 */
export async function getReportingManagerList() {
  const response = await httpClient.get<GetReportingManagerListResponse>(
    `${userProfileRoute}/GetReportingManagerList`
  );
  return response.data;
}

/**
 * Create new employee
 * POST /UserProfile/AddEmploymentDetail
 * Permission: Create.Employees
 */
export async function createEmployee(data: CreateEmployeeRequest) {
  const response = await httpClient.post<CreateOrUpdateEmployeeResponse>(
    `${userProfileRoute}/AddEmploymentDetail`,
    data
  );
  return response.data;
}

/**
 * Update existing employee
 * POST /UserProfile/UpdateEmploymentDetail
 * Permission: Edit.Employees
 */
export async function updateEmployee(data: UpdateEmployeeRequest) {
  const response = await httpClient.post<CreateOrUpdateEmployeeResponse>(
    `${userProfileRoute}/UpdateEmploymentDetail`,
    data
  );
  return response.data;
}

