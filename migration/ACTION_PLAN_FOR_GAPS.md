# HRMS Migration - Implementation Action Plan

**Created:** February 1, 2026  
**Based On:** Comprehensive Investigation Findings  
**Priority:** Critical items must be completed before Phase 2 (Backend) begins

---

## IMPLEMENTATION ROADMAP

### Phase 0: Immediate Fixes (Days 1-2)

#### Item 0.1: Fix Dashboard Custom Date Range Feature
**Blocked Components:** Dashboard functionality broken for custom date ranges
**Severity:** 🔴 CRITICAL
**Effort:** 8-12 hours
**Owner:** Frontend Team

**Steps:**
1. Create new component: `modern/frontend/src/components/dashboard/CustomDatePicker.vue`
   - Model based on legacy: `legacy/Frontend/HRMS-Frontend/source/src/pages/Dashboard/components/CustomDatePicker.tsx`
   - Copy exact styling and UX from legacy Material-UI version
   - Use date-fns for date calculations (or add moment.js)

2. Update `modern/frontend/src/views/dashboard/DashboardView.vue`
   ```typescript
   // Add to dayOptions:
   { title: 'Custom', value: '-1' }
   
   // Add state variables:
   const showCustomDatePicker = ref(false);
   const customDateRange = ref<{ from: string; to: string; days: number } | null>(null);
   const customLabel = ref('');
   
   // Add handler:
   const handleDayChange = (value: string) => {
     if (value === '-1') {
       showCustomDatePicker.value = true;
       return;
     }
     // ... rest of handling
   }
   
   // Add custom date confirmation:
   const handleCustomDateConfirm = (data: { from: string; to: string; days: number; label: string }) => {
     customDateRange.value = { from: data.from, to: data.to, days: data.days };
     customLabel.value = data.label;
     selectedDays.value = '-1';
     // Refetch data...
   }
   ```

3. Update `DashboardTile.vue` to render CustomDatePicker dialog

4. Test Cases:
   - [ ] Open custom date picker dialog
   - [ ] Select valid date range (from < to < today)
   - [ ] See date validation errors for invalid ranges
   - [ ] See formatted range in dropdown
   - [ ] Dropdown reverts to "Past 30 Days" if dialog cancelled without selection
   - [ ] API calls receive correct from/to dates

**Success Criteria:**
- Custom date picker dialog opens and closes correctly
- Date validation works (start < end < today)
- Formatted date range displays in dropdown
- API calls receive calculated from/to dates
- All dashboard tiles update with custom date range

---

#### Item 0.2: Fix Employee Create/Edit Form (Placeholder)
**Blocked Components:** Cannot add or edit employees in modern app
**Severity:** 🔴 CRITICAL
**Effort:** 20-24 hours
**Owner:** Frontend Team

**Steps:**
1. Create `modern/frontend/src/components/employee/EmployeeForm.vue`
   - Reference legacy: `legacy/Frontend/HRMS-Frontend/source/src/pages/Employee/EmployeeForm.tsx`
   - Multi-section form with 4 tabs:
     - Personal Information (Name, DOB, Gender, Marital Status, Blood Group, etc.)
     - Contact Information (Email, Phone, Address, City, State, PIN, Emergency Contact)
     - Employment Details (Department, Designation, Manager, DOJ, Branch, Job Type, Status)
     - Financial Details (PAN, Aadhar, Bank Account, PF, ESI, Passport)

2. Create `modern/frontend/src/composables/useEmployeeForm.ts`
   - Form state management
   - Validation logic using VeeValidate + Zod
   - Auto-fetch select options (departments, designations, etc.)
   - Image upload handling
   - Submit handlers (POST for create, PUT for edit)

3. Update `modern/frontend/src/views/employees/EmployeeCreateView.vue`
   ```vue
   <template>
     <!-- Remove placeholder alert -->
     <!-- Use EmployeeForm component -->
     <EmployeeForm :mode="isEditMode ? 'edit' : 'create'" :employee-id="employeeIdFromRoute" />
   </template>
   ```

4. Update `modern/frontend/src/views/employees/EmployeeDetailView.vue` to add Edit button linking to create/edit form

5. Update `modern/frontend/src/services/employees/employeesService.ts`
   ```typescript
   // Add:
   export async function createEmployee(data: EmployeeCreateRequest) {
     return httpClient.post('/Employee', transformToRequest(data));
   }
   
   export async function updateEmployee(id: number, data: EmployeeUpdateRequest) {
     return httpClient.put(`/Employee/${id}`, transformToRequest(data));
   }
   ```

6. Test Cases:
   - [ ] Form loads in create mode (all fields empty)
   - [ ] Form loads in edit mode with existing data
   - [ ] All required fields have validation
   - [ ] Date pickers work correctly
   - [ ] Autocomplete dropdowns (Department, Designation, Manager)
   - [ ] Profile picture upload and preview
   - [ ] Form validation shows errors
   - [ ] Submit creates new employee (POST)
   - [ ] Submit updates existing employee (PUT)
   - [ ] Navigate back to list after successful save
   - [ ] Error messages display for failed submissions

**Success Criteria:**
- Form displays all employee fields with correct input types
- Validation works for required fields
- Profile picture upload works
- Create employee API call works
- Update employee API call works
- Form shows success/error messages
- Navigation works correctly

---

#### Item 0.3: Fix Navigation Filtering Using Menus Array
**Blocked Components:** Navigation might show wrong items or missing items
**Severity:** 🟡 HIGH
**Effort:** 4-6 hours
**Owner:** Frontend Team

**Steps:**
1. Verify login response structure in `modern/frontend/src/stores/auth.store.ts`
   ```typescript
   // Check if this property exists and is populated:
   interface LoginResponse {
     // ... other fields
     menus: Array<{
       mainMenu: string;
       mainMenuApiEndPoint: string;
       subMenus: Array<{
         subMenu: string;
         subMenuApiEndPoint: string;
       }>;
     }>;
   }
   ```

2. Update auth.store.ts to store menus:
   ```typescript
   const menus = ref<MenuStructure[]>([]);
   
   // Add setter when login response received:
   this.menus = response.data.menus;
   ```

3. Update `modern/frontend/src/config/navigation.ts` filtering
   - Current approach: Using permission strings like 'Read.Role'
   - Correct approach: Filter navigation items by matching against menus array
   
   ```typescript
   function filterNavigationByMenus(navItems: NavItem[], userMenus: MenuStructure[]): NavItem[] {
     return navItems.filter(item => {
       const permittedMenu = userMenus.find(m =>
         m.mainMenu.toLowerCase() === item.title.toLowerCase()
       );
       if (!permittedMenu) return false;
       
       // Filter submenu items
       if (item.children) {
         item.children = item.children.filter(child => {
           return permittedMenu.subMenus.find(sub =>
             sub.subMenu.toLowerCase() === child.title.toLowerCase()
           );
         });
       }
       
       return true;
     });
   }
   ```

4. Update `modern/frontend/src/components/layout/AppLayout.vue`
   - Use filtered navigation items
   - Pass menus from auth store to filter function

5. Test Cases:
   - [ ] Login and see only permitted menu items
   - [ ] Login as different role and see different menu items
   - [ ] Menu items match backend configuration
   - [ ] Submenu filtering works correctly
   - [ ] Menu structure persists on page refresh

**Success Criteria:**
- Navigation displays only permitted menu items
- Menu items match backend menus array
- No permission-based permission strings used
- Navigation works correctly with auth store

---

### Phase 1: High Priority Fixes (Days 3-4)

#### Item 1.1: Implement Employee Import/Export
**Blocked Components:** Excel functionality broken
**Severity:** 🟡 HIGH
**Effort:** 6-8 hours
**Owner:** Frontend Team

**Steps:**
1. Update `modern/frontend/src/views/employees/EmployeeListView.vue`
   ```typescript
   const handleExport = async () => {
     isExporting.value = true;
     try {
       // Build filters from current state
       const filters: EmployeeSearchFilter = { ...employeeFilters.value };
       if (selectedEmployees.value.length > 0) {
         filters.employeeCode = selectedEmployees.value.join(',');
       }
       
       // Call export API
       const response = await exportEmployeesData({
         ...mapSortingToApiParams(),
         Filters: transformFiltersToRequest(filters),
       });
       
       // Trigger file download
       const url = window.URL.createObjectURL(new Blob([response]));
       const link = document.createElement('a');
       link.href = url;
       link.setAttribute('download', `employees-${new Date().toISOString()}.xlsx`);
       document.body.appendChild(link);
       link.click();
       link.parentNode?.removeChild(link);
       
       showSuccess('Employees exported successfully');
     } catch (error) {
       showError('Failed to export employees');
     } finally {
       isExporting.value = false;
     }
   }
   
   const handleImport = async () => {
     if (!importFile.value || importFile.value.length === 0) {
       showError('Please select a file');
       return;
     }
     
     isImporting.value = true;
     try {
       const formData = new FormData();
       formData.append('file', importFile.value[0]);
       
       const response = await importEmployeesData(formData);
       
       importMessage.value = `${response.successCount} employees imported, ${response.errorCount} failed`;
       importMessageType.value = response.errorCount === 0 ? 'success' : 'warning';
       
       // Refresh employee list after successful import
       if (response.successCount > 0) {
         await fetchEmployees();
       }
     } catch (error) {
       importMessage.value = error.response?.data?.message || 'Import failed';
       importMessageType.value = 'error';
     } finally {
       isImporting.value = false;
     }
   }
   ```

2. Verify `modern/frontend/src/services/employees/employeesService.ts` has:
   ```typescript
   export async function exportEmployeesData(params: ExportRequest) {
     return httpClient.post('/Employee/export', 
       transformFiltersToRequest(params),
       { responseType: 'blob' }
     );
   }
   
   export async function importEmployeesData(formData: FormData) {
     return httpClient.post('/Employee/ImportExcel', formData, {
       headers: { 'Content-Type': 'multipart/form-data' }
     });
   }
   ```

3. Test Cases:
   - [ ] Export with no filters exports all employees
   - [ ] Export with filters exports only filtered employees
   - [ ] Exported file downloads as Excel
   - [ ] Import uploads Excel file
   - [ ] Import shows success/error count
   - [ ] Import refreshes employee list on success
   - [ ] Import validation shows errors for invalid files

**Success Criteria:**
- Export button downloads Excel file with employee data
- Import button accepts Excel files
- Import shows success/error messages
- Employee list refreshes after successful import
- Both features work with filters applied

---

#### Item 1.2: Integration Test Exit Management Module
**Blocked Components:** Exit/Resignation workflows untested
**Severity:** 🟡 HIGH
**Effort:** 10-12 hours
**Owner:** QA + Frontend Team

**Steps:**
1. Locate all exit-management component files in `modern/frontend/src/views/employees/`
2. For each component, verify:
   - [ ] Component renders without errors
   - [ ] All buttons are functional
   - [ ] All forms have proper validation
   - [ ] API calls use correct endpoints
   - [ ] API calls use correct request format (PascalCase)
   - [ ] API responses are handled correctly
   - [ ] Error messages display
   - [ ] Loading states display

3. Test workflows:
   - [ ] Employee can submit resignation
   - [ ] Employee sees resignation in their profile
   - [ ] Employee can request early release
   - [ ] Employee can revoke resignation (if allowed)
   - [ ] Admin can see resignation list
   - [ ] Admin can accept resignation
   - [ ] Admin can reject resignation with reason
   - [ ] Admin can manage each clearance type
   - [ ] File uploads work for each clearance

4. Document any failing tests and create bug reports

**Success Criteria:**
- All exit management workflows tested and working
- API calls use correct formats
- Error handling working
- File uploads working
- All known FRONTEND_ATTEMPT_COUNT issues resolved

---

#### Item 1.3: Integration Test Asset Management Module
**Blocked Components:** Asset allocation workflows untested
**Severity:** 🟡 HIGH
**Effort:** 10-12 hours
**Owner:** QA + Frontend Team

**Steps:**
1. Locate all asset-management component files in `modern/frontend/src/views/employees/`
2. For each component, verify:
   - [ ] Component renders without errors
   - [ ] All buttons are functional
   - [ ] All forms have proper validation
   - [ ] API calls use correct endpoints
   - [ ] Status transition validation works

3. Test workflows:
   - [ ] View asset inventory list with filtering
   - [ ] Create new asset with all details
   - [ ] Edit asset information
   - [ ] Allocate asset to employee (with validation)
   - [ ] Change asset status with notes
   - [ ] View allocation history
   - [ ] Cannot allocate retired/missing/damaged assets
   - [ ] File uploads work (invoice, signature)
   - [ ] Warranty expiry validation works

4. Document any failing tests and create bug reports

**Success Criteria:**
- All asset management workflows tested and working
- Validation rules enforced correctly
- API calls use correct formats
- File uploads working
- Status transition logic working

---

### Phase 2: Verification & Auditing (Days 5-7)

#### Item 2.1: Audit API Casing Pattern Consistency
**Blocked Components:** Potential API failures across all modules
**Severity:** 🟠 MEDIUM
**Effort:** 4-6 hours
**Owner:** Frontend Team

**Steps:**
1. Search all service files for `.post()` and `.put()` calls:
   ```bash
   grep -r "\.post\|\.put" modern/frontend/src/services/ --include="*.ts"
   ```

2. For each call, verify:
   - [ ] Request parameters are PascalCase (if .NET API)
   - [ ] Transformation function is applied before sending

3. Create transformation utility if doesn't exist:
   ```typescript
   // modern/frontend/src/services/api/transform.ts
   export function transformToAPIFormat(obj: any): any {
     const result: any = {};
     for (const key in obj) {
       const newKey = key.charAt(0).toUpperCase() + key.slice(1);
       result[newKey] = obj[key];
     }
     return result;
   }
   ```

4. Apply transformation to all POST/PUT calls

5. Test with actual .NET backend

**Success Criteria:**
- All POST/PUT requests use PascalCase
- No 400 errors due to property naming
- GET responses properly handled as camelCase

---

#### Item 2.2: Audit Date Handling (Null vs. Empty String)
**Blocked Components:** Potential API validation errors
**Severity:** 🟠 MEDIUM
**Effort:** 3-4 hours
**Owner:** Frontend Team

**Steps:**
1. Search codebase for empty string date patterns:
   ```bash
   grep -r 'from: ""' modern/frontend/
   grep -r 'to: ""' modern/frontend/
   grep -r ': ""' modern/frontend/ | grep -i date
   ```

2. Replace all occurrences with `null`:
   ```typescript
   // WRONG:
   { from: "", to: "" }
   
   // CORRECT:
   { from: null, to: null }
   ```

3. Test with .NET backend that validates DateOnly fields

**Success Criteria:**
- No empty string date values sent to API
- All optional date fields use `null`
- .NET backend accepts requests without validation errors

---

#### Item 2.3: Audit Pagination Formula
**Blocked Components:** Wrong page numbers displayed
**Severity:** 🟠 MEDIUM
**Effort:** 2-3 hours
**Owner:** Frontend Team

**Steps:**
1. Find all `.data-table-server` components or paginated lists
2. Verify formula: `StartIndex = (page - 1) * pageSize + 1`
   ```typescript
   // WRONG:
   StartIndex: (page - 1) * pageSize
   
   // CORRECT:
   StartIndex: (page - 1) * pageSize + 1
   ```

3. Test pagination:
   - [ ] Page 1 shows items 1-10
   - [ ] Page 2 shows items 11-20
   - [ ] Page last shows remaining items
   - [ ] Different page sizes work correctly

**Success Criteria:**
- Pagination uses 1-based StartIndex
- Pages show correct items
- Page size changes work correctly

---

### Phase 3: Documentation & Certification (Days 8-10)

#### Item 3.1: Create Test Cases Documentation
**Output:** Complete test case specifications
**Effort:** 8-10 hours
**Owner:** QA Team

**Deliverables:**
- Functional test cases for each module
- Integration test cases for module dependencies
- Regression test cases
- Performance test cases
- API contract test cases

---

#### Item 3.2: Create API Contract Validations
**Output:** API contract compliance documentation
**Effort:** 4-5 hours
**Owner:** Backend + Frontend Team

**Deliverables:**
- Document all .NET API response formats
- Create TypeScript interfaces matching responses
- Create validation schemas for all requests
- Document error response formats
- Document pagination/filtering patterns

---

#### Item 3.3: Authentication & Authorization Testing
**Output:** Security certification
**Effort:** 6-8 hours
**Owner:** QA + Security Team

**Test Cases:**
- [ ] Unauthenticated access denied
- [ ] Token expiration and refresh
- [ ] Permission-based access control
- [ ] Role-based access control
- [ ] SSO login flow
- [ ] Logout and session cleanup

---

## IMPLEMENTATION PRIORITY MATRIX

| Priority | Item | Days | Blocker | Phase |
|----------|------|------|---------|-------|
| 🔴 P0-1 | Dashboard Custom Date Range | 1-2 | YES | 0 |
| 🔴 P0-2 | Employee Create/Edit Form | 3-4 | YES | 0 |
| 🔴 P0-3 | Navigation Menus Filtering | 1 | YES | 0 |
| 🟠 P1-1 | API Casing Audit | 1 | YES | 0 |
| 🟠 P1-2 | Employee Import/Export | 1-2 | NO | 1 |
| 🟠 P1-3 | Exit Management Testing | 2-3 | NO | 1 |
| 🟠 P1-4 | Asset Management Testing | 2-3 | NO | 1 |
| 🟡 P2-1 | Date Handling Audit | 1 | NO | 2 |
| 🟡 P2-2 | Pagination Audit | 1 | NO | 2 |
| 🟢 P3-1 | Test Cases Documentation | 2 | NO | 3 |
| 🟢 P3-2 | API Contract Documentation | 1 | NO | 3 |

---

## RESOURCE ALLOCATION

### Frontend Developer (Full-time)
- Weeks 1-2: P0 items (Custom Date Range, Employee Form, Navigation)
- Week 2: P1 items (Import/Export)
- Week 3: Verification and fixes

### QA Engineer (Full-time)
- Week 1: Testing P0 implementations as completed
- Week 2: Exit Management and Asset Management testing
- Week 3: Regression testing and certification

### Backend Liaison (Part-time)
- Week 1: API contract documentation
- Week 2: API validation and testing support
- Week 3: Integration testing support

### Documentation Specialist (Part-time)
- Week 2-3: Test case documentation
- Week 3: Certification documentation

---

## SUCCESS CRITERIA FOR RELEASE

### Functional Requirements
- [ ] All TIER 1 critical gaps fixed and tested
- [ ] All TIER 2 high priority items completed
- [ ] All TIER 3 audits completed
- [ ] 100% of P0 and P1 items resolved

### Quality Requirements
- [ ] 95%+ test pass rate
- [ ] 0 critical bugs remaining
- [ ] <5 high-priority bugs remaining
- [ ] API response times within SLA

### Documentation Requirements
- [ ] API contracts documented
- [ ] Test cases documented
- [ ] Known limitations documented
- [ ] Migration decisions documented

### Security Requirements
- [ ] Authentication flows tested
- [ ] Authorization enforced correctly
- [ ] Token handling correct
- [ ] No secrets in code

---

## Rollback Plan

If issues arise during testing:

1. **Issue Identified**
   - Document the issue with steps to reproduce
   - Determine severity (Critical/High/Medium/Low)

2. **Triage Decision**
   - If Critical: Immediate rollback to previous version
   - If High: Create hotfix branch
   - If Medium/Low: Add to backlog for next sprint

3. **Escalation**
   - Critical issues: Notify project lead immediately
   - Create incident ticket in tracking system
   - Assign resources to fix

4. **Communication**
   - Notify stakeholders of timeline
   - Provide estimated fix date
   - Update progress regularly

---

## Conclusion

This action plan provides a structured approach to fixing the identified gaps in the HRMS migration. By following this plan:

1. **Days 1-2:** Fix critical blockers (Custom Dates, Employee Form, Navigation)
2. **Days 3-4:** Implement high-priority features (Import/Export, Module Testing)
3. **Days 5-7:** Complete verification and auditing
4. **Days 8-10:** Documentation and certification

**Estimated Total Effort:** 3-4 weeks with 2-3 person team

**Go/No-Go Decision Point:** End of Week 2 (after all P0/P1 items complete)

