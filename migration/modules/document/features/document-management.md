# Feature: Document Management

**Status:** complete
**APPROVED:** 2026-01-27
**Priority:** wave-6
**Module:** document
**Dependencies:** auth-pages, layout-and-styles

## Implementation Details

**Frontend Completed:** ✅
**Commit:** e25692a
**Worktree:** worktrees/document-management/modern/frontend

**Files Created:**
- `src/types/document.types.ts` - TypeScript types and constants
- `src/services/document/document.service.ts` - API service (6 endpoints)
- `src/views/documents/DocumentListView.vue` - Main document list page
- `src/components/documents/AddEditDocumentDialog.vue` - Add/Edit dialog
- `src/components/documents/DocumentTypeSelect.vue` - Document type dropdown
- `src/components/documents/ViewDocumentButton.vue` - Preview attachment button
- `src/router/index.ts` - Added /documents route

**Key Features Implemented:**
- Document types: PAN, Aadhar, Passport, Voter Card, Driving License
- Type-specific validation (PAN regex: ABCDE1234F)
- Expiry date conditional on document type (isExpiryDateRequired)
- File upload using FormData (multipart/form-data)
- Permission checks: Read/Create/Edit/View.PersonalDetails
- Duplicate document type prevention
- Admin view via employeeId query param
- PDF/image preview with base64 decode
- Data table with pagination (10 records/page)

## Overview

Document Management allows employees to upload and manage their government-issued identity documents (PAN, Aadhar, Passport, Voter Card, Driving License). Each document type has specific validation rules and optional expiry dates. Documents are stored as files and can be previewed.

## Routes

| Path | Component | Permission | Description |
|------|-----------|------------|-------------|
| `/documents` | DocumentsPage | Read.PersonalDetails | View and manage employee documents |
| `/documents?employeeId={id}` | DocumentsPage | Read.PersonalDetails | View documents for specific employee (admin view) |

## User Stories

1. As an employee, I can view all my uploaded documents in a data table
2. As an employee, I can add a new document with type, number, expiry (if required), and file upload
3. As an employee, I can edit an existing document's details
4. As an employee, I can preview/download document attachments
5. As an employee, I cannot upload duplicate document types
6. As an admin, I can view any employee's documents by passing employeeId query param

## Components

### Main Page Component
**File:** `/pages/Document/index.tsx`

**Functionality:**
- Displays data table of user documents
- Shows document type, number, expiry date, attachment preview, and edit action
- Opens Add/Edit popup for document management
- Fetches documents for current user or specific employee (via query param)
- Permission-based "Add Document" button
- Pagination support (10 records per page default)

**State Management:**
- `data` - Array of UserDocumentType
- `isPopupOpen` - Controls add/edit popup visibility
- `selectedUserDocumentId` - ID of document being edited (0 for new)
- `startIndex` - Pagination start index
- `pageSize` - Records per page
- `totalRecords` - Total document count
- `currentDocType` - Currently selected document type for editing
- `existingDocTypes` - Array of already uploaded document type IDs (prevents duplicates)

**Permissions:**
- Read: `Read.PersonalDetails`
- Create: `Create.PersonalDetails`
- Edit: `Edit.PersonalDetails`
- View: `View.PersonalDetails`

### Document Table Headers Component
**File:** `/pages/Document/components/documentHeader.tsx`

**Columns:**
1. S.No - Auto-increment index
2. Document Type - String (e.g., "PAN Card", "Aadhar Card")
3. Document Number - String
4. Expiry - Formatted date (MMM DD, YYYY) - can be null
5. Attachment - View/Download button with permission check
6. Actions - Edit button (permission-based, only if Edit.PersonalDetails)

**Functionality:**
- `handleEditClick` callback to open edit popup with document ID
- ViewDocument component for file preview (containerType=1 for User Documents)
- Permission-based column rendering (Actions column only if Edit permission exists)

### Document Type Select Field Component
**File:** `/pages/Document/components/DocumentTypeSelectField.tsx`

**Props:**
- `name` - Form field name (default: "documentTypeId")
- `required` - Boolean
- `id` - Document category ID (PERSONAL_DETAILS_DOCUMENT_ID = 1)
- `onApiResponse` - Callback to pass fetched document types to parent

**Functionality:**
- Fetches government document types from API on mount
- Renders FormSelectField with options (id/name key-value pairs)
- Returns document type metadata including `isExpiryDateRequired` flag
- Used in Add/Edit form

### View User Document Component
**File:** `/pages/Document/components/ViewUserDocument.tsx`

**Props:**
- `fileName` - Document file location/name
- `hasPermission` - Boolean (View.PersonalDetails)

**Functionality:**
- Eye icon button to preview document
- Disabled if no permission (shows VisibilityOff icon)
- Calls downloadUserDocument API with filename
- Opens FilePreview dialog with byte array content
- Validates file extension before preview
- Handles permission-based tooltips

### Add User Document Popup Container
**File:** `/pages/Document/components/AddUserDocumentPopup/index.tsx`

**Props:**
- `open` - Boolean
- `onClose` - Callback
- `userDocumentId` - Number (0 for add, >0 for edit)
- `existingDocTypes` - Array of already uploaded document type IDs
- `currentDocType` - Current document type being edited

**Functionality:**
- Manages form state and validation
- Fetches document details if editing (getUserDocumentById)
- Handles create (addUserDocument) and update (updateUserDocument) operations
- Dynamic validation based on document type
- Conditional expiry date field (based on isExpiryDateRequired)
- Prevents duplicate document types (except current one when editing)
- File upload optional when editing (if document already has attachment)
- Converts Moment.js dates to YYYY-MM-DD format for API
- Uses FormData for multipart/form-data submission

**Form Fields:**
- `documentTypeId` - Required select field
- `documentNumber` - Required text field with type-specific validation
- `documentExpiry` - Conditional date picker (only if isExpiryDateRequired)
- `file` - File upload (required for add, optional for edit if location exists)

**Dynamic Behavior:**
- On document type change: Updates selectedDocumentType state
- If type doesn't require expiry: Clears documentExpiry field
- Validates document number based on selected type (PAN, Aadhar, Passport, etc.)

### Add User Document Form Component
**File:** `/pages/Document/components/AddUserDocumentPopup/AddUserDocumentForm.tsx`

**Props:**
- `open`, `onClose`, `onCloseHandler`
- `userDocumentId` - Edit mode if > 0
- `method` - React Hook Form methods
- `onSubmit` - Form submit handler
- `handleResetForm` - Reset button handler
- `isLoading`, `isSaving`, `isUpdating` - Loading states
- `selectedDocumentType` - Current selected type metadata
- `userDocumentData` - Existing document data (for edit mode)
- `handleApiResponse` - Callback for document types

**Functionality:**
- Modal dialog (max-width: sm, full-width)
- Dynamic title: "Add User Document" or "Edit User Document"
- Shows DocumentTypeSelectField with PERSONAL_DETAILS_DOCUMENT_ID (1)
- FormTextField for document number (required)
- Conditional FormDatePicker for expiry (only if isExpiryDateRequired)
- FileUpload component with optional ViewDocument button (edit mode)
- Submit button with dynamic text: "Save" / "Saving" / "Update" / "Updating"
- Reset button to revert form
- Prevents backdrop/ESC close during submission
- Shows CircularProgress while loading edit data

### Validation Schema
**File:** `/pages/Document/components/AddUserDocumentPopup/validationSchema.ts`

**Function:** `getValidationSchema(isFileRequired, documentTypes, existingDocTypes, currentDocType)`

**Rules:**

1. **documentTypeId:**
   - Required
   - Must not be in existingDocTypes (unless editing current document type)

2. **documentNumber:**
   - Required
   - Type-specific validation:
     - **PAN (1):** Regex `/^[A-Z]{5}[0-9]{4}[A-Z]{1}$/` (e.g., ABCDE1234F)
     - **Aadhar (2):** Max 20 chars, valid Aadhar pattern (12 digits with optional spaces/dashes)
     - **Passport (3):** Max 20 chars, alphanumeric only, not only numbers
     - **Voter Card (4):** Max 20 chars, alphanumeric only, not only numbers
     - **Driving License (5):** Max 20 chars, alphanumeric only, not only numbers

3. **documentExpiry:**
   - Conditional: Required only if selected documentType.isExpiryDateRequired = true
   - Must be valid Moment date
   - Cannot be in the past (must be >= today)

4. **file:**
   - Conditional: Required if isFileRequired = true (add mode or edit without existing file)
   - Must pass fileValidation (size, type, name validations)
   - Allowed types: .pdf, .jpg, .jpeg, .png
   - Max filename length: 100 characters
   - Filename must be alphanumeric with dashes/underscores

**Constants Used:**
```typescript
PERSONAL_DETAILS_DOCUMENT_ID = 1

PersonalDetailDocumentTypeMap = {
  PAN_NUMBER: 1,
  AADHAR_NUMBER: 2,
  PASSPORT_NUMBER: 3,
  VOTER_CARD_NUMBER: 4,
  DRIVING_LICENSE_NUMBER: 5,
}
```

## Data Models

### UserDocumentType (Frontend)
```typescript
{
  id: number;
  employeeId: number;
  documentName: string;
  documentType: string; // Display name (e.g., "PAN Card")
  documentTypeId?: string; // ID as string for form compatibility
  documentNumber: string;
  documentExpiry: string; // ISO date string
  location: string; // File path/blob name
}
```

### GovtDocumentType (Frontend)
```typescript
{
  id: number;
  name: string; // Display name
  isExpiryDateRequired: boolean;
}
```

### AddUserDocumentArgs (Request - Create)
```typescript
{
  EmployeeId: number;
  DocumentTypeId: number;
  DocumentNumber: string;
  DocumentExpiry: string; // YYYY-MM-DD format or empty string
  File: File | null;
}
```

### UpdateUserDocumentArgs (Request - Update)
```typescript
{
  Id: number;
  EmployeeId: number;
  DocumentTypeId: number;
  DocumentNumber: string;
  DocumentExpiry: string; // YYYY-MM-DD format or empty string
  File: File | string; // File object or empty string
}
```

## Business Logic

### Document Type Uniqueness
- Each employee can only have ONE document per document type
- On add: documentTypeId must not exist in user's document list
- On edit: documentTypeId can match current document being edited
- Validation enforced in frontend schema and backend

### Expiry Date Logic
- Not all document types require expiry dates
- GovtDocumentType.isExpiryDateRequired determines if expiry field is shown
- If required: Must be >= today's date
- If not required: Field is hidden and value is undefined/null

### File Upload Logic
- **Add mode:** File is required
- **Edit mode:** File is optional if document already has a location (existing file)
- Allowed formats: PDF, JPG, JPEG, PNG
- Submitted as FormData (multipart/form-data)

### Employee Context
- Default: Uses current user's userId from useUserStore
- Admin view: Can pass employeeId query parameter to view/manage another employee's documents
- Both create and update operations use employeeId from query param or current user

### Permission-Based Features
- View list: Requires Read.PersonalDetails
- Add button: Requires Create.PersonalDetails
- Edit button: Requires Edit.PersonalDetails
- View attachment: Requires View.PersonalDetails

## API Integration

**See:** `/migration/api-contracts/document/document-management.api.md`

### Endpoints Used

1. **GET** `/api/UserProfile/GovtDocumentList/{idProofFor}` - Fetch document types
2. **GET** `/api/UserProfile/GetUserDocumentList/{employeeId}` - List all documents
3. **GET** `/api/UserProfile/GetUserDocumentById/{id}` - Get single document for edit
4. **POST** `/api/UserProfile/UploadUserDocument` - Create document (FormData)
5. **POST** `/api/UserProfile/UpdateUploadUserDocument` - Update document (FormData)
6. **GET** `/api/UserProfile/DownloadUserDocument?filename={filename}` - Preview/download file

**Note:** The DownloadUserDocument endpoint is called by frontend but may be mapped to GetUserDocumentSasUrl in actual implementation. Verify during implementation.

## UI/UX Details

### Data Table
- Columns: S.No, Document Type, Document Number, Expiry, Attachment, Actions
- 10 records per page (default)
- Pagination controls at bottom
- Loading spinner during fetch
- Empty state: Empty table (no custom empty message in legacy)

### Add/Edit Dialog
- Modal dialog (small width, centered)
- Title: "Add User Document" or "Edit User Document"
- Close icon in top-right
- Cannot close during save/update (backdrop/ESC disabled via onCloseHandler)
- Form layout: Vertical stack with 30px gap
- Buttons: "Save"/"Update" (primary), "Reset" (secondary)
- GlobalLoader overlay during save/update

### Attachment Preview
- Eye icon in Attachment column
- Disabled (VisibilityOff) if no View permission
- Tooltip: "View Attachment" or "No Permission To View Attachment"
- Opens FilePreview modal with PDF/image viewer
- Handles byte array from API response

### Edit Mode
- Clicking Edit icon opens dialog with pre-filled data
- File upload shows ViewDocument button for existing attachment
- Can upload new file to replace existing one (optional)
- Document type is editable but validates against duplicates (excluding current)

## Validation Messages

### Frontend (Yup)
- "Document Type is required"
- "This document type already exists"
- "PAN Card must have 5 uppercase letters, 4 digits, and 1 uppercase letter (e.g., ABCDE1234F)."
- "Document Number is required"
- "Document Expiry Date is required"
- "Expiry date cannot be in the past"
- "Invalid Date"
- "File is required"
- File validation messages (from fileValidation utility)

### Backend (FluentValidation)
- "EmployeeId is required"
- "DocumentTypeId is required"
- "Document Number is required"
- "File name length must not exceeded 100 characters."
- "File name must be alphanumeric and can include dashes and underscores..."
- "Only pdf,jpg,jpeg,png files are allowed."
- "Document expiry date must be greater than today's date."

## Edge Cases & Error Handling

1. **Duplicate Document Type:**
   - Frontend prevents selection of existing type
   - Backend returns 409 Conflict if duplicate detected
   - Error message: "The document has been already upload"

2. **Missing File:**
   - Add mode: Required, shows validation error
   - Edit mode: Optional, can update other fields without re-uploading

3. **Invalid File:**
   - Validates extension, size, filename
   - Shows specific error message for each validation failure

4. **Expiry Date in Past:**
   - Both frontend and backend validate
   - Must be greater than today (not equal)

5. **Invalid Document Number Format:**
   - Type-specific validation (PAN regex is strictest)
   - Shows format example in error message

6. **Permission Denied:**
   - Buttons/actions hidden if no permission
   - Attachment view disabled with tooltip

7. **Employee Not Found:**
   - Backend returns 404
   - Frontend shows error toast via throwApiError

8. **File Preview Failed:**
   - Shows error toast: "File name is not available" or "Invalid file"
   - API errors handled via throwApiError

## Testing Checklist

### Functional Tests
- [ ] View document list for current user
- [ ] View document list for another employee (admin)
- [ ] Add new document with all required fields
- [ ] Add document with expiry date (for types that require it)
- [ ] Add document without expiry date (for types that don't require it)
- [ ] Prevent adding duplicate document type
- [ ] Edit existing document - update number and expiry
- [ ] Edit existing document - upload new file
- [ ] Edit existing document - change to another available type
- [ ] Preview/download document attachment
- [ ] Pagination works correctly

### Validation Tests
- [ ] PAN number validation: ABCDE1234F format
- [ ] Aadhar validation: 12 digits with optional spaces/dashes
- [ ] Passport validation: alphanumeric, max 20 chars
- [ ] Voter Card validation: alphanumeric, max 20 chars
- [ ] Driving License validation: alphanumeric, max 20 chars
- [ ] Expiry date cannot be in past
- [ ] Expiry date required for specific types
- [ ] File upload required for add mode
- [ ] File upload optional for edit mode
- [ ] Invalid file type rejected
- [ ] File name too long rejected

### Permission Tests
- [ ] Add button hidden without Create permission
- [ ] Edit button hidden without Edit permission
- [ ] View attachment disabled without View permission
- [ ] List access denied without Read permission

### UI/UX Tests
- [ ] Loading spinner shows during fetch
- [ ] Dialog title changes based on add/edit mode
- [ ] Submit button text changes during save/update
- [ ] Reset button clears form (add) or reverts to original (edit)
- [ ] Cannot close dialog during save
- [ ] Form fields clear on close (add mode)
- [ ] Form fields populate on edit mode
- [ ] Expiry field shows/hides based on selected type
- [ ] Success toast shows after save/update
- [ ] Error toast shows on API failure

### Edge Cases
- [ ] Document number with special characters (should fail)
- [ ] Document type change clears expiry date if not required
- [ ] Edit document to same type (no duplicate error)
- [ ] Upload large file (should validate size)
- [ ] Upload non-image/PDF file (should reject)
- [ ] Preview non-existent file (should show error)

## Migration Notes

### Vue.js Implementation

**State Management:**
- Use Pinia store for document list and form state
- Computed properties for existingDocTypes array
- Reactive refs for popup state and selected document

**Form Validation:**
- Use VeeValidate + Zod for form validation
- Convert Yup schema to Zod schema
- Implement custom document number validators per type
- Conditional expiry field validation

**File Upload:**
- Use Vuetify File Input or custom component
- Implement file preview before upload
- FormData construction for multipart submission

**API Service:**
- Create documentService.ts with all endpoint methods
- Use composables pattern for async operations
- Error handling via toast notifications

**Components Structure:**
```
/pages/documents/
  index.vue (main page)
  components/
    DocumentTable.vue
    DocumentTableColumns.ts
    AddEditDocumentDialog.vue
    DocumentTypeSelect.vue
    ViewDocumentButton.vue
```

**Permissions:**
- Use permission composable/directive
- Check permissions in template v-if conditions
- Hide/disable elements based on permission state

### Key Differences from Legacy
- Replace Material-UI with Vuetify components
- Replace React Hook Form with VeeValidate
- Replace Yup with Zod
- Replace Moment.js with native Date or date-fns
- Replace useAsync hook with Vue composables
- Replace useUserStore with Pinia store

### Critical Details
1. PERSONAL_DETAILS_DOCUMENT_ID = 1 (constant for personal documents category)
2. Document type IDs are integers but forms use strings (convert as needed)
3. Date format for API: YYYY-MM-DD (DateOnly in .NET)
4. File submission uses FormData (multipart/form-data)
5. containerType = 1 for User Documents (used in ViewDocument component)
6. DownloadUserDocument endpoint may need verification (possibly mapped to GetUserDocumentSasUrl)

### Potential Issues
- DownloadUserDocument endpoint not found in UserProfileController - may be implemented differently
- Verify actual endpoint used for file download/preview
- Check if byte array response or SAS URL is used for file access
- Confirm file upload size limits and allowed extensions match backend validation
