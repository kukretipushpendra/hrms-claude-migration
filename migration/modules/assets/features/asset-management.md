# Asset Management Feature

## Overview
The Asset Management feature enables IT administrators to manage company IT assets (laptops, desktops, monitors, etc.) including tracking inventory, allocating assets to employees, monitoring asset history, and importing assets via Excel. Employees can view their allocated assets through their profile.

## Status
CURRENT: human-review
TYPE: feature
WAVE: 4
DEPENDS_ON: [frontend-setup, layout-and-styles, auth-pages]
FRONTEND_QA_STATUS: passed
FRONTEND_ATTEMPT_COUNT: 3

## Legacy Routes

### Admin Routes (Protected with ASSET_DETAILS permissions)
- `/IT-Assets` - IT Assets list/table page (READ permission)
- `/IT-Assets/add` - Add new IT asset (CREATE permission)
- `/IT-Assets/:assetId` - Asset details layout with tabs (READ permission)
  - `/IT-Assets/:assetId/general` - Asset general information tab (VIEW permission)
  - `/IT-Assets/:assetId/history` - Asset allocation history tab (VIEW permission)

### Employee Routes
- `/profile/it-assets` - Employee's allocated assets view (feature flag: enableITAsset)

## Legacy Components

### Main Pages
1. **ItAssetTable** (`/pages/AssetManagement/ItAssetTable/index.tsx`)
   - Main assets listing page with Material React Table
   - Features: Sorting, pagination, filtering, column visibility
   - Includes employee search filter and Excel import functionality
   - Uses `TableTopToolbar` for filters and actions

2. **AddITAssetPage** (`/pages/AssetManagement/AddITAssetPage.tsx`)
   - Add new IT asset form
   - File uploads: Product invoice, signature/acknowledgment document
   - Validation: Asset type, status, condition, branch, dates
   - Form fields: Device name, code, serial number, invoice, manufacturer, model, specifications

3. **AssetDetailsLayout** (`/pages/AssetManagement/AssetDetails/AssetDetailsLayout.tsx`)
   - Layout wrapper for asset detail views
   - Tab navigation: General, History
   - Edit mode toggle (only on General tab)
   - Breadcrumb navigation
   - Dynamic page title: "{deviceName} ({deviceCode})"

4. **AssetGeneralPage** (`/pages/AssetManagement/AssetDetails/AssetGeneralPage.tsx`)
   - Wrapper for ITAssetForm in edit mode
   - Passes asset data and edit state from outlet context

5. **EmployeeITAssets** (`/pages/ITAssets/EmployeeITAssets/EmployeeITAssets.tsx`)
   - Employee view of their allocated assets
   - Simple data table with pagination
   - Can be viewed by employee or admin (via employeeId query param)

### Shared Components
1. **ITAssetForm** (`/pages/AssetManagement/components/ITAssetForm.tsx`)
   - Multi-mode form: add, edit, read
   - Asset allocation/deallocation logic
   - Complex validation rules:
     - Cannot allocate retired assets
     - Cannot allocate missing or damaged assets in inventory
     - Warranty expiry must be after purchase date
   - Dynamic fields:
     - Shows "note" field when status/condition changes
     - Employee autocomplete for allocation
     - File upload with view/download for existing files
   - Asset status logic:
     - New assets cannot be "Allocated" status directly
     - Allocated assets can be moved to Retired/InInventory (deallocates)
     - Status change triggers history entry

2. **HistoryTable** (`/pages/AssetManagement/components/HistoryTable/index.tsx`)
   - Display asset allocation history
   - Shows: Employee name, status, condition, dates, notes, modified by
   - Client-side pagination and sorting

3. **TableTopToolbar** (`/pages/AssetManagement/ItAssetTable/TableTopToolBar.tsx`)
   - Toolbar with filters and actions
   - Excel import functionality
   - Employee multi-select filter
   - Filter toggle and reset

4. **ItAssetTableFilter** (`/pages/AssetManagement/components/ItAssetTableFilter.tsx`)
   - Filter form for asset search
   - Filters: Device name, code, manufacturer, model, asset type, status, branch

5. **ImportButton** (`/pages/AssetManagement/components/ImportButton.tsx`)
   - Excel file import with confirmation dialog
   - Handles import confirmed flag

6. **AssetUserAutocomplete** (`/pages/AssetManagement/components/AssetUserAutocomplete.tsx`)
   - Employee selection for asset allocation
   - Autocomplete search

7. **AssetFormSelectField** (`/pages/AssetManagement/components/AssetFormSelectField.tsx`)
   - Custom select field for asset forms

## API Endpoints

### Base Route: `/api/AssetManagement`

1. **POST /GetEmployeeAssetList**
   - List of employee assets (deprecated/alternative endpoint)
   - Permission: `Permissions.ReadAsset`
   - Request: `SearchRequestDto<EmployeeAssetSearchRequestDto>`
   - Response: `ApiResponseModel<EmployeeAssetListResponseDto>`

2. **POST /UpsertEmployeeAsset**
   - Create/update employee asset record (deprecated/alternative endpoint)
   - Permission: `Permissions.CreateAsset`
   - Request: `EmployeeAssetCreateDto`
   - Response: `ApiResponseModel<EmployeeAssetResponseDto>`

3. **POST /GetAssetList**
   - Get paginated, filtered, sorted asset list
   - Permission: `Permissions.ReadAsset`
   - Request: `SearchRequestDto<ITAssetSearchRequestDto>`
   - Response: `ApiResponseModel<ITAssetListResponseDto>`

4. **POST /UpsertITAsset**
   - Create or update IT asset (multipart/form-data)
   - Permission: `Permissions.CreateAsset`
   - Request: `ITAssetRequestDto` (FormData)
   - Response: `ApiResponseModel<CrudResult>`
   - Side effect: If `isAllocated` is set, calls `AllocateAssetById`

5. **GET /GetEmployeeAsset/{employeeId}**
   - Get all assets allocated to an employee
   - Permission: `Permissions.ViewAsset`
   - Response: `ApiResponseModel<IEnumerable<EmployeeITAssetResponseDto>>`

6. **GET /GetAssetById/{AssetId}**
   - Get detailed asset information by ID
   - Permission: `Permissions.ViewAsset`
   - Response: `ApiResponseModel<ITAssetResponseDto>`

7. **GET /GetAssetHistoryById/{AssetId}**
   - Get allocation history for an asset
   - Permission: `Permissions.ViewAsset`
   - Response: `ApiResponseModel<IEnumerable<ITAssetHistoryResponseDto>>`

8. **POST /ImportExcel**
   - Import assets from Excel file
   - Permission: `Permissions.CreateAsset`
   - Request: `IFormFile excelfile`, `bool importConfirmed=true`
   - Response: `ApiResponseModel<CrudResult>`

## Data Models

### TypeScript Types (`/services/AssetManagement/types.ts`)

```typescript
type ItAsset = {
  id: number;
  deviceName: string;
  deviceCode: string;
  serialNumber: string;
  manufacturer: string;
  model: string;
  assetType: AssetType;
  assetStatus: AssetStatus;
  branch: BranchLocation;
  purchaseDate: string;
  warrantyExpires: string;
  comments: string;
  custodian: string;
  allocatedBy: string;
  custodianFullName: string;
  modifiedOn: string;
}

type AssetData = {
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
  purchaseDate: string;
  warrantyExpires: string;
  comments: string;
  modifiedOn: string;
  specification: string;
  custodian: Custodian | null;
  employeeId: number | null;
  note: string | null;
  productFileOriginalName: string | null;
  productFileName: string | null;
  signatureFileOriginalName: string | null;
  signatureFileName: string | null;
}

type ItAssetHistory = {
  id: number;
  custodian: string;
  employeeName: string;
  assetStatus: AssetStatus;
  assetCondition: AssetCondition;
  modifiedOn: string;
  modifiedBy: string;
  issueDate: string;
  returnDate: string;
  note: string;
}

type EmployeeAsset = {
  assetId: number;
  serialNumber: string;
  deviceCode: string;
  deviceName: string;
  manufacturer: string;
  model: string;
  assetType: AssetType;
  branch: BranchLocation;
  assignedBy: string;
  assignedOn: string;
  returnDate: string;
  assetStatus: AssetStatus;
  assetCondition: AssetCondition;
}

type UpsertITAssetPayload = {
  id?: number;
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
  purchaseDate: string;
  warrantyExpires: string;
  specification: string;
  comments: string;
  employeeId: number | "";
  isAllocated: boolean | "";
  note: string | "";
  productFileOriginalName: File | "";
  signatureFileOriginalName: File | "";
}

type Custodian = {
  employeeId: number;
  email: string;
  firstName: string;
  middleName: string;
  lastName: string;
  fullName: string;
}
```

### C# Entities

**ITAsset** (`/Domain/Entities/ITAsset.cs`)
```csharp
public class ITAsset : BaseEntity
{
    public string? DeviceName { get; set; }
    public string? DeviceCode { get; set; }
    public string? SerialNumber { get; set; }
    public string? InvoiceNumber { get; set; }
    public string? Manufacturer { get; set; }
    public string? Model { get; set; }
    public AssetType AssetType { get; set; }
    public AssetStatus Status { get; set; }
    public AssetCondition AssetCondition { get; set; } = AssetCondition.Ok;
    public BranchLocation? Branch { get; set; }
    public DateOnly PurchaseDate { get; set; }
    public DateOnly? WarrantyExpires { get; set; }
    public string? Specification { get; set; }
    public string? Comments { get; set; }
    public string? ProductFileOriginalName { get; set; }
    public string? ProductFileName { get; set; }
    public string? SignatureFileOriginalName { get; set; }
    public string? SignatureFileName { get; set; }
}
```

**ITAssetHistory** (`/Domain/Entities/ITAssetHistory.cs`)
```csharp
public class ITAssetHistory : BaseEntity
{
    public long AssetId { get; set; }
    public long EmployeeId { get; set; }
    public string? Note { get; set; }
    public AssetStatus Status { get; set; }
    public AssetCondition AssetCondition { get; set; } = AssetCondition.Ok;
    public DateOnly? IssueDate { get; set; }
    public DateOnly? ReturnDate { get; set; }
}
```

### Enums

**AssetType** (14 types)
- 1: Laptop
- 2: Desktop
- 3: Monitor
- 4: Keyboard
- 5: Mouse
- 6: Printer
- 7: Scanner
- 8: UPS
- 9: ExternalHardDrive
- 10: Headset
- 11: Webcam
- 12: Projector
- 13: SoftwareLicense
- 14: NetworkCable

**AssetStatus**
- 1: InInventory
- 2: Allocated
- 3: Retired

**AssetCondition**
- 1: Ok
- 2: Damage (note: backend uses "Damage", frontend uses "damaged")
- 3: Missing (note: backend uses "Missing", frontend uses "missing")

## Permissions
- `ASSET_DETAILS.READ` - View asset list
- `ASSET_DETAILS.CREATE` - Create/update assets, import Excel
- `ASSET_DETAILS.VIEW` - View asset details, history, employee assets

## Feature Flags
- `enableITAsset` - Controls visibility of IT Assets menu and routes

## Migration Notes

### Critical Business Logic
1. **Asset Allocation Logic**
   - When allocating an asset (status change from InInventory/Retired to Allocated with employeeId), set `isAllocated = true`
   - When deallocating (status change from Allocated to InInventory/Retired), set `isAllocated = false`
   - Backend creates ITAssetHistory entry on allocation/deallocation

2. **Status Transition Rules**
   - New assets cannot be created with "Allocated" status (must allocate separately)
   - Allocated assets can be retired or moved to inventory
   - Retired assets cannot be allocated to employees
   - Assets marked as "missing" or "damaged" in inventory cannot be allocated

3. **History Tracking**
   - Every allocation/deallocation creates a history entry
   - History includes: employee, status, condition, dates, note, modified by
   - History is read-only, displayed in chronological order

4. **File Handling**
   - Product invoice file is required
   - Signature/acknowledgment file is optional
   - Files sent as multipart/form-data
   - Backend stores original filename and generated filename separately
   - Frontend displays original filename, downloads using generated filename

5. **Employee Asset View**
   - Employees can only see their own assets via profile
   - Admins can view any employee's assets via employeeId parameter
   - Shows current allocation only (not history)

### Validation Rules
- Device name, code, serial number, invoice number, manufacturer, model are required
- Asset type, status, condition, branch are required (must be valid enum values)
- Purchase date is required, warranty expiry is required
- Warranty expiry cannot be before purchase date
- Product invoice file is required, max file size validation applies
- When status/condition changes, note field becomes required (shown dynamically)

### UI/UX Patterns
- Material React Table for listing with server-side pagination/sorting
- Tabbed interface for asset details (General, History)
- Edit mode toggle on General tab only
- Breadcrumb navigation on all pages
- Filter toggle with active filter indicator
- File upload with preview of existing files
- Dynamic form fields based on state changes

### Search/Filter Capabilities
- Text search: Device name, code, manufacturer, model
- Dropdown filters: Asset type, status, branch
- Employee multi-select filter (employee codes comma-separated)
- Sorting on all columns
- Column visibility toggle

### Excel Import
- Bulk import of assets via Excel file
- Import confirmation flag to handle validation
- Returns count of imported records

### Dependencies
- Requires employee data for allocation (employee autocomplete)
- Requires branch data (from system configuration)
- Requires permissions system for access control
- Requires file storage system for attachments

### Enum Naming Inconsistency
- Backend uses "Damage" and "Missing" (PascalCase)
- Frontend uses "damaged" and "missing" (lowercase)
- Ensure proper mapping during migration

### API Response Format
Standard format:
```json
{
  "statusCode": 200,
  "message": "Success message",
  "result": { ... }
}
```

### Navigation
- Menu item: "IT Assets" with DevicesIcon
- Located in main dashboard menu
- Single menu item (no submenu)
- Feature flag gated: `enableITAsset`
