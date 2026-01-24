# Event/Get Events API Contract

## POST /api/Event/GetEvents

**Description:** Get paginated and filtered list of events
**Auth Required:** Yes (ReadEvents permission)

### Request
- Method: POST
- Route Params: None
- Query Params: None
- Body: SearchRequestDto<EventSearchRequestDto>

### Response 200
```json
{
  "statusCode": 200,
  "message": "Success",
  "data": {
    "eventList": [
      {
        "eventId": 0,
        "eventName": "string",
        "eventDate": "2024-01-01",
        "eventCategory": "string",
        "location": "string",
        "description": "string",
        "status": "Upcoming"
      }
    ],
    "totalRecords": 0
  }
}
```

### TypeScript Types
```typescript
interface EventSearchRequest {
  eventName?: string;
  eventCategory?: string;
  status?: string;
  startDate?: string;
  endDate?: string;
}

interface EventItem {
  eventId: number;
  eventName: string;
  eventDate: string;
  eventCategory: string;
  location: string;
  description: string;
  status: string;
}

interface EventSearchResponse {
  eventList: EventItem[];
  totalRecords: number;
}
```
