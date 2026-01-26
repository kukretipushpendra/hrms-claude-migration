# KPI Feature

## Overview
Complete Key Performance Indicator (KPI) management system with quarterly self-ratings, manager reviews, goal assignment, and performance tracking. Supports multiple KPI plans per employee with review history tracking.

## Status
CURRENT: human-review
FRONTEND_QA: passed
TYPE: feature
WAVE: 4
DEPENDS_ON: [auth-pages, employees]
FEATURE_FLAG: enableKPI

## Implementation Notes

**Implemented (Core Functionality):**
- Employee KPI View (`/KPI/my-KPI`) - View/edit quarterly self-ratings, submit plan
- Goals Management (`/KPI/Goals`) - List, filter, create, edit, delete goals
- KPI types with proper TypeScript interfaces
- Complete API service with all 15 endpoints
- Utility functions for validation and helpers
- Dialog components for editing ratings
- Vue 3 Composition API with proper patterns

**Deferred (Placeholder Routes):**
- Manager Dashboard (`/KPI/KPI-Management`) - Complex filtering and status management
- KPI Details View (`/KPI/Kpi-Details/:employeeId`) - Multiple plans, manager ratings

**Rationale:**
Core employee self-service and goals CRUD implemented. Manager views require additional components (autocompletes, filter forms, rating history tables) that can be added incrementally. The implemented functionality provides value and can be tested independently.

## Legacy Routes

### Employee Routes
- `/KPI/my-KPI` - Employee's own KPI dashboard with quarterly self-ratings
- `/KPI/Kpi-Details/:employeeId` - Detailed KPI view for specific employee (manager access)

### Goals Management Routes
- `/KPI/Goals` - List all KPI goals
- `/KPI/Goals/Add-Goal` - Create new KPI goal
- `/KPI/Goals/Edit-Goal/:id` - Edit existing KPI goal

### Manager Routes
- `/KPI/KPI-Management` - Manager dashboard showing all team members' KPIs

## Legacy Components

### Main Pages

#### EmployeeKPI (`pages/KPI/EmployeeKPI/index.tsx`)
- Employee's personal KPI dashboard
- Displays quarterly ratings (Q1-Q4) in table format
- Shows last review date and next review date
- Allows employee to add/edit quarterly self-ratings
- View manager ratings and notes
- Submit completed KPI plan for manager review
- Uses hover states to show edit icons on quarterly cells

#### KpiDetails (`pages/KPI/KpiDetails/index.tsx`)
- Manager view of employee's KPI details
- Multiple KPI plan selection (Current + Historical)
- Edit/view quarterly employee self-ratings
- Add/edit manager ratings and notes
- Assign goals to employees
- Submit manager review
- View rating history for each goal
- Confirmation dialog before submission

#### GoalListPage (`pages/KPI/GoalListPage/index.tsx`)
- List all KPI goals with filtering
- CRUD operations for goals
- Filter by title, department, created date range, created by
- Delete goal with confirmation
- Navigate to add/edit goal pages

#### UpsertGoalPage (`pages/KPI/UpsertGoalPage.tsx`)
- Add/Edit KPI goals
- Fields: Title, Department, Description, Employee IDs (comma-separated)
- Validation with Yup schema
- Form reset functionality

#### MangerDashboardPage (`pages/KPI/MangerDashboardPage/index.tsx`)
- Manager's KPI management dashboard
- Lists all reporting employees with KPI status
- Status options: Not Created, Assigned, Submitted, Reviewed
- Filter by employee code, appraisal date, review date, status
- Assign goals to employees without KPI
- Navigate to employee KPI details

### Dialog Components

#### KPIEditDialog (`pages/KPI/KPIEditDialog.tsx`)
- Edit employee quarterly self-ratings (Q1-Q4)
- Rating input (numeric)
- Notes field (optional)
- View/Edit modes

#### ManagerKPIEditDialog (`pages/KPI/Components/ManagerKPIEditDialog.tsx`)
- Edit manager ratings for employee goals
- Manager rating input
- Manager notes field
- Editable/View-only modes

#### AssignGoalDialog (`pages/KPI/Components/AssignGoalDialog.tsx`)
- Assign goals to employees
- Select goal from autocomplete
- Set allowed quarters (Q1, Q2, Q3, Q4)
- Set target expected
- Display employee name and email

#### KpiRatingHistoryTable (`pages/KPI/KpiDetails/KpiRatingHistoryTable.tsx`)
- View manager rating history for a specific goal
- Shows manager name, rating, comment, date
- Dialog component

#### KpiConfiramtionDialog (`pages/KPI/KpiDetails/KpiConfiramtionDialog.tsx`)
- Confirmation dialog for submitting KPI plan
- Used by managers before submitting reviews

### Reusable Components

#### EmployeeManagerAutocomplete (`pages/KPI/Components/EmployeeManagerAutocomplete.tsx`)
- Autocomplete for selecting employees under manager

#### GoalAutocomplete (`pages/KPI/Components/GoalAutocomplete.tsx`)
- Autocomplete for selecting KPI goals

#### GoalsUserAutocomplete (`pages/KPI/Components/GoalsUserAutocomplte.tsx`)
- Autocomplete for selecting multiple users when creating goals

#### KpiGoalFilterForm (`pages/KPI/Components/KpiGoalFilterForm.tsx`)
- Filter form for goals list
- Filters: Title, Department, Date range, Created by

#### ManagerDashboardFilterForm (`pages/KPI/Components/ManagerDashboardFilterForm.tsx`)
- Filter form for manager dashboard
- Filters: Appraisal dates, Review dates, Status

### Table Columns
- `EmployeeKPI/useTableColumn.tsx` - Columns for employee KPI table
- `KpiDetails/useTableColumn.tsx` - Columns for KPI details table
- `GoalListPage/useTableColumn.tsx` - Columns for goals list
- `MangerDashboardPage/useTableColumn.tsx` - Columns for manager dashboard

### Utility Files
- `pages/KPI/utils.ts` - Helper functions (canEmployeeSubmitRatings, canManagerSubmitRatings)
- `pages/KPI/constant.ts` - Default filter constants
- `pages/KPI/KpiDetails/type.ts` - TypeScript types for KPI details

## API Endpoints

### Goals Management
- `POST /api/KPI/CreateGoal` - Create new goal
- `GET /api/KPI/GetGoalById/{goalId}` - Get goal by ID
- `POST /api/KPI/UpdateGoal` - Update goal
- `POST /api/KPI/GetGoalList` - Get paginated/filtered goals list
- `POST /api/KPI/DeleteGoal/{goalId}` - Delete goal

### Employee KPI
- `GET /api/KPI/GetEmployeeSelfRating` - Get employee's self ratings (params: employeeId?, planId?)
- `POST /api/KPI/UpdateEmployeeSelfRating` - Update employee quarterly self-rating
- `POST /api/KPI/SubmitKPIPlanByEmployee/{planId}` - Submit KPI plan for manager review

### Manager KPI
- `POST /api/KPI/GetEmployeesKPI` - Get list of employees with KPI status (Manager Dashboard)
- `GET /api/KPI/GetEmployeesByManager` - Get list of employees reporting to manager
- `GET /api/KPI/GetEmployeeRatingByManager/{EmployeeId}` - Get all KPI plans and ratings for employee
- `POST /api/KPI/UpdateEmployeeRatingByManager` - Update manager rating for goal
- `POST /api/KPI/AssignGoalByManager` - Assign goal to employee with quarters and target
- `POST /api/KPI/SubmitKPIPlanByManager/{planId}` - Submit manager review
- `POST /api/KPI/GetManagerRatingHistoryByGoal` - Get rating history for specific goal

## Data Models

### Frontend Types (`services/KPI/types.ts`)

```typescript
// Goal Rating (per goal in a plan)
type GoalRating = {
  employeeCode: string;
  employeeId: number;
  planId: number;
  goalId: number;
  goalTitle: string;
  lastAppraisal: string | null;
  nextAppraisal: string | null;
  q1_Rating: number | null;
  q2_Rating: number | null;
  q3_Rating: number | null;
  q4_Rating: number | null;
  q1_Note: string | null;
  q2_Note: string | null;
  q3_Note: string | null;
  q4_Note: string | null;
  managerRating: number | null;
  managerNote: string | null;
  targetExpected: number | null;
  status: null | boolean;
  allowedQuarter: string; // comma-separated quarters
};

// Plan Rating (KPI Plan with goals)
type PlanRating = {
  planId: number;
  reviewDate: string;
  isReviewed: boolean;
  joiningDate: string;
  lastAppraisal: string;
  nextAppraisal: string;
  goals: GoalRating[];
};

// Employee Self Rating Response
type GetEmployeeSelfRatingResponse = {
  statusCode: number;
  message: string;
  result: [{
    employeeCode: string;
    employeeId: number;
    employeeName: string;
    isReviewed: boolean | null;
    email: string;
    joiningDate: string;
    planId: number;
    reviewDate: string | null;
    lastReviewDate: string | null;
    nextAppraisal: string | null;
    ratings: GoalRating[];
  }];
};

// Goal Data
type goalData = {
  title: string;
  description: string;
  departmentId: number;
  employeeId: number;
  goalId: number;
  employeeIds: string; // comma-separated
};

// Goal List Item
type goalList = {
  id: string;
  title: string;
  description: string;
  department: string;
  createdOn: Date;
  createdBy: string;
};

// Employee Goal List (Manager Dashboard)
type employeesGoalList = {
  employeeId: number;
  employeeName: string;
  email: string;
  reviewDate: string | null;
  isReviewed: boolean | null;
  joiningDate: string;
  lastReviewDate?: string;
  nextAppraisal?: string;
  planId: number;
  employeeCode: string;
};

// Update Self Rating
type UpdateSelfRatingPayload = {
  goalId: number;
  planId: number;
  note: string | null;
  quarter: Quarter; // Q1, Q2, Q3, Q4
  rating: number;
};

// Update Manager Rating
type updateManagerRating = {
  planId: number;
  goalId: number;
  managerRating: number;
  managerNote: string | null;
};

// Assign Goal
type AssignGoalByManagerRequest = {
  goalId: number;
  employeeId: number;
  allowedQuarter?: string; // comma-separated
  targetExpected?: string;
  planId?: number | null;
};

// Manager Rating History
type ManagerRatingHistory = {
  managerId: number;
  managerName?: string;
  managerRating?: number;
  managerComment?: string;
  createdOn: string;
};

// Filters
interface KPIGoalRequestFilter {
  title?: string | null;
  departmentId?: number | null;
  createdOnFrom?: string | null;
  createdOnTo?: string | null;
  createdBy?: string | null;
}

interface employeesGoalListFilter {
  appraisalDateFrom?: string;
  appraisalDateTo?: string;
  reviewDateFrom?: string;
  reviewDateTo?: string;
  employeeCode?: string;
  statusFilter: number | null; // null, 0=Not Created, 1=Assigned, 2=Submitted, 3=Reviewed
}
```

### Backend Entities

#### KPIGoal (`Domain/Entities/KPIGoal.cs`)
```csharp
public class KPIGoals : BaseEntity {
  public long Id { get; set; }
  public string Title { get; set; }
  public string? Description { get; set; }
  public long DepartmentId { get; set; }
  public string EmployeeIds { get; set; } // comma-separated
}
```

#### KPIPlan (`Domain/Entities/KPIPlan.cs`)
```csharp
public class KPIPlan : BaseEntity {
  public long EmployeeId { get; set; }
  public string? AppraisalCycle { get; set; }
  public bool? IsReviewed { get; set; }
  public DateTime? ReviewDate { get; set; }
  public string? OverallProgress { get; set; }
  public string? AppraisalNote { get; set; }
  public string? AppraisalAttachment { get; set; }
}
```

#### KPIDetails (`Domain/Entities/KPIDetails.cs`)
```csharp
public class KPIDetails : BaseEntity {
  public long PlanId { get; set; }
  public long GoalId { get; set; }

  // Quarterly ratings
  public decimal? Q1_Rating { get; set; }
  public decimal? Q2_Rating { get; set; }
  public decimal? Q3_Rating { get; set; }
  public decimal? Q4_Rating { get; set; }

  // Quarterly notes
  public string? Q1_Note { get; set; }
  public string? Q2_Note { get; set; }
  public string? Q3_Note { get; set; }
  public string? Q4_Note { get; set; }

  public string? TargetExpected { get; set; }
  public decimal? EmployeeRating { get; set; }
  public decimal? ManagerRating { get; set; }
  public string? EmployeeNote { get; set; }
  public string? ManagerNote { get; set; }
  public bool? Status { get; set; }
  public string? AllowedQuarter { get; set; } // comma-separated
}
```

### Backend DTOs (Models/Models/KPI/)
- `GoalRequestDto.cs` - Create/Update goal request
- `GoalResponseDto.cs` - Goal response
- `KPIGoalRequestDto.cs` - Goal search/filter request
- `KPIGoalsSearchResponseDto.cs` - Goal search response
- `GetSelfRatingListDto.cs` - Self rating list
- `GetSelfRatingResponseDto.cs` - Self rating response
- `UpdateEmployeeSelfRatingRequestDto.cs` - Update self rating
- `ManagerRatingUpdateRequestDto.cs` - Update manager rating
- `AssignGoalRequestDto.cs` - Assign goal request
- `AssignGoalByManagerRequestDto.cs` - Assign goal by manager
- `GetEmpByManagerRequestDto.cs` - Get employees by manager request
- `GetEmpListResponseDto.cs` - Employee list response
- `GetEmpResponseDto.cs` - Employee response
- `EmployeeByManagerResponse.cs` - Employees by manager
- `GetEmployeeRatingByManagerResponseDto.cs` - Employee ratings by manager
- `GetRatingHistoryRequestDto.cs` - Rating history request
- `ManagerRatingHistoryByGoalResponseDto.cs` - Manager rating history
- `PlanRatingDto.cs` - Plan rating
- `EnsureKPIResponseDto.cs` - Ensure KPI response
- `KPIEmail.cs` - KPI email template

## Permissions

Backend permissions (from `Permissions.cs`):
- `Read.KPI` - View KPI
- `Create.KPI` - Create KPI
- `Edit.KPI` - Edit KPI ratings/goals
- `Delete.KPI` - Delete KPI goals
- `View.KPI` - View specific KPI details
- `Read.KPIGoals` - View goals list
- `Read.KPIDashboard` - Access manager dashboard

Frontend permission mapping (from `utils/constants.ts`):
- `KPI.READ` - My KPI page
- `KPI.VIEW` - KPI Details page
- `KPI.CREATE` - Add goal
- `KPI.EDIT` - Edit goal
- `KPI_GOALS.READ` - Goals list
- `KPI_DASHBOARD.READ` - KPI Management (Manager Dashboard)

## Database Tables

Based on entity structure:
1. `KPIGoals` - Stores goal definitions
2. `KPIPlan` - Stores KPI plans per employee
3. `KPIDetails` - Stores quarterly ratings and manager reviews

Related tables:
- `Departments` - Referenced by KPIGoals
- `Users` - Referenced by KPIPlan (EmployeeId)
- Email notification system for KPI updates

## Key Features

### Employee Features
1. View own KPI with quarterly ratings
2. Add/Edit quarterly self-ratings (Q1-Q4)
3. Add notes for each quarter
4. Submit completed KPI plan to manager
5. View manager ratings and notes (read-only)
6. View last review and next review dates

### Manager Features
1. View all team members' KPIs in dashboard
2. Filter employees by status, date ranges, employee code
3. Assign goals to employees
4. Set allowed quarters and target expectations
5. View/Edit employee self-ratings
6. Add manager ratings and notes
7. Submit manager review
8. View rating history for each goal
9. View multiple KPI plans (current + historical)

### Admin Features
1. Create/Edit/Delete KPI goals
2. Assign goals to multiple employees
3. Filter goals by title, department, date, creator

## KPI Status Flow

1. **Not Created** - Employee has no KPI plan
2. **Assigned** - Manager assigned goals, employee hasn't submitted
3. **Submitted** - Employee submitted ratings, awaiting manager review
4. **Reviewed** - Manager completed review

Status determined by:
- No planId → Not Created
- planId exists, isReviewed = null → Assigned
- isReviewed = false → Submitted
- isReviewed = true → Reviewed

## Migration Notes

### Complex UI Patterns
1. **Hover-based Edit Icons** - Quarter cells show edit icons on hover
2. **Dynamic Cell Actions** - Cells have different actions based on status
3. **Multiple KPI Plans** - Support historical plan selection with dropdown
4. **Quarterly Rating System** - Q1-Q4 with individual notes
5. **Rating History Dialog** - Shows all previous manager ratings for a goal

### Date Calculations
- Next appraisal date calculated from joining date or last review date
- Complex logic in `displayDate` useMemo hooks

### Special Considerations
1. **Feature Flag** - enableKPI must be true
2. **Permissions** - Multiple granular permissions for different actions
3. **Manager Hierarchy** - Uses reporting manager relationships
4. **Comma-separated Values** - EmployeeIds, AllowedQuarter stored as CSV strings
5. **Email Notifications** - KPI submission triggers emails (EmailTemplateTypes enum)

### UI Framework
- Material-UI v6 components
- Material React Table for data tables
- React Hook Form for forms
- Yup validation
- Toast notifications for feedback

### State Management
- React hooks (useState, useEffect, useMemo)
- Custom useAsync hook for API calls
- useUserStore for current user data

### API Response Format
Standard format:
```json
{
  "statusCode": 200,
  "message": "Success message",
  "result": { /* data */ }
}
```

### Validation Rules
- Goal title: required
- Goal description: required, max 600 chars
- Department: required
- Ratings: numeric
- Notes: optional

### Migration Priority
This is a complex feature with multiple interdependent components. Recommend migrating in this order:
1. Goals CRUD (simpler standalone feature)
2. Employee KPI (self-ratings)
3. Manager Dashboard and KPI Details (most complex)

### Testing Focus
- Quarterly rating input/display
- Manager vs Employee permissions
- Status transitions
- Date calculations
- Filter combinations
- Multi-plan selection
- Rating history tracking
