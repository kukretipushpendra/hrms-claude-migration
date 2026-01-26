// Document Management Types

/**
 * Document Category IDs
 */
export const DOCUMENT_CATEGORIES = {
  PERSONAL_DETAILS: 1,
  NOMINEE_DETAILS: 2,
} as const;

/**
 * Personal Detail Document Type IDs
 */
export const PERSONAL_DETAIL_DOCUMENT_TYPES = {
  PAN_NUMBER: 1,
  AADHAR_NUMBER: 2,
  PASSPORT_NUMBER: 3,
  VOTER_CARD_NUMBER: 4,
  DRIVING_LICENSE_NUMBER: 5,
} as const;

/**
 * Blob Document Container Types
 */
export const BLOB_CONTAINER_TYPES = {
  USER_DOCUMENT: 1,
  NOMINEE_DOCUMENT: 2,
  EVENT_DOCUMENT: 3,
  EMPLOYER_DOCUMENT: 4,
} as const;

/**
 * Government Document Type
 */
export interface GovtDocumentType {
  id: number;
  name: string;
  isExpiryDateRequired: boolean;
}

/**
 * User Document
 */
export interface UserDocument {
  id: number;
  employeeId: number;
  documentName: string;
  documentTypeId: number;
  documentType: string;
  documentNumber: string;
  documentExpiry: string | null;
  location: string;
}

/**
 * Add User Document Request
 */
export interface AddUserDocumentRequest {
  EmployeeId: number;
  DocumentTypeId: number;
  DocumentNumber: string;
  DocumentExpiry: string;
  File: File | null;
}

/**
 * Update User Document Request
 */
export interface UpdateUserDocumentRequest {
  Id: number;
  EmployeeId: number;
  DocumentTypeId: number;
  DocumentNumber: string;
  DocumentExpiry: string;
  File: File | string;
}

/**
 * Document Form Data
 */
export interface DocumentFormData {
  documentTypeId: number | null;
  documentNumber: string;
  documentExpiry: string;
  file: File | null;
}

/**
 * Document List Filters
 */
export interface DocumentListFilters {
  employeeId?: number;
  page: number;
  pageSize: number;
}
