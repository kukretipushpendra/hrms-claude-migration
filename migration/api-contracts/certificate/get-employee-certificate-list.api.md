# Certificate/Get Employee Certificate List API Contract

## POST /api/UserProfile/GetEmployeeCerificateList

**Description:** Get paginated and filtered employee certificate list
**Auth Required:** Yes (ReadCertificate permission)

### Request
- Method: POST
- Route Params: None
- Query Params: None
- Body: SearchRequestDto<UserCertificateSearchRequestDto>

### Response 200
```json
{
  "statusCode": 200,
  "message": "Success",
  "data": {
    "certificateList": [
      {
        "certificateId": 0,
        "employeeId": 0,
        "employeeName": "string",
        "certificateName": "string",
        "issuedBy": "string",
        "issuedDate": "2024-01-01",
        "expiryDate": "2025-01-01",
        "status": "Active"
      }
    ],
    "totalRecords": 0
  }
}
```

### TypeScript Types
```typescript
interface UserCertificateSearchRequest {
  employeeName?: string;
  certificateName?: string;
  status?: string;
}

interface UserCertificateItem {
  certificateId: number;
  employeeId: number;
  employeeName: string;
  certificateName: string;
  issuedBy: string;
  issuedDate: string;
  expiryDate: string | null;
  status: string;
}

interface UserCertificateSearchResponse {
  certificateList: UserCertificateItem[];
  totalRecords: number;
}
```
