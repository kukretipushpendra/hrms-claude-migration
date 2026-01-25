# Dashboard/Birthday List API Contract

## GET /api/Dashboard/GetBirthdayList

**Description:** Get list of employees with birthdays in current week
**Auth Required:** Yes

### Request
- Method: GET
- Route Params: None
- Query Params: None
- Body: None

### Response 200
```json
{
  "statusCode": 200,
  "message": "Success",
  "data": [
    {
      "employeeId": 0,
      "fullName": "string",
      "dateOfBirth": "2024-01-01",
      "profilePicture": "string"
    }
  ]
}
```

### TypeScript Types
```typescript
interface BirthdayResponse {
  employeeId: number;
  fullName: string;
  dateOfBirth: string;
  profilePicture: string | null;
}

interface ApiResponse<T> {
  statusCode: number;
  message: string;
  data: T;
}
```
