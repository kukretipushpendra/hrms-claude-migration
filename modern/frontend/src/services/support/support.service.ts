import httpClient from '@/services/api/http-client';
import type {
  AddFeedbackRequest,
  AddFeedbackResponse,
  Feedback,
  FeedbackListResponse,
  EmployeeFeedbackListResponse,
  ModifyStatusRequest,
  FeedbackSearchFilter,
  EmployeeFeedbackFilter,
} from '@/types/support.types';

const BASE_URL = '/Feedback';

// Helper to convert object to FormData for file uploads
function objectToFormData(data: AddFeedbackRequest): FormData {
  const formData = new FormData();

  formData.append('employeeId', String(data.employeeId));
  formData.append('feedbackType', String(data.feedbackType));
  formData.append('subject', data.subject);
  formData.append('description', data.description);

  if (data.attachment) {
    formData.append('attachment', data.attachment);
  }

  return formData;
}

// Pagination and sorting params (matching legacy API)
export interface FeedbackListParams {
  searchValue?: string;
  pageNumber: number;
  pageSize: number;
  sortColumn: string;
  sortDirection: 'asc' | 'desc';
  filter: FeedbackSearchFilter;
}

export interface EmployeeFeedbackListParams {
  searchValue?: string;
  pageNumber: number;
  pageSize: number;
  sortColumn: string;
  sortDirection: 'asc' | 'desc';
  filter: EmployeeFeedbackFilter;
}

/**
 * Add a new feedback/support ticket
 * POST /api/Feedback/AddFeedback
 */
export async function addFeedback(request: AddFeedbackRequest): Promise<AddFeedbackResponse> {
  const formData = objectToFormData(request);

  const response = await httpClient.post<{
    data: AddFeedbackResponse;
    isSuccess: boolean;
    message: string;
  }>(`${BASE_URL}/AddFeedback`, formData, {
    headers: {
      'Content-Type': 'multipart/form-data',
    },
  });

  return response.data.data;
}

/**
 * Get feedback details by ID
 * GET /api/Feedback/GetFeedbackById/{id}
 */
export async function getFeedbackById(id: number): Promise<Feedback> {
  const response = await httpClient.get<{
    data: Feedback;
    isSuccess: boolean;
    message: string;
  }>(`${BASE_URL}/GetFeedbackById/${id}`);

  return response.data.data;
}

/**
 * Get all feedback list (admin)
 * POST /api/Feedback/GetFeedbackList
 */
export async function getFeedbackList(params: FeedbackListParams): Promise<FeedbackListResponse> {
  const response = await httpClient.post<{
    data: FeedbackListResponse;
    isSuccess: boolean;
    message: string;
  }>(`${BASE_URL}/GetFeedbackList`, params);

  return response.data.data;
}

/**
 * Get employee's own feedback list
 * POST /api/Feedback/GetFeedbackByEmployee
 */
export async function getFeedbackByEmployee(
  params: EmployeeFeedbackListParams
): Promise<EmployeeFeedbackListResponse> {
  const response = await httpClient.post<{
    data: EmployeeFeedbackListResponse;
    isSuccess: boolean;
    message: string;
  }>(`${BASE_URL}/GetFeedbackByEmployee`, params);

  return response.data.data;
}

/**
 * Modify feedback status (admin)
 * POST /api/Feedback/ModifyFeedbackStatus
 */
export async function modifyFeedbackStatus(request: ModifyStatusRequest): Promise<boolean> {
  const response = await httpClient.post<{
    data: boolean;
    isSuccess: boolean;
    message: string;
  }>(`${BASE_URL}/ModifyFeedbackStatus`, request);

  return response.data.data;
}
