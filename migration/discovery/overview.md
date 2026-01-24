# Legacy Codebase Overview

## Backend Stack
FRAMEWORK: .NET 8.0
DATABASE: SQL Server (Entity Framework integration)
AUTH: JWT Bearer + Azure MSAL (SSO)
ARCHITECTURE: Clean Architecture (API, Application, Domain, Infrastructure layers)
VALIDATION: FluentValidation
LOGGING: Serilog (Console, File, SQL Server)
API_DOCS: Swagger/OpenAPI
SCHEDULED_JOBS: Quartz.NET
CONTROLLERS: 29
ENTITIES: 72

## Frontend Stack
FRAMEWORK: React 18.3.1
BUILD_TOOL: Vite 5.3.1
LANGUAGE: TypeScript 5.2.2
UI_FRAMEWORK: Material-UI (MUI) 6.5.0
STATE_MANAGEMENT: Zustand 4.5.4
FORM_HANDLING: React Hook Form 7.52.2 + Formik 2.4.6
VALIDATION: Yup 1.4.0
ROUTING: React Router DOM 6.24.1
DATA_FETCHING: SWR 2.2.5 + Axios 1.7.2
AUTH: Azure MSAL React 2.0.22
STYLING: Emotion 11.14.0 + Styled Components 6.1.11
RICH_TEXT: CKEditor5 43.3.1
CALENDAR: React Big Calendar 1.19.4
TABLES: Material React Table 3.2.1
COMPONENTS: ~632 TypeScript files

## Key Features
- Employee Management (CRUD, profiles, documents)
- Attendance Tracking (Time Doctor integration)
- Leave Management (accrual system, approvals)
- Asset Management (IT assets)
- Events & Company Policies
- KPI & Goal Tracking
- Grievance Management System
- Support Ticketing
- Role-Based Access Control (RBAC)
- Exit Management (resignation workflow)
- Email Templates & Notifications
- Developer Tools (logs, cron jobs)

## External Integrations
- Azure AD (SSO authentication)
- Time Doctor API (attendance data)
- Downtown API (timesheet sync)
- Azure Blob Storage (file storage)
- Email Notification Service
- SMTP (Office365)

## Database Connection
Server: SQL Server (local instance)
Connection: Entity Framework Core
Migrations: UNCLEAR (no migration files found in initial scan)

## Configuration
- Rate Limiting: Configured (999999 requests per 10 minutes)
- CORS: Enabled for localhost:5173
- Feature Flags: Exit Employee, Attendance, Leave, IT Asset, KPI, Grievance
- Scheduled Jobs: Notifications, Leave Accrual, Time Doctor Sync, Grievance Updates

## Build & Deploy
BACKEND_PORT: 7094 (HTTPS), 44373 (dev)
FRONTEND_PORT: 5173 (dev)
FRONTEND_BUILD: TypeScript compilation + Vite build (production/staging modes)
