# Auth/Login API Contract

## POST /api/Auth/Login

**Description:** Standard username/password login
**Auth Required:** No

### Request
- Method: POST
- Route Params: None
- Query Params: None
- Body: LoginDto

### Response 200
```json
{
  "statusCode": 200,
  "message": "Login successful",
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
  "message": "Error in Login",
  "data": null,
  "errors": ["validation error messages"]
}
```

### TypeScript Types
```typescript
interface LoginRequest {
  email: string;
  password: string;
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
```
