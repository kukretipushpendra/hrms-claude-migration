# Attendance/Employee Report API Contract

## POST /api/Attendance/GetEmployeeReport

**Description:** Get paginated and filtered employee attendance report
**Auth Required:** Yes (ReadAttendanceEmployeeReport permission)

### Request
- Method: POST
- Route Params: None
- Query Params: None
- Body: SearchRequestDto<EmployeeReportSearchRequestDto>

### Response 200
```json
{
  "statusCode": 200,
  "message": "Success",
  "data": {
    "reportList": [
      {
        "employeeId": 0,
        "employeeCode": "string",
        "employeeName": "string",
        "department": "string",
        "totalHours": 0,
        "presentDays": 0,
        "absentDays": 0
      }
    ],
    "totalRecords": 0
  }
}
```

### TypeScript Types
```typescript
interface EmployeeReportSearchRequest {
  dateFrom: string;
  dateTo: string;
  employeeCode?: string;
  employeeName?: string;
}

interface EmployeeReportItem {
  employeeId: number;
  employeeCode: string;
  employeeName: string;
  department: string;
  totalHours: number;
  presentDays: number;
  absentDays: number;
}
```
