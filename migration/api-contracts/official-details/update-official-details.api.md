# Official Details/Update Official Details API Contract

## POST /api/OfficialDetails/UpdateOfficialDetails

**Description:** Update official details
**Auth Required:** Yes (EditOfficialDetails permission)

### Request
- Method: POST
- Route Params: None
- Query Params: None
- Body: OfficialDetailsRequestDto

### Response 200
```json
{
  "statusCode": 200,
  "message": "Official details updated successfully",
  "data": {
    "isSuccess": true,
    "message": "Update successful"
  }
}
```

### Response 400
```json
{
  "statusCode": 400,
  "message": "Error updating official details",
  "data": null,
  "errors": ["validation errors"]
}
```

### TypeScript Types
```typescript
interface OfficialDetailsRequest {
  employeeId: number;
  officialEmail: string;
  officialPhone?: string;
  extension?: string;
  skypeId?: string;
  linkedInProfile?: string;
}
```
