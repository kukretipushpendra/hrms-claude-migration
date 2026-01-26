# API Contract: User Guides

## Base URL
```
{LEGACY_API_URL}/api/UserGuide
```

## Authentication
All endpoints require JWT Bearer token.

---

## Endpoints

### GET /GetAllMenu
Get list of available menus for user guides.

**Response:**
```json
{
  "data": [
    { "id": 1, "name": "Dashboard" },
    { "id": 2, "name": "Employees" },
    { "id": 3, "name": "Attendance" },
    { "id": 4, "name": "Leave Management" },
    { "id": 5, "name": "Settings" }
  ],
  "isSuccess": true,
  "message": null
}
```

---

### GET /GetUserGuideById/{id}
Get a single user guide by ID.

**Parameters:**
- `id` (path): number - Guide ID

**Response:**
```json
{
  "data": {
    "id": 1,
    "title": "Getting Started with Dashboard",
    "content": "<p>Welcome to the HRMS Dashboard...</p>",
    "status": 1,
    "menuId": 1,
    "menuName": "Dashboard",
    "roleId": null,
    "createdOn": "2026-01-15T10:00:00Z",
    "createdBy": "Admin User",
    "modifiedOn": "2026-01-20T14:30:00Z",
    "modifiedBy": "Admin User"
  },
  "isSuccess": true,
  "message": null
}
```

---

### POST /AddUserGuide
Create a new user guide.

**Request:**
```json
{
  "title": "How to Apply for Leave",
  "content": "<p>Step 1: Navigate to Leave Management...</p>",
  "status": 1,
  "menuId": 4
}
```

**Response:**
```json
{
  "data": 15,
  "isSuccess": true,
  "message": "User guide created successfully"
}
```

---

### POST /UpdateUserGuide
Update an existing user guide.

**Request:**
```json
{
  "id": 15,
  "title": "How to Apply for Leave (Updated)",
  "content": "<p>Updated content...</p>",
  "status": 1,
  "menuId": 4
}
```

**Response:**
```json
{
  "data": true,
  "isSuccess": true,
  "message": "User guide updated successfully"
}
```

---

### POST /GetAllUserGuide
Get paginated list of user guides with filters.

**Request:**
```json
{
  "searchValue": "",
  "pageNumber": 1,
  "pageSize": 25,
  "sortColumn": "createdOn",
  "sortDirection": "desc",
  "filter": {
    "title": "",
    "menuName": "",
    "status": null,
    "createdOn": null,
    "modifiedOn": null
  }
}
```

**Response:**
```json
{
  "data": {
    "totalRecords": 12,
    "userGuides": [
      {
        "id": 1,
        "title": "Getting Started with Dashboard",
        "content": "<p>Welcome to the HRMS Dashboard...</p>",
        "status": 1,
        "menuId": 1,
        "menuName": "Dashboard",
        "roleId": null,
        "createdOn": "2026-01-15T10:00:00Z",
        "createdBy": "Admin User",
        "modifiedOn": "2026-01-20T14:30:00Z",
        "modifiedBy": "Admin User"
      }
    ]
  },
  "isSuccess": true,
  "message": null
}
```

---

### POST /DeleteUserGuideById
Delete a user guide.

**Query Parameters:**
- `UserGuideId` (query): number - Guide ID to delete

**Response:**
```json
{
  "data": true,
  "isSuccess": true,
  "message": "User guide deleted successfully"
}
```

---

## TypeScript Types

```typescript
// Status Enum
export const UserGuideStatus = {
  Published: 1,
  Draft: 2
} as const;

export type UserGuideStatusValue = typeof UserGuideStatus[keyof typeof UserGuideStatus];

// Status Labels
export const USER_GUIDE_STATUS_LABEL: Record<UserGuideStatusValue, string> = {
  [UserGuideStatus.Published]: 'Published',
  [UserGuideStatus.Draft]: 'Draft'
};

// Interfaces
export interface UserGuide {
  id: number;
  title: string;
  content: string;
  status: UserGuideStatusValue;
  menuId: number;
  menuName: string;
  roleId: number | null;
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
```

---

## Error Responses

```json
{
  "data": null,
  "isSuccess": false,
  "message": "Error description"
}
```

Common errors:
- 401: Unauthorized - Invalid token
- 404: Not Found - Guide not found
- 400: Bad Request - Validation errors
