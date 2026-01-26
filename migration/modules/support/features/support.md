# Feature: Support/Feedback Management

## Status
STATUS: complete
APPROVED: 2026-01-27
PRIORITY: wave-5
COMPLEXITY: medium
DEPENDENCIES: authentication, employee-management
CREATED: 2026-01-26
FRONTEND_COMPLETE: 2026-01-26
MERGED_TO: feature/hrms-migration
COMMIT: 6e46258

## Overview
Support ticket system allowing employees to submit bugs and suggestions, and admins to manage and respond to tickets. Includes file attachments, status tracking, and email notifications.

**Note:** Backend uses "Feedback" terminology, frontend uses "Support" - maintain this pattern.

## Legacy Files

### Frontend (React.js)
```
source/src/services/Support/
├── index.ts
├── supportService.ts               # API service (5 endpoints)
└── types.ts                        # TypeScript types

source/src/pages/Support/
├── SupportAdminPage/
│   ├── index.tsx                   # Admin tickets list
│   ├── useTableColums.tsx          # MRT column definitions
│   ├── SupportAdminPageFilter.tsx  # Admin filter form
│   └── TableTopToolBar.tsx         # Table toolbar
├── SupportEmployeePage/
│   ├── index.tsx                   # My tickets list
│   ├── useTableColumns.tsx         # MRT column definitions
│   └── SupportEmployeeTableFilter.tsx # Employee filter
└── SupportDetailPage/
    ├── index.tsx                   # Ticket detail view
    └── UpdateStatusDialog.tsx      # Status update dialog

source/src/layout/Dashboard/Header/HeaderContent/SubmitSupportPage/
├── index.tsx                       # Header support button
├── SupportDialog.tsx               # Submit ticket dialog
└── validationSchema.ts             # Form validation
```

### Backend (.NET)
```
Controllers/FeedbackController.cs           # 5 endpoints
Services/FeedbackService.cs                 # Business logic
Services/Interfaces/IFeedbackService.cs     # Interface
Repositories/FeedbackRepository.cs          # Dapper data access
Interface/IFeedbackRepository.cs            # Repository interface
Entities/Feedback.cs                        # Feedback entity
Enums/FeedbackType.cs                       # Bug/Suggestion enum
Models/Feedback/*.cs                        # DTOs (7 files)
```

## Data Models

### Feedback (Entity)
```typescript
interface Feedback {
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
```

### Enums
```typescript
// Feedback Type (Bug/Suggestion)
const FeedbackType = {
  Bug: 1,
  Suggestion: 2
} as const;

// Ticket Status
const FeedbackStatus = {
  Open: 0,
  InProgress: 1,
  UnableToReproduce: 2,
  NotFixing: 3,
  NotApplicable: 4,
  Closed: 5
} as const;
```

## API Endpoints

| Method | Endpoint | Permission | Description |
|--------|----------|------------|-------------|
| POST | /api/Feedback/AddFeedback | CreateSupport | Create ticket (FormData) |
| GET | /api/Feedback/GetFeedbackById/{id} | ReadSupport | Get ticket details |
| POST | /api/Feedback/GetFeedbackList | ReadAllSupport | Admin: all tickets |
| POST | /api/Feedback/GetFeedbackByEmployee | ReadSupport | Employee: own tickets |
| POST | /api/Feedback/ModifyFeedbackStatus | EditSupport | Update ticket status |

## UI Components

### Pages/Views
1. **SupportAdminView** - Admin tickets list
   - Server-side pagination
   - Advanced filters (status, type, date range, search)
   - MRT data table
   - Link to details

2. **MySupportView** - Employee's tickets list
   - Server-side pagination
   - Basic filters (status, type)
   - View own tickets only

3. **SupportDetailView** - Ticket detail page
   - Full ticket info
   - Admin comment display
   - File attachment viewer
   - Edit status button (admin only)

4. **SubmitSupportButton** - Header icon button
   - Opens submit dialog
   - Accessible from all pages

### Dialogs
1. **SubmitSupportDialog** - Create ticket form
   - Pre-filled name/email from auth
   - Type selection (Bug/Suggestion)
   - Subject input (max 200 chars)
   - Description textarea (max 600 chars)
   - File upload (max 5MB)

2. **UpdateStatusDialog** - Admin status update
   - Status dropdown
   - Admin comment (max 600 chars)
   - Pre-filled with current values

### Filter Forms
1. **AdminFilterForm** - Full filtering
   - Status dropdown
   - Type dropdown
   - Search query
   - Date range (15/30/90 days or custom)

2. **EmployeeFilterForm** - Basic filtering
   - Status dropdown
   - Type dropdown

## Business Logic

### Submit Ticket Flow
1. Employee clicks Support icon in header
2. Dialog opens with name/email pre-filled
3. Employee fills form and attaches file
4. Backend validates and stores
5. File uploaded to blob storage
6. Email notification sent
7. Ticket visible in My Support

### Admin Review Flow
1. Admin opens Support Queries
2. Views/filters all tickets
3. Clicks View Details
4. Reviews ticket and attachment
5. Updates status with comment
6. Email notification sent to employee

### Access Control
- Employees: Submit tickets, view own tickets
- Admins: View all tickets, update status

## Status Options
| Value | Label | Color |
|-------|-------|-------|
| 0 | Open | Blue (info) |
| 1 | In Progress | Orange (warning) |
| 2 | Unable to Reproduce | Grey |
| 3 | Not Fixing | Red (error) |
| 4 | Not Applicable | Grey |
| 5 | Closed | Green (success) |

## Routes
```
/Support
├── /My-Support                 # Employee: own tickets
├── /Support-Queries            # Admin: all tickets
└── /Support-Details/:id        # Ticket detail view
```

## Validation Rules

### Submit Ticket
- feedbackType: Required
- subject: Required, max 200 chars
- description: Required, max 600 chars
- attachment: Optional, max 5MB

### Update Status
- ticketStatus: Required
- adminComment: Required, max 600 chars

## Special Requirements
1. **Header Integration** - Submit button in app header
2. **Email Notifications** - On submit and status change
3. **File Upload** - Blob storage with 5MB limit
4. **Date Range Presets** - 15, 30, 90 days or custom

## Migration Notes
1. API uses "Feedback" naming - match exactly
2. Use Vuetify dialog for submit/update forms
3. Server-side pagination for both lists
4. Pre-fill employee info from auth store
5. File viewer for attachments in detail view

## Estimated Files
- 4 views
- 3 dialogs/components
- 2 filter forms
- 1 header button component
- 1 service
- 1 types file
- ~12 total files
