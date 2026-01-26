# Asset Management API Contract

## Base URL
`/api/AssetManagement`

## Authentication
JWT Bearer Token required for all endpoints.

## Endpoints

### 1. POST /GetEmployeeAssetList
Retrieves a paginated and filtered list of employee asset assignments.

**Permission Required:** `ReadAsset`

#### Request
**Headers:**
```
Authorization: Bearer {jwt_token}
Content-Type: application/json
```

**Body:**
```typescript
interface SearchRequest<EmployeeAssetSearchRequest> {
  sortColumnName: string;        // Column to sort by
  sortDirection: string;          // "asc" or "desc"
  startIndex: number;             // Pagination start index
  pageSize: number;               // Number of records per page
  filters: {
    assetName?: string;           // Filter by asset name (optional)
  };
}
```

**Example:**
```json
{
  "sortColumnName": "LastUpdate",
  "sortDirection": "desc",
  "startIndex": 0,
  "pageSize": 10,
  "filters": {
    "assetName": "Laptop"
  }
}
```

#### Response
**Success (200):**
```typescript
interface ApiResponse<EmployeeAssetListResponse> {
  statusCode: 200;
  message: "Success";
  result: {
    employeeAssetList: Array<{
      id: number;                 // Employee Asset assignment ID
      assetID: number;            // IT Asset ID
      isActive: boolean;          // Whether asset is currently assigned
      assetName: string;          // Asset Type (e.g., "Laptop")
      assetNumber: string;        // Serial number
      brand: string;              // Manufacturer
      model: string;              // Model
      custodian: string;          // Employee name and email
      lastUpdate: string;         // ISO 8601 datetime (ModifiedOn)
    }>;
    totalRecords: number;         // Total count for pagination
  };
}
```

**Not Found (404):**
```typescript
interface ApiResponse<null> {
  statusCode: 404;
  message: "Record not found";
  result: null;
}
```

---

### 2. POST /UpsertEmployeeAsset
Creates or updates an employee asset assignment.

**Permission Required:** `CreateAsset`

#### Request
**Headers:**
```
Authorization: Bearer {jwt_token}
Content-Type: application/json
```

**Body:**
```typescript
interface EmployeeAssetCreateDto {
  employeeId: number;             // Employee ID to assign asset to
  assetId: number;                // IT Asset ID to assign
  assignedOn: string;             // Date in "YYYY-MM-DD" format
  isActive: boolean;              // Default: false
}
```

**Example:**
```json
{
  "employeeId": 123,
  "assetId": 456,
  "assignedOn": "2024-01-15",
  "isActive": true
}
```

#### Response
**Success (201):**
```typescript
interface ApiResponse<CrudResult> {
  statusCode: 201;
  message: "Success";
  result: "Success";              // CrudResult enum: "Success" or "Failed"
}
```

**Not Found (404):**
```typescript
interface ApiResponse<CrudResult> {
  statusCode: 404;
  message: "Record not found";
  result: "Failed";
}
```

---

### 3. POST /GetAssetList
Retrieves a paginated and filtered list of IT assets.

**Permission Required:** `ReadAsset`

#### Request
**Headers:**
```
Authorization: Bearer {jwt_token}
Content-Type: application/json
```

**Body:**
```typescript
interface SearchRequest<ITAssetSearchRequest> {
  sortColumnName: string;
  sortDirection: string;
  startIndex: number;
  pageSize: number;
  filters: {
    deviceName?: string;          // Filter by device name
    deviceCode?: string;          // Filter by device code
    manufacturer?: string;        // Filter by manufacturer
    model?: string;               // Filter by model
    assetStatus?: AssetStatus;    // Filter by status (1: InInventory, 2: Allocated, 3: Retired)
    assetType?: AssetType;        // Filter by type (1-14, see AssetType enum)
    branch?: BranchLocation;      // Filter by branch (1: Hyderabad, 2: Jaipur, 3: Pune)
    employeeCodes?: string;       // Filter by employee codes (comma-separated)
  };
}
```

**Example:**
```json
{
  "sortColumnName": "DeviceName",
  "sortDirection": "asc",
  "startIndex": 0,
  "pageSize": 20,
  "filters": {
    "deviceName": "Dell Laptop",
    "assetStatus": 2,
    "branch": 1
  }
}
```

#### Response
**Success (200):**
```typescript
interface ApiResponse<ITAssetListResponse> {
  statusCode: 200;
  message: "Success";
  result: {
    iTAssetList: Array<{
      id: number;
      deviceName: string;
      deviceCode: string;
      serialNumber: string;
      invoiceNumber: string;
      manufacturer: string;
      model: string;
      assetType: AssetType;
      assetStatus: AssetStatus;
      assetCondition: AssetCondition;
      branch: BranchLocation;
      purchaseDate: string | null;  // "YYYY-MM-DD"
      warrantyExpires: string | null; // "YYYY-MM-DD"
      comments: string;
      modifiedOn: string | null;    // ISO 8601 datetime
      specification: string;
      custodian: string;            // Employee email
      custodianFullName: string;    // Employee full name
      allocatedBy: string;          // Who allocated the asset
    }>;
    totalRecords: number;
  };
}
```

**Not Found (404):**
```typescript
interface ApiResponse<null> {
  statusCode: 404;
  message: "Record not found";
  result: null;
}
```

---

### 4. POST /UpsertITAsset
Creates or updates an IT asset. Supports file uploads for product document and signature.

**Permission Required:** `CreateAsset`

#### Request
**Headers:**
```
Authorization: Bearer {jwt_token}
Content-Type: multipart/form-data
```

**Body (FormData):**
```typescript
interface ITAssetRequestDto {
  id: number;                     // 0 for new asset, > 0 for update
  deviceName: string;
  deviceCode: string;
  serialNumber: string;
  invoiceNumber: string;
  manufacturer: string;
  model: string;
  assetType: AssetType;           // 1-14 (see AssetType enum)
  assetStatus: AssetStatus;       // 1: InInventory, 2: Allocated, 3: Retired
  assetCondition: AssetCondition; // 1: Ok, 2: Damage, 3: Missing
  branch: BranchLocation;         // 1: Hyderabad, 2: Jaipur, 3: Pune
  purchaseDate: string;           // "YYYY-MM-DD" format (required)
  warrantyExpires?: string;       // "YYYY-MM-DD" format (optional)
  specification?: string;         // Technical specifications
  comments?: string;              // Additional comments
  employeeId?: number;            // For allocation (optional)
  note?: string;                  // Note for allocation/history (optional)
  isAllocated?: boolean;          // true/false/null - triggers allocation logic
  productFileOriginalName?: File; // Product document file (optional)
  signatureFileOriginalName?: File; // Signature file (optional)
}
```

**Notes:**
- If `isAllocated` is `true`, the asset will be allocated to the employee specified in `employeeId`
- If `isAllocated` is `false`, the asset will be deallocated
- If `isAllocated` is `null`, only asset info is updated
- File size limit applies (check `UserDocFileMaxSize` in app config)
- Files are uploaded to blob storage

#### Response
**Success (201):**
```typescript
interface ApiResponse<CrudResult> {
  statusCode: 201;
  message: "Success";
  result: "Success";
}
```

**Not Found (404):**
```typescript
interface ApiResponse<CrudResult> {
  statusCode: 404;
  message: "Record not found" | "Invalid document max size" | "Already allocated";
  result: "Failed";
}
```

**Internal Server Error (500):**
```typescript
interface ApiResponse<CrudResult> {
  statusCode: 500;
  message: "Error in processing your request. {error details}";
  result: "Failed";
}
```

---

### 5. GET /GetEmployeeAsset/{employeeId}
Retrieves the list of IT assets assigned to a specific employee.

**Permission Required:** `ViewAsset`

#### Request
**Headers:**
```
Authorization: Bearer {jwt_token}
```

**URL Parameters:**
- `employeeId` (number, required): The employee's ID

**Example:** `GET /api/AssetManagement/GetEmployeeAsset/123`

#### Response
**Success (200):**
```typescript
interface ApiResponse<EmployeeITAssetResponse[]> {
  statusCode: 200;
  message: "Success";
  result: Array<{
    assetId: number;
    serialNumber: string;
    deviceCode: string;
    deviceName: string;
    manufacturer: string;
    model: string;
    assetType: AssetType;
    branch: BranchLocation | null;
    assignedBy: string;           // Email of person who assigned
    assignedOn: string;           // "YYYY-MM-DD"
    assetStatus: AssetStatus;
    assetCondition: AssetCondition;
    returnDate: string | null;    // "YYYY-MM-DD"
  }>;
}
```

**Not Found (404):**
```typescript
interface ApiResponse<null> {
  statusCode: 404;
  message: "Record not found";
  result: null;
}
```

---

### 6. GET /GetAssetById/{AssetId}
Retrieves detailed information about a specific IT asset.

**Permission Required:** `ViewAsset`

#### Request
**Headers:**
```
Authorization: Bearer {jwt_token}
```

**URL Parameters:**
- `AssetId` (number, required): The asset's ID

**Example:** `GET /api/AssetManagement/GetAssetById/456`

#### Response
**Success (200):**
```typescript
interface ApiResponse<ITAssetResponse> {
  statusCode: 200;
  message: "Success";
  result: {
    id: number;
    deviceName: string;
    deviceCode: string;
    serialNumber: string;
    invoiceNumber: string;
    manufacturer: string;
    model: string;
    assetType: AssetType;
    assetStatus: AssetStatus;
    branch: BranchLocation;
    assetCondition: AssetCondition;
    purchaseDate: string | null;  // "YYYY-MM-DD"
    warrantyExpires: string | null; // "YYYY-MM-DD"
    comments: string;
    modifiedOn: string;           // ISO 8601 datetime
    specification: string;
    custodian: {                  // Null if not allocated
      employeeId: number | null;
      email: string;
      firstName: string;
      middleName: string;
      lastName: string;
      fullName: string;
    } | null;
    productFileOriginalName: string | null; // Original filename
    productFileName: string | null;         // Blob storage filename
    signatureFileOriginalName: string | null;
    signatureFileName: string | null;
  };
}
```

**Not Found (404):**
```typescript
interface ApiResponse<null> {
  statusCode: 404;
  message: "Record not found";
  result: null;
}
```

---

### 7. GET /GetAssetHistoryById/{AssetId}
Retrieves the history of an IT asset, including all allocations and status changes.

**Permission Required:** `ViewAsset`

#### Request
**Headers:**
```
Authorization: Bearer {jwt_token}
```

**URL Parameters:**
- `AssetId` (number, required): The asset's ID

**Example:** `GET /api/AssetManagement/GetAssetHistoryById/456`

#### Response
**Success (200):**
```typescript
interface ApiResponse<ITAssetHistoryResponse[]> {
  statusCode: 200;
  message: "Success";
  result: Array<{
    employeeName: string;         // Full name of employee
    custodian: string;            // Employee email
    assetStatus: AssetStatus;
    assetCondition: AssetCondition;
    note: string | null;          // Notes about the change
    modifiedOn: string | null;    // ISO 8601 datetime
    modifiedBy: string | null;    // Email of person who made change
    issueDate: string | null;     // "YYYY-MM-DD" - when issued
    returnDate: string | null;    // "YYYY-MM-DD" - when returned
  }>;
}
```

**Not Found (404):**
```typescript
interface ApiResponse<null> {
  statusCode: 404;
  message: "Record not found";
  result: null;
}
```

---

### 8. POST /ImportExcel
Imports IT assets from an Excel file. Supports validation and preview mode.

**Permission Required:** `CreateAsset`

#### Request
**Headers:**
```
Authorization: Bearer {jwt_token}
Content-Type: multipart/form-data
```

**Body (FormData):**
```typescript
interface ImportExcelRequest {
  excelfile: File;                // Excel file (.xlsx, .xls)
  importConfirmed: boolean;       // Default: true. If false, returns validation preview
}
```

**Excel Format Required Headers:**
- `user name` - Employee email (optional, if provided asset will be allocated)
- `assignment date` - Date in MM/DD/YYYY format (required if user name provided)
- `device name` - Device name (required)
- `device code` - Device code
- `serial number` - Serial number (required, must be unique)
- `invoice number` - Invoice number
- `manufacturer` - Manufacturer name
- `model` - Model name
- `asset type` - Asset type (must match enum: Laptop, Desktop, etc.) (required)
- `status` - Status (Allocated if user provided, InInventory if not) (required)
- `location` - Branch location (Hyderabad, Jaipur, Pune)
- `purchase date` - Purchase date in MM/DD/YYYY format (required)
- `warranty expires` - Warranty expiry date in MM/DD/YYYY format (optional)
- `os` - Operating system
- `processor` - Processor details
- `ram` - RAM in GB (numeric)
- `hdd 1` - Primary storage
- `hdd 2` - Secondary storage
- `comments` - Additional comments

**Validation Rules:**
- Serial number must be unique and not empty
- Device name required
- If user name provided: must be valid employee email, assignment date required, status must be "Allocated"
- If user name not provided: status must be "InInventory"
- Assignment date cannot be earlier than purchase date
- Warranty expiry cannot be earlier than purchase date or assignment date
- Asset type must match enum values
- Cannot change Allocated asset to InInventory via import

#### Response
**Preview Mode (importConfirmed=false) - Success (200):**
```typescript
interface ApiResponse<CrudResult> {
  statusCode: 200;
  message: string; // JSON string containing validation results
  result: "Success";
}

// message contains JSON string:
{
  validRecordsCount: number;
  validRecords: Array<{
    row: number;
    serialNumber: string;
    deviceName: string;
  }>;
  duplicateCount: number;
  duplicateRecords: Array<{
    row: number;
    serialNumber: string;
    deviceName: string;
  }>;
  invalidCount: number;
  invalidRecords: Array<{
    row: number;
    reason: string;
  }>;
}
```

**Import Mode (importConfirmed=true) - Success (200):**
```typescript
interface ApiResponse<CrudResult> {
  statusCode: 200;
  message: "{N} record(s) imported, {M} record(s) updated.";
  result: "Success";
}
```

**Bad Request (400):**
```typescript
interface ApiResponse<CrudResult> {
  statusCode: 400;
  message: "Invalid excel file format" | "Excel file size exceeds maximum limit" | "No valid records to import.";
  result: "Failed";
}
```

**Conflict (409):**
```typescript
interface ApiResponse<CrudResult> {
  statusCode: 409;
  message: "Missing required column(s): {column names}";
  result: "Failed";
}
```

**Internal Server Error (500):**
```typescript
interface ApiResponse<CrudResult> {
  statusCode: 500;
  message: "Error: {error details}";
  result: "Failed";
}
```

---

## Data Types

### Enums

#### AssetType
```typescript
enum AssetType {
  Laptop = 1,
  Desktop = 2,
  Monitor = 3,
  Keyboard = 4,
  Mouse = 5,
  Printer = 6,
  Scanner = 7,
  UPS = 8,
  ExternalHardDrive = 9,
  Headset = 10,
  Webcam = 11,
  Projector = 12,
  SoftwareLicense = 13,
  NetworkCable = 14
}
```

#### AssetStatus
```typescript
enum AssetStatus {
  InInventory = 1,  // Asset is available in inventory
  Allocated = 2,    // Asset is assigned to an employee
  Retired = 3       // Asset is retired/disposed
}
```

#### AssetCondition
```typescript
enum AssetCondition {
  Ok = 1,       // Asset is in good condition
  Damage = 2,   // Asset is damaged
  Missing = 3   // Asset is missing
}
```

#### BranchLocation
```typescript
enum BranchLocation {
  Hyderabad = 1,
  Jaipur = 2,
  Pune = 3
}
```

#### CrudResult
```typescript
enum CrudResult {
  Failed = 0,
  Success = 1
}
```

### Common Types

#### ApiResponseModel&lt;T&gt;
Standard response wrapper for all API responses.
```typescript
interface ApiResponseModel<T> {
  statusCode: number;    // HTTP status code
  message: string;       // Success or error message
  result: T | null;      // Response data or null on error
}
```

#### SearchRequestDto&lt;T&gt;
Standard pagination and filtering request.
```typescript
interface SearchRequestDto<T> {
  sortColumnName: string;     // Column name to sort by
  sortDirection: string;      // "asc" or "desc"
  startIndex: number;         // Starting index for pagination (0-based)
  pageSize: number;           // Number of records per page
  filters: T;                 // Type-specific filter criteria
}
```

#### CustodianDto
Employee information for asset custodian.
```typescript
interface CustodianDto {
  employeeId: number | null;
  email: string;
  firstName: string;
  middleName: string;
  lastName: string;
  fullName: string;
}
```

---

## Error Responses

### Standard Error Format
All errors follow the `ApiResponseModel` structure:

```typescript
interface ApiResponseModel<T> {
  statusCode: number;
  message: string;
  result: null | "Failed";
}
```

### Common HTTP Status Codes

| Code | Description |
|------|-------------|
| 200 | Success |
| 201 | Created successfully |
| 400 | Bad request (invalid input) |
| 401 | Unauthorized (missing or invalid JWT token) |
| 403 | Forbidden (insufficient permissions) |
| 404 | Resource not found |
| 409 | Conflict (e.g., missing Excel headers) |
| 500 | Internal server error |

### Common Error Messages

- `"Success"` - Operation completed successfully
- `"Record not found"` - Requested resource does not exist
- `"Error in processing your request. {details}"` - Generic error with details
- `"Invalid document max size"` - Uploaded file exceeds size limit
- `"Already allocated"` - Asset is already allocated to another employee
- `"Missing required column(s): {columns}"` - Excel import validation failure
- `"Invalid excel file format"` - Uploaded file is not a valid Excel file
- `"Excel file size exceeds maximum limit"` - Excel file too large
- `"No valid records to import."` - All Excel records failed validation

---

## Notes

### Date Formats
- **Request dates (DateOnly):** `"YYYY-MM-DD"` format (e.g., "2024-01-15")
- **Response dates (DateOnly):** `"YYYY-MM-DD"` format or `null`
- **Response dates (DateTime):** ISO 8601 format with timezone (e.g., "2024-01-15T10:30:00Z")

### File Upload
- Files are uploaded to Azure Blob Storage
- Maximum file size controlled by `UserDocFileMaxSize` configuration
- Supported extensions checked via `FileValidations.AllowedExtensions`
- On error, uploaded files are automatically cleaned up
- Files stored in `UserDocumentContainer` container

### Asset Allocation Logic
When `UpsertITAsset` is called with `isAllocated` parameter:
- **`isAllocated = true`:** Asset is allocated to employee (requires `AssetCondition.Ok` and `AssetStatus.InInventory`)
- **`isAllocated = false`:** Asset is deallocated (returned)
- **`isAllocated = null`:** Only asset details are updated, no allocation change
- Allocation creates entries in both `EmployeeAsset` and `ITAssetHistory` tables

### History Tracking
- Asset history is automatically created when:
  - Asset condition changes
  - Asset status changes
  - Asset is allocated or deallocated
- History includes note field for context

### Permissions
- `ReadAsset` - View asset lists and search
- `CreateAsset` - Create/update assets and allocations
- `ViewAsset` - View detailed asset information

### Excel Import Behavior
- **Preview Mode:** Returns validation results without saving
- **Import Mode:** Saves valid records, returns count of imported/updated
- **Update Logic:** If serial number exists, updates existing record; otherwise creates new
- **Allocation Logic:** If user name provided, automatically allocates asset to employee
- **Status Management:** Cannot change Allocated asset to InInventory via import (prevents data loss)
