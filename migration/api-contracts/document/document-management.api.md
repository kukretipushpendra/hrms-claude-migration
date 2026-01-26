# API Contract: Document Management

**Module:** document
**Feature:** document-management
**Backend:** .NET WebAPI
**Base URL:** `/api/UserProfile`

## Endpoints

### 1. Get Government Document Types

Fetch available document types for a specific category (Personal Details, Nominee, etc.)

**Endpoint:** `GET /api/UserProfile/GovtDocumentList/{idProofFor}`

**Request:**
- **Path Parameters:**
  - `idProofFor` (int) - Document category ID
    - `1` = Personal Details (PAN, Aadhar, Passport, Voter Card, Driving License)
    - `2` = Nominee Details

**Response:** `200 OK`
```json
{
  "statusCode": 200,
  "message": "Success",
  "modelErrors": [],
  "result": [
    {
      "id": 1,
      "name": "PAN Card",
      "isExpiryDateRequired": false
    },
    {
      "id": 2,
      "name": "Aadhar Card",
      "isExpiryDateRequired": false
    },
    {
      "id": 3,
      "name": "Passport",
      "isExpiryDateRequired": true
    },
    {
      "id": 4,
      "name": "Voter Card",
      "isExpiryDateRequired": false
    },
    {
      "id": 5,
      "name": "Driving License",
      "isExpiryDateRequired": true
    }
  ]
}
```

**Response Codes:**
- `200` - Success
- `404` - Government documents not found

**Permission Required:** `Read.PersonalDetails`

---

### 2. Get User Document List

Fetch all documents for a specific employee.

**Endpoint:** `GET /api/UserProfile/GetUserDocumentList/{employeeId}`

**Request:**
- **Path Parameters:**
  - `employeeId` (long) - Employee ID

**Response:** `200 OK`
```json
{
  "statusCode": 200,
  "message": "Success",
  "modelErrors": [],
  "result": [
    {
      "id": 123,
      "employeeId": 456,
      "documentName": "PAN_456_20240115.pdf",
      "documentTypeId": 1,
      "documentType": "PAN Card",
      "documentNumber": "ABCDE1234F",
      "documentExpiry": null,
      "location": "user-documents/PAN_456_20240115.pdf"
    },
    {
      "id": 124,
      "employeeId": 456,
      "documentName": "Passport_456_20240116.pdf",
      "documentTypeId": 3,
      "documentType": "Passport",
      "documentNumber": "M1234567",
      "documentExpiry": "2030-12-31",
      "location": "user-documents/Passport_456_20240116.pdf"
    }
  ]
}
```

**Response Model:**
```typescript
{
  id: number;
  employeeId: number;
  documentName: string;
  documentTypeId: number;
  documentType: string; // Display name
  documentNumber: string;
  documentExpiry: string | null; // ISO date format (YYYY-MM-DD)
  location: string; // Blob storage path
}
```

**Response Codes:**
- `200` - Success
- `404` - User not found

**Permission Required:** `Read.PersonalDetails`

---

### 3. Get User Document By ID

Fetch a single document by its ID for editing.

**Endpoint:** `GET /api/UserProfile/GetUserDocumentById/{id}`

**Request:**
- **Path Parameters:**
  - `id` (long) - Document ID

**Response:** `200 OK`
```json
{
  "statusCode": 200,
  "message": "Success",
  "modelErrors": [],
  "result": {
    "id": 123,
    "employeeId": 456,
    "documentName": "PAN_456_20240115.pdf",
    "documentTypeId": 1,
    "documentType": "PAN Card",
    "documentNumber": "ABCDE1234F",
    "documentExpiry": null,
    "location": "user-documents/PAN_456_20240115.pdf"
  }
}
```

**Response Codes:**
- `200` - Success
- `404` - Document not found

**Permission Required:** `View.PersonalDetails`

---

### 4. Upload User Document (Create)

Create a new user document with file upload.

**Endpoint:** `POST /api/UserProfile/UploadUserDocument`

**Content-Type:** `multipart/form-data`

**Request Body:**
```typescript
{
  EmployeeId: number;
  DocumentTypeId: number;
  DocumentNumber: string;
  DocumentExpiry: string; // YYYY-MM-DD format or empty string
  File: File; // Binary file data
}
```

**Example:**
```
EmployeeId: 456
DocumentTypeId: 3
DocumentNumber: M1234567
DocumentExpiry: 2030-12-31
File: [Binary file data]
```

**Validation Rules:**
1. `EmployeeId` - Required, must be valid employee
2. `DocumentTypeId` - Required, must exist in DocumentType table
3. `DocumentNumber` - Required, type-specific format validation
4. `DocumentExpiry` - Optional, must be greater than today if provided
5. `File` - Required, must be PDF/JPG/JPEG/PNG, max filename 100 chars, alphanumeric filename

**Response:** `200 OK`
```json
{
  "statusCode": 200,
  "message": "Document uploaded successfully",
  "modelErrors": [],
  "result": true
}
```

**Error Responses:**

**400 Bad Request** - Validation errors
```json
{
  "statusCode": 400,
  "message": "Model state is invalid.",
  "modelErrors": [
    "Document Number is required",
    "File is required"
  ]
}
```

**409 Conflict** - Duplicate document type
```json
{
  "statusCode": 409,
  "message": "The document has been already upload",
  "modelErrors": []
}
```

**500 Internal Server Error** - Database or storage error
```json
{
  "statusCode": 500,
  "message": "Error in saving document information in database",
  "modelErrors": []
}
```

**Response Codes:**
- `200` - Document uploaded successfully
- `400` - Validation error / Document type not found / No file provided
- `409` - Document already exists for this type
- `500` - Error saving to database or blob storage

**Permission Required:** `Create.PersonalDetails`

---

### 5. Update User Document

Update an existing user document (can update metadata and/or replace file).

**Endpoint:** `POST /api/UserProfile/UpdateUploadUserDocument`

**Content-Type:** `multipart/form-data`

**Request Body:**
```typescript
{
  Id: number;
  EmployeeId: number;
  DocumentTypeId: number;
  DocumentNumber: string;
  DocumentExpiry: string; // YYYY-MM-DD format or empty string
  File: File | null; // Optional - only if replacing existing file
}
```

**Example (Update metadata only):**
```
Id: 123
EmployeeId: 456
DocumentTypeId: 1
DocumentNumber: ABCDE1234F
DocumentExpiry:
File: [Empty]
```

**Example (Update metadata + replace file):**
```
Id: 123
EmployeeId: 456
DocumentTypeId: 1
DocumentNumber: ABCDE5678G
DocumentExpiry:
File: [New binary file data]
```

**Validation Rules:**
1. `Id` - Required, must exist
2. `EmployeeId` - Required, must match document owner
3. `DocumentTypeId` - Required, can change type if not duplicate
4. `DocumentNumber` - Required, type-specific format validation
5. `DocumentExpiry` - Optional, must be greater than today if provided
6. `File` - Optional, if provided must pass file validations

**Response:** `200 OK`
```json
{
  "statusCode": 200,
  "message": "Document updated successfully",
  "modelErrors": [],
  "result": true
}
```

**Error Responses:**

**400 Bad Request** - Validation errors
```json
{
  "statusCode": 400,
  "message": "Model state is invalid.",
  "modelErrors": [
    "Invalid Employee Id",
    "Document expiry date must be greater than today's date."
  ]
}
```

**409 Conflict** - Duplicate document type (when changing type)
```json
{
  "statusCode": 409,
  "message": "The document has been already upload",
  "modelErrors": []
}
```

**Response Codes:**
- `200` - Document updated successfully
- `400` - Validation error / Invalid IDs
- `409` - Document type already exists (when changing type)
- `500` - Error updating database or blob storage

**Permission Required:** `Edit.PersonalDetails`

---

### 6. Download User Document

Download or preview a user document file (returns byte array).

**Endpoint:** `GET /api/UserProfile/DownloadUserDocument?filename={filename}`

**Request:**
- **Query Parameters:**
  - `filename` (string) - File location/blob name (from `location` field)

**Example Request:**
```
GET /api/UserProfile/DownloadUserDocument?filename=user-documents/PAN_456_20240115.pdf
```

**Response:** `200 OK`
```json
{
  "statusCode": 200,
  "message": "Success",
  "modelErrors": [],
  "result": "JVBERi0xLjQKJeLjz9MKMiAwIG9iago8PAovVHlwZSAvQ2F0YWxvZwovUGFnZXMgMyAwIF..." // Base64 encoded file content
}
```

**Response Model:**
- `result` - Base64 encoded byte array of file content

**Usage:**
- Frontend decodes base64 string to byte array
- Displays in FilePreview component (PDF viewer or image viewer)
- Can trigger download by creating blob URL

**Response Codes:**
- `200` - Success
- `404` - File not found in blob storage
- `500` - Error retrieving file from storage

**Permission Required:** `View.PersonalDetails`

**Note:** This endpoint may be implemented as `GetUserDocumentUrl` in some versions, which returns a SAS URL instead of byte array. Verify actual implementation during migration.

---

### 7. Get User Document URL (Alternative)

Alternative endpoint that returns a SAS (Shared Access Signature) URL for direct file access.

**Endpoint:** `GET /api/UserProfile/GetUserDocumentUrl?containerType={containerType}&filename={filename}`

**Request:**
- **Query Parameters:**
  - `containerType` (BlobDocumentContainerType enum) - Container type ID
    - `1` = User Documents
  - `filename` (string) - File location/blob name

**Example Request:**
```
GET /api/UserProfile/GetUserDocumentUrl?containerType=1&filename=user-documents/PAN_456_20240115.pdf
```

**Response:** `200 OK`
```json
{
  "statusCode": 200,
  "message": "Success",
  "modelErrors": [],
  "result": "https://storageaccount.blob.core.windows.net/user-documents/PAN_456_20240115.pdf?sv=2021-06-08&se=2024-01-15T12%3A00%3A00Z&sr=b&sp=r&sig=..."
}
```

**Response Model:**
- `result` - Temporary SAS URL (string) valid for limited time
- Can be null if file not found

**Usage:**
- Frontend can use URL directly in iframe or download
- URL expires after configured time period
- More efficient than downloading byte array for large files

**Response Codes:**
- `200` - Success (result can be null if file not found)
- `404` - Container or file not found
- `500` - Error generating SAS URL

**Permission Required:** `View.PersonalDetails`

---

## Data Models

### Backend DTOs

**UserDocumentRequestDto (C#):**
```csharp
public class UserDocumentRequestDto
{
    public long Id { get; set; }
    public long EmployeeId { get; set; }
    public long DocumentTypeId { get; set; }
    public string DocumentNumber { get; set; }
    public DateOnly? DocumentExpiry { get; set; }
    public IFormFile? File { get; set; }
}
```

**UserDocumentResponseDto (C#):**
```csharp
public class UserDocumentResponseDto
{
    public long Id { get; set; }
    public long EmployeeId { get; set; }
    public string DocumentName { get; set; }
    public long DocumentTypeId { get; set; }
    public string DocumentType { get; set; }
    public string DocumentNumber { get; set; }
    public DateOnly? DocumentExpiry { get; set; }
    public string Location { get; set; }
}
```

**GovtDocumentResponseDto (C#):**
```csharp
public class GovtDocumentResponseDto
{
    public long Id { get; set; }
    public string Name { get; set; }
    public bool IsExpiryDateRequired { get; set; }
}
```

---

## Validation Rules (Backend)

Implemented via `UserDocumentRequestValidation` (FluentValidation):

1. **EmployeeId:** Required, not null, not empty
2. **DocumentTypeId:** Required, not null, not empty
3. **DocumentNumber:** Required, not null, not empty
4. **DocumentExpiry:**
   - Must be greater than today if provided
   - Null/empty allowed for documents without expiry
5. **File:**
   - Filename max length: 100 characters
   - Filename pattern: Alphanumeric + dashes + underscores
   - Allowed extensions: .pdf, .jpg, .jpeg, .png
   - Case-insensitive extension check

**File Validation Constants:**
```csharp
FileValidations.FileNameLength = 100
FileValidations.AllowCharsInFileName = "^[a-zA-Z0-9_-]+\\.[a-zA-Z]{3,4}$"
FileValidations.AllowImageAndPdfTypes = [".pdf", ".jpg", ".jpeg", ".png"]
```

---

## Document Type Validation Rules (Frontend)

Implemented in `validationSchema.ts`:

### PAN Card (ID: 1)
- **Pattern:** `/^[A-Z]{5}[0-9]{4}[A-Z]{1}$/`
- **Example:** ABCDE1234F
- **Description:** 5 uppercase letters, 4 digits, 1 uppercase letter
- **Expiry Required:** No

### Aadhar Card (ID: 2)
- **Max Length:** 20 characters
- **Pattern:** 12 digits (can include spaces/dashes)
- **Example:** 1234 5678 9012 or 123456789012
- **Expiry Required:** No

### Passport (ID: 3)
- **Max Length:** 20 characters
- **Pattern:** Alphanumeric only, cannot be only numbers
- **Example:** M1234567
- **Expiry Required:** Yes

### Voter Card (ID: 4)
- **Max Length:** 20 characters
- **Pattern:** Alphanumeric only, cannot be only numbers
- **Example:** ABC1234567
- **Expiry Required:** No

### Driving License (ID: 5)
- **Max Length:** 20 characters
- **Pattern:** Alphanumeric only, cannot be only numbers
- **Example:** DL1420110012345
- **Expiry Required:** Yes

---

## Error Messages

### Success Messages
- `"Document uploaded successfully"` - After successful create
- `"Document updated successfully"` - After successful update

### Error Messages
- `"Model state is invalid."` - Validation errors (check modelErrors array)
- `"The document has been already upload"` - Duplicate document type
- `"Error in saving document information in database"` - Database save failed
- `"Error in updating document information in database"` - Database update failed
- `"Document type not found"` - Invalid DocumentTypeId
- `"No file is provided"` - File required but not uploaded
- `"User not found"` - Invalid EmployeeId
- `"Document not found"` - Invalid document Id
- `"Invalid Employee Id"` - EmployeeId mismatch
- `"File name is not available"` - Missing filename for download
- `"Error retrieving file from storage"` - Blob storage error

### Validation Error Messages
- `"EmployeeId is required"`
- `"DocumentTypeId is required"`
- `"Document Number is required"`
- `"File name length must not exceeded 100 characters."`
- `"File name must be alphanumeric and can include dashes and underscores..."`
- `"Only pdf,jpg,jpeg,png files are allowed."`
- `"Document expiry date must be greater than today's date."`

---

## Constants & Enums

### Document Category IDs
```typescript
PERSONAL_DETAILS_DOCUMENT_ID = 1
NOMINEE_DETAILS_DOCUMENT_ID = 2
```

### Document Type IDs (Personal Details)
```typescript
PersonalDetailDocumentTypeMap = {
  PAN_NUMBER: 1,
  AADHAR_NUMBER: 2,
  PASSPORT_NUMBER: 3,
  VOTER_CARD_NUMBER: 4,
  DRIVING_LICENSE_NUMBER: 5,
}
```

### Blob Container Types
```csharp
enum BlobDocumentContainerType
{
    UserDocument = 1,
    NomineeDocument = 2,
    EventDocument = 3,
    EmployerDocument = 4
}
```

---

## Permissions

All endpoints require specific permissions from the PersonalDetails permission group:

- `Read.PersonalDetails` - View document list, get document types
- `View.PersonalDetails` - View/download document files, get document by ID
- `Create.PersonalDetails` - Upload new documents
- `Edit.PersonalDetails` - Update existing documents
- `Delete.PersonalDetails` - (Not used in document management, but exists for completeness)

**Permission Enforcement:**
- Applied via `[HasPermission(Permissions.xxx)]` attribute on controller actions
- Frontend hides/disables features based on permission checks
- Unauthorized requests return 403 Forbidden

---

## Implementation Notes

### File Upload
- Use `multipart/form-data` content type
- Convert form data to FormData object in JavaScript
- File field accepts single file (not array)
- Backend receives as `IFormFile`

### Date Handling
- Frontend uses Moment.js (convert to native Date or date-fns in Vue)
- API expects `DateOnly` type (YYYY-MM-DD string format)
- Empty string used for null expiry dates
- Frontend displays as "MMM DD, YYYY" format

### File Storage
- Files stored in Azure Blob Storage
- `location` field contains blob path/name
- Download endpoint returns base64 encoded byte array
- Alternative SAS URL endpoint for direct access

### Employee Context
- Can view/manage own documents (current userId)
- Can view/manage other employee's documents (via employeeId param)
- Both create and update use employeeId from request
- Permission checks ensure proper access control

### Document Type Uniqueness
- Each employee can have max one document per type
- Enforced by business logic (not database constraint)
- Returns 409 Conflict if duplicate detected
- Update can change type if new type not already used

### Conditional Expiry
- Some document types require expiry, others don't
- `isExpiryDateRequired` flag from GovtDocumentType
- If required: Must be future date
- If not required: Field can be null/empty

---

## Testing Recommendations

### API Testing
1. Test each document type with valid format
2. Test invalid document numbers for each type
3. Test duplicate document type (should fail)
4. Test expiry date validation (past, present, future)
5. Test file upload with various file types
6. Test file upload with invalid filenames
7. Test update without file (metadata only)
8. Test update with new file (replace)
9. Test permission denied scenarios
10. Test employee not found scenario
11. Test document not found scenario
12. Test file download/preview functionality

### Integration Testing
1. Full flow: Add → View → Edit → Preview
2. Multi-user: Employee A cannot access Employee B's documents
3. Admin flow: View/manage documents for any employee
4. Concurrent edits to same document
5. Large file uploads (verify size limits)
6. Special characters in filenames
7. Network interruption during upload

---

## Migration Checklist

- [ ] Create Vue.js document service with all endpoints
- [ ] Implement FormData construction for file upload
- [ ] Handle multipart/form-data requests
- [ ] Implement Zod validation schema with type-specific rules
- [ ] Create document type constants file
- [ ] Implement file preview component (PDF/image viewer)
- [ ] Handle base64 to byte array conversion for preview
- [ ] Implement permission checks on all actions
- [ ] Add loading states for all async operations
- [ ] Implement toast notifications for success/error
- [ ] Test all document number format validations
- [ ] Test file upload and preview functionality
- [ ] Verify download endpoint behavior (byte array vs SAS URL)
- [ ] Test pagination and data table functionality
- [ ] Verify expiry date conditional logic
- [ ] Test duplicate document type prevention
- [ ] Verify employee context handling (own vs other employee)
