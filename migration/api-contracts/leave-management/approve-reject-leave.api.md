# Leave Management/Approve or Reject Leave API Contract

## POST /api/LeaveManagement/ApproveOrRejectLeave

**Description:** Approve or reject applied leave request
**Auth Required:** Yes (ReadLeaveApproval permission)

### Request
- Method: POST
- Route Params: None
- Query Params: None
- Body: LeaveApprovalDto

### Response 200
```json
{
  "statusCode": 200,
  "message": "Leave approved successfully",
  "data": {
    "isSuccess": true,
    "message": "string"
  }
}
```

### TypeScript Types
```typescript
interface LeaveApprovalDto {
  appliedLeaveId: number;
  status: 'Approved' | 'Rejected';
  remarks?: string;
}

interface CrudResult {
  isSuccess: boolean;
  message: string;
}
```
