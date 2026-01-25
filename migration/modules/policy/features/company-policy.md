# Company Policy

## Status
CURRENT: complete
TYPE: feature
FRONTEND: complete
FRONTEND_QA: passed
INTEGRATION_QA: passed
APPROVED_DATE: 2026-01-25

## Description
Company policy management:
- List all company policies
- View policy details with document
- Create new policy with PDF upload
- Publish/unpublish policies
- Policy version history

## Dependencies
DEPENDS_ON: [foundation/frontend-auth]

## Attempts
FRONTEND_ATTEMPT_COUNT: 0
INTEGRATION_ATTEMPT_COUNT: 0

## API Contracts
- migration/api-contracts/company-policy/get-company-policies.api.md
- migration/api-contracts/company-policy/create-company-policy.api.md

## Legacy Reference
LEGACY_FILES:
- legacy/Frontend/HRMS-Frontend/source/src/pages/CompanyPolicy/
- legacy/Backend/HRMSWebApi/HRMS.API/Controllers/CompanyPolicyController.cs

## Modern Implementation
MODERN_FILES:
- modern/frontend/src/views/policy/PolicyListView.vue
- modern/frontend/src/views/policy/PolicyDetailView.vue
- modern/frontend/src/views/policy/PolicyCreateView.vue
- modern/frontend/src/services/policy/policyService.ts

## Acceptance Criteria
1. List policies with pagination
2. View policy details
3. Download policy PDF
4. Create policy with file upload
5. Publish/unpublish toggle
6. Version history display
7. Match legacy UI exactly
