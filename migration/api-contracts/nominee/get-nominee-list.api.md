# Nominee/Get Nominee List API Contract

## POST /api/UserProfile/GetNomineeList

**Description:** Get paginated and filtered nominee list
**Auth Required:** Yes (ReadNomineeDetails permission)

### Request
- Method: POST
- Route Params: None
- Query Params: None
- Body: SearchRequestDto<NomineeSearchRequestDto>

### Response 200
```json
{
  "statusCode": 200,
  "message": "Success",
  "data": {
    "nomineeList": [
      {
        "nomineeId": 0,
        "employeeId": 0,
        "employeeName": "string",
        "nomineeName": "string",
        "relationship": "string",
        "dateOfBirth": "2000-01-01",
        "percentage": 50,
        "contactNumber": "string"
      }
    ],
    "totalRecords": 0
  }
}
```

### Response 400
```json
{
  "statusCode": 400,
  "message": "Nominee not found",
  "data": null
}
```

### TypeScript Types
```typescript
interface NomineeSearchRequest {
  employeeName?: string;
  nomineeName?: string;
}

interface NomineeItem {
  nomineeId: number;
  employeeId: number;
  employeeName: string;
  nomineeName: string;
  relationship: string;
  dateOfBirth: string;
  percentage: number;
  contactNumber: string | null;
}

interface NomineeSearchResponse {
  nomineeList: NomineeItem[];
  totalRecords: number;
}
```
