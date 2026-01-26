// Grievance API Service

import httpClient from '@/services/api/http-client';
import type {
  GrievanceType,
  GrievanceTypeSimple,
  EmployeeGrievance,
  GrievanceTicketData,
  SubmitGrievanceRequest,
  SubmitGrievanceResponse,
  GrievancePaginationRequest,
  PaginatedGrievanceResponse,
  UpdateRemarksRequest,
  GrievanceTypeRequest,
} from '@/types/grievance.types';

const BASE_URL = '/Grievance';

// API Response wrapper from .NET backend
interface ApiResponse<T> {
  data: T;
  isSuccess: boolean;
  message: string | null;
}

/**
 * Configuration Endpoints (Admin)
 */

// Get all grievance types with owners
export async function getAllGrievancesList(): Promise<GrievanceType[]> {
  const response = await httpClient.get<ApiResponse<GrievanceType[]>>(
    `${BASE_URL}/GetAllGrievancesList`
  );
  return response.data.data || [];
}

// Get active grievance types for dropdown
export async function getAllGrievanceTypeList(): Promise<GrievanceTypeSimple[]> {
  const response = await httpClient.get<ApiResponse<GrievanceTypeSimple[]>>(
    `${BASE_URL}/GetAllGrievanceTypeList`
  );
  return response.data.data || [];
}

// Get grievance type by ID
export async function getGrievanceTypeById(id: number): Promise<GrievanceType | null> {
  const response = await httpClient.get<ApiResponse<GrievanceType>>(
    `${BASE_URL}/GetGrievanceTypeById/${id}`
  );
  return response.data.data;
}

// Create grievance type
export async function addGrievanceType(payload: GrievanceTypeRequest): Promise<number> {
  const response = await httpClient.post<ApiResponse<number>>(`${BASE_URL}/AddGrievance`, payload);
  return response.data.data;
}

// Update grievance type
export async function updateGrievanceType(payload: GrievanceTypeRequest): Promise<boolean> {
  const response = await httpClient.post<ApiResponse<boolean>>(
    `${BASE_URL}/UpdateGrievance`,
    payload
  );
  return response.data.data;
}

// Delete grievance type
export async function deleteGrievanceType(id: number): Promise<boolean> {
  const response = await httpClient.post<ApiResponse<boolean>>(`${BASE_URL}/DeleteGrievance/${id}`);
  return response.data.data;
}

/**
 * Employee Grievance Endpoints
 */

// Submit new grievance
export async function submitGrievance(
  payload: SubmitGrievanceRequest
): Promise<SubmitGrievanceResponse> {
  const formData = new FormData();
  formData.append('grievanceTypeId', payload.grievanceTypeId.toString());
  formData.append('title', payload.title);
  if (payload.description) {
    formData.append('description', payload.description);
  }
  if (payload.attachment) {
    formData.append('attachment', payload.attachment);
  }

  const response = await httpClient.post<ApiResponse<SubmitGrievanceResponse>>(
    `${BASE_URL}/SubmitGrievance`,
    formData,
    {
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    }
  );
  return response.data.data;
}

// Get employee's grievances (paginated)
export async function getEmployeeGrievancesById(
  employeeId: number,
  request: GrievancePaginationRequest
): Promise<PaginatedGrievanceResponse> {
  const response = await httpClient.post<ApiResponse<PaginatedGrievanceResponse>>(
    `${BASE_URL}/GetEmployeeGrievancesById/${employeeId}`,
    request
  );
  return response.data.data;
}

// Get grievance details by ticket ID
export async function getEmployeeGrievanceDetail(
  ticketId: number
): Promise<EmployeeGrievance | null> {
  const response = await httpClient.get<ApiResponse<EmployeeGrievance>>(
    `${BASE_URL}/GetEmployeeGrievancesDetail/${ticketId}`
  );
  return response.data.data;
}

// Check if user can view grievance
export async function checkGrievanceViewAllowed(grievanceId: number): Promise<boolean> {
  const response = await httpClient.get<ApiResponse<boolean>>(
    `${BASE_URL}/GrievanceViewAllowed/${grievanceId}`
  );
  return response.data.data;
}

/**
 * Remarks & Resolution Endpoints
 */

// Get all remarks for a grievance ticket
export async function getGrievanceTicketRemarks(ticketId: number): Promise<GrievanceTicketData> {
  const response = await httpClient.get<ApiResponse<GrievanceTicketData>>(
    `${BASE_URL}/GetEmployeeGrievanceRemarksDetail/${ticketId}`
  );
  return response.data.data;
}

// Add remarks (and optionally escalate or resolve)
export async function updateEmployeeGrievanceRemarks(
  payload: UpdateRemarksRequest
): Promise<boolean> {
  const formData = new FormData();
  formData.append('grievanceId', payload.grievanceId.toString());
  formData.append('remarks', payload.remarks);
  if (payload.status !== undefined) {
    formData.append('status', payload.status.toString());
  }
  if (payload.attachment) {
    formData.append('attachment', payload.attachment);
  }

  const response = await httpClient.post<ApiResponse<boolean>>(
    `${BASE_URL}/UpdateEmployeeGrievanceRemarks`,
    formData,
    {
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    }
  );
  return response.data.data;
}

// Check if user can add remarks
export async function checkUpdateRemarksAllowed(
  grievanceTypeId: number,
  level: number
): Promise<boolean> {
  const response = await httpClient.get<ApiResponse<boolean>>(`${BASE_URL}/UpdateRemarksAllowed`, {
    params: {
      grievanceTypeId,
      level,
    },
  });
  return response.data.data;
}

// Send resolution email
export async function sendGrievanceResolvedEmail(ticketNo: string): Promise<boolean> {
  const response = await httpClient.get<ApiResponse<boolean>>(
    `${BASE_URL}/GrievanceResolvedEmail/${ticketNo}`
  );
  return response.data.data;
}

/**
 * Admin Reporting Endpoints
 */

// Get all grievances with filters (admin)
export async function getAllEmployeeGrievances(
  request: GrievancePaginationRequest
): Promise<PaginatedGrievanceResponse> {
  const response = await httpClient.post<ApiResponse<PaginatedGrievanceResponse>>(
    `${BASE_URL}/GetAllEmployeeGrievances`,
    request
  );
  return response.data.data;
}

// Export grievances to Excel
export async function exportGrievanceReport(request: GrievancePaginationRequest): Promise<Blob> {
  const response = await httpClient.post(`${BASE_URL}/ExportGrievanceReport`, request, {
    params: {
      format: 'excel',
    },
    responseType: 'blob',
  });
  return response.data;
}
