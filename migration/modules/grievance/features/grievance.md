# Feature: Grievance Management

## Status
STATUS: human-review
PRIORITY: wave-4
COMPLEXITY: high
DEPENDENCIES: authentication, employee-management
CREATED: 2026-01-26
FRONTEND_COMPLETE: 2026-01-26
MERGED_TO: feature/hrms-migration
COMMIT: 97bdf02

## Overview
Complete grievance management system with multi-level escalation, TAT tracking, and admin reporting. Employees can submit grievances, owners can add remarks and resolve/escalate, admins can configure types and view all grievances.

## Legacy Files

### Frontend (React.js)
```
source/src/pages/Grievances/
├── AddGrievancePage.tsx                    # Employee grievance submission form
├── EmployeeGrievanceListPage/index.tsx     # My grievances list with filters
├── EmployeeGrievanceDetailsPage.tsx        # Grievance detail summary view
├── GrievanceConfiguration/index.tsx        # Admin: grievance types CRUD
├── GrievanceAdminReport/index.tsx          # Admin: all grievances report
├── TicketPage/GrievanceTicketPage.tsx      # Full ticket view with remarks thread
└── UpsertGrievanceType.tsx                 # Add/edit grievance type form

source/src/pages/Grievances/components/
├── GrievanceStatusChip.tsx                 # Status badge with color coding
├── GrievanceTypeSelect.tsx                 # Type dropdown selector
├── EmployeeGrievanceFilter.tsx             # Employee filter form
├── AdminReportTableFilter.tsx              # Admin advanced filter
├── GrievanceSubmissionSuccessDialog.tsx    # Success dialog with ticket#
├── TicketHeader.tsx                        # Ticket header info
├── MessageCard.tsx                         # Remark message display
└── ResponseComposerCard.tsx                # Owner response form

source/src/services/Grievances/
├── grievanceService.ts                     # API service
└── types.ts                                # TypeScript types
```

### Backend (.NET)
```
Controllers/GrievanceController.cs          # 15 endpoints
Services/GrievanceService.cs                # Business logic
Services/Interfaces/IGrievanceService.cs    # Service interface
Repositories/GrievanceRepository.cs         # Dapper data access
Interface/IGrievanceRepository.cs           # Repository interface
Entities/EmployeeGrievance.cs               # Grievance entity
Entities/GrievanceType.cs                   # Type configuration entity
Entities/GrievanceOwner.cs                  # Owner mapping entity
Entities/GrievanceRemarks.cs                # Remarks entity
Enums/GrievanceStatus.cs                    # Status enum
Job/GrievanceLevelUpdateJob.cs              # Auto-escalation job
```

## Data Models

### GrievanceType
```typescript
interface GrievanceType {
  id: number;
  grievanceName: string;
  description: string;
  l1TatHours: number;
  l2TatHours: number;
  l3TatDays: number;
  isActive: boolean;
  isAutoEscalation: boolean;
  createdDate?: string;
  modifiedDate?: string;
}
```

### GrievanceOwner
```typescript
interface GrievanceOwner {
  id: number;
  grievanceTypeId: number;
  level: 1 | 2 | 3;
  ownerId: number;
  ownerName?: string;
  ownerEmail?: string;
}
```

### EmployeeGrievance
```typescript
interface EmployeeGrievance {
  id: number;
  ticketNo: string;
  grievanceTypeId: number;
  grievanceTypeName?: string;
  level: number;
  employeeId: number;
  employeeName?: string;
  title: string;
  description?: string;
  attachmentPath?: string;
  fileOriginalName?: string;
  status: GrievanceStatus;
  tatStatus?: boolean;
  resolvedDate?: string;
  managedBy?: string;
  createdDate: string;
  modifiedDate?: string;
}
```

### GrievanceRemarks
```typescript
interface GrievanceRemarks {
  id: number;
  grievanceId: number;
  remarks: string;
  attachmentPath?: string;
  createdById: number;
  createdByName?: string;
  designation?: string;
  createdDate: string;
}
```

### Enums
```typescript
const GrievanceStatus = {
  Open: 1,
  InProgress: 2,
  Resolved: 3,
  Closed: 4,
  Escalated: 5
} as const;

const GrievanceLevel = {
  L1: 1,
  L2: 2,
  L3: 3
} as const;
```

## API Endpoints

### Configuration (Admin)
| Method | Endpoint | Permission | Description |
|--------|----------|------------|-------------|
| GET | /api/Grievance/GetAllGrievancesList | ReadGrievancesConfiguration | List all grievance types with owners |
| GET | /api/Grievance/GetAllGrievanceTypeList | CreateGrievances | Active types for dropdown |
| GET | /api/Grievance/GetGrievanceTypeById/{id} | ReadGrievancesConfiguration | Get type by ID |
| POST | /api/Grievance/AddGrievance | ReadGrievancesConfiguration | Create grievance type |
| POST | /api/Grievance/UpdateGrievance | EditGrievances | Update grievance type |
| POST | /api/Grievance/DeleteGrievance/{id} | DeleteGrievances | Delete grievance type |

### Employee Operations
| Method | Endpoint | Permission | Description |
|--------|----------|------------|-------------|
| POST | /api/Grievance/SubmitGrievance | ReadGrievances | Submit new grievance (FormData) |
| POST | /api/Grievance/GetEmployeeGrievancesById/{employeeId} | ReadGrievances | List employee grievances |
| GET | /api/Grievance/GetEmployeeGrievancesDetail/{ticketId} | ViewGrievances | Get grievance details |
| GET | /api/Grievance/GrievanceViewAllowed/{grievanceId} | - | Check view permission |

### Remarks & Resolution
| Method | Endpoint | Permission | Description |
|--------|----------|------------|-------------|
| GET | /api/Grievance/GetEmployeeGrievanceRemarksDetail/{ticketId} | - | Get all remarks |
| POST | /api/Grievance/UpdateEmployeeGrievanceRemarks | - | Add remarks/resolve/escalate |
| GET | /api/Grievance/UpdateRemarksAllowed | - | Check if user can add remarks |
| GET | /api/Grievance/GrievanceResolvedEmail/{ticketNo} | - | Send resolution email |

### Admin Reporting
| Method | Endpoint | Permission | Description |
|--------|----------|------------|-------------|
| POST | /api/Grievance/GetAllEmployeeGrievances | ReadAllGrievances | All grievances with filters |
| POST | /api/Grievance/ExportGrievanceReport | ReadAllGrievances | Export to Excel |

## UI Components

### Pages/Views
1. **AddGrievanceView** - Employee submission form
   - Grievance type dropdown
   - Title input
   - Rich text description
   - File attachment
   - Success dialog with ticket number

2. **MyGrievanceListView** - Employee's grievances list
   - Server-side pagination
   - Filters: type, status
   - Status chip display
   - Click to view details

3. **GrievanceDetailsView** - Summary view
   - Ticket info card
   - Status, type, level
   - Description display
   - Attachment download

4. **GrievanceTicketView** - Full ticket page
   - Header with ticket info
   - Message thread (original + remarks)
   - Response composer (for owners)
   - Escalate/Resolve buttons

5. **GrievanceConfigurationView** - Admin types list
   - Types data table
   - Add/Edit/Delete actions
   - Toggle active status

6. **GrievanceTypeFormView** - Add/Edit type
   - Name, description
   - TAT settings (L1 hours, L2 hours, L3 days)
   - Auto-escalation toggle
   - Owner assignment per level

7. **GrievanceAdminReportView** - All grievances report
   - Advanced filters
   - Export to Excel
   - Server-side pagination

### Shared Components
1. **GrievanceStatusChip** - Status badge with colors
2. **GrievanceTypeSelect** - Type dropdown
3. **GrievanceFilterForm** - Employee filters
4. **AdminReportFilterForm** - Admin filters
5. **TicketHeader** - Ticket info header
6. **MessageCard** - Remark display card
7. **ResponseComposer** - Owner response form
8. **SuccessDialog** - Submission confirmation

## Business Logic

### Submission Flow
1. Employee fills form with type, title, description, attachment
2. Backend validates and stores grievance
3. Auto-generates ticket number
4. Sets Status=Open, Level=1
5. Sends notification email
6. Returns ticket number to UI

### Escalation Flow
1. Owner views assigned grievances
2. Adds remarks with optional attachment
3. Can Escalate (Level+1) or Resolve
4. If escalated: Status=Escalated, Level increments
5. If resolved: Status=Resolved, read-only

### Auto-Escalation
1. Scheduled job checks TAT
2. L1/L2: hours-based TAT
3. L3: days-based TAT
4. Auto-escalates with system remark
5. Max level is L3

### Access Control
- Employees: Own grievances only
- Owners: Assigned grievances at their level
- Admins: All grievances + configuration

## Status Colors
| Status | Color | Icon |
|--------|-------|------|
| Open | Blue (info) | Adjust |
| Resolved | Green (success) | CheckCircle |
| Escalated L1/L2 | Orange (warning) | Moving |
| Escalated L3 | Red (error) | Moving |

## Routes
```
/grievance
├── /configuration                    # Admin: types list
│   ├── /add                          # Add type form
│   └── /edit/:id                     # Edit type form
├── /my-grievance                     # Employee: my list
│   ├── /add                          # Submit form
│   └── /detail/:id                   # Detail view
├── /all-grievances                   # Admin: all grievances
└── /ticket/:ticketId                 # Full ticket page
```

## Validation Rules

### Submit Grievance
- grievanceTypeId: Required
- title: Required, max 200 chars
- description: Optional, max 5000 chars
- attachment: Optional, max 5MB

### Grievance Type
- grievanceName: Required, max 100 chars
- description: Required, max 500 chars
- l1TatHours: Required, > 0
- l2TatHours: Required, > 0
- l3TatDays: Required, > 0
- At least one owner per level

### Remarks
- remarks: Required, max 2000 chars
- attachment: Optional, max 5MB

## Migration Notes
1. Use Vuetify rich text editor for descriptions
2. FormData for file uploads
3. Server-side pagination for all lists
4. Match legacy status chip colors exactly
5. Preserve multi-level owner assignment UI
6. Auto-escalation is backend-only (no frontend needed)

## Estimated Files
- 7 views
- 8 components
- 1 service
- 1 types file
- 1 utils file
- ~20 total files
