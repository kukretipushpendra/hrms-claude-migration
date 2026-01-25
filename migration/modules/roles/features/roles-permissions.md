# Roles & Permissions

## Status
CURRENT: complete
TYPE: feature
FRONTEND: complete
FRONTEND_QA: passed
INTEGRATION_QA: passed
APPROVED_DATE: 2026-01-25

## Description
Role and permission management for HRMS:
- List all roles with user counts
- View/edit role permissions by module
- Create new roles
- Permission-based UI visibility

## Dependencies
DEPENDS_ON: [foundation/frontend-auth, foundation/frontend-dashboard]

## Attempts
FRONTEND_ATTEMPT_COUNT: 0
INTEGRATION_ATTEMPT_COUNT: 0

## API Contracts
- migration/api-contracts/role-permission/get-roles.api.md
- migration/api-contracts/role-permission/get-module-permissions.api.md
- migration/api-contracts/role-permission/save-role-permissions.api.md

## Legacy Reference
LEGACY_FILES:
- legacy/Frontend/HRMS-Frontend/source/src/pages/Roles/
- legacy/Backend/HRMSWebApi/HRMS.API/Controllers/RolePermissionController.cs

## Modern Implementation
MODERN_FILES:
- modern/frontend/src/views/roles/RolesListView.vue
- modern/frontend/src/views/roles/RolePermissionsView.vue
- modern/frontend/src/services/roles/rolesService.ts

## Acceptance Criteria
1. List roles with pagination and search
2. Show user count per role
3. Edit permissions by module (checkboxes)
4. Create new role with name
5. Permission changes reflect in user access
6. Match legacy UI exactly
