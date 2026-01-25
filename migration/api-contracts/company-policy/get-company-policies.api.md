# Company Policy/Get Company Policies API Contract

## POST /api/CompanyPolicy/GetCompanyPolicies

**Description:** Get paginated and filtered list of company policies
**Auth Required:** Yes (ReadCompanyPolicy permission)

### Request
- Method: POST
- Route Params: None
- Query Params: None
- Body: SearchRequestDto<CompanyPolicySearchRequestDto>

### Response 200
```json
{
  "statusCode": 200,
  "message": "Success",
  "data": {
    "companyPolicyList": [
      {
        "companyPolicyId": 0,
        "policyTitle": "string",
        "policyCategory": "string",
        "publishedDate": "2024-01-01",
        "status": "Published",
        "version": "1.0"
      }
    ],
    "totalRecords": 0
  }
}
```

### TypeScript Types
```typescript
interface CompanyPolicySearchRequest {
  policyTitle?: string;
  policyCategory?: string;
  status?: string;
  startDate?: string;
  endDate?: string;
}

interface CompanyPolicyItem {
  companyPolicyId: number;
  policyTitle: string;
  policyCategory: string;
  publishedDate: string;
  status: string;
  version: string;
}

interface CompanyPolicySearchResponse {
  companyPolicyList: CompanyPolicyItem[];
  totalRecords: number;
}
```
