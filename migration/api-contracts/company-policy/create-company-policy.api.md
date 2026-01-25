# Company Policy/Create Company Policy API Contract

## POST /api/CompanyPolicy/CreateCompanyPolicy

**Description:** Create new company policy
**Auth Required:** Yes (CreateCompanyPolicy permission)

### Request
- Method: POST
- Route Params: None
- Query Params: None
- Body: multipart/form-data (CompanyPolicyRequestDto)

### Response 200
```json
{
  "statusCode": 200,
  "message": "Company policy saved successfully",
  "data": {
    "companyPolicyId": 0,
    "policyTitle": "string",
    "version": "1.0"
  }
}
```

### Response 400
```json
{
  "statusCode": 400,
  "message": "Error in saving company policy",
  "data": null,
  "errors": ["validation errors"]
}
```

### TypeScript Types
```typescript
interface CompanyPolicyRequest {
  policyTitle: string;
  policyCategoryId: number;
  policyContent: string;
  effectiveDate: string;
  document?: File;
}

interface CompanyPolicyResponse {
  companyPolicyId: number;
  policyTitle: string;
  version: string;
}
```
