# Data Access Contracts

> **Purpose**: Document core queries and commands by module for parity validation
> **Scope**: Documentation only - NO code implementation

---

## Contract Format

Each contract documents:
- **Operation**: What the query/command does
- **Input**: Parameters required
- **Output**: Result structure
- **SQL Pattern**: The query approach (inline, SP, etc.)

---

## Module: Authentication (AuthRepository)

### AUTH-001: ValidateCredentials
| Aspect | Details |
|--------|---------|
| **Operation** | Validate user login credentials |
| **Input** | `{ email: string, password: string }` |
| **Output** | `User \| null` |
| **SQL Pattern** | Inline query |
| **Tables** | `User` |

### AUTH-002: GetUserWithRoles
| Aspect | Details |
|--------|---------|
| **Operation** | Get user with assigned roles and permissions |
| **Input** | `{ userId: number }` |
| **Output** | `User & { roles: Role[], permissions: Permission[] }` |
| **SQL Pattern** | Multi-table JOIN |
| **Tables** | `User`, `UserRole`, `Role`, `RolePermission`, `Permission` |

### AUTH-003: RefreshTokenValidation
| Aspect | Details |
|--------|---------|
| **Operation** | Validate and rotate refresh token |
| **Input** | `{ refreshToken: string }` |
| **Output** | `{ user: User, newRefreshToken: string }` |
| **SQL Pattern** | Transaction (read + update) |
| **Tables** | `RefreshToken`, `User` |

---

## Module: User Profile (UserProfileRepository)

### PROFILE-001: GetEmployeeById
| Aspect | Details |
|--------|---------|
| **Operation** | Get complete employee profile |
| **Input** | `{ employeeId: number }` |
| **Output** | `EmployeeProfile` (complex nested object) |
| **SQL Pattern** | FOR JSON PATH subqueries |
| **Tables** | `EmployeeData`, `Address`, `EducationalDetail`, `EmploymentDetail` |

### PROFILE-002: GetEmployeeList (Paginated)
| Aspect | Details |
|--------|---------|
| **Operation** | Get paginated employee list with filters |
| **Input** | `{ filters: EmployeeFilters, sortColumn: string, sortDirection: 'ASC'\|'DESC', startIndex: number, pageSize: number }` |
| **Output** | `{ data: EmployeeSummary[], totalCount: number }` |
| **SQL Pattern** | QueryHelper + OFFSET/FETCH |
| **Tables** | `vw_EmployeeData` (view) |

### PROFILE-003: CreateEmployee
| Aspect | Details |
|--------|---------|
| **Operation** | Create new employee with related records |
| **Input** | `CreateEmployeeDto` |
| **Output** | `{ employeeId: number }` |
| **SQL Pattern** | Transaction (multi-insert) |
| **Tables** | `EmployeeData`, `Address`, `User` |

### PROFILE-004: UpdateEmployee
| Aspect | Details |
|--------|---------|
| **Operation** | Update employee profile |
| **Input** | `{ employeeId: number, data: UpdateEmployeeDto }` |
| **Output** | `boolean` (success) |
| **SQL Pattern** | Transaction (multi-update) |
| **Tables** | `EmployeeData`, `Address` |

---

## Module: Attendance (AttendanceRepository)

### ATT-001: GetAttendanceConfigList
| Aspect | Details |
|--------|---------|
| **Operation** | Get attendance configuration with pagination |
| **Input** | `{ filters: AttendanceFilters, sort, pagination }` |
| **Output** | `{ data: AttendanceConfig[], totalCount: number }` |
| **SQL Pattern** | Stored Procedure |
| **SP Name** | `[dbo].[GetAttendanceConfigList]` |

### ATT-002: GetEmployeeAttendance
| Aspect | Details |
|--------|---------|
| **Operation** | Get employee attendance for date range |
| **Input** | `{ employeeId: number, startDate: Date, endDate: Date }` |
| **Output** | `Attendance[]` |
| **SQL Pattern** | Inline query with date range |
| **Tables** | `Attendance` |

### ATT-003: MarkAttendance
| Aspect | Details |
|--------|---------|
| **Operation** | Record employee check-in/check-out |
| **Input** | `{ employeeId: number, type: 'IN'\|'OUT', timestamp: Date }` |
| **Output** | `{ attendanceId: number }` |
| **SQL Pattern** | INSERT with audit |
| **Tables** | `Attendance`, `AttendanceAudit` |

### ATT-004: BulkImportAttendance
| Aspect | Details |
|--------|---------|
| **Operation** | Import attendance records in bulk |
| **Input** | `AttendanceRecord[]` |
| **Output** | `{ inserted: number, updated: number, errors: Error[] }` |
| **SQL Pattern** | Transaction with MERGE or loop |
| **Tables** | `Attendance` |

---

## Module: Leave Management (LeaveManagementRepository)

### LEAVE-001: ApplyLeave
| Aspect | Details |
|--------|---------|
| **Operation** | Submit leave application |
| **Input** | `ApplyLeaveDto` |
| **Output** | `{ applicationId: number }` |
| **SQL Pattern** | Transaction (insert + balance check) |
| **Tables** | `AppliedLeave`, `LeaveBalance` |

### LEAVE-002: ApproveRejectLeave
| Aspect | Details |
|--------|---------|
| **Operation** | Manager approves/rejects leave |
| **Input** | `{ applicationId: number, status: 'APPROVED'\|'REJECTED', comments: string }` |
| **Output** | `boolean` |
| **SQL Pattern** | Transaction (update + balance adjust) |
| **Tables** | `AppliedLeave`, `LeaveBalance`, `LeaveAudit` |

### LEAVE-003: GetLeaveBalance
| Aspect | Details |
|--------|---------|
| **Operation** | Get employee leave balances |
| **Input** | `{ employeeId: number, year: number }` |
| **Output** | `LeaveBalance[]` |
| **SQL Pattern** | Inline query |
| **Tables** | `LeaveBalance`, `LeaveType` |

### LEAVE-004: CreditMonthlyLeaveBalance
| Aspect | Details |
|--------|---------|
| **Operation** | Batch credit monthly leave accruals |
| **Input** | `{ month: number, year: number }` |
| **Output** | `{ processed: number }` |
| **SQL Pattern** | Stored Procedure with cursor |
| **SP Name** | `[dbo].[CreditMonthlyLeaveBalance]` |

---

## Module: Asset Management (AssetManagementRepository)

### ASSET-001: GetAssetList
| Aspect | Details |
|--------|---------|
| **Operation** | Get paginated asset list |
| **Input** | `{ filters, sort, pagination }` |
| **Output** | `{ data: Asset[], totalCount: number }` |
| **SQL Pattern** | QueryHelper |
| **Tables** | `Asset`, `AssetCategory` |

### ASSET-002: AssignAsset
| Aspect | Details |
|--------|---------|
| **Operation** | Assign asset to employee |
| **Input** | `{ assetId: number, employeeId: number, assignedDate: Date }` |
| **Output** | `{ assignmentId: number }` |
| **SQL Pattern** | Transaction |
| **Tables** | `AssetAssignment`, `Asset`, `AssetHistory` |

### ASSET-003: ReturnAsset
| Aspect | Details |
|--------|---------|
| **Operation** | Mark asset as returned |
| **Input** | `{ assignmentId: number, returnDate: Date, condition: string }` |
| **Output** | `boolean` |
| **SQL Pattern** | Transaction (update + history) |
| **Tables** | `AssetAssignment`, `Asset`, `AssetHistory` |

---

## Module: Grievance (GrievanceRepository)

### GRIEV-001: SubmitGrievance
| Aspect | Details |
|--------|---------|
| **Operation** | Submit new grievance |
| **Input** | `CreateGrievanceDto` |
| **Output** | `{ grievanceId: number }` |
| **SQL Pattern** | INSERT |
| **Tables** | `Grievance` |

### GRIEV-002: GetEmployeeGrievances
| Aspect | Details |
|--------|---------|
| **Operation** | Get grievances for employee (paginated) |
| **Input** | `{ employeeId: number, filters, pagination }` |
| **Output** | `{ data: Grievance[], totalCount: number }` |
| **SQL Pattern** | Stored Procedure |
| **SP Name** | `[dbo].[GetEmployeeGrievances]` |

### GRIEV-003: UpdateGrievanceStatus
| Aspect | Details |
|--------|---------|
| **Operation** | Update grievance status |
| **Input** | `{ grievanceId: number, status: GrievanceStatus, resolution: string }` |
| **Output** | `boolean` |
| **SQL Pattern** | UPDATE with audit |
| **Tables** | `Grievance`, `GrievanceAudit` |

---

## Module: Dashboard (DashboardRepository)

### DASH-001: GetDashboardStats
| Aspect | Details |
|--------|---------|
| **Operation** | Get aggregated dashboard statistics |
| **Input** | `{ userId: number, date: Date }` |
| **Output** | `DashboardStats` |
| **SQL Pattern** | Multiple aggregation queries |
| **Tables** | Multiple (cross-module) |

### DASH-002: GetRecentActivities
| Aspect | Details |
|--------|---------|
| **Operation** | Get recent activity feed |
| **Input** | `{ limit: number }` |
| **Output** | `Activity[]` |
| **SQL Pattern** | UNION of recent records |
| **Tables** | `AppliedLeave`, `Grievance`, `Attendance`, etc. |

---

## Module: Survey (SurveyRepository)

### SURV-001: GetActiveSurveys
| Aspect | Details |
|--------|---------|
| **Operation** | Get active surveys for employee |
| **Input** | `{ employeeId: number }` |
| **Output** | `Survey[]` |
| **SQL Pattern** | Inline query with date filter |
| **Tables** | `Survey`, `SurveyAssignment` |

### SURV-002: SubmitSurveyResponse
| Aspect | Details |
|--------|---------|
| **Operation** | Submit survey responses |
| **Input** | `{ surveyId: number, employeeId: number, responses: SurveyResponse[] }` |
| **Output** | `boolean` |
| **SQL Pattern** | Transaction (multi-insert) |
| **Tables** | `SurveyResponse`, `SurveyAnswer` |

---

## Module: Role & Permission (RolePermissionRepository)

### ROLE-001: GetRolesWithPermissions
| Aspect | Details |
|--------|---------|
| **Operation** | Get all roles with their permissions |
| **Input** | `{ includeInactive: boolean }` |
| **Output** | `Role[]` (with nested permissions) |
| **SQL Pattern** | FOR JSON PATH |
| **Tables** | `Role`, `RolePermission`, `Permission` |

### ROLE-002: AssignPermissionsToRole
| Aspect | Details |
|--------|---------|
| **Operation** | Set permissions for a role |
| **Input** | `{ roleId: number, permissionIds: number[] }` |
| **Output** | `boolean` |
| **SQL Pattern** | Transaction (delete existing + insert new) |
| **Tables** | `RolePermission` |

---

## Common Patterns

### Soft Delete Pattern
```sql
-- All queries should include
WHERE IsDeleted = 0
-- Or use view that filters deleted records
```

### Audit Trail Pattern
```sql
-- On INSERT
CreatedBy = @UserId, CreatedOn = GETUTCDATE()

-- On UPDATE
ModifiedBy = @UserId, ModifiedOn = GETUTCDATE()
```

### Pagination Pattern
```sql
ORDER BY {SortColumn} {SortDirection}
OFFSET @StartIndex ROWS
FETCH NEXT @PageSize ROWS ONLY
```

### Count + Data Pattern (Stored Procedures)
```sql
-- First result set: total count
SELECT COUNT(*) FROM ...

-- Second result set: paginated data
SELECT * FROM ... ORDER BY ... OFFSET ... FETCH ...
```

---

## Validation Rules by Contract

### PROFILE-003 (CreateEmployee)
- EmployeeCode: Required, unique, max 20 chars
- Email: Required, valid format, unique
- Phone: Required, valid format
- DOB: Required, must be in past, min age 18

### LEAVE-001 (ApplyLeave)
- StartDate: Required, not in past
- EndDate: Required, >= StartDate
- LeaveType: Must have sufficient balance
- No overlapping applications

### ATT-003 (MarkAttendance)
- No duplicate check-in without check-out
- Time must be current day (no backdating)
- Employee must be active

---

## Response Shape Contracts

### Standard List Response
```typescript
interface PaginatedResponse<T> {
  data: T[];
  totalCount: number;
  page: number;
  pageSize: number;
  totalPages: number;
}
```

### Standard Single Response
```typescript
interface SingleResponse<T> {
  statusCode: number;
  message: string;
  result: T;
}
```

### Error Response
```typescript
interface ErrorResponse {
  statusCode: number;
  message: string;
  errors?: ValidationError[];
}
```

---

## Notes for Node.js Implementation

1. **Maintain exact response shapes** - Legacy clients depend on these
2. **Preserve validation order** - Errors should occur in same sequence
3. **Match SQL execution order** - Especially for transactions
4. **Honor soft delete** - Always filter `IsDeleted = 0`
5. **UTC timestamps** - Use UTC for all date/time storage
6. **Audit trail** - Populate CreatedBy/ModifiedBy on every write
