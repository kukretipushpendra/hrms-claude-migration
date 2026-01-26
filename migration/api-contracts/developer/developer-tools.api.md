# API Contract: Developer Tools

## Base URL
```
{LEGACY_API_URL}/api/DevTool
```

## Authentication
All endpoints require JWT Bearer token. **Permission Required:** Read.Logs

---

## Endpoints

### POST /GetLogs
Get paginated list of developer logs with filters.

**Permission:** Read.Logs

**Request:**
```json
{
  "searchValue": "",
  "pageNumber": 1,
  "pageSize": 25,
  "sortColumn": "timestamp",
  "sortDirection": "desc",
  "filter": {
    "message": "",
    "requestId": "",
    "logLevel": null,
    "fromDate": null,
    "toDate": null
  }
}
```

**Response:**
```json
{
  "data": {
    "totalRecords": 150,
    "logs": [
      {
        "id": 1,
        "message": "Error processing request",
        "logLevel": "Error",
        "timestamp": "2026-01-26T10:30:00Z",
        "requestId": "req-12345-abcde",
        "logEvent": "HttpRequest",
        "exception": "System.NullReferenceException: Object reference not set..."
      }
    ]
  },
  "isSuccess": true,
  "message": null
}
```

---

### GET /GetCrons
Get list of available cron job types.

**Permission:** Read.Logs

**Response:**
```json
{
  "data": [
    { "id": 1, "name": "FetchTimeDoctorTimeSheetStats" },
    { "id": 2, "name": "MonthlyLeaveCredit" }
  ],
  "isSuccess": true,
  "message": null
}
```

---

### POST /GetCronLogs
Get paginated cron execution history.

**Permission:** Read.Logs

**Request:**
```json
{
  "searchValue": "",
  "pageNumber": 1,
  "pageSize": 25,
  "sortColumn": "startedAt",
  "sortDirection": "desc",
  "filter": {
    "cronId": null,
    "fromDate": null,
    "toDate": null
  }
}
```

**Response:**
```json
{
  "data": {
    "totalRecords": 50,
    "cronLogs": [
      {
        "id": 1,
        "cronId": 1,
        "cronName": "FetchTimeDoctorTimeSheetStats",
        "logId": 123,
        "payload": "{\"date\":\"2026-01-26\"}",
        "startedAt": "2026-01-26T00:00:00Z",
        "completedAt": "2026-01-26T00:05:30Z",
        "status": "Success"
      }
    ]
  },
  "isSuccess": true,
  "message": null
}
```

---

### POST /RunCron
Execute a cron job manually.

**Permission:** Read.Logs

**Request:**
```json
{
  "cronId": 1,
  "payload": {
    "date": "2026-01-26"
  }
}
```

**Response (Success):**
```json
{
  "data": {
    "executionId": 123,
    "status": "Started"
  },
  "isSuccess": true,
  "message": "Cron job started successfully"
}
```

**Response (Error):**
```json
{
  "data": null,
  "isSuccess": false,
  "message": "Cron job is already running"
}
```

---

## TypeScript Types

```typescript
// Log Level
export const LogLevel = {
  Warning: 'Warning',
  Error: 'Error'
} as const;

export type LogLevelType = typeof LogLevel[keyof typeof LogLevel];

// Cron Types
export const CronType = {
  FetchTimeDoctorTimeSheetStats: 1,
  MonthlyLeaveCredit: 2
} as const;

export type CronTypeValue = typeof CronType[keyof typeof CronType];

export const CRON_TYPE_LABEL: Record<CronTypeValue, string> = {
  [CronType.FetchTimeDoctorTimeSheetStats]: 'Timedoctor timesheet stats',
  [CronType.MonthlyLeaveCredit]: 'Monthly leave credit'
};

// Interfaces
export interface DeveloperLog {
  id: number;
  message: string;
  logLevel: LogLevelType;
  timestamp: string;
  requestId: string;
  logEvent: string;
  exception: string;
}

export interface CronTypeOption {
  id: CronTypeValue;
  name: string;
}

export interface CronLog {
  id: number;
  cronId: CronTypeValue;
  cronName: string;
  logId: number;
  payload: string;
  startedAt: string;
  completedAt: string;
  status: string;
}

// Request DTOs
export interface DeveloperLogsFilter {
  message?: string;
  requestId?: string;
  logLevel?: LogLevelType | null;
  fromDate?: string | null;
  toDate?: string | null;
}

export interface DeveloperLogsPaginationRequest {
  searchValue?: string;
  pageNumber: number;
  pageSize: number;
  sortColumn?: string;
  sortDirection?: 'asc' | 'desc';
  filter: DeveloperLogsFilter;
}

export interface CronLogsFilter {
  cronId?: CronTypeValue | null;
  fromDate?: string | null;
  toDate?: string | null;
}

export interface CronLogsPaginationRequest {
  searchValue?: string;
  pageNumber: number;
  pageSize: number;
  sortColumn?: string;
  sortDirection?: 'asc' | 'desc';
  filter: CronLogsFilter;
}

export interface RunCronRequest {
  cronId: CronTypeValue;
  payload?: Record<string, unknown>;
}

// Response DTOs
export interface DeveloperLogsResponse {
  totalRecords: number;
  logs: DeveloperLog[];
}

export interface CronLogsResponse {
  totalRecords: number;
  cronLogs: CronLog[];
}

export interface RunCronResponse {
  executionId: number;
  status: string;
}
```

---

## Date Range Presets

For filtering logs by date range, the UI provides preset options:

| Preset | Calculation |
|--------|-------------|
| Last 15 Minutes | fromDate = now - 15min, toDate = now |
| Last 1 Hour | fromDate = now - 1h, toDate = now |
| Today | fromDate = today 00:00, toDate = now |
| Yesterday | fromDate = yesterday 00:00, toDate = yesterday 23:59 |
| Last 7 Days | fromDate = now - 7d, toDate = now |
| Custom | User-selected fromDate and toDate |

---

## Error Responses

```json
{
  "data": null,
  "isSuccess": false,
  "message": "Error description"
}
```

Common errors:
- 401: Unauthorized - Invalid token
- 403: Forbidden - Missing Read.Logs permission
- 400: Bad Request - Invalid parameters
- 500: Internal Server Error - Cron execution failed
