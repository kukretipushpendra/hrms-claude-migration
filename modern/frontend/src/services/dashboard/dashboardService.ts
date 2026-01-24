import httpClient from '@/services/api/http-client';
import type {
  ApiResponse,
  EmployeeCount,
  EmployeeBirthday,
  WorkAnniversary,
  HolidayResult,
  UpcomingEvent,
  CompanyPolicyDocument,
  GetEmployeeCountParams,
  GetPublishedCompanyPoliciesParams,
} from './types';

const baseRoute = '/Dashboard';

/**
 * Get employee count statistics (active, new, exited)
 * POST /Dashboard/GetEmployeesCount
 * Requires: ReadEmploymentDetails permission
 */
export async function getEmployeesCount(params: GetEmployeeCountParams) {
  // .NET expects null (not empty string) for DateOnly? when using days filter
  const requestBody = params.days && params.days > 0
    ? { days: params.days, from: null, to: null }
    : { days: 0, from: params.from || null, to: params.to || null };

  const response = await httpClient.post<ApiResponse<EmployeeCount>>(
    `${baseRoute}/GetEmployeesCount`,
    requestBody
  );
  return response.data;
}

/**
 * Get birthday list for current week
 * GET /Dashboard/GetBirthdayList
 * No permission required
 */
export async function getBirthdayList() {
  const response = await httpClient.get<ApiResponse<EmployeeBirthday[]>>(
    `${baseRoute}/GetBirthdayList`
  );
  return response.data;
}

/**
 * Get work anniversary list for current week
 * GET /Dashboard/GetWorkAnniversaryList
 * No permission required
 */
export async function getWorkAnniversaryList() {
  const response = await httpClient.get<ApiResponse<WorkAnniversary[]>>(
    `${baseRoute}/GetWorkAnniversaryList`
  );
  return response.data;
}

/**
 * Get all holidays for US and India
 * GET /Dashboard/GetHolidayList
 * No permission required
 */
export async function getHolidayList() {
  const response = await httpClient.get<ApiResponse<HolidayResult>>(
    `${baseRoute}/GetHolidayList`
  );
  return response.data;
}

/**
 * Get upcoming two holidays for US and India
 * GET /Dashboard/GetUpcomingHolidayList
 * No permission required
 */
export async function getUpcomingHolidayList() {
  const response = await httpClient.get<ApiResponse<HolidayResult>>(
    `${baseRoute}/GetUpcomingHolidayList`
  );
  return response.data;
}

/**
 * Get upcoming three events
 * GET /Dashboard/GetUpcomingEvents
 * Requires: ReadEvents permission
 */
export async function getUpcomingEvents() {
  const response = await httpClient.get<ApiResponse<UpcomingEvent[] | null>>(
    `${baseRoute}/GetUpcomingEvents`
  );
  return response.data;
}

/**
 * Get published company policies
 * POST /Dashboard/GetPublishedCompanyPolicies
 * Requires: ReadCompanyPolicy permission
 */
export async function getPublishedCompanyPolicies(
  params: GetPublishedCompanyPoliciesParams
) {
  // .NET expects null (not empty string) for DateOnly? when using days filter
  const requestParams =
    params.days && params.days > 0
      ? { days: params.days, from: null, to: null }
      : { days: 0, from: params.from || null, to: params.to || null };

  const response = await httpClient.post<
    ApiResponse<CompanyPolicyDocument[] | null>
  >(`${baseRoute}/GetPublishedCompanyPolicies`, requestParams);
  return response.data;
}
