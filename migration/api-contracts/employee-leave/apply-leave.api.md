# Employee Leave/Apply Leave API Contract

## POST /api/EmployeeLeave/ApplyLeave

**Description:** Apply for leave request
**Auth Required:** Yes (CreateLeave permission)

### Request
- Method: POST
- Route Params: None
- Query Params: None
- Body: EmployeeLeaveApplyRequestDto

### Response 200
```json
{
  "statusCode": 200,
  "message": "Leave applied successfully",
  "data": {
    "isSuccess": true,
    "message": "Leave application submitted"
  }
}
```

### Response 400
```json
{
  "statusCode": 400,
  "message": "Invalid request",
  "data": null
}
```

### TypeScript Types
```typescript
interface EmployeeLeaveApplyRequest {
  employeeId: number;
  leaveTypeId: number;
  fromDate: string;
  toDate: string;
  reason: string;
  isHalfDay?: boolean;
}

interface CrudResult {
  isSuccess: boolean;
  message: string;
}
```
