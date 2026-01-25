# User Profile/Get Personal Details API Contract

## GET /api/UserProfile/GetPersonalDetailsById/{id}

**Description:** Get personal details by employee ID
**Auth Required:** Yes (ReadPersonalDetails permission)

### Request
- Method: GET
- Route Params:
  - id: long
- Query Params: None
- Body: None

### Response 200
```json
{
  "statusCode": 200,
  "message": "Success",
  "data": {
    "employeeId": 0,
    "firstName": "string",
    "lastName": "string",
    "email": "string",
    "phone": "string",
    "dateOfBirth": "2024-01-01",
    "gender": "string",
    "maritalStatus": "string",
    "address": {
      "addressLine1": "string",
      "city": "string",
      "state": "string",
      "country": "string",
      "zipCode": "string"
    }
  }
}
```

### Response 404
```json
{
  "statusCode": 404,
  "message": "Personal details not found",
  "data": null
}
```

### TypeScript Types
```typescript
interface AddressDto {
  addressLine1: string;
  addressLine2?: string;
  city: string;
  state: string;
  country: string;
  zipCode: string;
}

interface PersonalDetailsResponse {
  employeeId: number;
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
