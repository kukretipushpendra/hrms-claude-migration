// User Guide Management Types

// Enums (using const object pattern)
export const UserGuideStatus = {
  Published: 1,
  Draft: 2,
} as const;

export type UserGuideStatusValue = (typeof UserGuideStatus)[keyof typeof UserGuideStatus];

// Status Labels
export const USER_GUIDE_STATUS_LABEL: Record<UserGuideStatusValue, string> = {
  [UserGuideStatus.Published]: 'Published',
  [UserGuideStatus.Draft]: 'Draft',
};

// Core Interfaces
export interface UserGuide {
  id: number;
  title: string;
  content: string; // Rich text HTML
  status: UserGuideStatusValue;
  menuId: number;
  menuName: string;
  roleId: number | null; // Role-based access (currently null)
  createdOn: string;
  createdBy: string;
  modifiedOn: string | null;
  modifiedBy: string | null;
}

export interface MenuOption {
  id: number;
  name: string;
}

// Request DTOs
export interface UserGuideFilter {
  title?: string;
  menuName?: string;
  status?: UserGuideStatusValue | null;
  createdOn?: string | null;
  modifiedOn?: string | null;
}

export interface UserGuidePaginationRequest {
  searchValue?: string;
  pageNumber: number;
  pageSize: number;
  sortColumn?: string;
  sortDirection?: 'asc' | 'desc';
  filter: UserGuideFilter;
}

export interface AddUserGuideRequest {
  title: string;
  content: string;
  status: UserGuideStatusValue;
  menuId: number;
}

export interface UpdateUserGuideRequest {
  id: number;
  title: string;
  content: string;
  status: UserGuideStatusValue;
  menuId: number;
}

// Response DTOs
export interface UserGuideListResponse {
  totalRecords: number;
  userGuides: UserGuide[];
}
