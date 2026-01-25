# Official Details/Get Official Details API Contract

## GET /api/OfficialDetails/{id}

**Description:** Get official details by employee ID
**Auth Required:** Yes (ViewOfficialDetails permission)

### Request
- Method: GET
- Route Params:
  - id: long
- Query Params: None
- Body: None

### Response 200
```json
{
  "statusCode": 200,
  "message": "Success",
  "data": {
    "employeeId": 0,
    "officialEmail": "string",
    "officialPhone": "string",
    "extension": "string",
    "skypeId": "string",
    "linkedInProfile": "string"
  }
}
```

### TypeScript Types
```typescript
interface OfficialDetailsResponse {
  employeeId: number;
  officialEmail: string;
  officialPhone: string | null;
  extension: string | null;
  skypeId: string | null;
  linkedInProfile: string | null;
}
```
