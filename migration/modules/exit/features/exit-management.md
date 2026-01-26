# Exit Management Feature

## Overview
The Exit Management feature handles the complete employee resignation and exit process, including resignation submission, approval workflows, early release requests, and multi-department clearance processes (HR, IT, Department, Accounts). This feature supports both employee self-service and admin management functions.

## Status
CURRENT: frontend-in-progress
TYPE: feature
WAVE: 4
DEPENDS_ON: auth-module, employees-module
PROGRESS: 40% - Core infrastructure complete (types, services, utilities, 1/9 views)

## Legacy Routes

### Employee Routes (Self-Service)
- `/resignation-form/:userId?` - Submit resignation form
- `/profile/exit-details` - View exit details (within profile tabs)

### Admin Routes (SUPER_ADMIN only)
- `/employees/employee-exit` - List all resignations
- `/employees/employee-exit/:resignationId` - View/manage specific resignation with clearance tabs

## Legacy Components

### Employee Components
**Location:** `legacy/Frontend/HRMS-Frontend/source/src/pages/Resignation/`

1. **ResignationForm.tsx**
   - Submit resignation with reason
   - Auto-calculates last working day based on job type
   - Shows confirmation dialog with resignation and last working dates
   - Validates resignation active status before allowing new submission
   - Features: read-only employee info, resignation reason textarea (max 500 chars)

2. **ExitDetails.tsx**
   - Displays resignation details for employee
   - Shows resignation status, dates, rejection reasons
   - Request early release functionality
   - Revoke resignation (if pending/accepted and before last working day)
   - View resignation/rejection reasons in dialog
   - Progress stepper (disabled by default: `isEnableProgress = false`)

3. **EarlyReleaseDialog/**
   - Modal to request early release date
   - Date picker with validation (between today and last working day)
   - Submit early release request

4. **ResignationReasonPreview.tsx**
   - Dialog to view resignation reason, rejection reasons

### Admin Components
**Location:** `legacy/Frontend/HRMS-Frontend/source/src/pages/ExitEmployee/`

1. **ExitEmployeeListPage/index.tsx**
   - Data table with pagination, sorting, filtering
   - Filters: employee code/name, resignation status, branch, department, IT/accounts no-due, date ranges, employee status
   - Columns: employee code, name, department, resignation date, LWD, early release info, status, clearance flags
   - Click row to navigate to details page
   - Features: column visibility toggle, employee search autocomplete

2. **ExitDetailsPage/index.tsx**
   - Main resignation management page for admins
   - View resignation details
   - Accept/reject resignation
   - Accept/reject early release requests
   - Update last working day
   - Tab panel with 4 clearance types (HR, Department, IT, Account)
   - Disables editing if resignation status is completed/cancelled/revoked

3. **ExitDetailsPage/ExitDetailsForm.tsx**
   - Layout component with resignation info grid
   - Dialogs for: accept resignation, reject resignation, accept early release, reject early release, update last working day
   - Renders 4 clearance tabs (HR, Department, IT, Account)

### Clearance Components
**Location:** `legacy/Frontend/HRMS-Frontend/source/src/pages/ExitEmployee/components/`

1. **HRClearance/**
   - Fields: Advance bonus recovery amount, service agreement details, current EL, buyout days, exit interview status/details, attachment
   - Form validation with Yup
   - File upload support

2. **DepartmentClearance/**
   - Fields: KT status (dropdown enum), KT notes, KT users (multi-select employees), attachment
   - File upload support

3. **ITClearance/**
   - Fields: Access revoked (checkbox), Asset returned (checkbox), Asset condition (dropdown enum), Note, IT clearance certification (checkbox), attachment
   - Conditional validation: Note required if asset condition is damaged/faulty

4. **AccountClearance/**
   - Fields: F&F status (checkbox), F&F amount, Issue no-due certificate (checkbox), Note, attachment
   - File upload support

### Filter Components
**Location:** `legacy/Frontend/HRMS-Frontend/source/src/pages/ExitEmployee/components/`

1. **FilterForm.tsx**
   - Filters for admin exit employee list
   - Employee search, status filters, date range pickers, branch/department dropdowns

2. **TableTopToolbar.tsx**
   - Table controls: filter toggle, search, reset filters

## API Endpoints

### Employee APIs
**Controller:** `ExitEmployeeController.cs`
**Base Route:** `/api/ExitEmployee`

1. **POST** `/AddResignation`
   - Body: `{ employeeId, departmentId, reason, reportingManagerId, jobType }`
   - Returns: resignation ID
   - Permission: CreatePersonalDetails

2. **GET** `/GetResignationForm/{id}`
   - Returns: employee name, department, reporting manager, job type
   - Permission: ViewPersonalDetails

3. **GET** `/GetResignationDetails/{id}`
   - Returns: full resignation details with status, dates, reasons
   - Permission: ViewPersonalDetails

4. **POST** `/RevokeResignation/{resignationId}`
   - Revokes active resignation
   - Returns: success message

5. **POST** `/RequestEarlyRelease`
   - Body: `{ resignationId, earlyReleaseDate }`
   - Returns: success message

6. **GET** `/IsResignationExist/{EmployeeId}`
   - Returns: `{ resignationId, resignationStatus }` or null
   - Permission: ViewPersonalDetails

### Admin APIs
**Controller:** `AdminExitEmployeeController.cs`
**Base Route:** `/api/AdminExitEmployee`

1. **POST** `/GetResignationList`
   - Body: `{ sortColumnName, sortDirection, startIndex, pageSize, filters: {...} }`
   - Returns: `{ exitEmployeeList: [...], totalRecords }`

2. **GET** `/GetResignationById/{id}`
   - Returns: full resignation details for admin view

3. **POST** `/AcceptResignation/{id}`
   - Accepts resignation
   - Returns: success message

4. **POST** `/AcceptEarlyRelease`
   - Body: `{ resignationId, earlyReleaseDate }`
   - Returns: success message

5. **POST** `/AdminRejection`
   - Body: `{ resignationId, rejectionType: "resignation" | "earlyrelease", rejectReason }`
   - Returns: success message

6. **PATCH** `/UpdateLastWorkingDay`
   - Body: `{ resignationId, lastWorkingDay }`
   - Returns: success message

### Clearance APIs

7. **GET** `/GetITClearanceDetailByResignationId/{resignationId}`
   - Returns: IT clearance details or null

8. **POST** `/AddUpdateITClearance`
   - Body (FormData): `{ employeeId, resignationId, accessRevoked, assetReturned, assetCondition, attachmentUrl, note, itClearanceCertification }`
   - Returns: success message

9. **GET** `/GetHRClearanceByResignationId/{resignationId}`
   - Returns: HR clearance details

10. **POST** `/UpsertHRClearance`
    - Body (FormData): `{ employeeId, resignationId, advanceBonusRecoveryAmount, serviceAgreementDetails, currentEL, numberOfBuyOutDays, attachment, exitInterviewStatus, exitInterviewDetails }`
    - Returns: success message

11. **GET** `/GetDepartmentClearanceDetailByResignationId/{resignationId}`
    - Returns: Department clearance details

12. **POST** `/UpsertDepartmentClearance`
    - Body (FormData): `{ employeeId, resignationId, ktStatus, ktNotes, attachment, ktUsers: number[] }`
    - Returns: success message

13. **GET** `/GetAccountClearance/{resignationId}`
    - Returns: Account clearance details or null

14. **POST** `/AddUpdateAccountClearance`
    - Body (FormData): `{ employeeId, resignationId, fnFStatus, fnFAmount, issueNoDueCertificate, note, accountAttachment }`
    - Returns: success message

## Data Models

### TypeScript Types

#### Employee Exit Types
```typescript
// Resignation Form
type ResignationDetails = {
  id: number;
  employeeName: string;
  departmentId: number;
  department: string;
  reportingManagerId: number;
  reportingManagerName: string;
  jobType: number;
};

type AddResignationArgs = {
  employeeId: number;
  departmentId: number;
  reason: string;
  reportingManagerId: number;
  jobType: number;
};

// Exit Details
type GetResignationExitDetails = {
  id: number;
  employeeId: number;
  employeeName: string;
  reason: string;
  department: string;
  reportingManager: string;
  lastWorkingDay: string; // YYYY-MM-DD
  isActive: boolean;
  status: number; // ResignationStatus enum
  earlyReleaseDate: string | null;
  earlyReleaseStatus: number; // EarlyReleaseStatus enum
  rejectResignationReason: string;
  rejectEarlyReleaseReason: string;
  resignationDate: string; // YYYY-MM-DD
};

type RequestEarlyReleaseArgs = {
  resignationId: number;
  earlyReleaseDate: string; // YYYY-MM-DD
};

type ResignationActiveStatusResponse = {
  statusCode: number;
  message: string;
  result: {
    resignationId: number;
    resignationStatus: ResignationStatusCode;
  } | null;
};
```

#### Admin Exit Types
```typescript
// Exit Employee List
type ExitEmployeeListItem = {
  resignationId: number;
  employeeCode: string;
  employeeName: string;
  departmentName: string;
  resignationDate: string;
  lastWorkingDay: string;
  earlyReleaseRequest: boolean;
  earlyReleaseDate: string | null;
  earlyReleaseApprove: boolean | null;
  resignationStatus: number;
  employeeStatus: EmployeeStatus;
  employmentStatus: number;
  ktStatus: number;
  exitInterviewStatus: boolean;
  itNoDue: boolean;
  accountsNoDue: boolean;
  reportingManagerName: string;
  branchId: BranchLocation;
};

type ExitEmployeeSearchFilter = {
  employeeCode?: string;
  employeeName?: string;
  resignationStatus: number;
  branchId: number;
  departmentId: number;
  itNoDue: null | boolean;
  accountsNoDue: null | boolean;
  lastWorkingDayFrom: null | string;
  lastWorkingDayTo: null | string;
  resignationDate: null | string;
  employeeStatus: number;
};

// Rejection/Acceptance
type RejectResignationOrEarlyReleaseArgs = {
  resignationId: number;
  rejectionType: "resignation" | "earlyrelease";
  rejectReason: string | null;
};

type AcceptEarlyReleaseArgs = {
  resignationId: number;
  earlyReleaseDate: string; // YYYY-MM-DD
};

type UpdateLastWorkingDayArgs = {
  resignationId: number;
  lastWorkingDay: string; // YYYY-MM-DD
};
```

#### Clearance Types
```typescript
// IT Clearance
type ITClearanceDetails = {
  resignationId: number;
  accessRevoked: boolean;
  assetReturned: boolean;
  assetCondition: number; // AssetCondition enum
  attachmentUrl: string;
  note: string;
  itClearanceCertification: boolean;
};

type UpsertITClearanceDetailsArgs = {
  employeeId: number;
  resignationId: number;
  accessRevoked: boolean;
  assetReturned: boolean;
  assetCondition: number;
  attachmentUrl: File | string;
  note: string;
  itClearanceCertification: boolean;
};

// HR Clearance
type HrClearanceDetails = {
  resignationId: number;
  advanceBonusRecoveryAmount: number;
  serviceAgreementDetails: string;
  currentEL: number;
  numberOfBuyOutDays: number;
  attachment: string;
  exitInterviewStatus: boolean;
  exitInterviewDetails: string;
};

type UpsertHRClearanceArgs = {
  employeeId: number;
  resignationId: number;
  advanceBonusRecoveryAmount: number;
  serviceAgreementDetails: string;
  currentEL: number;
  numberOfBuyOutDays: number;
  attachment: File | string;
  exitInterviewStatus: boolean;
  exitInterviewDetails: string;
};

// Department Clearance
type GetDepartmentClearanceByResignationId = {
  resignationId: number;
  ktStatus: number; // KTStatus enum
  ktNotes: string;
  attachment: string;
  ktUsers: number[];
};

type UpsertDepartmentClearanceArgs = {
  employeeId: number;
  resignationId: number;
  ktStatus: number;
  ktNotes: string;
  attachment: File | string;
  ktUsers: number[];
};

// Account Clearance
type AccountClearanceDetails = {
  resignationId: number;
  fnFStatus: boolean;
  fnFAmount: number | null;
  issueNoDueCertificate: boolean;
  note: string;
  accountAttachment: string | null;
};

type UpsertAccountClearanceDetailsArgs = {
  employeeId: number;
  resignationId: number;
  fnFStatus: boolean;
  fnFAmount: number | null;
  issueNoDueCertificate: boolean;
  note: string;
  accountAttachment: File | null | string;
};
```

### C# Entity Models

```csharp
// Resignation Entity
public class Resignation : BaseEntity
{
    public long EmployeeId { get; set; }
    public long DepartmentId { get; set; }
    public string Reason { get; set; }
    public string RejectResignationReason { get; set; }
    public string RejectEarlyReleaseReason { get; set; }
    public DateOnly LastWorkingDay { get; set; }
    public long ReportingManagerId { get; set; }
    public JobType JobType { get; set; }
    public bool IsActive { get; set; } = true;
    public ResignationStatus ResignationStatus { get; set; } = ResignationStatus.Pending;
    public EarlyReleaseStatus EarlyReleaseStatus { get; set; }
}

// ITClearance Entity
public class ITClearance : BaseEntity
{
    public int ResignationId { get; set; }
    public bool AccessRevoked { get; set; }
    public bool AssetReturned { get; set; }
    public string AssetCondition { get; set; }
    public string AttachmentUrl { get; set; }
    public string Note { get; set; }
    public bool ITClearanceCertification { get; set; }
    public string FileOriginalName { get; set; }
}

// HRClearance Entity
public class HRClearance : BaseEntity
{
    public int ResignationId { get; set; }
    public decimal AdvanceBonusRecoveryAmount { get; set; }
    public string ServiceAgreementDetails { get; set; }
    public decimal CurrentEL { get; set; }
    public int NumberOfBuyOutDays { get; set; }
    public bool ExitInterviewStatus { get; set; }
    public string ExitInterviewDetails { get; set; }
    public string Attachment { get; set; }
    public string FileOriginalName { get; set; }
}

// DepartmentClearance Entity
public class DepartmentClearance : BaseEntity
{
    public int ResignationId { get; set; }
    public KTStatus KTStatus { get; set; }
    public string KTNotes { get; set; }
    public string Attachment { get; set; }
    public string KTUsers { get; set; } // Comma-separated user IDs
    public string FileOriginalName { get; set; }
}

// AccountClearance Entity
public class AccountClearance : BaseEntity
{
    public int ResignationId { get; set; }
    public bool? FnFStatus { get; set; }
    public decimal? FnFAmount { get; set; }
    public bool? IssueNoDueCertificate { get; set; }
    public string Note { get; set; }
    public string AccountAttachment { get; set; }
    public string FileOriginalName { get; set; }
}
```

### Enums

```typescript
// TypeScript Enums
enum ResignationStatus {
  pending = 0,
  accepted = 1,
  completed = 2,
  cancelled = 3, // Rejected
  revoked = 4
}

enum EarlyReleaseStatus {
  pending = 1,
  approved = 2,
  rejected = 3
}

enum AssetCondition {
  good = 1,
  damaged = 2,
  faulty = 3
}

enum KTStatus {
  pending = 0,
  inProgress = 1,
  completed = 2
}

enum JobType {
  permanent = 1,
  contract = 2,
  intern = 3
}
```

```csharp
// C# Enums
public enum ResignationStatus
{
    Pending = 0,
    Accepted = 1,
    Completed = 2,
    Cancelled = 3,
    Revoked = 4
}

public enum EarlyReleaseStatus
{
    Pending = 1,
    Approved = 2,
    Rejected = 3
}

public enum KTStatus
{
    Pending = 0,
    InProgress = 1,
    Completed = 2
}

public enum JobType
{
    Permanent = 1,
    Contract = 2,
    Intern = 3
}
```

## Permissions & Access Control

### Employee Access
- Any authenticated employee can submit resignation
- Can view own exit details
- Can revoke own resignation (if pending/accepted and before LWD)
- Can request early release (if resignation accepted)

### Admin Access (SUPER_ADMIN role required)
- View all resignations list
- View any resignation details
- Accept/reject resignations
- Accept/reject early release requests
- Update last working day
- Manage all clearances (HR, IT, Department, Account)

### Permissions Used
- `Permissions.CreatePersonalDetails` - Add resignation
- `Permissions.ViewPersonalDetails` - View resignation details
- `Permissions.EditPersonalDetails` - Edit resignation (currently commented out for revoke)
- `EMPLOYEES.READ` - Access admin exit employee features

## Business Logic

### Last Working Day Calculation
- Based on `JobType` enum
- Calculated in `calculateLastWorkingDay(resignationDate, jobType)` helper
- Notice period varies by job type (implementation in `legacy/Frontend/HRMS-Frontend/source/src/utils/helpers.ts`)

### Resignation Workflow
1. **Employee submits resignation**
   - Status: Pending
   - Last working day auto-calculated
   - Email notification sent

2. **Admin reviews resignation**
   - Accept: Status → Accepted
   - Reject: Status → Cancelled (with rejection reason)

3. **Employee can request early release** (if accepted)
   - Early release status: Pending
   - Date must be between today and last working day

4. **Admin reviews early release**
   - Accept: Update early release date
   - Reject: Set rejection reason

5. **Admin completes clearances**
   - HR clearance (exit interview, buyout, etc.)
   - Department clearance (KT status, users)
   - IT clearance (asset return, access)
   - Account clearance (F&F, no-due certificate)

6. **Resignation completion**
   - Status: Completed
   - All clearances done
   - Employee status updated

### Revoke Logic
- Allowed only if:
  - Status is Pending or Accepted
  - Last working day >= today
- Revoke sets status to Revoked
- Redirects to profile page

## Validation Rules

### Resignation Form
- Employee name: required, read-only
- Department: required, read-only
- Reporting manager: required, read-only
- Resignation reason: required, max 500 characters

### Early Release
- Release date: required, between today and early release date

### IT Clearance
- Access revoked: boolean
- Asset returned: boolean
- Asset condition: required if asset returned
- Note: required if asset condition is damaged/faulty
- IT clearance certification: boolean

### HR Clearance
- All numeric fields validated for positive numbers
- Exit interview details required if exit interview status is true

### Department Clearance
- KT status: required (dropdown)
- KT users: multi-select (employee IDs)
- KT notes: text area

### Account Clearance
- F&F amount: numeric, required if F&F status is true
- Issue no-due certificate: boolean

## File Uploads

All clearance forms support file attachments:
- Sent as FormData (multipart/form-data)
- Fields: `attachmentUrl`, `attachment`, `accountAttachment`, `departmentAttachment`, `hrAttachment`, `itAttachment`
- File or string (existing URL) accepted
- Uses `objectToFormData` utility for serialization

## UI/UX Features

### Material-UI Components Used
- DataTable (Material React Table) with pagination, sorting, filtering
- Dialogs for confirmations, previews, forms
- DatePicker (moment.js format: YYYY-MM-DD)
- Autocomplete for employee search
- Tabs for clearance sections
- Stepper for progress (disabled by default)
- Form validation with React Hook Form + Yup
- Toast notifications for success/error messages

### Responsive Grid Layout
- Exit details: 3 columns (xs=12, sm=6, md=4)
- Forms: responsive with FormInputGroup/FormInputContainer

### Loading States
- GlobalLoader component for async operations
- Individual loading states for fetch/submit operations

## Migration Notes

### Critical Implementation Details

1. **Date Handling**
   - Frontend uses moment.js with format "YYYY-MM-DD"
   - Backend uses DateOnly type (C#)
   - Ensure consistent date formatting in Vue.js migration

2. **File Upload Pattern**
   - Frontend uses `objectToFormData` utility
   - Backend expects FormData with file + metadata
   - Special handling for `ktUsers` array in department clearance (each user appended separately)

3. **Status Enums**
   - Must match exactly between frontend and backend
   - ResignationStatus, EarlyReleaseStatus, KTStatus, AssetCondition, JobType
   - Use number values, not string labels

4. **Permission Checks**
   - SUPER_ADMIN role required for admin routes
   - Feature flag: `enableExitEmployee` must be true
   - Employee can only see own exit details unless has EMPLOYEES.READ permission

5. **Resignation Active Status Check**
   - Before showing resignation form, check `IsResignationExist` API
   - Allow new resignation only if status is null, Cancelled, or Revoked
   - Otherwise redirect to not-found

6. **Clearance Tabs**
   - Only editable if resignation status is NOT (Completed, Cancelled, Revoked)
   - All 4 clearances are independent (can be filled in any order)
   - Each clearance has its own fetch/upsert operations

7. **Table Filters**
   - Default filters defined in `constants.ts`
   - Search by employee code uses comma-separated values
   - Date filters support range selection

8. **Navigation Pattern**
   - Profile page has "Exit Details" tab (conditionally shown)
   - Separate routes for resignation form and admin management
   - Query param `?employeeId=X` for viewing other employees' data

9. **Confirmation Dialogs**
   - Resignation submission shows custom dialog with dates
   - Admin actions (accept/reject) show confirmation dialogs
   - Revoke has confirmation dialog with warning message

10. **Email Notifications**
    - Backend sends emails on resignation events
    - Uses `EmailTemplateTypes` enum
    - Placeholders: employee name, dates, reasons, etc.

### Vue.js Migration Considerations

1. Replace React Hook Form with VeeValidate + Zod
2. Replace moment.js with day.js or date-fns
3. Replace Material-UI with Vuetify
4. Replace React Router with Vue Router
5. Replace Zustand with Pinia for state management
6. Replace Axios interceptors with Vue composables
7. Convert TypeScript interfaces to Vue 3 TypeScript types
8. Use Vue 3 Composition API with `<script setup>`
9. Replace `useAsync` hook with Vue composable
10. Convert class components to functional components (already done in legacy)

### API Contract Validation
- All endpoints tested and working
- Standard response format: `{ statusCode, message, result }`
- Error handling returns validation errors array for 400 status
- File uploads use multipart/form-data content type

### Testing Checklist
- [ ] Employee can submit resignation
- [ ] Resignation form calculates correct last working day
- [ ] Employee can view exit details in profile
- [ ] Employee can revoke resignation (when allowed)
- [ ] Employee can request early release
- [ ] Admin can view resignation list with filters
- [ ] Admin can accept/reject resignation
- [ ] Admin can accept/reject early release
- [ ] Admin can update last working day
- [ ] Admin can fill HR clearance with file upload
- [ ] Admin can fill Department clearance with KT users
- [ ] Admin can fill IT clearance with conditional note validation
- [ ] Admin can fill Account clearance
- [ ] Permission checks work correctly
- [ ] Feature flag enables/disables exit features
- [ ] Date validations work (early release, last working day)
- [ ] Status transitions work correctly
- [ ] Email notifications sent (backend)

## Dependencies

### Frontend Dependencies
- React Hook Form + Yup (forms/validation)
- Material-UI (UI components)
- Material React Table (data tables)
- moment.js (date handling)
- react-toastify (notifications)
- axios (HTTP client)

### Backend Dependencies
- Dapper (data access)
- SQL Server (database)
- FluentValidation (API validation)
- AutoMapper (DTO mapping)
- Serilog (logging)

### Related Features
- Employee module (employee data, search)
- Authentication (permissions, roles)
- Email notifications (templates, sending)
- File upload/download (attachments)
- Department/Branch master data

## Database Tables

1. **Resignation** - Main resignation records
2. **ResignationHistory** - Audit trail of resignation changes
3. **ITClearance** - IT clearance details
4. **HRClearance** - HR clearance details
5. **DepartmentClearance** - Department clearance details
6. **AccountClearance** - Account clearance details

## Known Issues & Patterns

Refer to `/migration/KNOWN_ISSUES_AND_PATTERNS.md` for common patterns encountered during migration.

## Success Metrics

- Employee can complete resignation flow without errors
- Admin can process all resignations efficiently
- All clearances can be filled and saved
- File uploads work for all clearance types
- Permissions and access control work as expected
- Date calculations and validations are accurate
