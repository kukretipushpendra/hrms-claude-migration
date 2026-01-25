# Database Schema

## Database Type
SQL Server (local instance via Entity Framework Core)

## Connection String
```
Server=PIO-LAP-1083\SQLEXPRESS;Database=HRMS;User Id=sa;Password=***;MultipleActiveResultSets=true;TrustServerCertificate=True
```

## Tables (72 Entities Found)

### Core Authentication & User Management
- **EmployeeData** - Core employee information
- **Role** - User roles
- **Permission** - System permissions
- **UserRoleMapping** - User-role associations
- **Module** - System modules
- **SubModule** - Sub-modules
- **Address** - Employee addresses
- **PermanentAddress** - Permanent address details
- **City** - City master data
- **State** - State master data
- **Country** - Country master data

### Employee Profile & Details
- **EmploymentDetail** - Employment information (department, designation, etc.)
- **UserQualificationInfo** - Education qualifications
- **Qualification** - Qualification master
- **University** - University master
- **UserCertificate** - Professional certifications
- **UserNomineeInfo** - Nominee/emergency contact details
- **Relationship** - Relationship types
- **PreviousEmployer** - Previous employment history
- **PreviousEmployerDocument** - Previous employer documents
- **ProfessionalReference** - Professional references
- **CurrentEmployerDocument** - Current employment documents
- **UserDocument** - User document storage
- **DocumentType** - Document type master
- **EmployerDocumentType** - Employer document types
- **EmployStatus** - Employment status types
- **Teams** - Team/department structure

### Company Policy & Events
- **CompanyPolicy** - Company policy documents
- **CompanyPolicyHistory** - Policy version history
- **CompanyPolicyDocCategory** - Policy categories
- **PolicyStatus** - Policy status types
- **Event** - Company events
- **EventCategory** - Event categories
- **EventDocument** - Event attachments

### Attendance & Time Tracking
- **Attendance** - Daily attendance records
- **DowntownData** - Downtown timesheet sync data

### Leave Management
- **AppliedLeave** - Leave applications
- **EmployeeLeave** - Employee leave balance
- **LeaveType** - Leave type definitions
- **AccrualUtilizedLeave** - Leave accrual tracking
- **CompOffAndSwapHolidayDetail** - Comp-off and holiday swap

### Asset Management
- **ITAsset** - IT asset inventory
- **ITAssetHistory** - Asset assignment history
- **EmployeeAsset** - Employee-asset mapping
- **AssetCondition** - Asset condition types

### Exit Management
- **Resignation** - Resignation requests
- **ResignationHistory** - Resignation workflow history
- **AccountClearance** - Account clearance status
- **DepartmentClearance** - Department clearance
- **HRClearance** - HR clearance
- **ITClearance** - IT clearance

### KPI & Performance
- **KPIGoal** - KPI goals
- **KPIDetails** - KPI tracking details
- **KPIPlan** - KPI plans
- **ManagerRatingHistory** - Manager rating records

### Grievance Management
- **EmployeeGrievance** - Employee grievances
- **GrievanceType** - Grievance type definitions
- **GrievanceOwner** - Grievance owners/handlers
- **GrievanceRemarks** - Grievance comments/updates

### Support & Feedback
- **Feedback** - Support tickets/feedback

### Email & Notifications
- **NotificationTemplate** - Email notification templates

### Employee Groups & Surveys
- **Group** - Employee groups
- **UserGroupMapping** - User-group associations
- **Survey** - Employee surveys
- **SurveyEmpGroupMapping** - Survey-group mapping
- **SurveyResponse** - Survey responses
- **SurveyStatus** - Survey status types

### System & Logging
- **Logging** - Application logs (Serilog)
- **CronLog** - Scheduled job logs

### User Guides
- **UserGuide** - Help documentation

## Key Relationships

### Employee Hierarchy
```
EmployeeData (1) ─── (1) Address
              ├─── (1) PermanentAddress
              ├─── (N) UserRoleMapping ─── (1) Role
              ├─── (N) UserQualificationInfo ─── (1) Qualification
              ├─── (N) UserCertificate
              ├─── (N) UserNomineeInfo ─── (1) Relationship
              ├─── (1) EmploymentDetail
              ├─── (N) PreviousEmployer
              ├─── (N) ProfessionalReference
              ├─── (N) UserDocument
              ├─── (N) Attendance
              ├─── (N) AppliedLeave
              ├─── (1) EmployeeLeave
              ├─── (N) EmployeeAsset ─── (1) ITAsset
              ├─── (0-1) Resignation
              ├─── (N) KPIDetails
              ├─── (N) EmployeeGrievance
              └─── (N) Feedback
```

### Policy Management
```
CompanyPolicy (1) ─── (N) CompanyPolicyHistory
              └─── (1) CompanyPolicyDocCategory
```

### Leave Management
```
AppliedLeave (1) ─── (1) LeaveType
             └─── (1) EmployeeData

EmployeeLeave (1) ─── (1) EmployeeData
              └─── (N) AccrualUtilizedLeave
```

### Exit Management
```
Resignation (1) ─── (1) EmployeeData
            ├─── (N) ResignationHistory
            ├─── (1) AccountClearance
            ├─── (N) DepartmentClearance
            ├─── (1) HRClearance
            └─── (1) ITClearance
```

### Asset Management
```
ITAsset (1) ─── (N) ITAssetHistory
        └─── (N) EmployeeAsset ─── (1) EmployeeData
```

### Grievance System
```
EmployeeGrievance (1) ─── (1) EmployeeData
                  ├─── (1) GrievanceType
                  ├─── (1) GrievanceOwner
                  └─── (N) GrievanceRemarks
```

## Stored Procedures
UNCLEAR: No stored procedures found in Domain/Entities scan. May exist in Infrastructure layer.

## Views
UNCLEAR: No database views found in initial scan.

## Indexes
UNCLEAR: Entity Framework conventions likely used. Custom indexes need infrastructure layer analysis.

## Seeding Data
Based on configuration:
- Authentication test users (3 users: test.hr, test.dev, test.admin)
- Leave types: Casual, Earned (with accrual rules)
- Job type durations: Probation (15 days), Training (15 days), Confirmed (3 months)

## Migration Strategy
UNCLEAR: No explicit migration files found. Database schema likely managed through:
1. Entity Framework Core Code-First migrations
2. Direct SQL scripts (location unknown)
3. Manual database updates

## Notes
- Multiple Active Result Sets (MARS) enabled
- TrustServerCertificate enabled (development setting)
- Auto-create SQL table enabled for Serilog logging
- Entity relationships follow navigation property conventions
