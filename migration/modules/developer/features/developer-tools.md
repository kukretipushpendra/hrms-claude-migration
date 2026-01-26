# Feature: Developer Tools

## Status
STATUS: human-review
PRIORITY: wave-5
COMPLEXITY: medium
DEPENDENCIES: authentication
CREATED: 2026-01-26
FRONTEND_COMPLETED: 2026-01-26
COMMIT: fba8aa5

## Overview
Developer tools for HRMS administrators. Provides log viewing and cron job management functionality. Used for debugging, monitoring, and manual execution of scheduled tasks.

## Legacy Files

### Frontend (React.js)
```
source/src/pages/Developer/
├── Logging/
│   ├── LogsTable/
│   │   └── index.tsx              # Main logs list page
│   └── Detail/
│       └── LogDetails.tsx         # Log details view
├── Crons/
│   └── LogsTable/
│       └── index.tsx              # Cron jobs page
source/src/services/Developer/
├── DeveloperService.ts            # API service
├── types.ts                       # TypeScript types
└── index.ts                       # Exports
source/src/menu-items/dashboard.tsx # Navigation config (lines 298-323)
```

### Backend (.NET)
```
Controllers/DevToolController.cs    # 4 endpoints
```

## Data Models

### DeveloperLog
```typescript
interface DeveloperLog {
  id: number;
  message: string;
  logLevel: string;      // "Warning" | "Error"
  timestamp: string;
  requestId: string;
  logEvent: string;
  exception: string;
}
```

### CronType
```typescript
interface CronType {
  id: number;
  name: string;
}

// Available Crons
const CronTypes = {
  FetchTimeDoctorTimeSheetStats: 1,
  MonthlyLeaveCredit: 2
} as const;
```

### CronLog
```typescript
interface CronLog {
  id: number;
  cronId: number;
  logId: number;
  payload: string;
  startedAt: string;
  completedAt: string;
}
```

## API Endpoints

| Method | Endpoint | Permission | Description |
|--------|----------|------------|-------------|
| POST | /api/DevTool/GetLogs | Read.Logs | Get paginated logs with filters |
| GET | /api/DevTool/GetCrons | Read.Logs | Get available cron types |
| POST | /api/DevTool/GetCronLogs | Read.Logs | Get cron execution history |
| POST | /api/DevTool/RunCron | Read.Logs | Execute a cron job manually |

## UI Components

### Pages/Views
1. **DeveloperLogsView** - Main logs list
   - Server-side paginated table
   - Filters: message, requestId, logLevel, dateRange
   - Date range presets (15min, 1h, today, yesterday, 7d, custom)
   - Click row to view details

2. **LogDetailsView** - Single log detail
   - Shows full log info including exception

3. **CronJobsView** - Cron management
   - Dropdown to select cron type
   - Type-specific form (FetchTimeDoctorStats or MonthlyLeaveCredit)
   - Run button with loading state
   - Cron execution history table

### Components
1. **LogsTable** - Data table for logs
2. **LogsFilterForm** - Filter form with date presets
3. **CronSelector** - Cron type dropdown
4. **CronLogsTable** - Cron history table
5. **CronExecutionForm** - Form to run cron

## Business Logic

### Log Level Colors
- Warning: orange/warning
- Error: red/error

### Date Range Presets
```typescript
const DATE_PRESETS = {
  'last-15-min': { label: 'Last 15 Minutes', minutes: 15 },
  'last-1-hour': { label: 'Last 1 Hour', minutes: 60 },
  'today': { label: 'Today' },
  'yesterday': { label: 'Yesterday' },
  'last-7-days': { label: 'Last 7 Days', days: 7 },
  'custom': { label: 'Custom' }
};
```

### Cron Type Forms
- **FetchTimeDoctorTimeSheetStats (1)**: TimedDoctor integration form
- **MonthlyLeaveCredit (2)**: Monthly leave credit form

## Routes
```
/developer/logs              # Logs list
/developer/logs/:id          # Log details
/developer/cron-jobs         # Cron jobs management
```

## Validation Rules

### Logs Filter
- message: Optional string
- requestId: Optional string
- logLevel: Optional ("Warning" | "Error")
- fromDate: Optional date
- toDate: Optional date

### Run Cron
- cronId: Required number (1 or 2)
- Additional payload based on cron type

## Permission
- Permission Key: `Read.Logs`
- All developer tools pages require this permission

## Migration Notes
1. Use Vuetify data table with server-side pagination
2. Date range filter with presets dropdown
3. Log level as colored chip
4. Cron execution form with dynamic fields based on type
5. Exception text in monospace/pre format
6. Timestamp format: "YYYY MMM DD HH:mm:ss"

## Estimated Files
- 3 views (logs list, log details, cron jobs)
- 4 components (logs table, filters, cron selector, cron logs table)
- 1 service
- 1 types file
- ~9 total files
