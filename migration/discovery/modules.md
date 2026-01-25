# Module Breakdown

## Core Modules

| Module | Backend Controller | Frontend Pages | Key Features |
|--------|-------------------|----------------|--------------|
| Authentication | AuthController | Login, InternalUserLogin | SSO Login, JWT Login, Token Refresh |
| Dashboard | DashboardController | Dashboard | Dashboard widgets, statistics |
| Employee Management | EmployeeController | Employee (list, add, profile) | Employee CRUD, profile management |
| Roles & Permissions | RolePermissionController | Roles (list, add, edit) | Role management, permission assignment |
| Company Policy | CompanyPolicyController | CompanyPolicy (list, view, edit, add) | Policy documents, version tracking |
| Events | EventController | Events (list, view, edit, add) | Event management, calendar |
| Profile | UserProfileController | Profile (personal, employment, nominee, education, certificate, official) | Multi-section user profile |
| Employment Details | EmploymentDetailController, OfficialDetailsController | EmploymentDetails (edit), Settings (department, designation, team) | Job details, organization structure |
| Education & Certificates | EducationalDetailController, CertificateController | EducationDetails, Certificates | Academic records, certifications |
| Nominee & References | NomineeController, ProfessionalReferenceController, PreviousEmployerController | Nominee | Emergency contacts, references |
| Attendance | AttendanceController | Attendance (my-attendance, configuration, employee-report) | Time tracking, Time Doctor integration |
| Leave Management | LeaveManagementController, EmployeeLeaveController | Leaves (apply-leave, details, approval, calendar) | Leave requests, accrual, approval workflow |
| Asset Management | AssetManagementController | IT-Assets (list, add, details/general, details/history) | IT asset tracking, assignment |
| Exit Management | ExitEmployeeController, AdminExitEmployeeController | Resignation, ExitEmployee (list, details) | Resignation workflow, clearance |
| KPI | KPIController | KPI (my-KPI, details, goals, management) | Goal setting, performance tracking |
| Grievance | GrievanceController | Grievance (my-grievance, all-grievance, tickets, configuration) | Ticket system, escalation |
| Support | FeedbackController | Support (queries, details, my-support) | Feedback, support requests |
| Email & Notifications | NotificationTemplateController | Email (templates, table) | Email templates, notification config |
| Settings | DevToolController | Settings (department, designation, team, email, user-guides) | System configuration |
| Developer Tools | DevToolController | Developer (logs, cron-jobs) | System logs, scheduled job monitoring |
| User Guides | UserGuideController | UserGuide (list, add, edit) | Help documentation |

## Module Dependencies

### Foundation Modules (No dependencies)
- Authentication
- Dashboard
- Roles & Permissions

### Dependent Modules
- **Employee Management** → Authentication, Roles
- **Profile** → Employee Management, Employment Details
- **Attendance** → Employee Management
- **Leave Management** → Employee Management, Attendance
- **Asset Management** → Employee Management
- **Exit Management** → Employee Management, Leave Management
- **KPI** → Employee Management
- **Grievance** → Employee Management
- **Support** → Employee Management
- **Events** → Authentication
- **Company Policy** → Authentication

## Feature Flags
- `enableExitEmployee`: Exit Management module
- `enableAttendance`: Attendance module
- `enableLeave`: Leave Management module
- `enableITAsset`: Asset Management module
- `enableKPI`: KPI module
- `enableGrievance`: Grievance module

## Page Module Statistics
Total Page Directories: 31
- AssetManagement
- Attendance
- Certificates
- CompanyPolicy
- Dashboard
- Developer
- Document
- EducationDetails
- Email
- Employee
- EmploymentDetails
- Events
- ExitEmployee
- Grievances
- ITAssets
- KPI
- LeaveCalenderAdmin
- Leaves
- Login
- Nominee
- NotFoundPage
- Profile
- Resignation
- Roles
- Settings
- Support
- Unauthorized
- UserGuide

## Component Count
Total TypeScript Files: 632
Reusable Components: ~50+ (DataTable, Form components, common UI elements)
