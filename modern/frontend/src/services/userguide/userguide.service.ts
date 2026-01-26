// User Guide API Service

import httpClient from '@/services/api/http-client';
import type {
  UserGuide,
  MenuOption,
  UserGuidePaginationRequest,
  UserGuideListResponse,
  AddUserGuideRequest,
  UpdateUserGuideRequest,
} from '@/types/userguide.types';

const BASE_URL = '/UserGuide';

// API Response wrapper from .NET backend
interface ApiResponse<T> {
  data: T;
  isSuccess: boolean;
  message: string | null;
}

/**
 * Get list of available menus for user guides
 */
export async function getAllMenu(): Promise<MenuOption[]> {
  const response = await httpClient.get<ApiResponse<MenuOption[]>>(`${BASE_URL}/GetAllMenu`);
  return response.data.data || [];
}

/**
 * Get single user guide by ID
 */
export async function getUserGuideById(id: number): Promise<UserGuide | null> {
  const response = await httpClient.get<ApiResponse<UserGuide>>(
    `${BASE_URL}/GetUserGuideById/${id}`
  );
  return response.data.data;
}

/**
 * Create a new user guide
 */
export async function addUserGuide(payload: AddUserGuideRequest): Promise<number> {
  const response = await httpClient.post<ApiResponse<number>>(`${BASE_URL}/AddUserGuide`, payload);
  return response.data.data;
}

/**
 * Update an existing user guide
 */
export async function updateUserGuide(payload: UpdateUserGuideRequest): Promise<boolean> {
  const response = await httpClient.post<ApiResponse<boolean>>(
    `${BASE_URL}/UpdateUserGuide`,
    payload
  );
  return response.data.data;
}

/**
 * Get paginated list of user guides with filters
 */
export async function getAllUserGuide(
  request: UserGuidePaginationRequest
): Promise<UserGuideListResponse> {
  const response = await httpClient.post<ApiResponse<UserGuideListResponse>>(
    `${BASE_URL}/GetAllUserGuide`,
    request
  );
  return response.data.data;
}

/**
 * Delete a user guide by ID
 */
export async function deleteUserGuideById(userGuideId: number): Promise<boolean> {
  const response = await httpClient.post<ApiResponse<boolean>>(
    `${BASE_URL}/DeleteUserGuideById`,
    null,
    {
      params: { UserGuideId: userGuideId },
    }
  );
  return response.data.data;
}
