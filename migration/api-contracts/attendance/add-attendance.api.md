# Attendance/Add Attendance API Contract

## POST /api/Attendance/AddAttendance/{employeeId}

**Description:** Create employee attendance record
**Auth Required:** Yes (CreateAttendence permission)

### Request
- Method: POST
- Route Params:
  - employeeId: long
- Query Params: None
- Body: AttendanceRequestDto

### Response 200
```json
{
  "statusCode": 200,
  "message": "Attendance created successfully",
  "data": {
    "attendanceId": 0,
    "employeeId": 0,
    "date": "2024-01-01",
    "timeIn": "09:00:00",
    "timeOut": "18:00:00",
    "hoursWorked": 9.0
  }
}
```

### Response 400
```json
{
  "statusCode": 400,
  "message": "Error in saving employee attendance",
  "data": null
}
```

### TypeScript Types
```typescript
interface AttendanceRequest {
  date: string;
  timeIn: string;
  timeOut?: string;
  notes?: string;
}

interface AttendanceResponse {
  attendanceId: number;
  employeeId: number;
  date: string;
  timeIn: string;
  timeOut: string | null;
  hoursWorked: number;
}
```
