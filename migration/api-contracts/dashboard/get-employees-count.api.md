# Dashboard/Employees Count API Contract

## POST /api/Dashboard/GetEmployeesCount

**Description:** Get count of active, inactive, and newly joined employees
**Auth Required:** Yes (ReadEmploymentDetails permission)

### Request
- Method: POST
- Route Params: None
- Query Params: None
- Body: DashboardRequestDto

### Response 200
```json
{
  "statusCode": 200,
  "message": "Success",
  "data": {
    "activeEmployees": 0,
    "inactiveEmployees": 0,
    "joinedEmployees": 0
  }
}
```

### TypeScript Types
```typescript
interface DashboardRequest {
  startDate?: string;
  endDate?: string;
}

interface EmployeesCountResponse {
  activeEmployees: number;
  inactiveEmployees: number;
  joinedEmployees: number;
}
```
