# Employee Management

## Status
CURRENT: ready-for-dev
TYPE: feature
FRONTEND: pending
FRONTEND_QA: pending
INTEGRATION_QA: pending

## Description
Employee listing and management:
- List all employees with filters (department, status, search)
- Employee detail view
- Add/edit employee basic info
- Import employees from Excel
- Export employee list

## Dependencies
DEPENDS_ON: [foundation/frontend-auth, roles/roles-permissions]

## Attempts
FRONTEND_ATTEMPT_COUNT: 0
INTEGRATION_ATTEMPT_COUNT: 0

## API Contracts
- migration/api-contracts/employee/get-employees.api.md
- migration/api-contracts/employee/export-employee-list.api.md
- migration/api-contracts/employee/import-excel.api.md

## Legacy Reference
LEGACY_FILES:
- legacy/Frontend/HRMS-Frontend/source/src/pages/Employees/
- legacy/Backend/HRMSWebApi/HRMS.API/Controllers/EmployeeController.cs

## Modern Implementation
MODERN_FILES:
- modern/frontend/src/views/employees/EmployeeListView.vue
- modern/frontend/src/views/employees/EmployeeDetailView.vue
- modern/frontend/src/services/employees/employeeService.ts

## Acceptance Criteria
1. List employees with pagination
2. Filter by department, status, search term
3. View employee details
4. Add new employee
5. Edit employee info
6. Import from Excel
7. Export to Excel
8. Match legacy UI exactly
