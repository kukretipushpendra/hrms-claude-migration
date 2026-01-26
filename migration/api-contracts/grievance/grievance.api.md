# API Contract: Grievance Management

## Base URL
```
{LEGACY_API_URL}/api/Grievance
```

## Authentication
All endpoints require JWT Bearer token in Authorization header.

---

## Configuration Endpoints (Admin)

### GET /GetAllGrievancesList
Get all grievance types with their owners for configuration.

**Permission:** ReadGrievancesConfiguration

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "grievanceName": "IT Support",
      "description": "Technical issues",
      "l1TatHours": 4,
      "l2TatHours": 8,
      "l3TatDays": 2,
      "isActive": true,
      "isAutoEscalation": true,
      "owners": [
        { "level": 1, "ownerId": 101, "ownerName": "John Doe" },
        { "level": 2, "ownerId": 102, "ownerName": "Jane Smith" },
        { "level": 3, "ownerId": 103, "ownerName": "Admin User" }
      ],
      "createdDate": "2026-01-15T10:00:00Z"
    }
  ],
  "isSuccess": true,
  "message": null
}
```

---

### GET /GetAllGrievanceTypeList
Get active grievance types for dropdown selection.

**Permission:** CreateGrievances

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "grievanceName": "IT Support",
      "description": "Technical issues"
    },
    {
      "id": 2,
      "grievanceName": "HR Policy",
      "description": "HR related concerns"
    }
  ],
  "isSuccess": true,
  "message": null
}
```

---

### GET /GetGrievanceTypeById/{grievanceTypeId}
Get grievance type details by ID.

**Permission:** ReadGrievancesConfiguration

**Parameters:**
- `grievanceTypeId` (path): number - Grievance type ID

**Response:**
```json
{
  "data": {
    "id": 1,
    "grievanceName": "IT Support",
    "description": "Technical issues",
    "l1TatHours": 4,
    "l2TatHours": 8,
    "l3TatDays": 2,
    "isActive": true,
    "isAutoEscalation": true,
    "owners": [
      { "id": 10, "level": 1, "ownerId": 101, "ownerName": "John Doe", "ownerEmail": "john@company.com" },
      { "id": 11, "level": 2, "ownerId": 102, "ownerName": "Jane Smith", "ownerEmail": "jane@company.com" },
      { "id": 12, "level": 3, "ownerId": 103, "ownerName": "Admin User", "ownerEmail": "admin@company.com" }
    ]
  },
  "isSuccess": true,
  "message": null
}
```

---

### POST /AddGrievance
Create a new grievance type with owners.

**Permission:** ReadGrievancesConfiguration

**Request:**
```json
{
  "grievanceName": "Facilities",
  "description": "Office facilities issues",
  "l1TatHours": 6,
  "l2TatHours": 12,
  "l3TatDays": 3,
  "isActive": true,
  "isAutoEscalation": false,
  "owners": [
    { "level": 1, "ownerId": 101 },
    { "level": 2, "ownerId": 102 },
    { "level": 3, "ownerId": 103 }
  ]
}
```

**Response:**
```json
{
  "data": 5,
  "isSuccess": true,
  "message": "Grievance type created successfully"
}
```

---

### POST /UpdateGrievance
Update an existing grievance type.

**Permission:** EditGrievances

**Request:**
```json
{
  "id": 1,
  "grievanceName": "IT Support Updated",
  "description": "Technical and IT issues",
  "l1TatHours": 4,
  "l2TatHours": 8,
  "l3TatDays": 2,
  "isActive": true,
  "isAutoEscalation": true,
  "owners": [
    { "id": 10, "level": 1, "ownerId": 101 },
    { "id": 11, "level": 2, "ownerId": 102 },
    { "id": 12, "level": 3, "ownerId": 103 }
  ]
}
```

**Response:**
```json
{
  "data": true,
  "isSuccess": true,
  "message": "Grievance type updated successfully"
}
```

---

### POST /DeleteGrievance/{grievanceTypeId}
Soft delete a grievance type.

**Permission:** DeleteGrievances

**Parameters:**
- `grievanceTypeId` (path): number - Grievance type ID to delete

**Response:**
```json
{
  "data": true,
  "isSuccess": true,
  "message": "Grievance type deleted successfully"
}
```

---

## Employee Grievance Endpoints

### POST /SubmitGrievance
Submit a new grievance (employee).

**Permission:** ReadGrievances

**Content-Type:** multipart/form-data

**Request (FormData):**
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| grievanceTypeId | number | Yes | Grievance type |
| title | string | Yes | Grievance title |
| description | string | No | Detailed description |
| attachment | file | No | Supporting document |

**Response:**
```json
{
  "data": {
    "id": 123,
    "ticketNo": "GRV-2026-00123"
  },
  "isSuccess": true,
  "message": "Grievance submitted successfully"
}
```

---

### POST /GetEmployeeGrievancesById/{EmployeeId}
Get paginated list of employee's grievances.

**Permission:** ReadGrievances

**Parameters:**
- `EmployeeId` (path): number - Employee ID

**Request:**
```json
{
  "searchValue": "",
  "pageNumber": 1,
  "pageSize": 10,
  "sortColumn": "createdDate",
  "sortDirection": "desc",
  "filter": {
    "grievanceTypeId": null,
    "status": null
  }
}
```

**Response:**
```json
{
  "data": {
    "items": [
      {
        "id": 123,
        "ticketNo": "GRV-2026-00123",
        "grievanceTypeId": 1,
        "grievanceTypeName": "IT Support",
        "title": "Laptop not working",
        "status": 1,
        "statusName": "Open",
        "level": 1,
        "createdDate": "2026-01-25T09:00:00Z"
      }
    ],
    "totalCount": 15,
    "pageNumber": 1,
    "pageSize": 10
  },
  "isSuccess": true,
  "message": null
}
```

---

### GET /GetEmployeeGrievancesDetail/{TicketId}
Get grievance details by ticket ID.

**Permission:** ViewGrievances

**Parameters:**
- `TicketId` (path): number - Grievance ID

**Response:**
```json
{
  "data": {
    "id": 123,
    "ticketNo": "GRV-2026-00123",
    "grievanceTypeId": 1,
    "grievanceTypeName": "IT Support",
    "level": 1,
    "employeeId": 1001,
    "employeeName": "Employee Name",
    "title": "Laptop not working",
    "description": "<p>My laptop has issues...</p>",
    "attachmentPath": "/files/grievances/123/doc.pdf",
    "fileOriginalName": "document.pdf",
    "status": 1,
    "statusName": "Open",
    "tatStatus": true,
    "resolvedDate": null,
    "managedBy": "John Doe",
    "createdDate": "2026-01-25T09:00:00Z",
    "modifiedDate": null
  },
  "isSuccess": true,
  "message": null
}
```

---

### GET /GrievanceViewAllowed/{grievanceId}
Check if current user can view this grievance.

**Parameters:**
- `grievanceId` (path): number - Grievance ID

**Response:**
```json
{
  "data": true,
  "isSuccess": true,
  "message": null
}
```

---

## Remarks & Resolution Endpoints

### GET /GetEmployeeGrievanceRemarksDetail/{ticketId}
Get all remarks for a grievance ticket.

**Parameters:**
- `ticketId` (path): number - Grievance ID

**Response:**
```json
{
  "data": {
    "grievance": {
      "id": 123,
      "ticketNo": "GRV-2026-00123",
      "grievanceTypeId": 1,
      "grievanceTypeName": "IT Support",
      "level": 2,
      "employeeId": 1001,
      "employeeName": "Employee Name",
      "designation": "Software Engineer",
      "title": "Laptop not working",
      "description": "<p>My laptop has issues...</p>",
      "attachmentPath": "/files/grievances/123/doc.pdf",
      "fileOriginalName": "document.pdf",
      "status": 5,
      "statusName": "Escalated",
      "createdDate": "2026-01-25T09:00:00Z"
    },
    "remarks": [
      {
        "id": 1,
        "grievanceId": 123,
        "remarks": "Looking into this issue",
        "attachmentPath": null,
        "createdById": 101,
        "createdByName": "John Doe",
        "designation": "IT Manager",
        "createdDate": "2026-01-25T10:00:00Z"
      },
      {
        "id": 2,
        "grievanceId": 123,
        "remarks": "Escalating to L2 for further review",
        "attachmentPath": null,
        "createdById": 101,
        "createdByName": "John Doe",
        "designation": "IT Manager",
        "createdDate": "2026-01-25T14:00:00Z"
      }
    ]
  },
  "isSuccess": true,
  "message": null
}
```

---

### POST /UpdateEmployeeGrievanceRemarks
Add remarks and optionally escalate or resolve.

**Content-Type:** multipart/form-data

**Request (FormData):**
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| grievanceId | number | Yes | Grievance ID |
| remarks | string | Yes | Remark text |
| status | number | No | 3=Resolved, 5=Escalated |
| attachment | file | No | Supporting document |

**Response:**
```json
{
  "data": true,
  "isSuccess": true,
  "message": "Remarks added successfully"
}
```

---

### GET /UpdateRemarksAllowed
Check if current user can add remarks to this grievance.

**Query Parameters:**
- `grievanceTypeId` (query): number - Grievance type ID
- `level` (query): number - Current grievance level

**Response:**
```json
{
  "data": true,
  "isSuccess": true,
  "message": null
}
```

---

### GET /GrievanceResolvedEmail/{ticketNo}
Send resolution notification email.

**Parameters:**
- `ticketNo` (path): string - Ticket number

**Response:**
```json
{
  "data": true,
  "isSuccess": true,
  "message": "Email sent successfully"
}
```

---

## Admin Reporting Endpoints

### POST /GetAllEmployeeGrievances
Get all grievances with advanced filtering (admin).

**Permission:** ReadAllGrievances

**Request:**
```json
{
  "searchValue": "",
  "pageNumber": 1,
  "pageSize": 10,
  "sortColumn": "createdDate",
  "sortDirection": "desc",
  "filter": {
    "grievanceTypeId": null,
    "status": null,
    "level": null,
    "tatStatus": null,
    "fromDate": null,
    "toDate": null,
    "createdById": null
  }
}
```

**Response:**
```json
{
  "data": {
    "items": [
      {
        "id": 123,
        "ticketNo": "GRV-2026-00123",
        "grievanceTypeId": 1,
        "grievanceTypeName": "IT Support",
        "employeeId": 1001,
        "employeeName": "Employee Name",
        "employeeCode": "EMP001",
        "title": "Laptop not working",
        "status": 1,
        "statusName": "Open",
        "level": 1,
        "tatStatus": true,
        "managedBy": "John Doe",
        "resolvedDate": null,
        "createdDate": "2026-01-25T09:00:00Z"
      }
    ],
    "totalCount": 150,
    "pageNumber": 1,
    "pageSize": 10
  },
  "isSuccess": true,
  "message": null
}
```

---

### POST /ExportGrievanceReport
Export grievances to Excel.

**Permission:** ReadAllGrievances

**Query Parameters:**
- `format` (query): string - "excel"

**Request:** Same as GetAllEmployeeGrievances

**Response:**
- Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
- Binary Excel file

---

## TypeScript Types

```typescript
// Enums
export const GrievanceStatus = {
  Open: 1,
  InProgress: 2,
  Resolved: 3,
  Closed: 4,
  Escalated: 5
} as const;

export type GrievanceStatusType = typeof GrievanceStatus[keyof typeof GrievanceStatus];

export const GrievanceLevel = {
  L1: 1,
  L2: 2,
  L3: 3
} as const;

export type GrievanceLevelType = typeof GrievanceLevel[keyof typeof GrievanceLevel];

// Interfaces
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
}

export interface GrievanceOwner {
  id?: number;
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
```

---

## Status Mappings

| Status Value | Label | Color | Use Case |
|--------------|-------|-------|----------|
| 1 | Open | Blue (info) | New grievance |
| 2 | InProgress | Blue (info) | Being worked on |
| 3 | Resolved | Green (success) | Completed |
| 4 | Closed | Grey | Archived |
| 5 | Escalated | Orange/Red | Moved to higher level |

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
- 401: Unauthorized - Invalid or expired token
- 403: Forbidden - Insufficient permissions
- 404: Not Found - Grievance/Type not found
- 400: Bad Request - Validation errors
