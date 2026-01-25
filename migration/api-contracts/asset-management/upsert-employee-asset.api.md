# Asset Management/Upsert Employee Asset API Contract

## POST /api/AssetManagement/UpsertEmployeeAsset

**Description:** Create or update employee asset record
**Auth Required:** Yes (CreateAsset permission)

### Request
- Method: POST
- Route Params: None
- Query Params: None
- Body: EmployeeAssetCreateDto

### Response 200
```json
{
  "statusCode": 200,
  "message": "Employee asset saved successfully",
  "data": {
    "employeeAssetId": 0,
    "isSuccess": true
  }
}
```

### Response 400
```json
{
  "statusCode": 400,
  "message": "Error saving employee asset",
  "data": null
}
```

### TypeScript Types
```typescript
interface EmployeeAssetCreateDto {
  employeeAssetId?: number;
  employeeId: number;
  assetId: number;
  assignedDate: string;
  returnDate?: string;
  notes?: string;
}
```
