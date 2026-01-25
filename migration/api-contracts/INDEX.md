# HRMS API Contracts Index

**Total Endpoints Documented:** 41
**Extraction Date:** 2026-01-23
**Source:** Legacy .NET Backend (HRMS.API)

## Module Summary

| Module | Endpoint Count | Directory |
|--------|---------------|-----------|
| Auth | 4 | /auth |
| Dashboard | 3 | /dashboard |
| Employee | 3 | /employee |
| Attendance | 3 | /attendance |
| Leave Management | 4 | /leave-management |
| Employee Leave | 2 | /employee-leave |
| User Profile | 3 | /user-profile |
| Role Permission | 3 | /role-permission |
| Asset Management | 3 | /asset-management |
| Event | 3 | /event |
| Company Policy | 2 | /company-policy |
| Official Details | 2 | /official-details |
| Employment Detail | 2 | /employment-detail |
| Certificate | 2 | /certificate |
| Nominee | 2 | /nominee |

## Auth Module (4 endpoints)
- POST /api/Auth - SSO Login
- POST /api/Auth/Login - Standard Login
- POST /api/Auth/RefreshToken - Refresh Access Token
- GET /api/Auth/CheckHealth - Health Check

## Dashboard Module (3 endpoints)
- GET /api/Dashboard/GetBirthdayList - Birthday List
- POST /api/Dashboard/GetEmployeesCount - Employee Count
- GET /api/Dashboard/GetHolidayList - Holiday List

## Employee Module (3 endpoints)
- POST /api/Employee/GetEmployees - Get Employee List
- POST /api/Employee/export - Export to Excel
- POST /api/Employee/ImportExcel - Import from Excel

## Attendance Module (3 endpoints)
- POST /api/Attendance/AddAttendance/{employeeId} - Add Attendance
- GET /api/Attendance/GetAttendance/{employeeId} - Get Attendance
- POST /api/Attendance/GetEmployeeReport - Employee Report

## Leave Management Module (4 endpoints)
- GET /api/LeaveManagement/GetEmployeeLeaveById/{employeeId} - Get Leave Balance
- POST /api/LeaveManagement/UpdateLeaves - Update Leaves
- POST /api/LeaveManagement/GetAppliedLeaves - Get Applied Leaves
- POST /api/LeaveManagement/ApproveOrRejectLeave - Approve/Reject Leave

## Employee Leave Module (2 endpoints)
- POST /api/EmployeeLeave/ApplyLeave - Apply for Leave
- POST /api/EmployeeLeave/GetLeaveHistoryByEmployeeId/{employeeId} - Leave History

## User Profile Module (3 endpoints)
- GET /api/UserProfile/GetPersonalDetailsById/{id} - Get Personal Details
- POST /api/UserProfile/AddPersonalDetail - Add Personal Detail
- POST /api/UserProfile/UploadUserProfileImage - Upload Profile Image

## Role Permission Module (3 endpoints)
- POST /api/RolePermission/GetRoles - Get Roles
- GET /api/RolePermission/GetModulePermissionsByRole - Get Module Permissions
- POST /api/RolePermission/SaveRolePermissions - Save Role Permissions

## Asset Management Module (3 endpoints)
- POST /api/AssetManagement/GetEmployeeAssetList - Get Employee Assets
- POST /api/AssetManagement/UpsertEmployeeAsset - Create/Update Employee Asset
- POST /api/AssetManagement/GetAssetList - Get IT Assets

## Event Module (3 endpoints)
- POST /api/Event/GetEvents - Get Events
- POST /api/Event/CreateEvent - Create Event
- GET /api/Event/{id} - Get Event by ID

## Company Policy Module (2 endpoints)
- POST /api/CompanyPolicy/GetCompanyPolicies - Get Policies
- POST /api/CompanyPolicy/CreateCompanyPolicy - Create Policy

## Official Details Module (2 endpoints)
- GET /api/OfficialDetails/{id} - Get Official Details
- POST /api/OfficialDetails/UpdateOfficialDetails - Update Official Details

## Employment Detail Module (2 endpoints)
- POST /api/UserProfile/AddEmploymentDetail - Add Employment Detail
- GET /api/UserProfile/GetEmploymentDetailById - Get Employment Detail

## Certificate Module (2 endpoints)
- POST /api/UserProfile/UploadEmployeeCertificate - Upload Certificate
- POST /api/UserProfile/GetEmployeeCerificateList - Get Certificate List

## Nominee Module (2 endpoints)
- POST /api/UserProfile/AddNominee - Add Nominee
- POST /api/UserProfile/GetNomineeList - Get Nominee List

## Additional Controllers Not Yet Documented

The following controllers exist but have not yet been fully documented:
- AdminExitEmployeeController
- DevToolController
- EducationalDetailController
- EmployeeGroupController
- ExitEmployeeController
- ExternalAPIController
- FeedbackController
- GrievanceController
- KPIController
- NotificationTemplateController
- PreviousEmployerController
- ProfessionalReferenceController
- SurveyController
- UserGuideController

## Common Response Structure

All endpoints return responses in this format:

```typescript
interface ApiResponse<T> {
  statusCode: number;
  message: string;
  data: T | null;
  errors?: string[];
}
```

## Authentication

Most endpoints require JWT Bearer token authentication via the `Authorization` header:
```
Authorization: Bearer <token>
```

## Permission System

Endpoints use attribute-based authorization with the following permission types:
- Read{Module} - View data
- View{Module} - View details
- Create{Module} - Create records
- Edit{Module} - Update records
- Delete{Module} - Delete/Archive records

## File Upload Endpoints

Endpoints accepting files use `multipart/form-data`:
- Employee/ImportExcel
- UserProfile/UploadUserProfileImage
- UserProfile/UploadUserDocument
- Certificate/UploadEmployeeCertificate
- Event/CreateEvent
- CompanyPolicy/CreateCompanyPolicy
- Nominee/AddNominee

## Pagination Pattern

List endpoints use this pagination structure:

```typescript
interface SearchRequest<T> {
  searchFilter: T;
  pageIndex: number;    // 0-based
  pageSize: number;     // Records per page
  sortBy?: string;
  sortOrder?: 'asc' | 'desc';
}
```

## Status Codes

- 200: Success
- 400: Bad Request / Validation Error
- 401: Unauthorized
- 403: Forbidden / Invalid Token
- 404: Not Found
- 409: Conflict (Duplicate)
- 500: Internal Server Error

## Notes

1. All date fields use ISO 8601 format: `YYYY-MM-DD`
2. All datetime fields include time: `YYYY-MM-DDTHH:mm:ss`
3. File download endpoints return raw binary with appropriate Content-Type headers
4. Excel export endpoints return `.xlsx` files with timestamped filenames
5. Validation errors return array of error messages in the `errors` field
