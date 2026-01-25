# Role Permission/Get Roles API Contract

## POST /api/RolePermission/GetRoles

**Description:** Get paginated and filtered list of roles
**Auth Required:** Yes (ReadRole permission)

### Request
- Method: POST
- Route Params: None
- Query Params: None
- Body: SearchRequestDto<RoleRequestSearchDto>

### Response 200
```json
{
  "statusCode": 200,
  "message": "Success",
  "data": {
    "rolesList": [
      {
        "roleId": 0,
        "roleName": "string",
        "description": "string",
        "isActive": true
      }
    ],
    "totalRecords": 0
  }
}
```

### TypeScript Types
```typescript
interface RoleRequestSearchDto {
  roleName?: string;
  isActive?: boolean;
}

interface RoleItem {
  roleId: number;
  roleName: string;
  description: string;
  isActive: boolean;
}

interface RoleSearchResponse {
  rolesList: RoleItem[];
  totalRecords: number;
}
```
