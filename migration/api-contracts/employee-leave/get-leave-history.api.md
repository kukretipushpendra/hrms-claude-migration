# Employee Leave/Get Leave History API Contract

## POST /api/EmployeeLeave/GetLeaveHistoryByEmployeeId/{employeeId}

**Description:** Get leave history for employee with pagination and date filtering
**Auth Required:** Yes (ReadLeave permission)

### Request
- Method: POST
- Route Params:
  - employeeId: long
- Query Params: None
- Body: SearchRequestDto<LeaveHistoryFilterDto>

### Response 200
```json
{
  "statusCode": 200,
  "message": "Success",
  "data": {
    "leaveHistory": [
      {
        "appliedLeaveId": 0,
        "leaveType": "string",
        "fromDate": "2024-01-01",
        "toDate": "2024-01-05",
        "totalDays": 5,
        "status": "Approved",
        "appliedDate": "2023-12-20",
        "reason": "string"
      }
    ],
    "totalRecords": 0
  }
}
```

### TypeScript Types
```typescript
interface LeaveHistoryFilter {
  startDate?: string;
  endDate?: string;
}

interface LeaveHistoryItem {
  appliedLeaveId: number;
  leaveType: string;
  fromDate: string;
  toDate: string;
  totalDays: number;
  status: string;
  appliedDate: string;
  reason: string;
}

interface LeaveHistoryTotalRecordsResponse {
  leaveHistory: LeaveHistoryItem[];
  totalRecords: number;
}
```
