# Leave Management/Get Applied Leaves API Contract

## POST /api/LeaveManagement/GetAppliedLeaves

**Description:** Get filtered and paginated applied leave records
**Auth Required:** Yes (ReadLeave permission)

### Request
- Method: POST
- Route Params: None
- Query Params: None
- Body: SearchRequestDto<AppliedLeaveSearchRequestDto>

### Response 200
```json
{
  "statusCode": 200,
  "message": "Success",
  "data": {
    "appliedLeavesList": [
      {
        "appliedLeaveId": 0,
        "employeeId": 0,
        "employeeName": "string",
        "leaveType": "string",
        "fromDate": "2024-01-01",
        "toDate": "2024-01-05",
        "totalDays": 5,
        "status": "Pending",
        "reason": "string"
      }
    ],
    "totalRecords": 0
  }
}
```

### TypeScript Types
```typescript
interface AppliedLeaveSearchRequest {
  employeeId?: number;
  leaveType?: string;
  status?: string;
  fromDate?: string;
  toDate?: string;
}

interface AppliedLeaveItem {
  appliedLeaveId: number;
  employeeId: number;
  employeeName: string;
  leaveType: string;
  fromDate: string;
  toDate: string;
  totalDays: number;
  status: string;
  reason: string;
}

interface GetAppliedLeavesTotalRecordsDto {
  appliedLeavesList: AppliedLeaveItem[];
  totalRecords: number;
}
```
