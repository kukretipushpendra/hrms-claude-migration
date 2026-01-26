import httpClient from '@/services/api/http-client';
import type { ApiResponse } from '@/stores/auth.store';
import type {
  GetNomineeListRequest,
  GetNomineeListResponse,
  NomineeRelationship,
  AddNomineeRequest,
  UpdateNomineeRequest,
  CrudResult,
  NomineeItem,
} from '@/types/nominee.types';

const baseRoute = '/UserProfile';

// Convert object to FormData for multipart/form-data upload
function objectToFormData(obj: Record<string, unknown>): FormData {
  const formData = new FormData();
  Object.entries(obj).forEach(([key, value]) => {
    if (value !== undefined && value !== null) {
      if (value instanceof File) {
        formData.append(key, value);
      } else {
        formData.append(key, String(value));
      }
    }
  });
  return formData;
}

export const nomineeService = {
  /**
   * Get paginated and filtered nominee list
   * POST /api/UserProfile/GetNomineeList
   */
  async getNomineeList(
    payload: GetNomineeListRequest
  ): Promise<ApiResponse<GetNomineeListResponse>> {
    const response = await httpClient.post<ApiResponse<GetNomineeListResponse>>(
      `${baseRoute}/GetNomineeList`,
      payload
    );
    return response.data;
  },

  /**
   * Get relationship dropdown options
   * GET /api/UserProfile/GetRelationshipList
   */
  async getRelationshipList(): Promise<ApiResponse<NomineeRelationship[]>> {
    const response = await httpClient.get<ApiResponse<NomineeRelationship[]>>(
      `${baseRoute}/GetRelationshipList`
    );
    return response.data;
  },

  /**
   * Add new nominee
   * POST /api/UserProfile/AddNominee
   */
  async addNominee(args: AddNomineeRequest): Promise<ApiResponse<CrudResult>> {
    const formData = objectToFormData(args as Record<string, unknown>);
    const response = await httpClient.post<ApiResponse<CrudResult>>(
      `${baseRoute}/AddNominee`,
      formData,
      {
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      }
    );
    return response.data;
  },

  /**
   * Get nominee by ID
   * GET /api/UserProfile/GetNomineeById/{id}
   */
  async getNomineeById(id: number): Promise<ApiResponse<NomineeItem>> {
    const response = await httpClient.get<ApiResponse<NomineeItem>>(
      `${baseRoute}/GetNomineeById/${id}`
    );
    return response.data;
  },

  /**
   * Update existing nominee
   * PUT /api/UserProfile/UpdateNominee
   */
  async updateNominee(args: UpdateNomineeRequest): Promise<ApiResponse<CrudResult>> {
    const formData = objectToFormData(args as Record<string, unknown>);
    const response = await httpClient.put<ApiResponse<CrudResult>>(
      `${baseRoute}/UpdateNominee`,
      formData,
      {
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      }
    );
    return response.data;
  },

  /**
   * Download nominee document
   * GET /api/UserProfile/DownloadNomineeDocument?filename={fileName}
   */
  async downloadNomineeDocument(fileName: string): Promise<ApiResponse<string>> {
    const response = await httpClient.get<ApiResponse<string>>(
      `${baseRoute}/DownloadNomineeDocument`,
      {
        params: { filename: fileName },
      }
    );
    return response.data;
  },

  /**
   * Delete nominee
   * DELETE /api/UserProfile/DeleteNominee/{id}
   */
  async deleteNominee(id: number): Promise<ApiResponse<null>> {
    const response = await httpClient.delete<ApiResponse<null>>(`${baseRoute}/DeleteNominee/${id}`);
    return response.data;
  },
};
