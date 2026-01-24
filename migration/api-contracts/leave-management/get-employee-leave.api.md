# Leave Management/Get Employee Leave API Contract

## GET /api/LeaveManagement/GetEmployeeLeaveById/{employeeId}

**Description:** Get employee leave balance by employee ID
**Auth Required:** Yes (ReadLeave permission)

### Request
- Method: GET
- Route Params:
  - employeeId: int
- Query Params: None
- Body: None

### Response 200
```json
{
  "statusCode": 200,
  "message": "Success",
  "data": {
    "employeeId": 0,
    "casualLeave": 0,
    "sickLeave": 0,
    "earnedLeave": 0,
    "compOff": 0,
    "totalLeaves": 0
  }
}
```

### Response 404
```json
{
  "statusCode": 404,
  "message": "Employment details not found",
  "data": null
}
```

### TypeScript Types
```typescript
interface EmployeeLeaveResponse {
  employeeId: number;
  casualLeave: number;
  sickLeave: number;
  earnedLeave: number;
  compOff: number;
  totalLeaves: number;
}
```
