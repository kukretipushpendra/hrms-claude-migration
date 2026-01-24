# Employee/Export List API Contract

## POST /api/Employee/export

**Description:** Export employee list to Excel
**Auth Required:** Yes (ViewEmployees permission)

### Request
- Method: POST
- Route Params: None
- Query Params: None
- Body: SearchRequestDto<EmployeeSearchRequestDto>

### Response 200
```
Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
Content-Disposition: attachment; filename="EmployeeList_20240101_120000.xlsx"

[Binary Excel file data]
```

### TypeScript Types
```typescript
// Returns File/Blob
type ExportResponse = Blob;
```
