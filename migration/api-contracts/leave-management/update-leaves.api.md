# Leave Management/Update Leaves API Contract

## POST /api/LeaveManagement/UpdateLeaves

**Description:** Update employee leave balance
**Auth Required:** Yes (EditLeave permission)

### Request
- Method: POST
- Route Params: None
- Query Params: None
- Body: EmployeeLeaveRequestDto

### Response 200
```json
{
  "statusCode": 200,
  "message": "Leave balance updated successfully",
  "data": {
    "isSuccess": true,
    "message": "string"
  }
}
```

### Response 400
```json
{
  "statusCode": 400,
  "message": "Error in updating Leave details",
  "data": null
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
interface EmployeeLeaveRequest {
  employeeId: number;
  casualLeave: number;
  sickLeave: number;
  earnedLeave: number;
  compOff: number;
}

interface CrudResult {
  isSuccess: boolean;
  message: string;
}
```
