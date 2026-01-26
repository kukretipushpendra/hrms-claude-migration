# API Contract: Support/Feedback Management

## Base URL
```
{LEGACY_API_URL}/api/Feedback
```

**Note:** Backend uses "Feedback" terminology for all endpoints.

## Authentication
All endpoints require JWT Bearer token in Authorization header.

---

## Endpoints

### POST /AddFeedback
Create a new support ticket.

**Permission:** CreateSupport

**Content-Type:** multipart/form-data

**Request (FormData):**
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| employeeId | number | Yes | Employee submitting ticket |
| feedbackType | number | Yes | 1=Bug, 2=Suggestion |
| subject | string | Yes | Max 200 chars |
| description | string | Yes | Max 600 chars |
| attachment | file | No | Max 5MB |

**Response:**
```json
{
  "data": {
    "id": 123,
    "ticketId": "SUP-2026-00123"
  },
  "isSuccess": true,
  "message": "Support ticket created successfully"
}
```

---

### GET /GetFeedbackById/{id}
Get support ticket details by ID.

**Permission:** ReadSupport

**Parameters:**
- `id` (path): number - Feedback/ticket ID

**Response:**
```json
{
  "data": {
    "id": 123,
    "employeeId": 1001,
    "employeeName": "John Doe",
    "employeeEmail": "john.doe@company.com",
    "ticketStatus": 0,
    "feedbackType": 1,
    "subject": "Login button not working",
    "description": "When I click the login button, nothing happens...",
    "adminComment": null,
    "attachmentPath": "/files/feedback/123/screenshot.png",
    "fileOriginalName": "screenshot.png",
    "createdOn": "2026-01-25T09:30:00Z",
    "modifiedOn": null
  },
  "isSuccess": true,
  "message": null
}
```

---

### POST /GetFeedbackList
Get all support tickets with filters (admin).

**Permission:** ReadAllSupport

**Request:**
```json
{
  "searchValue": "",
  "pageNumber": 1,
  "pageSize": 10,
  "sortColumn": "createdOn",
  "sortDirection": "desc",
  "filter": {
    "ticketStatus": null,
    "feedbackType": null,
    "searchQuery": "",
    "createdOnFrom": "2026-01-01",
    "createdOnTo": "2026-01-31",
    "employeeCodes": []
  }
}
```

**Response:**
```json
{
  "data": {
    "totalRecords": 45,
    "feedbackList": [
      {
        "id": 123,
        "employeeId": 1001,
        "employeeName": "John Doe",
        "employeeEmail": "john.doe@company.com",
        "ticketStatus": 0,
        "feedbackType": 1,
        "subject": "Login button not working",
        "description": "When I click the login button...",
        "adminComment": null,
        "attachmentPath": "/files/feedback/123/screenshot.png",
        "fileOriginalName": "screenshot.png",
        "createdOn": "2026-01-25T09:30:00Z",
        "modifiedOn": null
      }
    ]
  },
  "isSuccess": true,
  "message": null
}
```

---

### POST /GetFeedbackByEmployee
Get employee's own support tickets.

**Permission:** ReadSupport

**Request:**
```json
{
  "searchValue": "",
  "pageNumber": 1,
  "pageSize": 10,
  "sortColumn": "createdOn",
  "sortDirection": "desc",
  "filter": {
    "ticketStatus": null,
    "feedbackType": null
  }
}
```

**Response:**
```json
{
  "data": {
    "totalRecords": 5,
    "feedbackList": [
      {
        "id": 123,
        "ticketStatus": 0,
        "feedbackType": 1,
        "subject": "Login button not working",
        "description": "When I click the login button...",
        "adminComment": null,
        "createdOn": "2026-01-25T09:30:00Z",
        "modifiedOn": null
      }
    ]
  },
  "isSuccess": true,
  "message": null
}
```

**Note:** Employee endpoint does not return employee name/email (current user assumed).

---

### POST /ModifyFeedbackStatus
Update ticket status and add admin comment.

**Permission:** EditSupport

**Request:**
```json
{
  "id": 123,
  "ticketStatus": 1,
  "adminComment": "We are looking into this issue. Will update soon."
}
```

**Response:**
```json
{
  "data": true,
  "isSuccess": true,
  "message": "Feedback status updated successfully"
}
```

---

## TypeScript Types

```typescript
// Enums
export const FeedbackType = {
  Bug: 1,
  Suggestion: 2
} as const;

export type FeedbackTypeValue = typeof FeedbackType[keyof typeof FeedbackType];

export const FeedbackStatus = {
  Open: 0,
  InProgress: 1,
  UnableToReproduce: 2,
  NotFixing: 3,
  NotApplicable: 4,
  Closed: 5
} as const;

export type FeedbackStatusType = typeof FeedbackStatus[keyof typeof FeedbackStatus];

// Labels
export const FEEDBACK_TYPE_LABEL: Record<FeedbackTypeValue, string> = {
  [FeedbackType.Bug]: 'Bug',
  [FeedbackType.Suggestion]: 'Suggestion'
};

export const FEEDBACK_STATUS_LABEL: Record<FeedbackStatusType, string> = {
  [FeedbackStatus.Open]: 'Open',
  [FeedbackStatus.InProgress]: 'In Progress',
  [FeedbackStatus.UnableToReproduce]: 'Unable to Reproduce',
  [FeedbackStatus.NotFixing]: 'Not Fixing',
  [FeedbackStatus.NotApplicable]: 'Not Applicable',
  [FeedbackStatus.Closed]: 'Closed'
};

// Interfaces
export interface Feedback {
  id: number;
  employeeId: number;
  employeeName?: string;
  employeeEmail?: string;
  ticketStatus: FeedbackStatusType;
  feedbackType: FeedbackTypeValue;
  subject: string;
  description: string;
  adminComment?: string;
  attachmentPath?: string;
  fileOriginalName?: string;
  createdOn: string;
  modifiedOn?: string;
}

export interface EmployeeFeedback {
  id: number;
  ticketStatus: FeedbackStatusType;
  feedbackType: FeedbackTypeValue;
  subject: string;
  description: string;
  adminComment?: string;
  createdOn: string;
  modifiedOn?: string;
}

// Request DTOs
export interface AddFeedbackRequest {
  employeeId: number;
  feedbackType: FeedbackTypeValue;
  subject: string;
  description: string;
  attachment?: File;
}

export interface FeedbackSearchFilter {
  ticketStatus?: FeedbackStatusType | null;
  feedbackType?: FeedbackTypeValue | null;
  searchQuery?: string;
  createdOnFrom?: string | null;
  createdOnTo?: string | null;
  employeeCodes?: string[];
}

export interface EmployeeFeedbackFilter {
  ticketStatus?: FeedbackStatusType | null;
  feedbackType?: FeedbackTypeValue | null;
}

export interface ModifyStatusRequest {
  id: number;
  ticketStatus: FeedbackStatusType;
  adminComment: string;
}

// Response DTOs
export interface AddFeedbackResponse {
  id: number;
  ticketId?: string;
}

export interface FeedbackListResponse {
  totalRecords: number;
  feedbackList: Feedback[];
}

export interface EmployeeFeedbackListResponse {
  totalRecords: number;
  feedbackList: EmployeeFeedback[];
}
```

---

## Status Colors (UI Mapping)

| Status | Value | Color | Icon |
|--------|-------|-------|------|
| Open | 0 | Blue (info) | mdi-circle-outline |
| In Progress | 1 | Orange (warning) | mdi-progress-clock |
| Unable to Reproduce | 2 | Grey | mdi-help-circle |
| Not Fixing | 3 | Red (error) | mdi-close-circle |
| Not Applicable | 4 | Grey | mdi-minus-circle |
| Closed | 5 | Green (success) | mdi-check-circle |

---

## Filter Date Presets

| Preset | Days Back |
|--------|-----------|
| Last 15 Days | 15 |
| Last 30 Days | 30 |
| Last 90 Days | 90 |
| Custom | User-defined |

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
- 404: Not Found - Ticket not found
- 400: Bad Request - Validation errors

---

## Permissions

| Permission | Description |
|------------|-------------|
| CreateSupport | Submit new tickets |
| ReadSupport | View own tickets, view detail |
| ReadAllSupport | View all tickets (admin) |
| EditSupport | Update ticket status |
