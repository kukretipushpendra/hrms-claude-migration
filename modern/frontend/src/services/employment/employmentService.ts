import httpClient from '@/services/api/http-client';
import type {
  GetEmploymentDetailByIdResponse,
  AddEmploymentDetailArgs,
  UpdateEmploymentDetailArgs,
  AddOrUpdateEmploymentDetailResponse,
  GetReportingManagerListResponse,
  GetDesignationListResponse,
  GetDepartmentListResponse,
  GetDepartmentListArgs,
  GetTeamListResponse,
  GetTeamListArgs,
  GetLatestEmployeeCodeResponse,
  GetRoleListResponse,
} from './types';

const baseRoute = '/UserProfile';

/**
 * Get employment detail by employee ID
 * GET /UserProfile/GetEmploymentDetailById?id={id}
 * Permission: Read.EmploymentDetails
 */
export async function getEmploymentDetailById(userId: string | number) {
  const response = await httpClient.get<GetEmploymentDetailByIdResponse>(
    `${baseRoute}/GetEmploymentDetailById?id=${userId}`
  );
  return response.data;
}

/**
 * Add new employment detail
 * POST /UserProfile/AddEmploymentDetail
 * Permission: Create.EmploymentDetails
 */
export async function addEmploymentDetail(args: AddEmploymentDetailArgs) {
  const response = await httpClient.post<AddOrUpdateEmploymentDetailResponse>(
    `${baseRoute}/AddEmploymentDetail`,
    args
  );
  return response.data;
}

/**
 * Update existing employment detail
 * POST /UserProfile/UpdateEmploymentDetail
 * Permission: Edit.EmploymentDetails
 */
export async function updateEmploymentDetail(args: UpdateEmploymentDetailArgs) {
  const response = await httpClient.post<AddOrUpdateEmploymentDetailResponse>(
    `${baseRoute}/UpdateEmploymentDetail`,
    args
  );
  return response.data;
}

/**
 * Get reporting manager list (autocomplete)
 * GET /UserProfile/GetReportingManagerList?name={name}&RoleId={roleId}
 */
export async function getReportingManagerList(params?: { name?: string; roleId?: number }) {
  const response = await httpClient.get<GetReportingManagerListResponse>(
    `${baseRoute}/GetReportingManagerList`,
    { params }
  );
  return response.data;
}

/**
 * Get designation list
 * GET /UserProfile/GetDesignationList
 * Permission: ViewDesignationDetails
 */
export async function getDesignationList() {
  const response = await httpClient.get<GetDesignationListResponse>(
    `${baseRoute}/GetDesignationList`
  );
  return response.data;
}

/**
 * Get departments (paginated)
 * POST /UserProfile/GetDepartments
 * Permission: ViewDepartmentDetails
 */
export async function getDepartments(args: GetDepartmentListArgs) {
  const response = await httpClient.post<GetDepartmentListResponse>(
    `${baseRoute}/GetDepartments`,
    args
  );
  return response.data;
}

/**
 * Get teams (paginated)
 * POST /UserProfile/GetTeams
 * Permission: ViewTeamDetails
 */
export async function getTeams(args: GetTeamListArgs) {
  const response = await httpClient.post<GetTeamListResponse>(`${baseRoute}/GetTeams`, args);
  return response.data;
}

/**
 * Get latest employee code
 * GET /UserProfile/GetLatestEmployeeCode
 */
export async function getLatestEmployeeCode() {
  const response = await httpClient.get<GetLatestEmployeeCodeResponse>(
    `${baseRoute}/GetLatestEmployeeCode`
  );
  return response.data;
}

/**
 * Get role list
 * GET /RolePermission/GetRolesList
 * Note: Uses RolePermission controller, not UserProfile
 */
export async function getRoleList() {
  const response = await httpClient.get<GetRoleListResponse>('/RolePermission/GetRolesList');
  return response.data;
}

// Note: Branch list and Employee Status list use constants (see utils.ts)
// - BRANCH_LOCATION_OPTIONS
// - EMPLOYEE_STATUS_OPTIONS
// These are not fetched from API as per legacy implementation
