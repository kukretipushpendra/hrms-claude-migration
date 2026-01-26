# API Contract: Email Notifications / Template Management

## Base URL
```
{LEGACY_API_URL}/api/NotificationTemplate
```

## Authentication
All endpoints require JWT Bearer token. **Role Required:** SUPER_ADMIN

---

## Endpoints

### POST /GetEmailTemplates
Get paginated list of email templates with filters.

**Permission:** ReadEmailNotification

**Request:**
```json
{
  "searchValue": "",
  "pageNumber": 1,
  "pageSize": 1000,
  "sortColumn": "modifiedOn",
  "sortDirection": "desc",
  "filter": {
    "templateName": "",
    "senderName": "",
    "senderEmail": "",
    "templateType": null,
    "status": null
  }
}
```

**Response:**
```json
{
  "data": {
    "totalRecords": 25,
    "templates": [
      {
        "id": 1,
        "templateName": "Birthday Wishes",
        "subject": "Happy Birthday {FirstName}!",
        "content": "<p>Dear {FirstName},<br>Wishing you a wonderful birthday!</p>",
        "type": 1,
        "status": 1,
        "senderName": "HR Team",
        "senderEmail": "hr@company.com",
        "ccEmails": "manager@company.com",
        "bccEmails": "",
        "toEmail": "",
        "createdOn": "2026-01-15T10:00:00Z",
        "modifiedOn": "2026-01-20T14:30:00Z"
      }
    ]
  },
  "isSuccess": true,
  "message": null
}
```

---

### GET /{id}
Get single email template by ID.

**Permission:** ViewEmailNotification

**Parameters:**
- `id` (path): number - Template ID

**Response:**
```json
{
  "data": {
    "id": 1,
    "templateName": "Birthday Wishes",
    "subject": "Happy Birthday {FirstName}!",
    "content": "<p>Dear {FirstName},<br>Wishing you a wonderful birthday!</p>",
    "type": 1,
    "status": 1,
    "senderName": "HR Team",
    "senderEmail": "hr@company.com",
    "ccEmails": "manager@company.com",
    "bccEmails": "",
    "toEmail": "",
    "createdOn": "2026-01-15T10:00:00Z",
    "modifiedOn": "2026-01-20T14:30:00Z"
  },
  "isSuccess": true,
  "message": null
}
```

---

### POST /AddEmailTemplate
Create a new email template.

**Permission:** CreateEmailNotification

**Request:**
```json
{
  "templateName": "Leave Applied Notification",
  "subject": "Leave Application - {EmployeeName}",
  "content": "<p>Dear {ReportingManagerName},<br>{EmployeeName} has applied for leave from {StartDate} to {EndDate}.</p>",
  "type": 6,
  "senderName": "HRMS System",
  "senderEmail": "noreply@company.com",
  "ccEmails": "",
  "bccEmails": "",
  "toEmail": "",
  "isDefault": false
}
```

**Response:**
```json
{
  "data": 15,
  "isSuccess": true,
  "message": "Email template created successfully"
}
```

---

### POST /UpdateEmailTemplate
Update an existing email template.

**Permission:** EditEmailNotification

**Request:**
```json
{
  "id": 15,
  "templateName": "Leave Applied Notification Updated",
  "subject": "Leave Application - {EmployeeName}",
  "content": "<p>Dear {ReportingManagerName},<br>{EmployeeName} has applied for leave.</p>",
  "type": 6,
  "senderName": "HRMS System",
  "senderEmail": "noreply@company.com",
  "ccEmails": "hr@company.com",
  "bccEmails": "",
  "toEmail": ""
}
```

**Response:**
```json
{
  "data": true,
  "isSuccess": true,
  "message": "Email template updated successfully"
}
```

---

### POST /ToggleEmailTemplateStatus
Toggle template active/inactive status.

**Permission:** DeleteEmailNotification

**Request:**
```json
{
  "id": 15,
  "status": 1
}
```

**Response (Success):**
```json
{
  "data": true,
  "isSuccess": true,
  "message": "Status updated successfully"
}
```

**Response (Conflict - Another active exists):**
```json
{
  "data": false,
  "isSuccess": false,
  "message": "Another template is already active for this type"
}
```

---

### GET /GetEmailTemplateNameList
Get list of available template types for dropdown.

**Permission:** ReadEmailNotification

**Response:**
```json
{
  "data": [
    { "id": 1, "name": "Birthday" },
    { "id": 2, "name": "Anniversary" },
    { "id": 3, "name": "Welcome" },
    { "id": 4, "name": "Grievance Resolved" },
    { "id": 5, "name": "Resignation Approved" },
    { "id": 6, "name": "Leave Applied" },
    { "id": 7, "name": "Leave Approval" },
    { "id": 8, "name": "Leave Rejection" },
    { "id": 9, "name": "Resignation Applied" },
    { "id": 10, "name": "Resignation Rejected" },
    { "id": 11, "name": "Early Release Requested" },
    { "id": 12, "name": "Early Release Approved" },
    { "id": 13, "name": "Early Release Rejected" },
    { "id": 14, "name": "Account Clearance Granted" },
    { "id": 15, "name": "IT Clearance Granted" },
    { "id": 16, "name": "Grievance Submitted" },
    { "id": 17, "name": "New Role Added" },
    { "id": 18, "name": "Updated Policy" },
    { "id": 19, "name": "New Policy Added" },
    { "id": 20, "name": "KPI Complete" },
    { "id": 21, "name": "Feedback Submitted" },
    { "id": 22, "name": "Feedback Status Changed" }
  ],
  "isSuccess": true,
  "message": null
}
```

---

### GET /GetDefaultTemplate
Get the default template for a specific type.

**Permission:** ReadEmailNotification

**Query Parameters:**
- `type` (query): number - Template type enum value

**Response:**
```json
{
  "data": {
    "id": 1,
    "templateName": "Default Birthday Template",
    "subject": "Happy Birthday!",
    "content": "<p>Default birthday template content...</p>",
    "type": 1,
    "status": null,
    "senderName": "System",
    "senderEmail": "system@company.com",
    "ccEmails": "",
    "bccEmails": "",
    "toEmail": "",
    "createdOn": "2026-01-01T00:00:00Z",
    "modifiedOn": null
  },
  "isSuccess": true,
  "message": null
}
```

---

### POST /DeleteTemplate/{id}
Soft delete an email template.

**Parameters:**
- `id` (path): number - Template ID to delete

**Response:**
```json
{
  "data": true,
  "isSuccess": true,
  "message": "Template deleted successfully"
}
```

---

## TypeScript Types

```typescript
// Template Type Enum (22 types)
export const EmailTemplateType = {
  Birthday: 1,
  Anniversary: 2,
  Welcome: 3,
  GrievanceResolved: 4,
  ResignationApproved: 5,
  LeaveApplied: 6,
  LeaveApproval: 7,
  LeaveRejection: 8,
  ResignationApplied: 9,
  ResignationRejected: 10,
  EarlyReleaseRequested: 11,
  EarlyReleaseApproved: 12,
  EarlyReleaseRejected: 13,
  AccountClearanceGranted: 14,
  ITClearanceGranted: 15,
  GrievanceSubmitted: 16,
  NewRoleAdded: 17,
  UpdatedPolicy: 18,
  NewPolicyAdded: 19,
  KPIComplete: 20,
  FeedbackSubmitted: 21,
  FeedbackStatusChanged: 22
} as const;

export type EmailTemplateTypeValue = typeof EmailTemplateType[keyof typeof EmailTemplateType];

// Status Enum
export const EmailTemplateStatus = {
  Inactive: 0,
  Active: 1
} as const;

export type EmailTemplateStatusValue = typeof EmailTemplateStatus[keyof typeof EmailTemplateStatus];

// Template Type Labels
export const EMAIL_TEMPLATE_TYPE_LABEL: Record<EmailTemplateTypeValue, string> = {
  [EmailTemplateType.Birthday]: 'Birthday',
  [EmailTemplateType.Anniversary]: 'Anniversary',
  [EmailTemplateType.Welcome]: 'Welcome',
  [EmailTemplateType.GrievanceResolved]: 'Grievance Resolved',
  [EmailTemplateType.ResignationApproved]: 'Resignation Approved',
  [EmailTemplateType.LeaveApplied]: 'Leave Applied',
  [EmailTemplateType.LeaveApproval]: 'Leave Approval',
  [EmailTemplateType.LeaveRejection]: 'Leave Rejection',
  [EmailTemplateType.ResignationApplied]: 'Resignation Applied',
  [EmailTemplateType.ResignationRejected]: 'Resignation Rejected',
  [EmailTemplateType.EarlyReleaseRequested]: 'Early Release Requested',
  [EmailTemplateType.EarlyReleaseApproved]: 'Early Release Approved',
  [EmailTemplateType.EarlyReleaseRejected]: 'Early Release Rejected',
  [EmailTemplateType.AccountClearanceGranted]: 'Account Clearance Granted',
  [EmailTemplateType.ITClearanceGranted]: 'IT Clearance Granted',
  [EmailTemplateType.GrievanceSubmitted]: 'Grievance Submitted',
  [EmailTemplateType.NewRoleAdded]: 'New Role Added',
  [EmailTemplateType.UpdatedPolicy]: 'Updated Policy',
  [EmailTemplateType.NewPolicyAdded]: 'New Policy Added',
  [EmailTemplateType.KPIComplete]: 'KPI Complete',
  [EmailTemplateType.FeedbackSubmitted]: 'Feedback Submitted',
  [EmailTemplateType.FeedbackStatusChanged]: 'Feedback Status Changed'
};

// Status Labels
export const EMAIL_TEMPLATE_STATUS_LABEL: Record<EmailTemplateStatusValue, string> = {
  [EmailTemplateStatus.Inactive]: 'Inactive',
  [EmailTemplateStatus.Active]: 'Active'
};

// Interfaces
export interface EmailTemplate {
  id: number;
  templateName: string;
  subject: string;
  content: string;
  type: EmailTemplateTypeValue;
  status: EmailTemplateStatusValue | null;
  senderName: string;
  senderEmail: string;
  ccEmails: string;
  bccEmails: string;
  toEmail: string;
  createdOn: string;
  modifiedOn?: string | null;
}

export interface EmailTemplateTypeOption {
  id: EmailTemplateTypeValue;
  name: string;
}

// Request DTOs
export interface EmailTemplateSearchFilter {
  templateName?: string;
  senderName?: string;
  senderEmail?: string;
  templateType?: EmailTemplateTypeValue | null;
  status?: EmailTemplateStatusValue | null;
}

export interface AddEmailTemplateRequest {
  templateName: string;
  subject: string;
  content: string;
  type: EmailTemplateTypeValue;
  senderName: string;
  senderEmail: string;
  ccEmails?: string;
  bccEmails?: string;
  toEmail?: string;
  isDefault?: boolean;
}

export interface UpdateEmailTemplateRequest {
  id: number;
  templateName: string;
  subject: string;
  content: string;
  type: EmailTemplateTypeValue;
  senderName: string;
  senderEmail: string;
  ccEmails?: string;
  bccEmails?: string;
  toEmail?: string;
}

export interface ToggleStatusRequest {
  id: number;
  status: EmailTemplateStatusValue;
}

// Response DTOs
export interface EmailTemplateListResponse {
  totalRecords: number;
  templates: EmailTemplate[];
}
```

---

## Status Values

| Value | Label | Description |
|-------|-------|-------------|
| 0 | Inactive | Template saved but not used |
| 1 | Active | Template used for sending |
| null | Default | System default template |

---

## Available Placeholders

Templates support these dynamic placeholders:

| Placeholder | Description |
|-------------|-------------|
| `{FirstName}` | Employee first name |
| `{LastName}` | Employee last name |
| `{EmployeeName}` | Full employee name |
| `{SenderName}` | Email sender name |
| `{SenderEmail}` | Email sender address |
| `{StartDate}` | Leave/event start date |
| `{EndDate}` | Leave/event end date |
| `{TotalLeaveDays}` | Total leave days |
| `{LeaveType}` | Type of leave |
| `{CreatedOn}` | Creation date |
| `{Reason}` | Reason/description |
| `{RejectReason}` | Rejection reason |
| `{TicketNo}` | Ticket/grievance number |
| `{Department}` | Department name |
| `{ReportingManagerName}` | Manager's name |
| `{ResignationDate}` | Resignation date |
| `{LastWorkingDate}` | Last working day |
| `{RoleName}` | Role name |
| `{DocumentName}` | Document/policy name |
| `{Branch}` | Branch name |
| `{ReviewDate}` | Review/KPI date |

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
- 403: Forbidden - Not SUPER_ADMIN
- 404: Not Found - Template not found
- 400: Bad Request - Validation errors
- 409: Conflict - Another active template exists for type
