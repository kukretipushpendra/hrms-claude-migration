import apiClient from '../api/axios-client';
import type {
  GovtDocumentType,
  UserDocument,
  AddUserDocumentRequest,
  UpdateUserDocumentRequest,
} from '@/types/document.types';

/**
 * Document Service
 * Handles all document-related API calls
 */
class DocumentService {
  /**
   * Get Government Document Types
   * @param idProofFor - Document category ID (1 = Personal Details)
   */
  async getGovtDocumentTypes(idProofFor: number): Promise<GovtDocumentType[]> {
    const response = await apiClient.get(`/api/UserProfile/GovtDocumentList/${idProofFor}`);
    return response.data.result;
  }

  /**
   * Get User Document List
   * @param employeeId - Employee ID
   */
  async getUserDocumentList(employeeId: number): Promise<UserDocument[]> {
    const response = await apiClient.get(`/api/UserProfile/GetUserDocumentList/${employeeId}`);
    return response.data.result;
  }

  /**
   * Get User Document By ID
   * @param id - Document ID
   */
  async getUserDocumentById(id: number): Promise<UserDocument> {
    const response = await apiClient.get(`/api/UserProfile/GetUserDocumentById/${id}`);
    return response.data.result;
  }

  /**
   * Upload User Document (Create)
   * @param request - Add user document request
   */
  async uploadUserDocument(request: AddUserDocumentRequest): Promise<boolean> {
    const formData = new FormData();
    formData.append('EmployeeId', request.EmployeeId.toString());
    formData.append('DocumentTypeId', request.DocumentTypeId.toString());
    formData.append('DocumentNumber', request.DocumentNumber);
    formData.append('DocumentExpiry', request.DocumentExpiry || '');

    if (request.File) {
      formData.append('File', request.File);
    }

    const response = await apiClient.post('/api/UserProfile/UploadUserDocument', formData, {
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    });
    return response.data.result;
  }

  /**
   * Update User Document
   * @param request - Update user document request
   */
  async updateUserDocument(request: UpdateUserDocumentRequest): Promise<boolean> {
    const formData = new FormData();
    formData.append('Id', request.Id.toString());
    formData.append('EmployeeId', request.EmployeeId.toString());
    formData.append('DocumentTypeId', request.DocumentTypeId.toString());
    formData.append('DocumentNumber', request.DocumentNumber);
    formData.append('DocumentExpiry', request.DocumentExpiry || '');

    if (request.File && typeof request.File !== 'string') {
      formData.append('File', request.File);
    }

    const response = await apiClient.post('/api/UserProfile/UpdateUploadUserDocument', formData, {
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    });
    return response.data.result;
  }

  /**
   * Download User Document
   * @param filename - Document filename/location
   */
  async downloadUserDocument(filename: string): Promise<string> {
    const response = await apiClient.get('/api/UserProfile/DownloadUserDocument', {
      params: { filename },
    });
    return response.data.result; // Base64 encoded file content
  }

  /**
   * Get User Document URL (Alternative - SAS URL)
   * @param containerType - Blob container type
   * @param filename - Document filename/location
   */
  async getUserDocumentUrl(containerType: number, filename: string): Promise<string | null> {
    const response = await apiClient.get('/api/UserProfile/GetUserDocumentUrl', {
      params: { containerType, filename },
    });
    return response.data.result;
  }
}

export const documentService = new DocumentService();
