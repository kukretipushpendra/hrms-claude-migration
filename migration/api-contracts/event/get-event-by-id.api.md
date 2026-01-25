# Event/Get Event By ID API Contract

## GET /api/Event/{id}

**Description:** Get event details by ID
**Auth Required:** Yes (ViewEvents permission)

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
    "eventId": 0,
    "eventName": "string",
    "eventDate": "2024-01-01",
    "eventCategoryId": 0,
    "eventCategory": "string",
    "location": "string",
    "description": "string",
    "status": "Upcoming",
    "documents": []
  }
}
```

### Response 404
```json
{
  "statusCode": 404,
  "message": "Event not found",
  "data": null
}
```

### TypeScript Types
```typescript
interface EventResponse {
  eventId: number;
  eventName: string;
  eventDate: string;
  eventCategoryId: number;
  eventCategory: string;
  location: string;
  description: string;
  status: string;
  documents: string[];
}
```
