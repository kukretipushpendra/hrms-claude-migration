# Auth/Check Health API Contract

## GET /api/Auth/CheckHealth

**Description:** Health check endpoint that returns API version
**Auth Required:** No

### Request
- Method: GET
- Route Params: None
- Query Params: None
- Body: None

### Response 200
```json
"API Version 1.0.0"
```

### TypeScript Types
```typescript
// Returns plain string
type HealthCheckResponse = string;
```
