// Grievance Management Types

// Enums (using const object pattern)
export const GrievanceStatus = {
  Open: 1,
  InProgress: 2,
  Resolved: 3,
  Closed: 4,
  Escalated: 5,
} as const;

export type GrievanceStatusType = (typeof GrievanceStatus)[keyof typeof GrievanceStatus];

export const GrievanceLevel = {
  L1: 1,
  L2: 2,
  L3: 3,
} as const;

export type GrievanceLevelType = (typeof GrievanceLevel)[keyof typeof GrievanceLevel];

// Status Labels
export const GRIEVANCE_STATUS_LABEL: Record<GrievanceStatusType, string> = {
  [GrievanceStatus.Open]: 'Open',
  [GrievanceStatus.InProgress]: 'In Progress',
  [GrievanceStatus.Resolved]: 'Resolved',
  [GrievanceStatus.Closed]: 'Closed',
  [GrievanceStatus.Escalated]: 'Escalated',
};

// Level Labels
export const GRIEVANCE_LEVEL_LABEL: Record<GrievanceLevelType, string> = {
  [GrievanceLevel.L1]: 'L1',
  [GrievanceLevel.L2]: 'L2',
  [GrievanceLevel.L3]: 'L3',
};

// Core Interfaces
export interface GrievanceType {
  id: number;
  grievanceName: string;
  description: string;
  l1TatHours: number;
  l2TatHours: number;
  l3TatDays: number;
  isActive: boolean;
  isAutoEscalation: boolean;
  owners?: GrievanceOwner[];
  createdDate?: string;
  modifiedDate?: string;
}

export interface GrievanceOwner {
  id?: number;
  grievanceTypeId?: number;
  level: number;
  ownerId: number;
  ownerName?: string;
  ownerEmail?: string;
}

export interface EmployeeGrievance {
  id: number;
  ticketNo: string;
  grievanceTypeId: number;
  grievanceTypeName?: string;
  level: number;
  employeeId: number;
  employeeName?: string;
  employeeCode?: string;
  designation?: string;
  title: string;
  description?: string;
  attachmentPath?: string;
  fileOriginalName?: string;
  status: GrievanceStatusType;
  statusName?: string;
  tatStatus?: boolean;
  resolvedDate?: string;
  managedBy?: string;
  createdDate: string;
  modifiedDate?: string;
}

export interface GrievanceRemarks {
  id: number;
  grievanceId: number;
  remarks: string;
  attachmentPath?: string;
  createdById: number;
  createdByName?: string;
  designation?: string;
  createdDate: string;
}

export interface GrievanceTicketData {
  grievance: EmployeeGrievance;
  remarks: GrievanceRemarks[];
}

// Request DTOs
export interface SubmitGrievanceRequest {
  grievanceTypeId: number;
  title: string;
  description?: string;
  attachment?: File;
}

export interface EmployeeGrievanceFilter {
  grievanceTypeId?: number | null;
  status?: GrievanceStatusType | null;
}

export interface AdminGrievanceFilter extends EmployeeGrievanceFilter {
  level?: number | null;
  tatStatus?: boolean | null;
  fromDate?: string | null;
  toDate?: string | null;
  createdById?: number | null;
}

export interface UpdateRemarksRequest {
  grievanceId: number;
  remarks: string;
  status?: GrievanceStatusType;
  attachment?: File;
}

export interface GrievanceTypeRequest {
  id?: number;
  grievanceName: string;
  description: string;
  l1TatHours: number;
  l2TatHours: number;
  l3TatDays: number;
  isActive: boolean;
  isAutoEscalation: boolean;
  owners: GrievanceOwner[];
}

// Response DTOs
export interface SubmitGrievanceResponse {
  id: number;
  ticketNo: string;
}

// Paginated Response
export interface PaginatedGrievanceResponse {
  items: EmployeeGrievance[];
  totalCount: number;
  pageNumber: number;
  pageSize: number;
}

// API Pagination Request
export interface GrievancePaginationRequest {
  searchValue?: string;
  pageNumber: number;
  pageSize: number;
  sortColumn?: string;
  sortDirection?: 'asc' | 'desc';
  filter: EmployeeGrievanceFilter | AdminGrievanceFilter;
}

// Simple type list (for dropdowns)
export interface GrievanceTypeSimple {
  id: number;
  grievanceName: string;
  description: string;
}
