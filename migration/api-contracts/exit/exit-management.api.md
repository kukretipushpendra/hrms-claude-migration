# Exit Management API Contract

## Overview
API endpoints for managing employee resignations, early release requests, and exit clearances (IT, HR, Department, Accounts).

## Base URLs

### Employee Exit Operations
`/api/ExitEmployee`

### Admin Exit Operations
`/api/AdminExitEmployee`

## Authentication
All endpoints require JWT Bearer Token in Authorization header:
```
Authorization: Bearer <token>
```

Most endpoints also require specific permissions (noted per endpoint).

---

## Employee Exit Endpoints

### 1. POST /api/ExitEmployee/AddResignation
Submit a new resignation request.

**Permission Required:** `CreatePersonalDetails`

#### Request
```typescript
interface ResignationRequestDto {
  employeeId: number;
  departmentId: number;
  reason: string;
  reportingManagerId: number;
  jobType: JobType;  // 1 = Probation, 2 = Confirmed, 3 = Training
}
```

#### Response - Success (200)
```typescript
interface ApiResponse {
  statusCode: 200;
  message: string;
  result: null;
}
```

#### Response - Error (400)
```typescript
interface ApiResponse {
  statusCode: 400;
  message: "Model State is Invalid";
  result: string[];  // Array of validation error messages
}
```

---

### 2. GET /api/ExitEmployee/GetResignationForm/{id}
Get resignation form details by resignation ID.

**Permission Required:** `ViewPersonalDetails`

#### Request
**URL Parameters:**
- `id` (long) - Resignation ID

#### Response - Success (200)
```typescript
interface ApiResponse {
  statusCode: 200;
  message: string;
  result: ResignationResponseDto;
}

interface ResignationResponseDto {
  id: number;
  employeeName: string | null;
  departmentId: number;
  status: ResignationStatus;  // 1 = Pending, 2 = Revoked, 3 = Accepted, 4 = Cancelled, 5 = Completed
  department: string | null;
  reportingManagerId: number;
  reportingManagerName: string | null;
  jobType: JobType;  // 1 = Probation, 2 = Confirmed, 3 = Training
}
```

#### Response - Error (404)
```typescript
interface ApiResponse {
  statusCode: 404;
  message: "User not found";
  result: null;
}
```

---

### 3. GET /api/ExitEmployee/GetResignationDetails/{id}
Get detailed resignation exit data by resignation ID.

**Permission Required:** `ViewPersonalDetails`

#### Request
**URL Parameters:**
- `id` (long) - Resignation ID

#### Response - Success (200)
```typescript
interface ApiResponse {
  statusCode: 200;
  message: string;
  result: any;  // Returns resignation exit data (structure varies based on implementation)
}
```

---

### 4. POST /api/ExitEmployee/RevokeResignation/{resignationId}
Revoke a pending resignation request.

**Permission Required:** None specified (commented out in code)

#### Request
**URL Parameters:**
- `resignationId` (int) - Resignation ID to revoke

#### Response - Success (200)
```typescript
interface ApiResponse {
  statusCode: 200;
  message: string;
  result: any;
}
```

#### Response - Error (400)
```typescript
interface ApiResponse {
  statusCode: 400;
  message: "Invalid request or unable to revoke resignation";
  result: null;
}
```

---

### 5. POST /api/ExitEmployee/RequestEarlyRelease
Request early release from notice period.

#### Request
```typescript
interface EarlyReleaseRequestDto {
  resignationId: number;
  earlyReleaseDate: string;  // DateOnly format: "YYYY-MM-DD"
  // earlyReleaseStatus and createdBy are auto-set by backend
}
```

#### Response - Success (200)
```typescript
interface ApiResponse {
  statusCode: 200;
  message: string;
  result: any;
}
```

---

### 6. GET /api/ExitEmployee/IsResignationExist/{EmployeeId}
Check if an active resignation exists for an employee.

**Permission Required:** `ViewPersonalDetails`

#### Request
**URL Parameters:**
- `EmployeeId` (long) - Employee ID

#### Response - Success (200)
```typescript
interface ApiResponse {
  statusCode: 200;
  message: string;
  result: IsResignationExistResponseDto;
}

interface IsResignationExistResponseDto {
  resignationId: number;
  resignationStatus: ResignationStatus;  // 1 = Pending, 2 = Revoked, 3 = Accepted, 4 = Cancelled, 5 = Completed
}
```

---

## Admin Exit Endpoints

### 7. POST /api/AdminExitEmployee/GetResignationList
Get paginated list of resignation requests with filtering.

#### Request
```typescript
interface SearchRequest {
  sortColumnName: string;      // Column to sort by (empty for default)
  sortDirection: string;        // "asc" or "desc" (empty for default)
  startIndex: number;           // Pagination start index
  pageSize: number;             // Number of records per page
  filters: ResignationSearchFilters;
}

interface ResignationSearchFilters {
  employeeName?: string | null;
  resignationStatus?: ResignationStatus | null;  // 1 = Pending, 2 = Revoked, 3 = Accepted, 4 = Cancelled, 5 = Completed
  lastWorkingDayFrom?: string | null;  // DateOnly format: "YYYY-MM-DD"
  lastWorkingDayTo?: string | null;    // DateOnly format: "YYYY-MM-DD"
  accountsNoDue?: boolean | null;
  itNoDue?: boolean | null;
  resignationDate?: string | null;     // DateOnly format: "YYYY-MM-DD"
  employeeStatus?: number | null;      // 1 = Active, 2 = FnFPending, 3 = OnNotice, 4 = ExEmployee
  employeeCode?: string | null;
  branchId?: number | null;
  departmentId?: number | null;
}
```

#### Response - Success (200)
```typescript
interface ApiResponse {
  statusCode: 200;
  message: string;
  result: ExitEmployeeListResponse;
}

interface ExitEmployeeListResponse {
  exitEmployeeList: AdminExitEmployeeDto[];
  totalRecords: number;
}

interface AdminExitEmployeeDto {
  resignationId: number;
  employeeCode: string;
  employeeName: string;
  fnFStatus: boolean;
  departmentName: string;
  resignationDate: string;        // DateOnly format: "YYYY-MM-DD"
  lastWorkingDay: string;         // DateOnly format: "YYYY-MM-DD"
  earlyReleaseDate: string | null; // DateOnly format: "YYYY-MM-DD"
  resignationStatus: ResignationStatus;  // 1 = Pending, 2 = Revoked, 3 = Accepted, 4 = Cancelled, 5 = Completed
  employeeStatus: EmployeeStatus;       // 1 = Active, 2 = FnFPending, 3 = OnNotice, 4 = ExEmployee
  employmentStatus: EmploymentStatus;   // 1 = FullTime, 2 = PartTime, 3 = Probation, 4 = Internship
  ktStatus: KTStatus;                   // 1 = Pending, 2 = InProgress, 3 = Completed
  exitInterviewStatus: boolean;
  earlyReleaseStatus: EarlyReleaseStatus; // 1 = Pending, 2 = Accepted, 3 = Rejected
  itNoDue: boolean;
  jobType: number;
  accountsNoDue: boolean;
  reportingManagerName: string;
  rejectEarlyReleaseReason: string;
  rejectResignationReason: string;
  reason: string;
  branchId: number | null;
}
```

---

### 8. GET /api/AdminExitEmployee/GetResignationById/{id}
Get detailed resignation information by ID.

#### Request
**URL Parameters:**
- `id` (int) - Resignation ID

#### Response - Success (200)
```typescript
interface ApiResponse {
  statusCode: 200;
  message: string;
  result: AdminExitEmployeeDto;  // Same structure as in GetResignationList
}
```

#### Response - Error (404)
```typescript
interface ApiResponse {
  statusCode: 404;
  message: "Resignation detail not found";
  result: null;
}
```

---

### 9. POST /api/AdminExitEmployee/AcceptResignation/{id}
Accept a resignation request.

#### Request
**URL Parameters:**
- `id` (int) - Resignation ID to accept

#### Response - Success (200)
```typescript
interface ApiResponse {
  statusCode: 200;
  message: "Resignation Accepted Successfully";
  result: any;
}
```

#### Response - Error (404)
```typescript
interface ApiResponse {
  statusCode: 404;
  message: "Not Found";
  result: null;
}
```

---

### 10. POST /api/AdminExitEmployee/AcceptEarlyRelease
Accept an early release request.

#### Request
```typescript
interface AcceptEarlyReleaseRequest {
  resignationId: number;
  earlyReleaseDate: string;  // DateOnly format: "YYYY-MM-DD"
}
```

#### Response - Success (200)
```typescript
interface ApiResponse {
  statusCode: 200;
  message: "Early Release Accepted Successfully";
  result: string;
}
```

#### Response - Error (404)
```typescript
interface ApiResponse {
  statusCode: 404;
  message: "Not Found";
  result: null;
}
```

---

### 11. GET /api/AdminExitEmployee/GetITClearanceDetailByResignationId/{resignationId}
Get IT clearance details for a resignation.

#### Request
**URL Parameters:**
- `resignationId` (int) - Resignation ID

#### Response - Success (200)
```typescript
interface ApiResponse {
  statusCode: 200;
  message: string;
  result: ITClearanceResponse;
}

interface ITClearanceResponse {
  resignationId: number;
  accessRevoked: boolean;
  assetReturned: boolean;
  assetCondition: AssetCondition;  // 1 = Ok, 2 = Damage, 3 = Missing
  attachmentUrl: string;
  note: string;
  itClearanceCertification: boolean;
}
```

#### Response - Error (404)
```typescript
interface ApiResponse {
  statusCode: 404;
  message: "Not Found";
  result: null;
}
```

---

### 12. POST /api/AdminExitEmployee/AddUpdateITClearance
Add or update IT clearance details.

**Content-Type:** `multipart/form-data` (due to file upload)

#### Request
```typescript
interface ITClearanceRequest {
  employeeId: number;
  resignationId: number;
  accessRevoked: boolean;
  assetReturned: boolean;
  assetCondition: number;  // 1 = Ok, 2 = Damage, 3 = Missing
  attachmentUrl?: File | null;  // File upload (optional)
  note: string;
  itClearanceCertification: boolean;
}
```

#### Response - Success (200)
```typescript
interface ApiResponse {
  statusCode: 200;
  message: string;
  result: string;
}
```

#### Response - Error (404)
```typescript
interface ApiResponse {
  statusCode: 404;
  message: "Not Found";
  result: null;
}
```

---

### 13. POST /api/AdminExitEmployee/AdminRejection
Reject a resignation or early release request.

#### Request
```typescript
interface AdminRejectionRequest {
  resignationId: number;
  employeeId: number;
  rejectionType: string;  // "Resignation" or "EarlyRelease"
  rejectReason?: string | null;
}
```

#### Response - Success (200)
```typescript
interface ApiResponse {
  statusCode: 200;
  message: string;
  result: string;
}
```

#### Response - Error (404)
```typescript
interface ApiResponse {
  statusCode: 404;
  message: "Resignation detail not found";
  result: null;
}
```

---

### 14. GET /api/AdminExitEmployee/GetHRClearanceByResignationId/{resignationId}
Get HR clearance details for a resignation.

#### Request
**URL Parameters:**
- `resignationId` (int) - Resignation ID

#### Response - Success (200)
```typescript
interface ApiResponse {
  statusCode: 200;
  message: string;
  result: HRClearanceResponse;
}

interface HRClearanceResponse {
  resignationId: number;
  advanceBonusRecoveryAmount: number;  // decimal
  serviceAgreementDetails: string;
  currentEL: number;  // decimal - Current Earned Leave balance
  numberOfBuyOutDays: number;
  exitInterviewStatus: boolean;
  exitInterviewDetails: string;
  attachment: string;  // URL to attachment
}
```

#### Response - Error (404)
```typescript
interface ApiResponse {
  statusCode: 404;
  message: "HR clearance detail not found";
  result: null;
}
```

---

### 15. POST /api/AdminExitEmployee/UpsertHRClearance
Add or update HR clearance details.

**Content-Type:** `multipart/form-data` (due to file upload)

#### Request
```typescript
interface HRClearanceRequest {
  employeeId: number;
  resignationId: number;
  advanceBonusRecoveryAmount: number;  // decimal
  serviceAgreementDetails: string;
  currentEL: number;  // decimal
  numberOfBuyOutDays: number;
  exitInterviewStatus: boolean;
  exitInterviewDetails: string;
  attachment?: File | null;  // File upload (optional)
}
```

#### Response - Success (200)
```typescript
interface ApiResponse {
  statusCode: 200;
  message: string;
  result: string;
}
```

#### Response - Error (404)
```typescript
interface ApiResponse {
  statusCode: 404;
  message: "Resignation not found";
  result: null;
}
```

---

### 16. GET /api/AdminExitEmployee/GetAccountClearance/{resignationId}
Get account clearance details for a resignation.

#### Request
**URL Parameters:**
- `resignationId` (int) - Resignation ID

#### Response - Success (200)
```typescript
interface ApiResponse {
  statusCode: 200;
  message: string;
  result: AccountClearanceResponse;
}

interface AccountClearanceResponse {
  resignationId: number;
  fnFStatus: boolean;
  fnFAmount: number;  // decimal
  issueNoDueCertificate: boolean;
  note: string | null;
  accountAttachment: string;  // URL to attachment
}
```

#### Response - Error (404)
```typescript
interface ApiResponse {
  statusCode: 404;
  message: "Not Found";
  result: null;
}
```

---

### 17. POST /api/AdminExitEmployee/AddUpdateAccountClearance
Add or update account clearance details.

**Content-Type:** `multipart/form-data` (due to file upload)

#### Request
```typescript
interface AccountClearanceRequest {
  employeeId: number;
  resignationId: number;
  fnFStatus: boolean;
  fnFAmount: number;  // decimal
  issueNoDueCertificate: boolean;
  note?: string | null;
  accountAttachment?: File | null;  // File upload (optional)
}
```

#### Response - Success (200)
```typescript
interface ApiResponse {
  statusCode: 200;
  message: string;
  result: string;
}
```

#### Response - Error (404)
```typescript
interface ApiResponse {
  statusCode: 404;
  message: "Not Found";
  result: null;
}
```

---

### 18. PATCH /api/AdminExitEmployee/UpdateLastWorkingDay
Update the last working day for a resignation.

#### Request
```typescript
interface UpdateLastWorkingDayRequest {
  resignationId: number;
  lastWorkingDay: string;  // DateOnly format: "YYYY-MM-DD"
}
```

#### Response - Success (200)
```typescript
interface ApiResponse {
  statusCode: 200;
  message: "Updated last working day successfully";
  result: string;
}
```

#### Response - Error (404)
```typescript
interface ApiResponse {
  statusCode: 404;
  message: "Resignation not found";
  result: null;
}
```

---

### 19. GET /api/AdminExitEmployee/GetDepartmentClearanceDetailByResignationId/{resignationId}
Get department clearance details for a resignation.

#### Request
**URL Parameters:**
- `resignationId` (int) - Resignation ID

#### Response - Success (200)
```typescript
interface ApiResponse {
  statusCode: 200;
  message: string;
  result: DepartmentClearanceResponse;
}

interface DepartmentClearanceResponse {
  resignationId: number;
  ktStatus: KTStatus;  // 1 = Pending, 2 = InProgress, 3 = Completed
  ktNotes: string;
  attachment: string;  // URL to attachment
  ktUsers: number[];   // Array of user IDs involved in knowledge transfer
}
```

#### Response - Error (404)
```typescript
interface ApiResponse {
  statusCode: 404;
  message: "Department clearance detail not found";
  result: null;
}
```

---

### 20. POST /api/AdminExitEmployee/UpsertDepartmentClearance
Add or update department clearance details.

**Content-Type:** `multipart/form-data` (due to file upload)

#### Request
```typescript
interface DepartmentClearanceRequest {
  employeeId: number;
  resignationId: number;
  ktStatus: KTStatus;  // 1 = Pending, 2 = InProgress, 3 = Completed
  ktNotes: string;
  attachment?: File | null;  // File upload (optional)
  ktUsers: number[];  // Array of user IDs
}
```

#### Response - Success (200)
```typescript
interface ApiResponse {
  statusCode: 200;
  message: string;
  result: string;
}
```

#### Response - Error (404)
```typescript
interface ApiResponse {
  statusCode: 404;
  message: "Resignation not found";
  result: null;
}
```

---

## Data Types

### Enums

#### ResignationStatus
```typescript
enum ResignationStatus {
  Pending = 1,
  Revoked = 2,
  Accepted = 3,
  Cancelled = 4,
  Completed = 5
}
```

#### JobType
```typescript
enum JobType {
  Probation = 1,
  Confirmed = 2,
  Training = 3
}
```

#### EarlyReleaseStatus
```typescript
enum EarlyReleaseStatus {
  Pending = 1,
  Accepted = 2,
  Rejected = 3
}
```

#### AssetCondition
```typescript
enum AssetCondition {
  Ok = 1,
  Damage = 2,
  Missing = 3
}
```

#### KTStatus (Knowledge Transfer Status)
```typescript
enum KTStatus {
  Pending = 1,
  InProgress = 2,
  Completed = 3
}
```

#### EmployeeStatus
```typescript
enum EmployeeStatus {
  Active = 1,
  FnFPending = 2,      // F&F Pending
  OnNotice = 3,
  ExEmployee = 4
}
```

#### EmploymentStatus
```typescript
enum EmploymentStatus {
  FullTime = 1,
  PartTime = 2,
  Probation = 3,
  Internship = 4
}
```

---

## Standard Response Format

All endpoints return this standard response structure:

```typescript
interface ApiResponse<T> {
  statusCode: number;    // HTTP status code (200, 400, 404, etc.)
  message: string;       // Success or error message
  result: T | null;      // Response data or null on error
}
```

---

## Error Responses

### Validation Error (400)
```typescript
{
  statusCode: 400,
  message: "Model State is Invalid",
  result: [
    "Reason is required",
    "Department ID must be greater than 0"
  ]
}
```

### Not Found (404)
```typescript
{
  statusCode: 404,
  message: "User not found" | "Resignation detail not found" | "Not Found",
  result: null
}
```

### Unauthorized (401)
```typescript
{
  statusCode: 401,
  message: "Unauthorized",
  result: null
}
```

### Forbidden (403)
```typescript
{
  statusCode: 403,
  message: "Forbidden - Insufficient permissions",
  result: null
}
```

---

## Notes

1. **Date Format:** All dates use `DateOnly` format in C# backend, which serializes as `"YYYY-MM-DD"` strings in JSON.

2. **File Uploads:** Endpoints that accept file uploads (`IFormFile` in C#) require `multipart/form-data` content type. These are:
   - `AddUpdateITClearance` (attachmentUrl)
   - `UpsertHRClearance` (attachment)
   - `AddUpdateAccountClearance` (accountAttachment)
   - `UpsertDepartmentClearance` (attachment)

3. **Permissions:** Most endpoints require specific permissions checked via `[HasPermission]` attribute. Common permissions:
   - `CreatePersonalDetails` - For creating/updating resignation
   - `ViewPersonalDetails` - For viewing resignation details

4. **Pagination:** The `GetResignationList` endpoint uses `SearchRequestDto<T>` pattern for server-side pagination, sorting, and filtering.

5. **F&F Status:** "F&F" stands for "Full and Final Settlement" - the final payment clearance when an employee exits.

6. **KT:** "KT" stands for "Knowledge Transfer" - the process of transferring knowledge from exiting employee to remaining team members.
