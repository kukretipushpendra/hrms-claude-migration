# Foundation: Frontend Dashboard

## Status
CURRENT: human-review
TYPE: foundation
FRONTEND: complete
FRONTEND_QA: passed
INTEGRATION_QA: passed

## Description
Dashboard page connected to .NET backend:
- Analytics cards (Total Employees, New Enrolled, Exited)
- Dashboard tiles (Work Anniversary, Holidays, Birthdays, Events, Policies)
- Day filter (7/30/90 days)
- Permission-based tile visibility
- Role-based analytics visibility (hide for EMPLOYEE role)

## Dependencies
DEPENDS_ON: [foundation/frontend-auth]

## Attempts
FRONTEND_ATTEMPT_COUNT: 0
INTEGRATION_ATTEMPT_COUNT: 0

## API Contracts
- migration/api-contracts/dashboard/get-employees-count.api.md
- migration/api-contracts/dashboard/get-birthday-list.api.md
- migration/api-contracts/dashboard/get-holiday-list.api.md

## Legacy Reference
LEGACY_FILES:
- legacy/Frontend/HRMS-Frontend/source/src/pages/Dashboard/index.tsx
- legacy/Frontend/HRMS-Frontend/source/src/pages/Dashboard/AdminDashboard.tsx
- legacy/Frontend/HRMS-Frontend/source/src/components/cards/Maincard.tsx
- legacy/Frontend/HRMS-Frontend/source/src/api/dashboard.ts

## Modern Implementation
MODERN_FILES:
- modern/frontend/src/views/dashboard/DashboardView.vue
- modern/frontend/src/components/dashboard/AnalyticsCard.vue
- modern/frontend/src/components/dashboard/DashboardTile.vue

## Acceptance Criteria
1. Dashboard loads after successful login
2. Analytics cards show correct counts from API
3. Day filter changes data fetched
4. Tiles display correct data
5. Permission-based tiles show/hide correctly
6. Role-based analytics visibility works
7. Loading states match legacy
8. Error handling matches legacy

## Notes
- Dashboard API: GET /api/Dashboard/GetDashboardData?days={7|30|90}
- Requires valid JWT token
- Different view for EMPLOYEE vs other roles
