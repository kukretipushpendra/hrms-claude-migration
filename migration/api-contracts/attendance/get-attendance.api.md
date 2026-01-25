# Attendance/Get Attendance API Contract

## GET /api/Attendance/GetAttendance/{employeeId}

**Description:** Get attendance records for an employee with filters and pagination
**Auth Required:** Yes (ReadAttendance permission)

### Request
- Method: GET
- Route Params:
  - employeeId: long
- Query Params:
  - dateFrom: string (optional)
  - dateTo: string (optional)
  - pageIndex: int (default: 0)
  - pageSize: int (default: 7)
- Body: None

### Response 200
```json
{
  "statusCode": 200,
  "message": "Success",
  "data": {
    "attendanceList": [
      {
        "attendanceId": 0,
        "date": "2024-01-01",
        "timeIn": "09:00:00",
        "timeOut": "18:00:00",
        "hoursWorked": 9.0,
        "status": "Present"
      }
    ],
    "totalRecords": 0
  }
}
```

### TypeScript Types
```typescript
interface AttendanceListItem {
  attendanceId: number;
  date: string;
  timeIn: string;
  timeOut: string | null;
  hoursWorked: number;
  status: string;
}

interface AttendanceListResponse {
  attendanceList: AttendanceListItem[];
  totalRecords: number;
}
```
