// Exit Management API Service
// Connects to EXISTING .NET backend at http://localhost:5281

import httpClient from '../api/http-client';
import type {
  ApiResponse,
  AddResignationRequest,
  ResignationFormData,
  ResignationExitDetails,
  RequestEarlyReleaseRequest,
  ResignationActiveStatusResult,
  GetResignationListRequest,
  GetResignationListResponse,
  ExitEmployeeListItem,
  AdminRejectionRequest,
  AcceptEarlyReleaseRequest,
  UpdateLastWorkingDayRequest,
  ITClearanceDetails,
  UpsertITClearanceRequest,
  HRClearanceDetails,
  UpsertHRClearanceRequest,
  DepartmentClearanceDetails,
  UpsertDepartmentClearanceRequest,
  AccountClearanceDetails,
  UpsertAccountClearanceRequest,
} from '@/types/exit.types';

// ============================================================================
// EMPLOYEE EXIT ENDPOINTS
// ============================================================================

/**
 * Submit a new resignation request
 * POST /api/ExitEmployee/AddResignation
 */
export const addResignation = async (
  data: AddResignationRequest
): Promise<ApiResponse<null>> => {
  // .NET backend expects PascalCase
  const response = await httpClient.post<ApiResponse<null>>(
    '/ExitEmployee/AddResignation',
    {
      EmployeeId: data.employeeId,
      DepartmentId: data.departmentId,
      Reason: data.reason,
      ReportingManagerId: data.reportingManagerId,
      JobType: data.jobType,
    }
  );
  return response.data;
};

/**
 * Get resignation form details by employee ID
 * GET /api/ExitEmployee/GetResignationForm/{id}
 */
export const getResignationForm = async (
  employeeId: number
): Promise<ApiResponse<ResignationFormData>> => {
  const response = await httpClient.get<ApiResponse<ResignationFormData>>(
    `/ExitEmployee/GetResignationForm/${employeeId}`
  );
  return response.data;
};

/**
 * Get resignation exit details by resignation ID
 * GET /api/ExitEmployee/GetResignationDetails/{id}
 */
export const getResignationDetails = async (
  resignationId: number
): Promise<ApiResponse<ResignationExitDetails>> => {
  const response = await httpClient.get<ApiResponse<ResignationExitDetails>>(
    `/ExitEmployee/GetResignationDetails/${resignationId}`
  );
  return response.data;
};

/**
 * Revoke a resignation request
 * POST /api/ExitEmployee/RevokeResignation/{resignationId}
 */
export const revokeResignation = async (
  resignationId: number
): Promise<ApiResponse<null>> => {
  const response = await httpClient.post<ApiResponse<null>>(
    `/ExitEmployee/RevokeResignation/${resignationId}`
  );
  return response.data;
};

/**
 * Request early release from notice period
 * POST /api/ExitEmployee/RequestEarlyRelease
 */
export const requestEarlyRelease = async (
  data: RequestEarlyReleaseRequest
): Promise<ApiResponse<null>> => {
  const response = await httpClient.post<ApiResponse<null>>(
    '/ExitEmployee/RequestEarlyRelease',
    {
      ResignationId: data.resignationId,
      EarlyReleaseDate: data.earlyReleaseDate,
    }
  );
  return response.data;
};

/**
 * Check if resignation exists for employee
 * GET /api/ExitEmployee/IsResignationExist/{EmployeeId}
 */
export const isResignationExist = async (
  employeeId: number
): Promise<ApiResponse<ResignationActiveStatusResult | null>> => {
  const response = await httpClient.get<
    ApiResponse<ResignationActiveStatusResult | null>
  >(`/ExitEmployee/IsResignationExist/${employeeId}`);
  return response.data;
};

// ============================================================================
// ADMIN EXIT ENDPOINTS
// ============================================================================

/**
 * Get paginated list of resignations with filters
 * POST /api/AdminExitEmployee/GetResignationList
 */
export const getResignationList = async (
  request: GetResignationListRequest
): Promise<ApiResponse<GetResignationListResponse>> => {
  // .NET backend expects PascalCase
  const response = await httpClient.post<
    ApiResponse<GetResignationListResponse>
  >('/AdminExitEmployee/GetResignationList', {
    SortColumnName: request.sortColumnName,
    SortDirection: request.sortDirection,
    StartIndex: request.startIndex,
    PageSize: request.pageSize,
    Filters: {
      EmployeeCode: request.filters.employeeCode || null,
      EmployeeName: request.filters.employeeName || null,
      ResignationStatus: request.filters.resignationStatus || null,
      BranchId: request.filters.branchId || null,
      DepartmentId: request.filters.departmentId || null,
      ItNoDue: request.filters.itNoDue || null,
      AccountsNoDue: request.filters.accountsNoDue || null,
      LastWorkingDayFrom: request.filters.lastWorkingDayFrom || null,
      LastWorkingDayTo: request.filters.lastWorkingDayTo || null,
      ResignationDate: request.filters.resignationDate || null,
      EmployeeStatus: request.filters.employeeStatus || null,
    },
  });
  return response.data;
};

/**
 * Get resignation details by ID (admin view)
 * GET /api/AdminExitEmployee/GetResignationById/{id}
 */
export const getResignationById = async (
  resignationId: number
): Promise<ApiResponse<ExitEmployeeListItem>> => {
  const response = await httpClient.get<ApiResponse<ExitEmployeeListItem>>(
    `/AdminExitEmployee/GetResignationById/${resignationId}`
  );
  return response.data;
};

/**
 * Accept resignation request
 * POST /api/AdminExitEmployee/AcceptResignation/{id}
 */
export const acceptResignation = async (
  resignationId: number
): Promise<ApiResponse<string>> => {
  const response = await httpClient.post<ApiResponse<string>>(
    `/AdminExitEmployee/AcceptResignation/${resignationId}`
  );
  return response.data;
};

/**
 * Accept early release request
 * POST /api/AdminExitEmployee/AcceptEarlyRelease
 */
export const acceptEarlyRelease = async (
  data: AcceptEarlyReleaseRequest
): Promise<ApiResponse<string>> => {
  const response = await httpClient.post<ApiResponse<string>>(
    '/AdminExitEmployee/AcceptEarlyRelease',
    {
      ResignationId: data.resignationId,
      EarlyReleaseDate: data.earlyReleaseDate,
    }
  );
  return response.data;
};

/**
 * Reject resignation or early release request
 * POST /api/AdminExitEmployee/AdminRejection
 */
export const adminRejection = async (
  data: AdminRejectionRequest
): Promise<ApiResponse<string>> => {
  const response = await httpClient.post<ApiResponse<string>>(
    '/AdminExitEmployee/AdminRejection',
    {
      ResignationId: data.resignationId,
      EmployeeId: data.employeeId,
      RejectionType: data.rejectionType,
      RejectReason: data.rejectReason || null,
    }
  );
  return response.data;
};

/**
 * Update last working day
 * PATCH /api/AdminExitEmployee/UpdateLastWorkingDay
 */
export const updateLastWorkingDay = async (
  data: UpdateLastWorkingDayRequest
): Promise<ApiResponse<string>> => {
  const response = await httpClient.patch<ApiResponse<string>>(
    '/AdminExitEmployee/UpdateLastWorkingDay',
    {
      ResignationId: data.resignationId,
      LastWorkingDay: data.lastWorkingDay,
    }
  );
  return response.data;
};

// ============================================================================
// IT CLEARANCE ENDPOINTS
// ============================================================================

/**
 * Get IT clearance details
 * GET /api/AdminExitEmployee/GetITClearanceDetailByResignationId/{resignationId}
 */
export const getITClearance = async (
  resignationId: number
): Promise<ApiResponse<ITClearanceDetails | null>> => {
  const response = await httpClient.get<
    ApiResponse<ITClearanceDetails | null>
  >(`/AdminExitEmployee/GetITClearanceDetailByResignationId/${resignationId}`);
  return response.data;
};

/**
 * Add or update IT clearance
 * POST /api/AdminExitEmployee/AddUpdateITClearance
 */
export const upsertITClearance = async (
  data: UpsertITClearanceRequest
): Promise<ApiResponse<string>> => {
  const formData = new FormData();
  formData.append('employeeId', String(data.employeeId));
  formData.append('resignationId', String(data.resignationId));
  formData.append('accessRevoked', String(data.accessRevoked));
  formData.append('assetReturned', String(data.assetReturned));
  formData.append('assetCondition', String(data.assetCondition));
  formData.append('note', data.note || '');
  formData.append(
    'itClearanceCertification',
    String(data.itClearanceCertification)
  );

  if (data.attachmentUrl instanceof File) {
    formData.append('attachmentUrl', data.attachmentUrl);
  } else if (data.attachmentUrl) {
    formData.append('attachmentUrl', data.attachmentUrl);
  }

  const response = await httpClient.post<ApiResponse<string>>(
    '/AdminExitEmployee/AddUpdateITClearance',
    formData,
    {
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    }
  );
  return response.data;
};

// ============================================================================
// HR CLEARANCE ENDPOINTS
// ============================================================================

/**
 * Get HR clearance details
 * GET /api/AdminExitEmployee/GetHRClearanceByResignationId/{resignationId}
 */
export const getHRClearance = async (
  resignationId: number
): Promise<ApiResponse<HRClearanceDetails | null>> => {
  const response = await httpClient.get<
    ApiResponse<HRClearanceDetails | null>
  >(`/AdminExitEmployee/GetHRClearanceByResignationId/${resignationId}`);
  return response.data;
};

/**
 * Add or update HR clearance
 * POST /api/AdminExitEmployee/UpsertHRClearance
 */
export const upsertHRClearance = async (
  data: UpsertHRClearanceRequest
): Promise<ApiResponse<string>> => {
  const formData = new FormData();
  formData.append('employeeId', String(data.employeeId));
  formData.append('resignationId', String(data.resignationId));
  formData.append(
    'advanceBonusRecoveryAmount',
    String(data.advanceBonusRecoveryAmount)
  );
  formData.append('serviceAgreementDetails', data.serviceAgreementDetails || '');
  formData.append('currentEL', String(data.currentEL));
  formData.append('numberOfBuyOutDays', String(data.numberOfBuyOutDays));
  formData.append('exitInterviewStatus', String(data.exitInterviewStatus));
  formData.append('exitInterviewDetails', data.exitInterviewDetails || '');

  if (data.attachment instanceof File) {
    formData.append('attachment', data.attachment);
  } else if (data.attachment) {
    formData.append('attachment', data.attachment);
  }

  const response = await httpClient.post<ApiResponse<string>>(
    '/AdminExitEmployee/UpsertHRClearance',
    formData,
    {
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    }
  );
  return response.data;
};

// ============================================================================
// DEPARTMENT CLEARANCE ENDPOINTS
// ============================================================================

/**
 * Get department clearance details
 * GET /api/AdminExitEmployee/GetDepartmentClearanceDetailByResignationId/{resignationId}
 */
export const getDepartmentClearance = async (
  resignationId: number
): Promise<ApiResponse<DepartmentClearanceDetails | null>> => {
  const response = await httpClient.get<
    ApiResponse<DepartmentClearanceDetails | null>
  >(
    `/AdminExitEmployee/GetDepartmentClearanceDetailByResignationId/${resignationId}`
  );
  return response.data;
};

/**
 * Add or update department clearance
 * POST /api/AdminExitEmployee/UpsertDepartmentClearance
 */
export const upsertDepartmentClearance = async (
  data: UpsertDepartmentClearanceRequest
): Promise<ApiResponse<string>> => {
  const formData = new FormData();
  formData.append('employeeId', String(data.employeeId));
  formData.append('resignationId', String(data.resignationId));
  formData.append('ktStatus', String(data.ktStatus));
  formData.append('ktNotes', data.ktNotes || '');

  // Append each KT user separately (backend expects this format)
  data.ktUsers.forEach((userId) => {
    formData.append('ktUsers', String(userId));
  });

  if (data.attachment instanceof File) {
    formData.append('attachment', data.attachment);
  } else if (data.attachment) {
    formData.append('attachment', data.attachment);
  }

  const response = await httpClient.post<ApiResponse<string>>(
    '/AdminExitEmployee/UpsertDepartmentClearance',
    formData,
    {
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    }
  );
  return response.data;
};

// ============================================================================
// ACCOUNT CLEARANCE ENDPOINTS
// ============================================================================

/**
 * Get account clearance details
 * GET /api/AdminExitEmployee/GetAccountClearance/{resignationId}
 */
export const getAccountClearance = async (
  resignationId: number
): Promise<ApiResponse<AccountClearanceDetails | null>> => {
  const response = await httpClient.get<
    ApiResponse<AccountClearanceDetails | null>
  >(`/AdminExitEmployee/GetAccountClearance/${resignationId}`);
  return response.data;
};

/**
 * Add or update account clearance
 * POST /api/AdminExitEmployee/AddUpdateAccountClearance
 */
export const upsertAccountClearance = async (
  data: UpsertAccountClearanceRequest
): Promise<ApiResponse<string>> => {
  const formData = new FormData();
  formData.append('employeeId', String(data.employeeId));
  formData.append('resignationId', String(data.resignationId));
  formData.append('fnFStatus', String(data.fnFStatus));
  formData.append('fnFAmount', String(data.fnFAmount || 0));
  formData.append(
    'issueNoDueCertificate',
    String(data.issueNoDueCertificate)
  );
  formData.append('note', data.note || '');

  if (data.accountAttachment instanceof File) {
    formData.append('accountAttachment', data.accountAttachment);
  } else if (data.accountAttachment) {
    formData.append('accountAttachment', data.accountAttachment);
  }

  const response = await httpClient.post<ApiResponse<string>>(
    '/AdminExitEmployee/AddUpdateAccountClearance',
    formData,
    {
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    }
  );
  return response.data;
};
