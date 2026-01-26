# Feature: User Guides

## Status
STATUS: human-review
PRIORITY: wave-5
COMPLEXITY: medium
DEPENDENCIES: authentication
CREATED: 2026-01-26
FRONTEND_COMPLETED: 2026-01-26
HUMAN_REVIEW: 2026-01-26

## Overview
Admin feature for creating and managing user guides/help documentation for the HRMS system. Guides are organized by menu and can be published or saved as drafts. Supports rich text content editing.

**Note:** This feature is not exposed in the main navigation menu but is accessible via direct URL.

## Legacy Files

### Frontend (React.js)
```
source/src/pages/UserGuide/
├── UpsertUserGuide.tsx              # Add/Edit page container
├── UserGuideForm/
│   └── UserGuideForm.tsx            # Reusable form component
├── UserGuideListPage/
│   ├── UserGuideListPage.tsx        # List view with table
│   ├── TableTopToolBar.tsx          # Toolbar with filters
│   └── useTableColumns.tsx          # Table column definitions
├── components/
│   ├── UserGuideMenuSelect.tsx      # Menu dropdown selector
│   └── UserGuideStatusSelect.tsx    # Status dropdown selector

source/src/services/UserGuide/
├── userGuide.ts                     # API service
├── types.ts                         # TypeScript types
└── index.ts                         # Exports
```

### Backend (.NET)
```
Controllers/UserGuideController.cs   # 6 endpoints
```

## Data Models

### UserGuide
```typescript
interface UserGuide {
  id: number;
  title: string;
  content: string;        // Rich text HTML
  status: UserGuideStatus;
  menuId: number;
  menuName: string;
  roleId: number | null;  // Role-based access (currently null)
  createdOn: string;
  createdBy: string;
  modifiedOn: string | null;
  modifiedBy: string | null;
}
```

### Enums
```typescript
const UserGuideStatus = {
  Published: 1,
  Draft: 2
} as const;

const USER_GUIDE_STATUS_LABEL = {
  1: 'Published',
  2: 'Draft'
};
```

### Menu Option
```typescript
interface MenuOption {
  id: number;
  name: string;
}
```

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/UserGuide/GetAllMenu | Get available menus for guides |
| GET | /api/UserGuide/GetUserGuideById/{id} | Get guide by ID |
| POST | /api/UserGuide/AddUserGuide | Create new guide |
| POST | /api/UserGuide/UpdateUserGuide | Update existing guide |
| POST | /api/UserGuide/GetAllUserGuide | Get filtered/paginated list |
| POST | /api/UserGuide/DeleteUserGuideById?UserGuideId={id} | Delete guide |

## UI Components

### Pages/Views
1. **UserGuideListView** - Main list page
   - Data table with pagination and sorting
   - Filters: title, menu, status, date range
   - Actions: Add, Edit, Delete

2. **UserGuideFormView** - Add/Edit page
   - Mode: "add" or "edit"
   - Rich text editor for content
   - Menu dropdown (disabled in edit mode)
   - Status toggle (Published/Draft)

### Components
1. **UserGuideTable** - Data table component
2. **UserGuideFilterForm** - Filter form
3. **UserGuideMenuSelect** - Menu dropdown
4. **UserGuideStatusSelect** - Status dropdown
5. **UserGuideContentEditor** - Rich text editor

## Business Logic

### Form Validation
- title: Required, max 200 chars
- menuId: Required (immutable after creation)
- status: Required (1 or 2)
- content: Required (HTML content)

### Status Behavior
- **Published (1):** Guide is visible to users
- **Draft (2):** Guide saved but not visible

### Edit Restrictions
- Menu field is disabled/immutable during edit
- Only title, status, and content can be modified

## Routes
```
/settings/user-guides              # Guide list
/settings/user-guides/add          # Add new guide
/settings/user-guides/:id/edit     # Edit guide
```

## UI Features

### List Page
- Columns: Menu, Title, Status, Created On, Created By, Last Updated On, Last Updated By
- Filters: Title, Menu Name, Status, Created Date, Modified Date
- Server-side pagination
- Edit and Delete actions

### Form Page
- Title input field
- Menu dropdown (from GetAllMenu endpoint)
- Status dropdown (Published/Draft)
- Rich text editor (TinyMCE-style)
- Save and Cancel buttons

### Delete
- Confirmation dialog before deletion

## Validation Rules

### Add Guide
- title: Required, max 200 chars
- menuId: Required
- status: Required (1 or 2)
- content: Required

### Update Guide
- id: Required
- title: Required, max 200 chars
- status: Required
- content: Required
- menuId: Preserved from original (not editable)

## Migration Notes
1. Use Vuetify rich text editor or TipTap for content
2. Menu dropdown populated from GetAllMenu API
3. Status as colored chip (Published=green, Draft=grey)
4. Server-side pagination for list
5. Menu field disabled in edit mode
6. Date formatting: "YYYY-MM-DD HH:mm"

## Estimated Files
- 2 views (list, form)
- 3 components (table, filters, editor)
- 1 service
- 1 types file
- ~7 total files
