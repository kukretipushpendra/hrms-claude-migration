import httpClient from '../api/http-client';
import type {
  AssignGoalByManagerRequest,
  AssignGoalByManagerResponse,
  DeleteGoalResponse,
  GetEmployeeRatingByManagerResponse,
  GetEmployeesByManagerResponse,
  GetEmployeeSelfRatingResponse,
  GetEmployeesGoalArgs,
  GetEmployeesGoalResponse,
  GetGoalByIdResponse,
  GetGoalListArgs,
  GetGoalListResponse,
  GetManagerRatingHistoryResponse,
  ManagerRatingHistoryRequest,
  SubmitKPIPlanResponse,
  SubmitManagerReviewResponse,
  UpdateManagerRatingRequest,
  UpdateManagerRatingResponse,
  UpdateSelfRatingPayload,
  UpdateSelfRatingResponse,
  UpsertGoalResponse,
  UpsertRequestGoal,
} from '@/types/kpi.types';

const baseRoute = '/KPI';

// Goals Management
export const createGoal = async (data: UpsertRequestGoal): Promise<UpsertGoalResponse> => {
  const response = await httpClient.post(`${baseRoute}/CreateGoal`, data);
  return response.data;
};

export const getGoalById = async (goalId: number): Promise<GetGoalByIdResponse> => {
  const response = await httpClient.get(`${baseRoute}/getGoalById/${goalId}`);
  return response.data;
};

export const updateGoal = async (data: UpsertRequestGoal): Promise<UpsertGoalResponse> => {
  const response = await httpClient.post(`${baseRoute}/UpdateGoal`, data);
  return response.data;
};

export const getGoalList = async (args: GetGoalListArgs): Promise<GetGoalListResponse> => {
  const response = await httpClient.post(`${baseRoute}/GetGoalList`, args);
  return response.data;
};

export const deleteGoal = async (id: number): Promise<DeleteGoalResponse> => {
  const response = await httpClient.post(`${baseRoute}/DeleteGoal/${id}`);
  return response.data;
};

// Employee KPI
export const getEmployeeSelfRating = async (args: {
  employeeId?: number;
  planId?: number;
}): Promise<GetEmployeeSelfRatingResponse> => {
  const { employeeId, planId } = args;

  if (typeof employeeId === 'undefined' && typeof planId === 'undefined') {
    throw new Error('At least one of `employeeId` or `planId` must be provided.');
  }

  const params = new URLSearchParams();

  if (typeof employeeId !== 'undefined') {
    params.append('employeeId', String(employeeId));
  }

  if (typeof planId !== 'undefined') {
    params.append('planId', String(planId));
  }

  const response = await httpClient.get(`${baseRoute}/GetEmployeeSelfRating?${params.toString()}`);
  return response.data;
};

export const updateEmployeeSelfRating = async (
  payload: UpdateSelfRatingPayload
): Promise<UpdateSelfRatingResponse> => {
  const response = await httpClient.post(`${baseRoute}/UpdateEmployeeSelfRating`, payload);
  return response.data;
};

export const submitKPIPlanByEmployee = async (planId: number): Promise<SubmitKPIPlanResponse> => {
  const response = await httpClient.post(`${baseRoute}/SubmitKPIPlanByEmployee/${planId}`);
  return response.data;
};

// Manager KPI
export const getEmployeesKPI = async (
  args: GetEmployeesGoalArgs
): Promise<GetEmployeesGoalResponse> => {
  const response = await httpClient.post(`${baseRoute}/GetEmployeesKPI`, args);
  return response.data;
};

export const getEmployeesByManager = async (params?: {
  name?: string;
}): Promise<GetEmployeesByManagerResponse> => {
  const response = await httpClient.get(`${baseRoute}/GetEmployeesByManager`, { params });
  return response.data;
};

export const getEmployeeRatingByManager = async (
  employeeId: number
): Promise<GetEmployeeRatingByManagerResponse> => {
  const response = await httpClient.get(`${baseRoute}/GetEmployeeRatingByManager/${employeeId}`);
  return response.data;
};

export const updateEmployeeRatingByManager = async (
  args: UpdateManagerRatingRequest
): Promise<UpdateManagerRatingResponse> => {
  const response = await httpClient.post(`${baseRoute}/UpdateEmployeeRatingByManager`, args);
  return response.data;
};

export const assignGoalByManager = async (
  args: AssignGoalByManagerRequest
): Promise<AssignGoalByManagerResponse> => {
  const response = await httpClient.post(`${baseRoute}/AssignGoalByManager`, args);
  return response.data;
};

export const submitKPIPlanByManager = async (
  planId: number
): Promise<SubmitManagerReviewResponse> => {
  const response = await httpClient.post(`${baseRoute}/SubmitKPIPlanByManager/${planId}`);
  return response.data;
};

export const getManagerRatingHistoryByGoal = async (
  params: ManagerRatingHistoryRequest
): Promise<GetManagerRatingHistoryResponse> => {
  const response = await httpClient.post(`${baseRoute}/GetManagerRatingHistoryByGoal`, params);
  return response.data;
};

// Export all as a single object
const kpiService = {
  createGoal,
  getGoalById,
  updateGoal,
  getGoalList,
  deleteGoal,
  getEmployeeSelfRating,
  updateEmployeeSelfRating,
  submitKPIPlanByEmployee,
  getEmployeesKPI,
  getEmployeesByManager,
  getEmployeeRatingByManager,
  updateEmployeeRatingByManager,
  assignGoalByManager,
  submitKPIPlanByManager,
  getManagerRatingHistoryByGoal,
};

export default kpiService;
