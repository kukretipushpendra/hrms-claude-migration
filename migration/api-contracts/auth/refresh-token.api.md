# Auth/Refresh Token API Contract

## POST /api/Auth/RefreshToken

**Description:** Generate new access token using refresh token
**Auth Required:** No

### Request
- Method: POST
- Route Params: None
- Query Params: None
- Body: RefreshTokenRequest

### Response 200
```json
{
  "statusCode": 200,
  "message": "Token refreshed successfully",
  "data": {
    "token": "string",
    "refreshToken": "string",
    "employeeId": 0,
    "email": "string",
    "firstName": "string",
    "lastName": "string"
  }
}
```

### Response 400
```json
{
  "statusCode": 400,
  "message": "Error in Get Refresh token",
  "data": null,
  "errors": ["validation error messages"]
}
```

### Response 403
```json
{
  "statusCode": 403,
  "message": "Invalid/Expired refresh token",
  "data": null
}
```

### TypeScript Types
```typescript
interface RefreshTokenRequest {
  refreshToken: string;
}

interface LoginResponse {
  token: string;
  refreshToken: string;
  employeeId: number;
  email: string;
  firstName: string;
  lastName: string;
}
```
