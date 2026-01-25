# Role Permission/Save Role Permissions API Contract

## POST /api/RolePermission/SaveRolePermissions

**Description:** Save or update role permissions
**Auth Required:** Yes (CreateRole, EditRole permissions)

### Request
- Method: POST
- Route Params: None
- Query Params: None
- Body: RolePermissionRequestDto

### Response 200
```json
{
  "statusCode": 200,
  "message": "Role permissions saved successfully",
  "data": true
}
```

### Response 400
```json
{
  "statusCode": 400,
  "message": "Error in saving role permissions",
  "data": null,
  "errors": ["validation errors"]
}
```

### TypeScript Types
```typescript
interface RolePermissionRequest {
  roleId: number;
  permissionIds: number[];
}
```
