# Exit Management Feature - Vue.js Implementation

## Status: IN PROGRESS

This document tracks the implementation of the exit-management feature frontend migration from React to Vue.js.

## Completed Files

### 1. Types (`src/types/exit.types.ts`) ✓
- All enums (ResignationStatus, JobTypes, EarlyReleaseStatus, AssetCondition, KTStatus, etc.)
- Employee exit types (ResignationFormData, AddResignationRequest, ResignationExitDetails, etc.)
- Admin exit types (ExitEmployeeListItem, ExitEmployeeSearchFilter, GetResignationListRequest, etc.)
- Clearance types (IT, HR, Department, Account)
- API response types
- Constants (NOTICE_PERIOD_CONFIG, status labels)

### 2. API Service (`src/services/exit/exit.service.ts`) ✓
**Employee Endpoints:**
- `addResignation` - POST /ExitEmployee/AddResignation
- `getResignationForm` - GET /ExitEmployee/GetResignationForm/{id}
- `getResignationDetails` - GET /ExitEmployee/GetResignationDetails/{id}
- `revokeResignation` - POST /ExitEmployee/RevokeResignation/{id}
- `requestEarlyRelease` - POST /ExitEmployee/RequestEarlyRelease
- `isResignationExist` - GET /ExitEmployee/IsResignationExist/{id}

**Admin Endpoints:**
- `getResignationList` - POST /AdminExitEmployee/GetResignationList
- `getResignationById` - GET /AdminExitEmployee/GetResignationById/{id}
- `acceptResignation` - POST /AdminExitEmployee/AcceptResignation/{id}
- `acceptEarlyRelease` - POST /AdminExitEmployee/AcceptEarlyRelease
- `adminRejection` - POST /AdminExitEmployee/AdminRejection
- `updateLastWorkingDay` - PATCH /AdminExitEmployee/UpdateLastWorkingDay

**Clearance Endpoints:**
- `getITClearance` / `upsertITClearance`
- `getHRClearance` / `upsertHRClearance`
- `getDepartmentClearance` / `upsertDepartmentClearance`
- `getAccountClearance` / `upsertAccountClearance`

### 3. Utilities (`src/utils/exit-helpers.ts`) ✓
- `calculateLastWorkingDay` - Calculate LWD based on job type
- `isValidJobType` - Validate job type enum
- `getNoticePeriod` - Get notice period text
- `formatDateForApi` - Format date as YYYY-MM-DD
- `formatDateForDisplay` - Format date for UI display
- `canRevokeResignation` - Check if resignation can be revoked
- `canRequestEarlyRelease` - Check if early release can be requested
- `canEditClearances` - Check if clearances are editable

### 4. Views - Employee (`src/views/exit/`) ✓
- `ResignationFormView.vue` - Employee resignation submission form

## Remaining Implementation

### 5. Views - Employee (TODO)
- [ ] `ExitDetailsView.vue` - Employee exit details (for /profile/exit-details tab)
  - Display resignation status and dates
  - View resignation/rejection reasons in dialog
  - Request early release button
  - Revoke resignation button

### 6. Views - Admin (TODO)
- [ ] `ExitEmployeeListView.vue` - Admin resignation list with filters
  - Server-side data table (Vuetify)
  - Pagination, sorting, filtering
  - Navigate to details on row click

- [ ] `ExitDetailsPageView.vue` - Admin resignation details
  - Display resignation details
  - Accept/reject resignation dialogs
  - Accept/reject early release dialogs
  - Update last working day dialog
  - Tabbed layout for 4 clearances

### 7. Components - Clearance Forms (TODO)
- [ ] `HRClearanceForm.vue` - HR clearance form
  - Fields: advance bonus recovery, service agreement, current EL, buyout days
  - Exit interview status/details
  - File upload
  - VeeValidate + Zod validation

- [ ] `DepartmentClearanceForm.vue` - Department clearance form
  - KT status dropdown
  - KT users multi-select (employee autocomplete)
  - KT notes textarea
  - File upload

- [ ] `ITClearanceForm.vue` - IT clearance form
  - Access revoked checkbox
  - Asset returned checkbox
  - Asset condition dropdown
  - Note (required if damaged/faulty)
  - IT clearance certification checkbox
  - File upload

- [ ] `AccountClearanceForm.vue` - Account clearance form
  - F&F status checkbox
  - F&F amount (required if F&F status true)
  - Issue no-due certificate checkbox
  - Note field
  - File upload

### 8. Components - Dialogs (TODO)
- [ ] `EarlyReleaseDialog.vue` - Request early release dialog
- [ ] `ResignationReasonDialog.vue` - View resignation/rejection reasons
- [ ] `AcceptResignationDialog.vue` - Accept resignation confirmation
- [ ] `RejectDialog.vue` - Reject resignation or early release
- [ ] `UpdateLWDDialog.vue` - Update last working day
- [ ] `RevokeConfirmDialog.vue` - Confirm resignation revocation

### 9. Components - Filters (TODO)
- [ ] `ExitEmployeeFilterForm.vue` - Admin list filters component
  - Employee code/name search
  - Status filters
  - Branch/department dropdowns
  - Date range pickers
  - IT/Accounts no-due filters

### 10. Router Configuration (TODO)
Add routes to `src/router/index.ts`:
```typescript
// Employee routes
{
  path: '/resignation-form/:userId?',
  name: 'ResignationForm',
  component: () => import('@/views/exit/ResignationFormView.vue'),
  meta: { requiresAuth: true }
},
{
  path: '/profile/exit-details',
  name: 'ExitDetails',
  component: () => import('@/views/exit/ExitDetailsView.vue'),
  meta: { requiresAuth: true }
},

// Admin routes
{
  path: '/employees/employee-exit',
  name: 'ExitEmployeeList',
  component: () => import('@/views/exit/ExitEmployeeListView.vue'),
  meta: { requiresAuth: true, requiresPermission: 'Read.Employees' }
},
{
  path: '/employees/employee-exit/:resignationId',
  name: 'ExitDetailsPage',
  component: () => import('@/views/exit/ExitDetailsPageView.vue'),
  meta: { requiresAuth: true, requiresPermission: 'Read.Employees' }
}
```

### 11. Composables (TODO - Optional)
- [ ] `useResignation.ts` - Composable for resignation operations
- [ ] `useClearance.ts` - Composable for clearance CRUD operations

## Implementation Notes

### Date Handling
- Using `dayjs` instead of `moment.js` (lighter alternative)
- All API dates use YYYY-MM-DD format
- Display dates use MMM DD, YYYY format

### Form Validation
- Using VeeValidate + Zod (Vue.js equivalent of React Hook Form + Yup)
- All validation rules match legacy exactly

### File Uploads
- Using FormData for multipart uploads
- Each clearance form handles file uploads independently
- Backend expects specific field names (attachmentUrl, attachment, accountAttachment)

### API Communication
- All endpoints connect to existing .NET backend at http://localhost:5281
- Request bodies use PascalCase (as .NET expects)
- Response data uses camelCase (as .NET returns)

### Permissions
- Employee routes: Any authenticated user
- Admin routes: Require `Read.Employees` permission
- Resignation submission: `CreatePersonalDetails` permission
- Resignation viewing: `ViewPersonalDetails` permission

### Known Legacy Patterns
1. **Resignation Active Status Check**: Before showing form, check if active resignation exists
2. **Job Type Notice Period**:
   - Probation (1): 15 days
   - Confirmed (2): 3 months
   - Training (3): 15 days
3. **Revoke Logic**: Can revoke if status is Pending or Accepted AND before LWD
4. **Early Release**: Can request if resignation is Accepted
5. **Clearance Editing**: Disabled if status is Completed, Cancelled, or Revoked

## Testing Checklist

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
- [ ] Date validations work (early release, last working day)
- [ ] Status transitions work correctly

## Next Steps

1. Complete remaining views (ExitDetailsView, admin views)
2. Create all clearance form components
3. Create dialog components
4. Create filter form component
5. Add router configuration
6. Run type-check and fix any TypeScript errors
7. Run lint and fix any linting errors
8. Test all functionality against .NET backend
9. Verify 100% parity with legacy React UI

## Dependencies

All required dependencies are already installed:
- `vue` - Vue.js 3
- `vue-router` - Routing
- `pinia` - State management
- `vee-validate` - Form validation
- `@vee-validate/zod` - Zod integration
- `zod` - Schema validation
- `vuetify` - UI framework
- `axios` - HTTP client
- `dayjs` - Date manipulation

## Estimated Completion Time

- Remaining views: ~4 hours
- Clearance forms: ~3 hours
- Dialog components: ~2 hours
- Filter form: ~1 hour
- Router + testing: ~2 hours
- **Total**: ~12 hours

## Reference Files

- Legacy React: `legacy/Frontend/HRMS-Frontend/source/src/pages/Resignation/`
- Legacy React: `legacy/Frontend/HRMS-Frontend/source/src/pages/ExitEmployee/`
- API Contract: `migration/api-contracts/exit/exit-management.api.md`
- Feature Spec: `migration/modules/exit/features/exit-management.md`
