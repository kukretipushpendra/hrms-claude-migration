# Employee/Import Excel API Contract

## POST /api/Employee/ImportExcel

**Description:** Import employees from Excel file
**Auth Required:** Yes (CreateEmployees permission)

### Request
- Method: POST
- Route Params: None
- Query Params:
  - importConfirmed: boolean
- Body: multipart/form-data
  - excefile: IFormFile

### Response 200
```json
{
  "statusCode": 200,
  "message": "Import successful",
  "data": {
    "successCount": 0,
    "failureCount": 0,
    "errors": []
  }
}
```

### TypeScript Types
```typescript
interface ImportExcelRequest {
  excefile: File;
  importConfirmed: boolean;
}

interface ImportExcelResponse {
  successCount: number;
  failureCount: number;
  errors: string[];
}
```
