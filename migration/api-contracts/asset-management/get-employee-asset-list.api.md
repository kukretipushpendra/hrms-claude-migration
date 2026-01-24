# Asset Management/Get Employee Asset List API Contract

## POST /api/AssetManagement/GetEmployeeAssetList

**Description:** Get paginated and filtered employee asset list
**Auth Required:** Yes (ReadAsset permission)

### Request
- Method: POST
- Route Params: None
- Query Params: None
- Body: SearchRequestDto<EmployeeAssetSearchRequestDto>

### Response 200
```json
{
  "statusCode": 200,
  "message": "Success",
  "data": {
    "employeeAssetList": [
      {
        "employeeAssetId": 0,
        "employeeId": 0,
        "employeeName": "string",
        "assetName": "string",
        "assetType": "string",
        "serialNumber": "string",
        "assignedDate": "2024-01-01",
        "status": "Assigned"
      }
    ],
    "totalRecords": 0
  }
}
```

### TypeScript Types
```typescript
interface EmployeeAssetSearchRequest {
  employeeName?: string;
  assetType?: string;
  status?: string;
}

interface EmployeeAssetItem {
  employeeAssetId: number;
  employeeId: number;
  employeeName: string;
  assetName: string;
  assetType: string;
  serialNumber: string;
  assignedDate: string;
  status: string;
}

interface EmployeeAssetListResponse {
  employeeAssetList: EmployeeAssetItem[];
  totalRecords: number;
}
```
