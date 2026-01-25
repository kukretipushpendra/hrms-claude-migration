import httpClient from '@/services/api/http-client';
import type {
  ApiResponse,
  CompanyPolicySearchRequest,
  CompanyPolicySearchResponse,
  CompanyPolicyDetail,
  CompanyPolicyRequest,
  CompanyPolicyResponse,
  PolicyCategory,
  PolicyStatus,
} from './types';

const baseRoute = '/CompanyPolicy';

/**
 * Get paginated and filtered list of company policies
 * POST /CompanyPolicy/GetCompanyPolicies
 * Requires: Read.CompanyPolicy permission
 */
export async function getCompanyPolicies(
  params: CompanyPolicySearchRequest
): Promise<ApiResponse<CompanyPolicySearchResponse>> {
  const response = await httpClient.post<ApiResponse<CompanyPolicySearchResponse>>(
    `${baseRoute}/GetCompanyPolicies`,
    params
  );
  return response.data;
}

/**
 * Get company policy by ID
 * GET /CompanyPolicy/GetCompanyPolicyById?id={id}
 * Requires: Read.CompanyPolicy permission
 */
export async function getCompanyPolicyById(id: number): Promise<ApiResponse<CompanyPolicyDetail>> {
  const response = await httpClient.get<ApiResponse<CompanyPolicyDetail>>(
    `${baseRoute}/GetCompanyPolicyById`,
    { params: { id } }
  );
  return response.data;
}

/**
 * Create new company policy
 * POST /CompanyPolicy/CreateCompanyPolicy
 * Requires: Create.CompanyPolicy permission
 */
export async function createCompanyPolicy(
  data: CompanyPolicyRequest
): Promise<ApiResponse<CompanyPolicyResponse>> {
  const formData = new FormData();
  formData.append('policyTitle', data.policyTitle);
  formData.append('policyCategoryId', data.policyCategoryId.toString());
  formData.append('policyContent', data.policyContent);
  formData.append('effectiveDate', data.effectiveDate);

  if (data.statusId !== undefined) {
    formData.append('statusId', data.statusId.toString());
  }

  if (data.accessibility !== undefined) {
    formData.append('accessibility', data.accessibility.toString());
  }

  if (data.emailRequest !== undefined) {
    formData.append('emailRequest', data.emailRequest.toString());
  }

  if (data.document) {
    formData.append('document', data.document);
  }

  const response = await httpClient.post<ApiResponse<CompanyPolicyResponse>>(
    `${baseRoute}/CreateCompanyPolicy`,
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
 * Update existing company policy
 * PUT /CompanyPolicy/UpdateCompanyPolicy
 * Requires: Update.CompanyPolicy permission
 */
export async function updateCompanyPolicy(
  id: number,
  data: CompanyPolicyRequest
): Promise<ApiResponse<CompanyPolicyResponse>> {
  const formData = new FormData();
  formData.append('companyPolicyId', id.toString());
  formData.append('policyTitle', data.policyTitle);
  formData.append('policyCategoryId', data.policyCategoryId.toString());
  formData.append('policyContent', data.policyContent);
  formData.append('effectiveDate', data.effectiveDate);

  if (data.statusId !== undefined) {
    formData.append('statusId', data.statusId.toString());
  }

  if (data.accessibility !== undefined) {
    formData.append('accessibility', data.accessibility.toString());
  }

  if (data.emailRequest !== undefined) {
    formData.append('emailRequest', data.emailRequest.toString());
  }

  if (data.document) {
    formData.append('document', data.document);
  }

  const response = await httpClient.put<ApiResponse<CompanyPolicyResponse>>(
    `${baseRoute}/UpdateCompanyPolicy`,
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
 * Toggle publish/unpublish company policy
 * PUT /CompanyPolicy/PublishCompanyPolicy
 * Requires: Update.CompanyPolicy permission
 */
export async function publishCompanyPolicy(companyPolicyId: number): Promise<ApiResponse<null>> {
  const response = await httpClient.put<ApiResponse<null>>(`${baseRoute}/PublishCompanyPolicy`, {
    companyPolicyId,
  });
  return response.data;
}

/**
 * Get policy categories
 * GET /CompanyPolicy/GetDocumentCategoryList
 */
export async function getPolicyCategories(): Promise<ApiResponse<PolicyCategory[]>> {
  const response = await httpClient.get<ApiResponse<PolicyCategory[]>>(
    `${baseRoute}/GetDocumentCategoryList`
  );
  return response.data;
}

/**
 * Get policy statuses
 * GET /CompanyPolicy/GetPolicyStatusList
 */
export async function getPolicyStatuses(): Promise<ApiResponse<PolicyStatus[]>> {
  const response = await httpClient.get<ApiResponse<PolicyStatus[]>>(
    `${baseRoute}/GetPolicyStatusList`
  );
  return response.data;
}

/**
 * Download policy document
 * GET /CompanyPolicy/DownloadDocument?id={id}
 */
export function getDocumentDownloadUrl(id: number): string {
  const baseURL = httpClient.defaults.baseURL || '';
  return `${baseURL}${baseRoute}/DownloadDocument?id=${id}`;
}
