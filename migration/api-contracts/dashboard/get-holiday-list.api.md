# Dashboard/Holiday List API Contract

## GET /api/Dashboard/GetHolidayList

**Description:** Get list of all holidays for US and India
**Auth Required:** Yes

### Request
- Method: GET
- Route Params: None
- Query Params: None
- Body: None

### Response 200
```json
{
  "statusCode": 200,
  "message": "Success",
  "data": {
    "usHolidays": [
      {
        "holidayDate": "2024-01-01",
        "holidayName": "string",
        "country": "US"
      }
    ],
    "indiaHolidays": [
      {
        "holidayDate": "2024-01-26",
        "holidayName": "string",
        "country": "India"
      }
    ]
  }
}
```

### TypeScript Types
```typescript
interface HolidayDto {
  holidayDate: string;
  holidayName: string;
  country: string;
}

interface HolidayResponse {
  usHolidays: HolidayDto[];
  indiaHolidays: HolidayDto[];
}
```
