# Asset Management/Get Asset List API Contract

## POST /api/AssetManagement/GetAssetList

**Description:** Get paginated and filtered IT asset list
**Auth Required:** Yes (ReadAsset permission)

### Request
- Method: POST
- Route Params: None
- Query Params: None
- Body: SearchRequestDto<ITAssetSearchRequestDto>

### Response 200
```json
{
  "statusCode": 200,
  "message": "Success",
  "data": {
    "assetList": [
      {
        "assetId": 0,
        "assetName": "string",
        "assetType": "string",
        "serialNumber": "string",
        "model": "string",
        "manufacturer": "string",
        "purchaseDate": "2024-01-01",
        "status": "Available"
      }
    ],
    "totalRecords": 0
  }
}
```

### TypeScript Types
```typescript
interface ITAssetSearchRequest {
  assetName?: string;
  assetType?: string;
  status?: string;
}

interface ITAssetItem {
  assetId: number;
  assetName: string;
  assetType: string;
  serialNumber: string;
  model: string;
  manufacturer: string;
  purchaseDate: string;
  status: string;
}

interface ITAssetListResponse {
  assetList: ITAssetItem[];
  totalRecords: number;
}
```
