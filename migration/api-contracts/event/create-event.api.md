# Event/Create Event API Contract

## POST /api/Event/CreateEvent

**Description:** Create new event
**Auth Required:** Yes (CreateEvents permission)

### Request
- Method: POST
- Route Params: None
- Query Params: None
- Body: multipart/form-data (EventRequestDto)

### Response 200
```json
{
  "statusCode": 200,
  "message": "Event created successfully",
  "data": {
    "eventId": 0,
    "eventName": "string",
    "eventDate": "2024-01-01"
  }
}
```

### Response 400
```json
{
  "statusCode": 400,
  "message": "Error in saving Event",
  "data": null,
  "errors": ["validation errors"]
}
```

### TypeScript Types
```typescript
interface EventRequest {
  eventName: string;
  eventDate: string;
  eventCategoryId: number;
  location: string;
  description: string;
  documents?: File[];
}

interface EventResponse {
  eventId: number;
  eventName: string;
  eventDate: string;
}
```
