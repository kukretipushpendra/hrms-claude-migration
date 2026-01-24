# Employee/Get Employees API Contract

## POST /api/Employee/GetEmployees

**Description:** Get paginated and filtered list of employees
**Auth Required:** Yes (ReadEmployees permission)

### Request
- Method: POST
- Route Params: None
- Query Params: None
- Body: SearchRequestDto<EmployeeSearchRequestDto>

### Response 200
```json
{
  "statusCode": 200,
  "message": "Success",
  "data": {
    "employeeList": [
      {
        "employeeId": 0,
        "employeeCode": "string",
        "firstName": "string",
        "lastName": "string",
        "email": "string",
        "department": "string",
        "designation": "string",
        "status": "string",
        "profilePicture": "string"
      }
    ],
    "totalRecords": 0
  }
}
```

### TypeScript Types
```typescript
interface EmployeeSearchRequest {
  employeeName?: string;
  employeeCode?: string;
  department?: string;
  status?: string;
}

interface SearchRequest<T> {
  searchFilter: T;
  pageIndex: number;
  pageSize: number;
  sortBy?: string;
  sortOrder?: 'asc' | 'desc';
}

interface EmployeeListItem {
  employeeId: number;
  employeeCode: string;
  firstName: string;
  lastName: string;
  email: string;
  department: string;
  designation: string;
  status: string;
  profilePicture: string | null;
}

interface EmployeeListSearchResponse {
  employeeList: EmployeeListItem[];
  totalRecords: number;
}
```
