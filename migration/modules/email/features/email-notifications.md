# Feature: Email Notifications / Template Management

## Status
STATUS: human-review
PRIORITY: wave-5
COMPLEXITY: medium
DEPENDENCIES: authentication
CREATED: 2026-01-26
FRONTEND_COMPLETED: 2026-01-26
COMMIT: e2a75ad

## Overview
Email template management system for HRMS notifications. Admins can create, edit, and manage email templates for 22 different event types (birthdays, leave, grievance, etc.). Templates support dynamic placeholders that are replaced with actual data when emails are sent.

**Note:** This feature covers the frontend template management UI only. Actual email sending is handled by backend scheduled jobs and is not part of frontend migration.

## Legacy Files

### Frontend (React.js)
```
source/src/pages/Email/components/
├── EmailTable/
│   ├── index.tsx                      # Main template list view
│   ├── useTableColumn.tsx             # MRT column definitions
│   └── TableTopToolbar.tsx            # Table toolbar
├── EmailTemplate.tsx                  # Add/Edit template form
├── FilterForm.tsx                     # Filter form component
├── EmailTemplateAutoComplete.tsx      # Template type dropdown
├── EmailAutoComplete.tsx              # Email address autocomplete
└── FormTextEditor/
    ├── TextEditor.tsx                 # CKEditor 5 wrapper
    ├── FormTextEditor.tsx             # Form integration
    └── editorConfig.ts                # Editor configuration

source/src/services/Notification/
├── notificationService.ts             # API service
├── type.ts                            # TypeScript types
└── index.ts                           # Exports
```

### Backend (.NET)
```
Controllers/NotificationTemplateController.cs    # 11 endpoints
Services/NotificationTemplateService.cs          # Template CRUD
Services/EmailNotificationService.cs             # Email sending (1006 lines)
Entities/NotificationTemplate.cs                 # Template entity
Entities/EmailNotification.cs                    # Sent email entity
Enums/EmailTemplateTypes.cs                      # 22 template types
Enums/EmailTemplateStatus.cs                     # Active/Inactive
Repositories/NotificationTemplateRepository.cs   # Data access
```

## Data Models

### EmailTemplate
```typescript
interface EmailTemplate {
  id: number;
  templateName: string;
  subject: string;
  content: string;  // HTML body
  type: EmailTemplateType;
  status: EmailTemplateStatus | null;  // null = default template
  senderName: string;
  senderEmail: string;
  ccEmails: string;   // semicolon-delimited
  bccEmails: string;  // semicolon-delimited
  toEmail: string;    // semicolon-delimited
  createdOn: string;
  modifiedOn?: string;
}
```

### Enums
```typescript
// 22 Template Types
const EmailTemplateType = {
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

// Template Status
const EmailTemplateStatus = {
  Inactive: 0,
  Active: 1
} as const;
// null status = default system template
```

## API Endpoints

| Method | Endpoint | Permission | Description |
|--------|----------|------------|-------------|
| POST | /api/NotificationTemplate/GetEmailTemplates | ReadEmailNotification | List templates with filters |
| GET | /api/NotificationTemplate/{id} | ViewEmailNotification | Get template by ID |
| POST | /api/NotificationTemplate/AddEmailTemplate | CreateEmailNotification | Create new template |
| POST | /api/NotificationTemplate/UpdateEmailTemplate | EditEmailNotification | Update existing template |
| POST | /api/NotificationTemplate/ToggleEmailTemplateStatus | DeleteEmailNotification | Toggle active/inactive |
| GET | /api/NotificationTemplate/GetEmailTemplateNameList | ReadEmailNotification | Get template type options |
| GET | /api/NotificationTemplate/GetDefaultTemplate | ReadEmailNotification | Get default for type |
| POST | /api/NotificationTemplate/DeleteTemplate/{id} | - | Soft delete template |

## UI Components

### Pages/Views
1. **EmailTemplateListView** - Main template list
   - Data table with all templates
   - Filters: name, type, sender, status
   - Actions: Add, Edit, Delete, Toggle Status
   - Server-side pagination

2. **EmailTemplateFormView** - Add/Edit template
   - Mode: "add" or "edit"
   - Rich text editor for email body
   - Placeholder insertion support
   - "Set as default" checkbox (add mode only)

### Components
1. **EmailTemplateTable** - Data table component
2. **EmailTemplateFilterForm** - Filter form
3. **EmailTemplateTypeSelect** - Template type dropdown
4. **EmailBodyEditor** - CKEditor 5 rich text editor
5. **StatusToggle** - Active/Inactive toggle

## Business Logic

### Template Management Rules
1. Only one template per type can be Active at a time
2. Toggling to Active checks for existing active template
3. Default templates (status=null) cannot be deleted
4. Template type cannot be changed after creation
5. Soft delete preserves template data

### Status Behavior
- **Active (1):** Template used for sending emails
- **Inactive (0):** Template saved but not used
- **null:** System default template

### Placeholder System
Templates support dynamic placeholders replaced at send time:
```
{FirstName}, {LastName}, {SenderName}, {SenderEmail}
{StartDate}, {EndDate}, {TotalLeaveDays}, {LeaveType}
{TicketNo}, {Department}, {CreatedOn}, {Reason}
{ReportingManagerName}, {EmployeeName}, etc.
```

## Routes
```
/settings/email-and-notification              # Template list
/settings/email-and-notification/add          # Add new template
/settings/email-and-notification/edit/:id     # Edit template
```

## Validation Rules

### Template Form
- templateName: Required, max 100 chars
- subject: Required, max 200 chars
- content: Required (HTML body)
- type: Required (add mode only)
- senderName: Required
- senderEmail: Required, valid email
- ccEmails: Optional, valid emails (semicolon-separated)
- bccEmails: Optional, valid emails (semicolon-separated)

## UI Features

### Rich Text Editor (CKEditor 5)
- Bold, Italic, Underline
- Lists (ordered/unordered)
- Links
- Tables
- Placeholder insertion button
- HTML source view

### Template Type Labels
```typescript
const TEMPLATE_TYPE_LABELS = {
  1: 'Birthday',
  2: 'Anniversary',
  3: 'Welcome',
  4: 'Grievance Resolved',
  5: 'Resignation Approved',
  6: 'Leave Applied',
  7: 'Leave Approval',
  8: 'Leave Rejection',
  9: 'Resignation Applied',
  10: 'Resignation Rejected',
  11: 'Early Release Requested',
  12: 'Early Release Approved',
  13: 'Early Release Rejected',
  14: 'Account Clearance Granted',
  15: 'IT Clearance Granted',
  16: 'Grievance Submitted',
  17: 'New Role Added',
  18: 'Updated Policy',
  19: 'New Policy Added',
  20: 'KPI Complete',
  21: 'Feedback Submitted',
  22: 'Feedback Status Changed'
};
```

## Migration Notes
1. Use Vuetify rich text editor or TipTap for email body
2. Server-side pagination for template list
3. Preserve placeholder syntax exactly
4. Status toggle as switch/checkbox
5. Admin-only feature (SUPER_ADMIN role)

## Estimated Files
- 2 views (list, form)
- 3 components (table, filters, editor)
- 1 service
- 1 types file
- ~8 total files
