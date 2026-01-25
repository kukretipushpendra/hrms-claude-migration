# Employee Management - Frontend QA Report

**Date:** 2026-01-25
**Feature:** employee/employee-management
**QA Type:** frontend-qa
**Status:** FAIL

## Executive Summary

The employee management frontend implementation has **CRITICAL ISSUES** that prevent it from functioning correctly with the .NET backend. The implementation does not match the actual backend API contract.

## Critical Issues Found

### 1. CRITICAL: Export Endpoint Mismatch
**File:** `modern/frontend/src/services/employees/employeesService.ts:85`
**Issue:** Export endpoint URL is incorrect
**Expected:** `/Employee/export`
**Actual:** `/Employee/ExportEmployeeList`

**Evidence from Legacy:**
```csharp
// legacy/Backend/HRMSWebApi/HRMS.API/Controllers/EmployeeController.cs:58
[HttpPost("export")]
[HasPermission(Permissions.ViewEmployees)]
public async Task<IActionResult> ExportEmployeeListToExcel([FromBody] SearchRequestDto<EmployeeSearchRequestDto> employeeSearchRequestDto)
```

**Impact:** Export functionality will fail with 404 error.

---

### 2. CRITICAL: Response Field Casing Mismatch
**File:** `modern/frontend/src/services/employees/types.ts:60-63`
**Issue:** TypeScript types define camelCase but .NET returns PascalCase

**Expected (from .NET backend):**
```typescript
interface GetEmployeeListResponse {
  statusCode: number;
  message: string;
  modelErrors: string[];
  result: {
    EmployeeList: EmployeeType[];  // PascalCase
    TotalRecords: number;           // PascalCase
  };
}
```

**Actual in types.ts:**
```typescript
result: {
  employeeList: EmployeeType[];  // camelCase - WRONG
  totalRecords: number;           // camelCase - WRONG
}
```

**Evidence from Legacy:**
```csharp
// HRMS.Models/Models/Employees/EmployeeListSearchResponseDto.cs:15-16
public IEnumerable<EmployeeListResponseDto> EmployeeList { get; set; }
public int TotalRecords { get; set; }
```

**Impact:** Frontend will receive data but cannot access it correctly. `response.result.employeeList` will be undefined.

---

### 3. CRITICAL: Request Filter Properties Casing
**File:** `modern/frontend/src/services/employees/types.ts:43-54`
**Issue:** Filter properties use camelCase but .NET expects PascalCase

**Expected (from .NET backend):**
```typescript
interface EmployeeSearchFilter {
  EmployeeCode?: string;      // PascalCase
  EmployeeName?: string;       // PascalCase
  DepartmentId: number;        // PascalCase
  DesignationId: number;       // PascalCase
  RoleId: number;              // PascalCase
  EmployeeStatus: number;      // PascalCase
  EmploymentStatus: number;    // PascalCase
  BranchId: number;            // PascalCase
  CountryId: number;           // PascalCase
  DOJFrom: string | null;      // PascalCase
  DOJTo: string | null;        // PascalCase
}
```

**Actual in types.ts:**
```typescript
export interface EmployeeSearchFilter {
  employeeCode?: string;       // camelCase - WRONG
  departmentId: number;        // camelCase - WRONG
  designationId: number;       // camelCase - WRONG
  // ... all fields are camelCase
}
```

**Evidence from Legacy:**
```csharp
// HRMS.Models/Models/Employees/EmployeeSearchRequestDto.cs:7-19
public string EmployeeCode { get; set; } = string.Empty;
public string EmployeeName { get; set; } = string.Empty;
public int DepartmentId { get; set; }
public int DesignationId { get; set; }
public int RoleId { get; set; }
public int EmployeeStatus { get; set; }
public int EmploymentStatus { get; set; }
```

**Impact:** Backend will receive empty filters, resulting in unfiltered data being returned.

---

### 4. CRITICAL: GetEmployeeListArgs Properties Casing
**File:** `modern/frontend/src/services/employees/types.ts:66-72`
**Issue:** Already using PascalCase correctly - BUT component passes incorrect data

**Current (CORRECT):**
```typescript
export interface GetEmployeeListArgs {
  SortColumnName: string;     // ✓ Correct
  SortDirection: string;      // ✓ Correct
  StartIndex: number;         // ✓ Correct
  PageSize: number;           // ✓ Correct
  Filters: EmployeeSearchFilter;  // BUT EmployeeSearchFilter is wrong
}
```

**Evidence:** This matches the legacy SearchRequestDto correctly, but the nested Filters object has wrong casing.

---

### 5. HIGH: Employee Response Structure Mismatch
**File:** `modern/frontend/src/services/employees/types.ts:1-41`
**Issue:** EmployeeType interface doesn't match actual .NET response

**Expected (from .NET):**
```typescript
interface EmployeeListResponseDto {
  Id: number;                  // PascalCase
  EmployeeCode: string;        // PascalCase
  EmployeeName: string;        // PascalCase
  Country: string;             // PascalCase
  Email: string;               // PascalCase
  JoiningDate: string;         // PascalCase (DateTime)
  JobType: number;             // Enum number
  Branch: number;              // Number
  DepartmentName: string;      // PascalCase
  Designation: string;         // PascalCase
  Phone: string;               // PascalCase
  PersonalEmail: string;       // PascalCase
  EmployeeStatus: string;      // PascalCase (string, not number!)
}
```

**Actual in types.ts:**
```typescript
export interface EmployeeType {
  slNo: number;               // Not in API response
  id: number;                 // camelCase - WRONG
  employeeCode: string;       // camelCase - WRONG
  // ... 30+ more fields that don't exist in EmployeeListResponseDto
}
```

**Evidence from Legacy:**
```csharp
// HRMS.Models/Models/Employees/EmployeeListResponseDto.cs:10-25
public class EmployeeListResponseDto
{
    public int Id { get; set; }
    public string EmployeeCode { get; set; }
    public string EmployeeName { get; set; }
    // ... etc
}
```

**Impact:** Type mismatch - the EmployeeType interface includes many fields not returned by GetEmployees API. This is likely a detailed employee type, not the list response type.

---

### 6. MEDIUM: API Contract Documentation Incorrect
**File:** `migration/api-contracts/employee/get-employees.api.md`
**Issue:** Contract shows camelCase response but .NET actually returns PascalCase

**Contract says:**
```json
{
  "data": {
    "employeeList": [...],
    "totalRecords": 0
  }
}
```

**Actual .NET response:**
```json
{
  "result": {
    "EmployeeList": [...],
    "TotalRecords": 0
  }
}
```

**Issues:**
1. Field name is `result` not `data`
2. Fields are PascalCase not camelCase
3. Contract TypeScript types are correct but JSON example is wrong

---

### 7. HIGH: Import Excel Endpoint Correct
**File:** `modern/frontend/src/services/employees/employeesService.ts:96-110`
**Status:** ✓ Appears correct

**Evidence:** Matches legacy controller at line 75:
```csharp
[HttpPost]
[Route("ImportExcel")]
public async Task<IActionResult> ImportExcel(IFormFile excefile, bool importConfirmed)
```

The service correctly sends multipart/form-data with `excefile` and query param `importConfirmed`.

---

## View Component Analysis

### EmployeeListView.vue

**File:** `modern/frontend/src/views/employees/EmployeeListView.vue`

#### Issues:

1. **Line 369:** Accessing `response.result?.employeeList` - will be undefined
   - Should be: `response.result?.EmployeeList` (PascalCase)

2. **Line 370:** Accessing `response.result?.totalRecords` - will be undefined
   - Should be: `response.result?.TotalRecords` (PascalCase)

3. **Line 282:** Filter object initialization uses camelCase
   - Should use PascalCase to match .NET backend

4. **Line 364:** 1-based pagination is correct (StartIndex: (page.value - 1) * itemsPerPage.value + 1)

5. **Line 399:** Export endpoint call will fail (uses wrong endpoint)

---

### EmployeeDetailView.vue

**File:** `modern/frontend/src/views/employees/EmployeeDetailView.vue`

#### Issues:

1. **Line 241:** Accessing `response.result` - should work if getEmployeeById is correct
2. Need to verify getEmployeeById endpoint matches legacy (not in scope for list feature)

---

## Test Plan Results

Due to backend not running, performed static analysis instead of runtime testing.

### Static Analysis Checklist

- [✗] Service endpoints match legacy controller
  - GetEmployees: ✓ Correct (`/Employee/GetEmployees`)
  - Export: ✗ Incorrect (`/Employee/ExportEmployeeList` should be `/Employee/export`)
  - Import: ✓ Correct (`/Employee/ImportExcel`)

- [✗] Request payload structure matches .NET DTOs
  - Top-level properties: ✓ PascalCase (correct)
  - Filter properties: ✗ camelCase (should be PascalCase)

- [✗] Response parsing matches .NET DTOs
  - Response structure: ✗ Expects camelCase, gets PascalCase
  - Field names: ✗ Mismatch (employeeList vs EmployeeList)

- [✗] TypeScript types match API contracts
  - Request types: ✗ Filter properties wrong casing
  - Response types: ✗ Wrong casing and wrong structure

- [✓] Component uses correct pagination (1-based StartIndex)

- [✗] Component correctly parses API responses
  - Expects camelCase fields that don't exist

---

## Required Fixes

### Fix 1: Correct Export Endpoint
**File:** `modern/frontend/src/services/employees/employeesService.ts`
**Line:** 85
**Change:**
```typescript
// FROM:
const response = await httpClient.post(`${baseRoute}/ExportEmployeeList`, args, {

// TO:
const response = await httpClient.post(`${baseRoute}/export`, args, {
```

### Fix 2: Update Response Type to PascalCase
**File:** `modern/frontend/src/services/employees/types.ts`
**Lines:** 56-64
**Change:**
```typescript
// FROM:
export interface GetEmployeeListResponse {
  statusCode: number;
  message: string;
  modelErrors: string[];
  result: {
    employeeList: EmployeeType[];
    totalRecords: number;
  };
}

// TO:
export interface GetEmployeeListResponse {
  statusCode: number;
  message: string;
  modelErrors: string[];
  result: {
    EmployeeList: EmployeeType[];  // PascalCase
    TotalRecords: number;           // PascalCase
  };
}
```

### Fix 3: Update Request Filter Properties to PascalCase
**File:** `modern/frontend/src/services/employees/types.ts`
**Lines:** 43-54
**Change:**
```typescript
// FROM:
export interface EmployeeSearchFilter {
  employeeCode?: string;
  departmentId: number;
  designationId: number;
  roleId: number;
  employeeStatus: number;
  employmentStatus: number;
  branchId: number;
  dojFrom: string | null;
  dojTo: string | null;
  countryId: number;
}

// TO:
export interface EmployeeSearchFilter {
  EmployeeCode?: string;      // PascalCase
  EmployeeName?: string;       // Add missing field
  DepartmentId: number;        // PascalCase
  DesignationId: number;       // PascalCase
  RoleId: number;              // PascalCase
  EmployeeStatus: number;      // PascalCase
  EmploymentStatus: number;    // PascalCase
  BranchId?: number;           // PascalCase, optional
  CountryId?: number;          // PascalCase, optional
  DOJFrom?: string | null;     // PascalCase
  DOJTo?: string | null;       // PascalCase
  EmployeeEmail?: string;      // Add missing field
}
```

### Fix 4: Update Component to Use PascalCase Response
**File:** `modern/frontend/src/views/employees/EmployeeListView.vue`
**Lines:** 369-370
**Change:**
```typescript
// FROM:
employees.value = response.result?.employeeList || [];
totalRecords.value = response.result?.totalRecords || 0;

// TO:
employees.value = response.result?.EmployeeList || [];
totalRecords.value = response.result?.TotalRecords || 0;
```

### Fix 5: Update Component Filter Initialization
**File:** `modern/frontend/src/views/employees/EmployeeListView.vue`
**Lines:** 270-280
**Change:**
```typescript
// FROM:
const DEFAULT_FILTERS: EmployeeSearchFilter = {
  departmentId: 0,
  designationId: 0,
  roleId: initialRoleId.value,
  employeeStatus: 0,
  employmentStatus: 0,
  branchId: 0,
  dojFrom: null,
  dojTo: null,
  countryId: 0,
};

// TO:
const DEFAULT_FILTERS: EmployeeSearchFilter = {
  EmployeeCode: '',
  EmployeeName: '',
  DepartmentId: 0,
  DesignationId: 0,
  RoleId: initialRoleId.value,
  EmployeeStatus: 0,
  EmploymentStatus: 0,
  BranchId: 0,
  CountryId: 0,
  DOJFrom: null,
  DOJTo: null,
};
```

### Fix 6: Fix Export Arguments in Component
**File:** `modern/frontend/src/views/employees/EmployeeListView.vue`
**Lines:** 393-396
**Change:**
```typescript
// FROM:
const filters = {
  ...employeeFilters.value,
  employeeCode: employeeCodes,
};

// TO:
const filters = {
  ...employeeFilters.value,
  EmployeeCode: employeeCodes,  // PascalCase
};
```

### Fix 7: Update API Contract Documentation
**File:** `migration/api-contracts/employee/get-employees.api.md`
**Lines:** 15-35
**Change:** Update JSON example to use PascalCase and correct field names

### Fix 8: Separate List Type from Detail Type
**File:** `modern/frontend/src/services/employees/types.ts`
**Recommendation:** Create separate interface for list response vs detail response
```typescript
// Add new interface for list items
export interface EmployeeListItem {
  Id: number;
  EmployeeCode: string;
  EmployeeName: string;
  Country: string;
  Email: string;
  JoiningDate: string;
  JobType: number;
  Branch: number;
  DepartmentName: string;
  Designation: string;
  Phone: string;
  PersonalEmail: string;
  EmployeeStatus: string;  // Note: string, not number!
}

// Update response to use correct type
export interface GetEmployeeListResponse {
  statusCode: number;
  message: string;
  modelErrors: string[];
  result: {
    EmployeeList: EmployeeListItem[];  // Use list-specific type
    TotalRecords: number;
  };
}
```

---

## Summary

**QA_RESULT:** FAIL
**CRITICAL_ISSUES:** 4
**HIGH_ISSUES:** 2
**MEDIUM_ISSUES:** 1

**Recommendation:** Spawn frontend-coder to fix casing mismatches between TypeScript types and .NET backend DTOs.

**Root Cause:** The implementation was created based on API contracts that documented camelCase responses, but the actual .NET backend returns PascalCase. This is a fundamental mismatch that affects all data flow.

**Next Steps:**
1. Increment FRONTEND_ATTEMPT_COUNT to 1
2. Set CURRENT to `frontend-in-progress`
3. Set FRONTEND_QA to `failed`
4. Spawn frontend-coder with specific fix instructions referencing this report
