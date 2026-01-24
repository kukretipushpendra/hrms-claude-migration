# Employment Detail/Get Employment Detail API Contract

## GET /api/UserProfile/GetEmploymentDetailById

**Description:** Get employment details by employee ID
**Auth Required:** Yes (ReadEmploymentDetails permission)

### Request
- Method: GET
- Route Params: None
- Query Params:
  - id: long
- Body: None

### Response 200
```json
{
  "statusCode": 200,
  "message": "Success",
  "data": {
    "employeeId": 0,
    "employeeCode": "string",
    "department": "string",
    "designation": "string",
    "team": "string",
    "reportingManager": "string",
    "joiningDate": "2024-01-01",
    "employmentType": "string",
    "role": "string",
    "status": "Active"
  }
}
```

### Response 400
```json
{
  "statusCode": 400,
  "message": "Employment details not found",
  "data": null
}
```

### TypeScript Types
```typescript
interface EmploymentResponse {
  employeeId: number;
  employeeCode: string;
  department: string;
  designation: string;
  team: string | null;
  reportingManager: string | null;
  joiningDate: string;
  employmentType: string;
  role: string;
  status: string;
}
```
