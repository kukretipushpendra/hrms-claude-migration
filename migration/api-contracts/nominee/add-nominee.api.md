# Nominee/Add Nominee API Contract

## POST /api/UserProfile/AddNominee

**Description:** Add employee nominee
**Auth Required:** Yes (CreateNomineeDetails permission)

### Request
- Method: POST
- Route Params: None
- Query Params: None
- Body: multipart/form-data (NomineeRequestDto)

### Response 200
```json
{
  "statusCode": 200,
  "message": "Nominee added successfully",
  "data": {
    "isSuccess": true,
    "message": "Nominee created"
  }
}
```

### Response 400
```json
{
  "statusCode": 400,
  "message": "Error in adding Nominee",
  "data": null,
  "errors": ["validation errors"]
}
```

### Response 404
```json
{
  "statusCode": 404,
  "message": "Invalid doc max size or no file provided",
  "data": null
}
```

### TypeScript Types
```typescript
interface NomineeRequest {
  employeeId: number;
  nomineeName: string;
  relationshipId: number;
  dateOfBirth: string;
  percentage: number;
  contactNumber?: string;
  document?: File;
}

interface CrudResult {
  isSuccess: boolean;
  message: string;
}
```
