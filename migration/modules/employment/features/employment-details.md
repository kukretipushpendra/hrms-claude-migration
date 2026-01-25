# Employment Details

## Status
CURRENT: ready-for-dev
TYPE: feature
FRONTEND: pending
FRONTEND_QA: pending
INTEGRATION_QA: pending

## Description
Employee employment details management:
- View employment details (job title, department, reporting manager)
- Edit employment details
- Employment history
- Designation changes

## Dependencies
DEPENDS_ON: [foundation/frontend-auth, employee/employee-management]

## Attempts
FRONTEND_ATTEMPT_COUNT: 0
INTEGRATION_ATTEMPT_COUNT: 0

## API Contracts
- migration/api-contracts/employment-detail/add-employment-detail.api.md
- migration/api-contracts/employment-detail/get-employment-detail.api.md

## Legacy Reference
LEGACY_FILES:
- legacy/Frontend/HRMS-Frontend/source/src/pages/EmploymentDetail/
- legacy/Backend/HRMSWebApi/HRMS.API/Controllers/EmploymentDetailController.cs

## Modern Implementation
MODERN_FILES:
- modern/frontend/src/views/employment/EmploymentDetailView.vue
- modern/frontend/src/views/employment/EmploymentEditView.vue
- modern/frontend/src/services/employment/employmentService.ts

## Acceptance Criteria
1. View employee's employment details
2. Edit employment information
3. Show employment history
4. Designation change tracking
5. Reporting manager selection
6. Match legacy UI exactly
