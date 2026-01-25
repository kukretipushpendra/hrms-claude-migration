// Types matching .NET backend responses

export interface ApiResponse<T> {
  statusCode: number;
  message: string;
  modelErrors?: string[];
  result?: T;
  data?: T; // Some endpoints use 'data' instead of 'result'
}

// Company Policy List
export interface CompanyPolicySearchRequest {
  Filters?: {
    Name?: string; // Policy title filter
    DocumentCategoryId?: number;
    StatusId?: number;
    StartDate?: string;
    EndDate?: string;
  };
  PageSize: number;
  StartIndex: number; // 1-based indexing
  SortColumnName?: string;
  SortDirection?: 'asc' | 'desc';
}

export interface CompanyPolicyItem {
  id: number;
  name: string; // Policy title
  documentCategory: string;
  documentCategoryId: number;
  policyDescription: string;
  statusId: number;
  status: string;
  versionNo: string;
  effectiveDate: string;
  createdBy?: string;
  createdOn?: string;
  modifiedBy?: string;
  fileName?: string;
  fileOriginalName?: string;
}

export interface CompanyPolicySearchResponse {
  companyPolicyList: CompanyPolicyItem[];
  totalRecords: number;
}

// Company Policy Detail
export interface CompanyPolicyDetail {
  companyPolicyId: number;
  policyTitle: string;
  policyCategory: string;
  policyCategoryId: number;
  policyContent: string;
  effectiveDate: string;
  publishedDate?: string;
  status: string;
  statusId: number;
  version: string;
  documentUrl?: string;
  fileName?: string;
  fileOriginalName?: string;
  createdBy: string;
  createdOn: string;
  modifiedBy?: string;
  modifiedOn?: string;
  accessibility?: boolean;
}

// Create/Update Request
export interface CompanyPolicyRequest {
  policyTitle: string;
  policyCategoryId: number;
  policyContent: string;
  effectiveDate: string;
  statusId?: number;
  accessibility?: boolean;
  emailRequest?: boolean;
  document?: File;
}

export interface CompanyPolicyResponse {
  companyPolicyId: number;
  policyTitle: string;
  version: string;
}

// Policy Categories
export interface PolicyCategory {
  id: number;
  name: string;
}

// Policy Statuses
export interface PolicyStatus {
  id: number;
  name: string;
}
