# Auth/SSO Login API Contract

## POST /api/Auth

**Description:** SSO (Single Sign-On) Login endpoint
**Auth Required:** No

### Request
- Method: POST
- Route Params: None
- Query Params: None
- Body: SSOLoginRequestDto

### Response 200
```json
{
  "statusCode": 200,
  "message": "string",
  "data": {
    "token": "string",
    "refreshToken": "string",
    "employeeId": 0,
    "email": "string",
    "firstName": "string",
    "lastName": "string",
    "profilePicture": "string",
    "menu": [],
    "permissions": []
  }
}
```

### Response 400
```json
{
  "statusCode": 400,
  "message": "Error in SSO Login",
  "data": null,
  "errors": ["validation error messages"]
}
```

### TypeScript Types
```typescript
interface SSOLoginRequest {
  // SSO-specific fields (check DTO for exact shape)
  token?: string;
}

interface LoginResponse {
  token: string;
  refreshToken: string;
  employeeId: number;
  email: string;
  firstName: string;
  lastName: string;
  profilePicture: string | null;
  menu: MenuResponseDto[];
  permissions: string[];
}

interface ApiResponse<T> {
  statusCode: number;
  message: string;
  data: T | null;
  errors?: string[];
}
```
