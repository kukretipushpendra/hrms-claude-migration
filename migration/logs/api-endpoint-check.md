# API Endpoint Check - Modern Frontend vs .NET Backend

**Date:** 2026-01-27
**Purpose:** Verify all API endpoints in modern Vue.js frontend match the .NET backend

## Summary

**Status:** 🔴 CRITICAL ISSUES FOUND

**Total Services Checked:** 18
**Issues Found:** 2 critical mismatches

---

## Critical Issues

### 1. Document Service - Wrong HTTP Client Import

**File:** `modern/frontend/src/services/document/document.service.ts`

**Issue:**
```typescript
// Line 1: WRONG import
import apiClient from '../api/axios-client';
```

**Problem:**
- Service imports from `axios-client.ts` which **DOES NOT EXIST**
- Should use `http-client.ts` like all other services
- All API calls use `/api/` prefix manually instead of relying on baseURL

**Impact:**
- Document service will fail at runtime
- API calls will fail with 404 errors
- Missing JWT token interceptor
- Missing refresh token logic

**Fix Required:**
```typescript
// Change line 1 to:
import httpClient from '../api/http-client';

// Update all apiClient.get/post calls to:
httpClient.get/post
```

**Affected Endpoints:**
- GET `/api/UserProfile/GovtDocumentList/{idProofFor}`
- GET `/api/UserProfile/GetUserDocumentList/{employeeId}`
- GET `/api/UserProfile/GetUserDocumentById/{id}`
- POST `/api/UserProfile/UploadUserDocument`
- POST `/api/UserProfile/UpdateUploadUserDocument`
- GET `/api/UserProfile/DownloadUserDocument`
- GET `/api/UserProfile/GetUserDocumentUrl`

---

### 2. Certificate Service - Typo in Backend Endpoint

**File:** `modern/frontend/src/services/certificates/certificate.service.ts`

**Backend Endpoint (Line 95 in CertificateController.cs):**
```csharp
[Route("GetEmployeeCerificateList")]  // Note: "Cerificate" not "Certificate"
```

**Frontend Call (Line 42 in certificate.service.ts):**
```typescript
`${baseRoute}/GetEmployeeCerificateList`  // Matches backend typo
```

**Status:** ✅ **CORRECT** - Frontend matches backend typo
**Note:** This is a backend typo but frontend correctly uses the typo to match the actual endpoint.

---

## Verified Services (No Issues)

### ✅ Assets Service
- Base Route: `/AssetManagement`
- Endpoints: 6 endpoints verified
- All match backend controller

### ✅ Attendance Service
- Base Route: `/Attendance`
- Endpoints: 7 endpoints verified
- Correct PascalCase conversion for .NET

### ✅ Dashboard Service
- Base Route: `/Dashboard`
- Endpoints: 7 endpoints verified
- Correct null handling for DateOnly parameters

### ✅ Employees Service
- Base Route: `/Employee`
- Endpoints: 8 endpoints verified
- Correct filter transformation to PascalCase

### ✅ Employment Service
- Base Route: `/UserProfile`
- Endpoints: 8 endpoints verified
- Correct route: `/RolePermission/GetRolesList` for role list

### ✅ Events Service
- Base Route: `/Event`
- Endpoints: 5 endpoints verified
- Correct multipart/form-data for file uploads

### ✅ Exit Service
- Base Route: `/ExitEmployee` and `/AdminExitEmployee`
- Endpoints: 16 endpoints verified
- Correct PascalCase for .NET payloads
- Correct multipart/form-data for clearance attachments

### ✅ Grievance Service
- Base Route: `/Grievance`
- Endpoints: 15 endpoints verified
- Correct response unwrapping from .NET ApiResponse wrapper

### ✅ KPI Service
- Base Route: `/KPI`
- Endpoints: 12 endpoints verified
- All goal and rating endpoints match

### ✅ Leave Service
- Base Route: `/LeaveManagement` and `/EmployeeLeave`
- Endpoints: 6 endpoints verified
- Correct dual base routes for different operations

### ✅ Nominee Service
- Base Route: `/UserProfile`
- Endpoints: 6 endpoints verified
- Correct FormData conversion for file uploads

### ✅ Policy Service
- Base Route: `/CompanyPolicy`
- Endpoints: 7 endpoints verified
- Correct multipart/form-data for document uploads

### ✅ Roles Service
- Base Route: `/RolePermission`
- Endpoints: 4 endpoints verified
- All permission endpoints match

### ✅ Support/Feedback Service
- Base Route: `/Feedback`
- Endpoints: 5 endpoints verified
- Correct API response unwrapping

### ✅ Developer Service
- Base Route: `/DevTool`
- Endpoints: 5 endpoints verified
- All developer tool endpoints match

### ✅ Email Service
- Base Route: `/NotificationTemplate`
- Endpoints: 7 endpoints verified
- All template endpoints match

### ✅ User Guide Service
- Base Route: `/UserGuide`
- Endpoints: 5 endpoints verified
- All user guide endpoints match

---

## Common Patterns Verified

### ✅ Request/Response Patterns
1. **PascalCase Conversion**: All services correctly convert camelCase to PascalCase for .NET
2. **Multipart Form Data**: File uploads use `multipart/form-data` correctly
3. **Response Unwrapping**: Services unwrap .NET ApiResponse structure correctly
4. **Blob Downloads**: Excel/PDF downloads use `responseType: 'blob'`

### ✅ Authentication
- All services use `http-client.ts` with JWT interceptor (except document service)
- Token refresh logic handled in interceptor
- Build version header included

### ✅ Error Handling
- 401 errors trigger token refresh
- 422 errors handled for build version mismatch
- All services return proper error responses

---

## Action Items

### IMMEDIATE (BLOCKING)

1. **Fix Document Service Import**
   ```bash
   File: modern/frontend/src/services/document/document.service.ts

   Change:
   - Line 1: import apiClient from '../api/axios-client';
   + Line 1: import httpClient from '../api/http-client';

   - All: apiClient.get/post
   + All: httpClient.get/post

   - Remove /api/ prefix from all endpoints (handled by baseURL)
   ```

2. **Verify Document Service Functionality**
   - Test all document upload/download flows
   - Verify JWT token is passed correctly
   - Test file downloads work properly

### RECOMMENDED (NON-BLOCKING)

1. **Backend Typo Fix** (Optional, for future cleanup)
   - Controller: `CertificateController.cs` Line 95
   - Change: `GetEmployeeCerificateList` → `GetEmployeeCertificateList`
   - Note: If fixed, update frontend service to match

---

## Testing Recommendations

1. **Document Service Tests**
   - Upload document
   - Download document
   - Update document
   - List documents
   - Get document by ID

2. **Integration Tests**
   - Test all services against running .NET backend
   - Verify 401 handling (token refresh)
   - Verify 422 handling (build version)
   - Test file uploads across all services

3. **API Contract Validation**
   - Compare all modern services with API contracts in `migration/api-contracts/`
   - Ensure field names match exactly (case-sensitive)

---

## Conclusion

The modern Vue.js frontend has **excellent API parity** with the .NET backend, with only **1 critical issue** in the document service using a non-existent HTTP client.

Once the document service import is fixed, all API calls should work correctly against the existing .NET backend.

All other services follow consistent patterns and correctly handle:
- PascalCase/camelCase conversion
- File uploads with multipart/form-data
- JWT authentication and token refresh
- .NET API response structure unwrapping
- Error handling

---

**Report Generated:** 2026-01-27
**Next Steps:** Fix document service import immediately before testing document-related features.
