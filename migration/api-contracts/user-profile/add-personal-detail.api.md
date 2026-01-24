# User Profile/Add Personal Detail API Contract

## POST /api/UserProfile/AddPersonalDetail

**Description:** Create new personal detail record
**Auth Required:** Yes (CreatePersonalDetails permission)

### Request
- Method: POST
- Route Params: None
- Query Params: None
- Body: PersonalDetailsRequestDto

### Response 200
```json
{
  "statusCode": 200,
  "message": "Personal detail saved successfully",
  "data": {
    "employeeId": 0
  }
}
```

### Response 400
```json
{
  "statusCode": 400,
  "message": "Error in saving personal detail",
  "data": null,
  "errors": ["validation errors"]
}
```

### Response 409
```json
{
  "statusCode": 409,
  "message": "Personal email already exists",
  "data": null
}
```

### TypeScript Types
```typescript
interface PersonalDetailsRequest {
  firstName: string;
  lastName: string;
  email: string;
  phone: string;
  dateOfBirth: string;
  gender: string;
  maritalStatus: string;
  address: AddressDto;
}
```
