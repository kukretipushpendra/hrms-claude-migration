# Employment Detail/Add Employment Detail API Contract

## POST /api/UserProfile/AddEmploymentDetail

**Description:** Create new employment detail record
**Auth Required:** Yes (CreateEmploymentDetails permission)

### Request
- Method: POST
- Route Params: None
- Query Params: None
- Body: AddEmploymentDetailRequestDto

### Response 200
```json
{
  "statusCode": 200,
  "message": "Employment details saved successfully",
  "data": {
    "employeeId": 0,
    "employeeCode": "string"
  }
}
```

### Response 400
```json
{
  "statusCode": 400,
  "message": "Error in saving employment detail",
  "data": null,
  "errors": ["validation errors"]
}
```

### TypeScript Types
```typescript
interface AddEmploymentDetailRequest {
  employeeCode: string;
  departmentId: number;
  designationId: number;
  teamId?: number;
  reportingManagerId?: number;
  joiningDate: string;
  employmentType: string;
  roleId: number;
  timeDoctorUserId?: string;
}
```
