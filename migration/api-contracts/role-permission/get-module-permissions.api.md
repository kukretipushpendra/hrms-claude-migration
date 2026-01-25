# Role Permission/Get Module Permissions API Contract

## GET /api/RolePermission/GetModulePermissionsByRole

**Description:** Get module list with permissions by role ID
**Auth Required:** Yes (ViewRole permission)

### Request
- Method: GET
- Route Params: None
- Query Params:
  - roleId: int
- Body: None

### Response 200
```json
{
  "statusCode": 200,
  "message": "Success",
  "data": {
    "roleId": 0,
    "roleName": "string",
    "modules": [
      {
        "moduleId": 0,
        "moduleName": "string",
        "permissions": [
          {
            "permissionId": 0,
            "permissionName": "string",
            "isGranted": true
          }
        ]
      }
    ]
  }
}
```

### Response 400
```json
{
  "statusCode": 400,
  "message": "Role required",
  "data": null
}
```

### Response 404
```json
{
  "statusCode": 404,
  "message": "Module permissions not found",
  "data": null
}
```

### TypeScript Types
```typescript
interface PermissionDto {
  permissionId: number;
  permissionName: string;
  isGranted: boolean;
}

interface ModuleDto {
  moduleId: number;
  moduleName: string;
  permissions: PermissionDto[];
}

interface ModulePermissionsResponse {
  roleId: number;
  roleName: string;
  modules: ModuleDto[];
}
```
