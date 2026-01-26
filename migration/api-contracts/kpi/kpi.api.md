# KPI API Contract

## Base URL
`/api/KPI`

## Authentication
JWT Bearer Token required for all endpoints.

## Standard Response Format

All endpoints return the following response structure:

```typescript
interface ApiResponse<T> {
  statusCode: number;
  message: string;
  result: T | null;
}
```

---

## Endpoints

### 1. POST /CreateGoal

Create a new KPI goal and optionally assign it to employees.

**Permission:** `CreateKPI`

#### Request

```typescript
interface GoalRequestDto {
  id: number;                  // Required for updates, 0 for new goals
  title: string;               // Goal title
  description: string;         // Goal description
  departmentId: number;        // Department ID
  employeeIds?: string;        // Comma-separated employee IDs (optional)
}
```

**Headers:**
```
Authorization: Bearer {token}
Content-Type: application/json
```

**Body:**
```json
{
  "id": 0,
  "title": "Improve Sales Performance",
  "description": "Increase quarterly sales by 15%",
  "departmentId": 3,
  "employeeIds": "101,102,103"
}
```

#### Response

**Success (200):**
```json
{
  "statusCode": 200,
  "message": "Goal added successfully",
  "result": 1
}
```

**Error (400):**
```json
{
  "statusCode": 400,
  "message": "Invalid request",
  "result": 0
}
```

---

### 2. GET /GetGoalById/{goalId}

Retrieve a specific goal by its ID.

**Permission:** `ReadKPI`

#### Request

**Path Parameters:**
- `goalId` (number, required) - The ID of the goal

**Headers:**
```
Authorization: Bearer {token}
```

#### Response

**Success (200):**
```json
{
  "statusCode": 200,
  "message": "Success",
  "result": {
    "id": 1,
    "title": "Improve Sales Performance",
    "description": "Increase quarterly sales by 15%",
    "departmentId": 3,
    "employeeIds": "101,102,103",
    "createdBy": "admin@example.com",
    "createdOn": "2024-01-15T10:30:00Z",
    "modifiedBy": null,
    "modifiedOn": null,
    "isDeleted": false
  }
}
```

---

### 3. POST /UpdateGoal

Update an existing KPI goal.

**Permission:** `EditKPI`

#### Request

```typescript
// Same as GoalRequestDto but with existing id
interface GoalRequestDto {
  id: number;                  // Required, must be > 0
  title: string;
  description: string;
  departmentId: number;
  employeeIds?: string;        // Comma-separated employee IDs
}
```

**Headers:**
```
Authorization: Bearer {token}
Content-Type: application/json
```

**Body:**
```json
{
  "id": 1,
  "title": "Improve Sales Performance (Updated)",
  "description": "Increase quarterly sales by 20%",
  "departmentId": 3,
  "employeeIds": "101,102"
}
```

#### Response

**Success (200):**
```json
{
  "statusCode": 200,
  "message": "Goal updated successfully",
  "result": 1
}
```

**Error (400):**
```json
{
  "statusCode": 400,
  "message": "Record not found",
  "result": 0
}
```

---

### 4. POST /GetGoalList

Retrieve a paginated and filtered list of KPI goals.

**Permission:** `ReadKPIGoals`

#### Request

```typescript
interface SearchRequestDto<KPIGoalRequestDto> {
  sortColumnName: string;      // Column to sort by (default: empty)
  sortDirection: string;       // "asc" or "desc" (default: empty)
  startIndex: number;          // Pagination start index (0-based)
  pageSize: number;            // Number of records per page
  filters: KPIGoalRequestDto;  // Filter criteria
}

interface KPIGoalRequestDto {
  title?: string | null;           // Filter by title (partial match)
  departmentId?: number | null;    // Filter by department ID
  createdOnFrom?: string | null;   // Filter by creation date (from) - DateOnly format
  createdOnTo?: string | null;     // Filter by creation date (to) - DateOnly format
  createdBy?: string;              // Filter by creator email
}
```

**Headers:**
```
Authorization: Bearer {token}
Content-Type: application/json
```

**Body:**
```json
{
  "sortColumnName": "CreatedOn",
  "sortDirection": "desc",
  "startIndex": 0,
  "pageSize": 10,
  "filters": {
    "title": "Sales",
    "departmentId": 3,
    "createdOnFrom": "2024-01-01",
    "createdOnTo": "2024-12-31",
    "createdBy": ""
  }
}
```

#### Response

**Success (200):**
```json
{
  "statusCode": 200,
  "message": "Success",
  "result": {
    "totalRecords": 25,
    "goalList": [
      {
        "id": 1,
        "title": "Improve Sales Performance",
        "description": "Increase quarterly sales by 15%",
        "departmentId": 3,
        "createdOn": "2024-01-15T10:30:00Z",
        "createdBy": "admin@example.com",
        "department": "Sales"
      }
    ]
  }
}
```

---

### 5. POST /DeleteGoal/{goalId}

Delete a KPI goal by ID.

**Permission:** `DeleteKPI`

#### Request

**Path Parameters:**
- `goalId` (number, required) - The ID of the goal to delete

**Headers:**
```
Authorization: Bearer {token}
```

#### Response

**Success (200):**
```json
{
  "statusCode": 200,
  "message": "Goal deleted successfully",
  "result": 1
}
```

**Error (200):**
```json
{
  "statusCode": 200,
  "message": "Record does not exist",
  "result": 0
}
```

---

### 6. POST /GetEmployeesKPI

Retrieve a list of employees with their KPI status for manager dashboard.

**Permission:** `ReadKPIDashBoard`

#### Request

```typescript
interface SearchRequestDto<GetEmpByManagerRequestDto> {
  sortColumnName: string;
  sortDirection: string;
  startIndex: number;
  pageSize: number;
  filters: GetEmpByManagerRequestDto;
}

interface GetEmpByManagerRequestDto {
  employeeName?: string | null;        // Filter by employee name
  employeeCode?: string | null;        // Filter by employee code
  appraisalDateFrom?: string | null;   // DateOnly format
  appraisalDateTo?: string | null;     // DateOnly format
  reviewDateFrom?: string | null;      // DateOnly format
  reviewDateTo?: string | null;        // DateOnly format
  statusFilter?: number | null;        // Status filter (specific values TBD)
}
```

**Headers:**
```
Authorization: Bearer {token}
Content-Type: application/json
```

**Body:**
```json
{
  "sortColumnName": "EmployeeName",
  "sortDirection": "asc",
  "startIndex": 0,
  "pageSize": 20,
  "filters": {
    "employeeName": "",
    "employeeCode": "",
    "appraisalDateFrom": null,
    "appraisalDateTo": null,
    "reviewDateFrom": null,
    "reviewDateTo": null,
    "statusFilter": null
  }
}
```

#### Response

**Success (200):**
```json
{
  "statusCode": 200,
  "message": "Success",
  "result": {
    "totalRecords": 15,
    "goalList": [
      {
        "employeeName": "John Doe",
        "employeeCode": "EMP001",
        "nextAppraisalDate": "2024-12-31",
        "lastReviewDate": "2024-06-30",
        "planId": 123,
        "email": "john.doe@example.com",
        "employeeId": 101,
        "joiningDate": "2020-01-15",
        "reviewDate": "2024-06-30",
        "isReviewed": true
      }
    ]
  }
}
```

---

### 7. GET /GetEmployeesByManager

Get all employees reporting to the current manager.

**Permission:** `ReadKPI`

#### Request

**Headers:**
```
Authorization: Bearer {token}
```

**Query Parameters:** None (uses JWT token to identify manager)

#### Response

**Success (200):**
```json
{
  "statusCode": 200,
  "message": "Success",
  "result": [
    {
      "id": 101,
      "email": "john.doe@example.com",
      "firstName": "John",
      "middleName": "",
      "lastName": "Doe"
    },
    {
      "id": 102,
      "email": "jane.smith@example.com",
      "firstName": "Jane",
      "middleName": "M",
      "lastName": "Smith"
    }
  ]
}
```

---

### 8. GET /GetEmployeeSelfRating

Retrieve employee self-rating details for a specific plan.

**Permission:** `ReadKPI`

#### Request

**Query Parameters:**
- `PlanId` (number, optional) - KPI Plan ID
- `EmployeeId` (number, optional) - Employee ID

**Headers:**
```
Authorization: Bearer {token}
```

**Example:**
```
GET /api/KPI/GetEmployeeSelfRating?PlanId=123&EmployeeId=101
```

#### Response

**Success (200):**
```json
{
  "statusCode": 200,
  "message": "Success",
  "result": [
    {
      "employeeCode": "EMP001",
      "employeeName": "John Doe",
      "email": "john.doe@example.com",
      "employeeId": 101,
      "planId": 123,
      "reviewDate": "2024-06-30",
      "isReviewed": false,
      "joiningDate": "2020-01-15",
      "lastAppraisal": "2023-12-31",
      "nextAppraisal": "2024-12-31",
      "ratings": [
        {
          "goalId": 1,
          "q1_Rating": 4.5,
          "q2_Rating": 4.8,
          "q3_Rating": null,
          "q4_Rating": null,
          "q1_Note": "Exceeded expectations",
          "q2_Note": "Outstanding performance",
          "q3_Note": null,
          "q4_Note": null,
          "managerRating": 4.6,
          "managerNote": "Great work overall",
          "goalTitle": "Improve Sales Performance",
          "targetExpected": "15% increase",
          "status": false,
          "allowedQuarter": "Q1,Q2,Q3"
        }
      ]
    }
  ]
}
```

**Error (200):**
```json
{
  "statusCode": 200,
  "message": "Record does not exist",
  "result": null
}
```

---

### 9. POST /UpdateEmployeeSelfRating

Update employee self-rating for a specific quarter.

**Permission:** `EditKPI`

#### Request

```typescript
interface UpdateEmployeeSelfRatingRequestDto {
  goalId: number;              // Goal ID
  planId: number;              // Plan ID
  note?: string | null;        // Self-rating note
  quarter?: string | null;     // "Q1", "Q2", "Q3", or "Q4"
  rating?: number | null;      // Rating value (decimal)
  allowedQuarter?: string | null;    // Allowed quarters
  targetExpected?: string | null;    // Target description
}
```

**Headers:**
```
Authorization: Bearer {token}
Content-Type: application/json
```

**Body:**
```json
{
  "goalId": 1,
  "planId": 123,
  "note": "Met all quarterly targets",
  "quarter": "Q1",
  "rating": 4.5,
  "allowedQuarter": "Q1,Q2",
  "targetExpected": "15% increase"
}
```

#### Response

**Success (200):**
```json
{
  "statusCode": 200,
  "message": "Success",
  "result": 1
}
```

**Error (400):**
```json
{
  "statusCode": 400,
  "message": "Already submitted",
  "result": 0
}
```

**Error (404):**
```json
{
  "statusCode": 404,
  "message": "Cannot update",
  "result": 0
}
```

---

### 10. POST /UpdateEmployeeRatingByManager

Manager updates employee rating for a goal.

**Permission:** `EditKPI`

#### Request

```typescript
interface ManagerRatingUpdateRequestDto {
  planId: number;              // Plan ID
  goalId: number;              // Goal ID
  managerRating: number;       // Manager's rating (decimal)
  managerNote?: string | null; // Manager's comment
}
```

**Headers:**
```
Authorization: Bearer {token}
Content-Type: application/json
```

**Body:**
```json
{
  "planId": 123,
  "goalId": 1,
  "managerRating": 4.8,
  "managerNote": "Excellent performance this quarter"
}
```

#### Response

**Success (200):**
```json
{
  "statusCode": 200,
  "message": "Success",
  "result": 1
}
```

**Error (404):**
```json
{
  "statusCode": 404,
  "message": "Record does not exist",
  "result": 0
}
```

---

### 11. POST /SubmitKPIPlanByEmployee/{planId}

Employee submits their KPI plan.

**Permission:** `EditKPI`

#### Request

**Path Parameters:**
- `planId` (number, required) - The ID of the KPI plan to submit

**Headers:**
```
Authorization: Bearer {token}
```

#### Response

**Success (200):**
```json
{
  "statusCode": 200,
  "message": "Submitted",
  "result": 1
}
```

**Error (200):**
```json
{
  "statusCode": 200,
  "message": "Already submitted",
  "result": 1
}
```

---

### 12. POST /AssignGoalByManager

Manager assigns a goal to an employee and sets targets.

**Permission:** `EditKPI`

#### Request

```typescript
interface AssignGoalByManagerRequestDto {
  goalId: number;                  // Goal ID to assign
  employeeId: number;              // Employee ID
  allowedQuarter?: string | null;  // Allowed quarters (e.g., "Q1,Q2,Q3")
  targetExpected?: string | null;  // Expected target description
  planId?: number | null;          // Optional plan ID
}
```

**Headers:**
```
Authorization: Bearer {token}
Content-Type: application/json
```

**Body:**
```json
{
  "goalId": 1,
  "employeeId": 101,
  "allowedQuarter": "Q1,Q2,Q3,Q4",
  "targetExpected": "Achieve 20% growth in sales",
  "planId": null
}
```

#### Response

**Success (200):**
```json
{
  "statusCode": 200,
  "message": "Assigned successfully",
  "result": 1
}
```

**Error (200):**
```json
{
  "statusCode": 200,
  "message": "Already assigned",
  "result": 0
}
```

---

### 13. POST /SubmitKPIPlanByManager/{planId}

Manager submits review of employee's KPI plan.

**Permission:** `EditKPI`

#### Request

**Path Parameters:**
- `planId` (number, required) - The ID of the KPI plan to submit

**Headers:**
```
Authorization: Bearer {token}
```

#### Response

**Success (200):**
```json
{
  "statusCode": 200,
  "message": "Reviewed",
  "result": 1
}
```

**Note:** This endpoint also triggers an email notification to admin.

**Error (200):**
```json
{
  "statusCode": 200,
  "message": "Already reviewed",
  "result": 1
}
```

---

### 14. POST /GetManagerRatingHistoryByGoal

Get history of manager ratings for a specific goal.

**Permission:** `EditKPI`

#### Request

```typescript
interface GetRatingHistoryRequestDto {
  planId: number;  // Plan ID
  goalId: number;  // Goal ID
}
```

**Headers:**
```
Authorization: Bearer {token}
Content-Type: application/json
```

**Body:**
```json
{
  "planId": 123,
  "goalId": 1
}
```

#### Response

**Success (200):**
```json
{
  "statusCode": 200,
  "message": "Success",
  "result": [
    {
      "managerId": 50,
      "managerName": "Sarah Johnson",
      "managerRating": 4.5,
      "managerComment": "Good progress in Q1",
      "createdOn": "2024-04-01T10:00:00Z"
    },
    {
      "managerId": 50,
      "managerName": "Sarah Johnson",
      "managerRating": 4.8,
      "managerComment": "Excellent performance in Q2",
      "createdOn": "2024-07-01T10:00:00Z"
    }
  ]
}
```

**Error (200):**
```json
{
  "statusCode": 200,
  "message": "Record does not exist",
  "result": null
}
```

---

### 15. GET /GetEmployeeRatingByManager/{EmployeeId}

Get all KPI ratings for an employee across all plans.

**Permission:** `ReadKPI`

#### Request

**Path Parameters:**
- `EmployeeId` (number, required) - The ID of the employee

**Headers:**
```
Authorization: Bearer {token}
```

#### Response

**Success (200):**
```json
{
  "statusCode": 200,
  "message": "Success",
  "result": [
    {
      "employeeCode": "EMP001",
      "employeeName": "John Doe",
      "email": "john.doe@example.com",
      "employeeId": 101,
      "joiningDate": "2020-01-15",
      "ratings": [
        {
          "planId": 123,
          "reviewDate": "2024-06-30",
          "isReviewed": true,
          "lastAppraisal": "2023-12-31",
          "nextAppraisal": "2024-12-31",
          "goals": [
            {
              "goalId": 1,
              "q1_Rating": 4.5,
              "q2_Rating": 4.8,
              "q3_Rating": null,
              "q4_Rating": null,
              "q1_Note": "Exceeded expectations",
              "q2_Note": "Outstanding performance",
              "q3_Note": null,
              "q4_Note": null,
              "managerRating": 4.6,
              "managerNote": "Great work overall",
              "goalTitle": "Improve Sales Performance",
              "targetExpected": "15% increase",
              "status": true,
              "allowedQuarter": "Q1,Q2,Q3,Q4"
            }
          ]
        }
      ]
    }
  ]
}
```

**Error (200):**
```json
{
  "statusCode": 200,
  "message": "Record does not exist",
  "result": []
}
```

---

## Data Types

### Core Entities

```typescript
// KPI Goal Entity
interface KPIGoals {
  id: number;
  title: string;
  description?: string | null;
  departmentId: number;
  employeeIds: string;         // Comma-separated employee IDs
  createdBy: string;
  createdOn: string;           // ISO 8601 date-time
  modifiedBy?: string | null;
  modifiedOn?: string | null;
  isDeleted: boolean;
}

// KPI Plan Entity
interface KPIPlan {
  id: number;
  employeeId: number;
  appraisalCycle?: string | null;
  isReviewed?: boolean | null;
  reviewDate?: string | null;  // ISO 8601 date-time
  overallProgress?: string | null;
  appraisalNote?: string | null;
  appraisalAttachment?: string | null;
  createdBy: string;
  createdOn: string;
  modifiedBy?: string | null;
  modifiedOn?: string | null;
  isDeleted: boolean;
}

// KPI Details Entity
interface KPIDetails {
  id: number;
  planId: number;
  goalId: number;
  q1_Rating?: number | null;
  q2_Rating?: number | null;
  q3_Rating?: number | null;
  q4_Rating?: number | null;
  q1_Note?: string | null;
  q2_Note?: string | null;
  q3_Note?: string | null;
  q4_Note?: string | null;
  targetExpected?: string | null;
  employeeRating?: number | null;
  managerRating?: number | null;
  employeeNote?: string | null;
  managerNote?: string | null;
  status?: boolean | null;     // Submission status
  allowedQuarter?: string | null;
  createdBy: string;
  createdOn: string;
  modifiedBy?: string | null;
  modifiedOn?: string | null;
  isDeleted: boolean;
}
```

### Request DTOs

```typescript
interface GoalRequestDto {
  id: number;
  title: string;
  description: string;
  departmentId: number;
  employeeIds?: string;
}

interface KPIGoalRequestDto {
  title?: string | null;
  departmentId?: number | null;
  createdOnFrom?: string | null;    // DateOnly format (YYYY-MM-DD)
  createdOnTo?: string | null;      // DateOnly format (YYYY-MM-DD)
  createdBy?: string;
}

interface GetEmpByManagerRequestDto {
  employeeName?: string | null;
  employeeCode?: string | null;
  appraisalDateFrom?: string | null;    // DateOnly format
  appraisalDateTo?: string | null;      // DateOnly format
  reviewDateFrom?: string | null;       // DateOnly format
  reviewDateTo?: string | null;         // DateOnly format
  statusFilter?: number | null;
}

interface UpdateEmployeeSelfRatingRequestDto {
  goalId: number;
  planId: number;
  note?: string | null;
  quarter?: string | null;              // "Q1", "Q2", "Q3", "Q4"
  rating?: number | null;
  allowedQuarter?: string | null;
  targetExpected?: string | null;
}

interface ManagerRatingUpdateRequestDto {
  planId: number;
  goalId: number;
  managerRating: number;
  managerNote?: string | null;
}

interface AssignGoalByManagerRequestDto {
  goalId: number;
  employeeId: number;
  allowedQuarter?: string | null;
  targetExpected?: string | null;
  planId?: number | null;
}

interface GetRatingHistoryRequestDto {
  planId: number;
  goalId: number;
}
```

### Response DTOs

```typescript
interface GoalResponseDto {
  id: number;
  title: string;
  description: string;
  departmentId: number;
  createdOn: string;               // ISO 8601 date-time
  createdBy: string;
  department: string;              // Department name
}

interface KPIGoalsSearchResponseDto {
  totalRecords: number;
  goalList: GoalResponseDto[];
}

interface EmployeeByManagerResponse {
  employeeName: string;
  employeeCode: string;
  nextAppraisalDate?: string | null;  // DateOnly format
  lastReviewDate?: string | null;     // DateOnly format
  planId: number;
  email?: string | null;
  employeeId?: number | null;
  joiningDate?: string | null;        // DateOnly format
  reviewDate?: string | null;         // DateOnly format
  isReviewed?: boolean | null;
}

interface GetEmpListResponseDto {
  totalRecords: number;
  goalList: EmployeeByManagerResponse[];
}

interface GetSelfRatingListDto {
  goalId: number;
  q1_Rating?: number | null;
  q2_Rating?: number | null;
  q3_Rating?: number | null;
  q4_Rating?: number | null;
  q1_Note?: string | null;
  q2_Note?: string | null;
  q3_Note?: string | null;
  q4_Note?: string | null;
  managerRating?: number | null;
  managerNote?: string | null;
  goalTitle: string;
  targetExpected?: string | null;
  status?: boolean | null;
  allowedQuarter?: string | null;
}

interface GetSelfRatingResponseDto {
  employeeCode: string;
  employeeName?: string | null;
  email?: string | null;
  employeeId: number;
  planId: number;
  reviewDate?: string | null;         // DateOnly format
  isReviewed?: boolean | null;
  joiningDate?: string | null;        // DateOnly format
  lastAppraisal?: string | null;      // DateOnly format
  nextAppraisal?: string | null;      // DateOnly format
  ratings: GetSelfRatingListDto[];
}

interface ReportingManagerResponseDto {
  id: number;
  email: string;
  firstName: string;
  middleName: string;
  lastName: string;
}

interface ManagerRatingHistoryByGoalResponseDto {
  managerId: number;
  managerName?: string | null;
  managerRating?: number | null;
  managerComment?: string | null;
  createdOn: string;                  // ISO 8601 date-time
}

interface PlanRatingDto {
  planId: number;
  reviewDate?: string | null;         // DateOnly format
  isReviewed?: boolean | null;
  lastAppraisal?: string | null;      // DateOnly format
  nextAppraisal?: string | null;      // DateOnly format
  goals: GetSelfRatingListDto[];
}

interface GetEmployeeRatingByManagerResponseDto {
  employeeCode?: string | null;
  employeeName?: string | null;
  email?: string | null;
  employeeId: number;
  joiningDate?: string | null;        // DateOnly format
  ratings?: PlanRatingDto[] | null;
}
```

### Common Types

```typescript
interface SearchRequestDto<T> {
  sortColumnName: string;
  sortDirection: string;              // "asc" or "desc"
  startIndex: number;                 // 0-based pagination
  pageSize: number;
  filters: T;
}

interface ApiResponseModel<T> {
  statusCode: number;
  message: string;
  result: T | null;
}

enum CrudResult {
  Failed = 0,
  Success = 1
}
```

---

## Error Responses

All errors follow the standard `ApiResponseModel<T>` format.

### Common Error Status Codes

- **200 with Failed Result**: Business logic error (record not found, already exists, etc.)
- **400**: Bad Request (invalid data, validation failed)
- **401**: Unauthorized (missing or invalid JWT token)
- **403**: Forbidden (insufficient permissions)
- **404**: Not Found (endpoint doesn't exist)
- **500**: Internal Server Error

### Standard Error Messages

```typescript
const ErrorMessages = {
  InvalidRequest: "Invalid request",
  RecordNotExist: "Record does not exist",
  AlreadySubmit: "Already submitted",
  CannotUpdate: "Cannot update",
  AlreadyAssigned: "Already assigned",
  AlreadyReviewed: "Already reviewed",
  NotFoundMessage: "Record not found"
};
```

### Standard Success Messages

```typescript
const SuccessMessages = {
  Success: "Success",
  GoalAdded: "Goal added successfully",
  GoalUpdated: "Goal updated successfully",
  GoalDeleted: "Goal deleted successfully",
  Submitted: "Submitted",
  AssignedSuccessfully: "Assigned successfully",
  Reviewed: "Reviewed"
};
```

---

## Permissions

The following permissions are required for KPI endpoints:

- `CreateKPI`: Create new KPI goals
- `ReadKPI`: Read KPI data (goals, plans, ratings)
- `EditKPI`: Update KPI data (goals, ratings, submissions)
- `DeleteKPI`: Delete KPI goals
- `ReadKPIGoals`: Read KPI goals list
- `ReadKPIDashBoard`: Access manager dashboard

---

## Business Rules

### KPI Plan Creation
- KPI Plan is automatically created for an employee if it doesn't exist when:
  - A goal is assigned to the employee
  - Manager assigns goals to the employee

### Goal Assignment
- Goals can be assigned to multiple employees via comma-separated IDs
- When updating a goal, the system:
  - Assigns goals to new employees
  - Revokes goals from removed employees

### Self-Rating Submission
- Employees can only rate for allowed quarters
- Cannot update rating after submission (status = true)
- Rating is saved per quarter (Q1, Q2, Q3, Q4)

### Manager Rating
- Manager rating creates a history entry for audit trail
- Manager can update ratings multiple times (history is preserved)

### Submission Flow
1. Employee submits self-ratings
2. Manager reviews and submits ratings
3. On manager submission, email notification is sent to admin

### Date Formats
- **DateTime**: ISO 8601 format (YYYY-MM-DDTHH:mm:ssZ)
- **DateOnly**: Simple date format (YYYY-MM-DD)

---

## Notes

1. All endpoints require JWT Bearer authentication
2. Permission-based authorization is enforced on all endpoints
3. The API uses the current user's context from JWT token for:
   - `SessionUserId`: Current user's ID
   - `UserEmailId`: Current user's email
   - `RoleId`: Current user's role ID
4. Pagination is 0-based (startIndex starts from 0)
5. Sorting is case-insensitive
6. Filters support partial matching for text fields
7. Decimal ratings typically range from 0.0 to 5.0 (implementation-dependent)
8. Quarter format: "Q1", "Q2", "Q3", "Q4" or comma-separated for allowed quarters
