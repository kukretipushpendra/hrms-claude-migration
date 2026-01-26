// Nominee types matching .NET backend API contracts

export interface NomineeItem {
  id: number;
  employeeId: number;
  employeeName?: string;
  nomineeName: string;
  dob: string;
  age: number;
  careOf: string;
  relationshipName: string;
  relationshipId?: string;
  others: string;
  percentage: number;
  isNomineeMinor: boolean;
  idProofDocType?: string;
  fileName?: string;
  fileOriginalName?: string;
}

export interface NomineeSearchFilter {
  nomineeName?: string;
  relationshipId?: number | string;
  employeeId?: number;
  others?: string;
}

export interface GetNomineeListRequest {
  sortColumnName: string;
  sortDirection: string;
  startIndex: number;
  pageSize: number;
  filters: NomineeSearchFilter;
}

export interface GetNomineeListResponse {
  nomineeList: NomineeItem[];
  totalRecords: number;
  totalPercentage: number;
}

export interface NomineeRelationship {
  id: number;
  name: string;
}

export interface AddNomineeRequest {
  EmployeeId: number;
  NomineeName: string;
  DOB: string;
  Age: number;
  CareOf: string;
  Relationship: number;
  Others: string;
  Percentage: number;
  File?: File | null;
  IdProofDocType: number;
}

export interface UpdateNomineeRequest {
  Id: number;
  EmployeeId: number;
  NomineeName: string;
  DOB: string;
  Age: number;
  CareOf: string;
  Relationship: number;
  Others: string;
  Percentage: number;
  File?: File | string;
  IdProofDocType: number;
}

export interface CrudResult {
  isSuccess: boolean;
  message: string;
}
