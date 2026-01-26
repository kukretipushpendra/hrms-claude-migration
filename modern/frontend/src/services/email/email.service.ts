// Email Notification / Template Management API Service

import httpClient from '@/services/api/http-client';
import type {
  EmailTemplate,
  EmailTemplateTypeOption,
  EmailTemplatePaginationRequest,
  EmailTemplateListResponse,
  AddEmailTemplateRequest,
  UpdateEmailTemplateRequest,
  ToggleStatusRequest,
} from '@/types/email.types';

const BASE_URL = '/NotificationTemplate';

// API Response wrapper from .NET backend
interface ApiResponse<T> {
  data: T;
  isSuccess: boolean;
  message: string | null;
}

/**
 * Get paginated list of email templates with filters
 */
export async function getEmailTemplates(
  request: EmailTemplatePaginationRequest
): Promise<EmailTemplateListResponse> {
  const response = await httpClient.post<ApiResponse<EmailTemplateListResponse>>(
    `${BASE_URL}/GetEmailTemplates`,
    request
  );
  return response.data.data;
}

/**
 * Get single email template by ID
 */
export async function getEmailTemplateById(id: number): Promise<EmailTemplate | null> {
  const response = await httpClient.get<ApiResponse<EmailTemplate>>(`${BASE_URL}/${id}`);
  return response.data.data;
}

/**
 * Create a new email template
 */
export async function addEmailTemplate(payload: AddEmailTemplateRequest): Promise<number> {
  const response = await httpClient.post<ApiResponse<number>>(
    `${BASE_URL}/AddEmailTemplate`,
    payload
  );
  return response.data.data;
}

/**
 * Update an existing email template
 */
export async function updateEmailTemplate(payload: UpdateEmailTemplateRequest): Promise<boolean> {
  const response = await httpClient.post<ApiResponse<boolean>>(
    `${BASE_URL}/UpdateEmailTemplate`,
    payload
  );
  return response.data.data;
}

/**
 * Toggle template active/inactive status
 */
export async function toggleEmailTemplateStatus(payload: ToggleStatusRequest): Promise<boolean> {
  const response = await httpClient.post<ApiResponse<boolean>>(
    `${BASE_URL}/ToggleEmailTemplateStatus`,
    payload
  );
  return response.data.data;
}

/**
 * Get list of available template types for dropdown
 */
export async function getEmailTemplateNameList(): Promise<EmailTemplateTypeOption[]> {
  const response = await httpClient.get<ApiResponse<EmailTemplateTypeOption[]>>(
    `${BASE_URL}/GetEmailTemplateNameList`
  );
  return response.data.data || [];
}

/**
 * Get the default template for a specific type
 */
export async function getDefaultTemplate(type: number): Promise<EmailTemplate | null> {
  const response = await httpClient.get<ApiResponse<EmailTemplate>>(
    `${BASE_URL}/GetDefaultTemplate`,
    {
      params: { type },
    }
  );
  return response.data.data;
}

/**
 * Soft delete an email template
 */
export async function deleteTemplate(id: number): Promise<boolean> {
  const response = await httpClient.post<ApiResponse<boolean>>(`${BASE_URL}/DeleteTemplate/${id}`);
  return response.data.data;
}
