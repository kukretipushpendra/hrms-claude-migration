// Certificate Service for Vue.js frontend
// Connects to existing .NET backend

import httpClient from '@/services/api/http-client';
import type {
  AddCertificateArgs,
  AddCertificateResponse,
  DeleteCertificateArgs,
  DeleteCertificateDetailApiResponse,
  DownloadCertificateDocumentResponse,
  GetCertificateByIdResponse,
  GetCertificateListArgs,
  GetCertificateListResponse,
  UpdateCertificateArgs,
} from './types';

const baseRoute = '/UserProfile';

// Helper to convert object to FormData
function objectToFormData(obj: Record<string, unknown>): FormData {
  const formData = new FormData();

  Object.entries(obj).forEach(([key, value]) => {
    if (value === null || value === undefined) {
      return;
    }
    if (value instanceof File) {
      formData.append(key, value);
    } else if (typeof value === 'object') {
      formData.append(key, JSON.stringify(value));
    } else {
      formData.append(key, String(value));
    }
  });

  return formData;
}

export const certificateService = {
  async getCertificateList(payload: GetCertificateListArgs): Promise<GetCertificateListResponse> {
    const response = await httpClient.post<GetCertificateListResponse>(
      `${baseRoute}/GetEmployeeCerificateList`,
      payload
    );
    return response.data;
  },

  async addCertificate(args: AddCertificateArgs): Promise<AddCertificateResponse> {
    const formData = objectToFormData(args as unknown as Record<string, unknown>);
    const response = await httpClient.post<AddCertificateResponse>(
      `${baseRoute}/UploadEmployeeCertificate`,
      formData,
      {
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      }
    );
    return response.data;
  },

  async getCertificateById(id: number): Promise<GetCertificateByIdResponse> {
    const response = await httpClient.get<GetCertificateByIdResponse>(
      `${baseRoute}/GetUserCertificateById/${id}`
    );
    return response.data;
  },

  async updateCertificate(args: UpdateCertificateArgs): Promise<AddCertificateResponse> {
    const formData = objectToFormData(args as unknown as Record<string, unknown>);
    const response = await httpClient.post<AddCertificateResponse>(
      `${baseRoute}/UpdateUploadEmployeeCertificate`,
      formData,
      {
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      }
    );
    return response.data;
  },

  async downloadCertificateDocument(
    fileName: string
  ): Promise<DownloadCertificateDocumentResponse> {
    const response = await httpClient.get<DownloadCertificateDocumentResponse>(
      `${baseRoute}/DownloadCertificateDocument?fileName=${fileName}`
    );
    return response.data;
  },

  async deleteCertificateDetail(
    payload: DeleteCertificateArgs
  ): Promise<DeleteCertificateDetailApiResponse> {
    const response = await httpClient.delete<DeleteCertificateDetailApiResponse>(
      `${baseRoute}/ArchiveUnarchiveUserCertificates`,
      {
        data: payload,
      }
    );
    return response.data;
  },
};
