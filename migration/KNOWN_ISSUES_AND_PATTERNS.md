# Known Issues & Migration Patterns

This file documents common issues, patterns, and lessons learned during the HRMS migration.
**IMPORTANT:** All migration agents MUST read this file before implementing any feature.

---

## Critical Patterns

### 1. Navigation/Sidebar Filtering

**Issue:** Navigation items not showing in sidebar.

**Root Cause:** The modern frontend was using permission strings like `Read.Role` for filtering, but the legacy system uses the `menus` array from the login response.

**Correct Pattern:**
```typescript
// Backend returns menus array in login response:
menus: [
  {
    mainMenu: "Dashboard",
    mainMenuApiEndPoint: "/dashboard",
    subMenus: []
  },
  {
    mainMenu: "Employees",
    mainMenuApiEndPoint: "/employees",
    subMenus: [
      { subMenu: "Employees List", subMenuApiEndPoint: "/employees/employee-list" }
    ]
  }
]

// Frontend MUST filter navigation by matching menu titles, NOT by permission strings
function filterNavigation(navItems, userMenus) {
  return navItems.filter(item => {
    // Check if this menu exists in user's permitted menus
    const permittedMenu = userMenus.find(m =>
      m.mainMenu.toLowerCase() === item.title.toLowerCase()
    );
    return !!permittedMenu;
  });
}
```

**Files Affected:**
- `modern/frontend/src/config/navigation.ts`
- `modern/frontend/src/components/layout/AppLayout.vue`
- `modern/frontend/src/stores/auth.store.ts`

---

### 2. API Endpoint Naming

**Issue:** API calls returning 404 errors.

**Root Cause:** Incorrect endpoint paths or missing route parameters.

**Correct Patterns:**

| Module | Correct Endpoint | Common Mistake |
|--------|------------------|----------------|
| Profile | `GET /UserProfile/GetPersonalDetailsById/{id}` | `/UserProfile/GetPersonalDetail` (missing Id) |
| Profile | `GET /UserProfile/GetPersonalProfileByIdAsync/{id}` | Using wrong endpoint |
| Employment | `GET /UserProfile/GetEmploymentDetail/{employeeId}` | Missing employeeId param |
| Roles | `GET /RolePermission/GetRolesList` | `/UserProfile/GetRoleIDList` (wrong controller) |

**Important:** Always verify endpoints in legacy backend controllers before implementing.

---

### 3. Holiday Calendar UI

**Issue:** Holiday calendar tile missing flag icons and modal.

**Correct Implementation:**
1. Use **SVG flag icons** (india.svg, american.svg), NOT emoji
2. Flag selector in **tile header** with View More arrow icon
3. Selected flag: `opacity: 1`, unselected: `opacity: 0.4`
4. View More button is `ArrowOutwardIcon` (mdi-arrow-top-right)
5. Modal uses `v-dialog` with `max-width="md"` and `fullWidth`

**Files Required:**
- `public/icons/india.svg`
- `public/icons/american.svg`
- `src/components/dashboard/HolidayCalendarTile.vue`

---

### 4. API Request/Response Patterns

**Request Properties (PascalCase for .NET):**
```typescript
// CORRECT
{ Email: "user@example.com", Password: "xxx" }
{ PageSize: 10, StartIndex: 1, Filters: {...} }

// WRONG
{ email: "user@example.com", password: "xxx" }
{ pageSize: 10, startIndex: 1, filters: {...} }
```

**Response Properties (camelCase):**
```typescript
// Backend returns camelCase in result
{ statusCode: 200, message: "Success", result: { employeeList: [...], totalRecords: 100 } }
```

**Pagination (1-based):**
```typescript
// First page
{ StartIndex: 1, PageSize: 10 }

// Second page
{ StartIndex: 2, PageSize: 10 }
```

---

### 5. Permission Format

**Backend Permission Format:** Dot notation stored in JWT
```
Read.Employees
Write.Employees
Read.CompanyPolicy
Read.Role
```

**Usage in Code:**
```typescript
// Check permission
authStore.hasPermission('Read.Employees')

// Get all permissions from modulePermissions in login response
userData.modulePermissions.modules.flatMap(m => m.permissions)
```

---

### 6. Authentication Headers

**Internal Login (Email/Password):**
```typescript
// MUST include X-API_KEY header
headers: { 'X-API_KEY': 'your-api-key' }
```

**SSO Login:**
```typescript
// Send MSAL token to /Auth endpoint
{ MsAuthToken: msalToken }
```

---

### 7. Dashboard Tile Styling

**Tile Structure (matching legacy):**
```css
.dashboard-tile {
  height: 250px;
  border: 1px solid #c7d9eb;
  border-radius: 15px;
  background: #F4FAFD;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.tile-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 15px;
  color: #1E75BB;
}

.flag-container {
  display: flex;
  gap: 5px;
}

.flag-icon {
  width: 30px;
  height: auto;
  cursor: pointer;
  opacity: 0.4;
  transition: opacity 0.3s;
}

.flag-icon.selected {
  opacity: 1;
}
```

---

### 8. Date Handling for .NET

**DateOnly Fields:**
```typescript
// Send null, NOT empty string
{ from: null, to: null }  // CORRECT
{ from: "", to: "" }       // WRONG - causes validation error
```

**Date Format:**
```typescript
// ISO format for dates
"2026-01-25"
```

---

### 9. File Exports

**Excel Export Pattern:**
```typescript
const response = await httpClient.post('/endpoint/export', data, {
  responseType: 'blob'  // IMPORTANT for file downloads
});
```

---

### 10. Constants vs API Calls

Some dropdowns use **hardcoded constants** instead of API calls:

| Dropdown | Source |
|----------|--------|
| Branch/Location | Constants (NOIDA, JAIPUR, US, REMOTE, etc.) |
| Employee Status | Constants (ACTIVE, INACTIVE, EXITED, etc.) |
| Country | API: `/UserProfile/GetCountryList` |
| Department | API: `/UserProfile/GetDepartmentList` OR `/Employee/GetDepartmentList` |

---

## Checklist Before Implementing Any Feature

- [ ] Read this KNOWN_ISSUES_AND_PATTERNS.md file
- [ ] Verify API endpoints in legacy backend controllers
- [ ] Check if navigation uses menus array filtering
- [ ] Use PascalCase for request bodies to .NET
- [ ] Handle null vs empty string for optional date fields
- [ ] Use correct permission format (Read.Module, Write.Module)
- [ ] Match legacy UI exactly (dimensions, colors, spacing)
- [ ] Test with actual .NET backend, not mocks

---

## Files to Always Check

1. **Legacy Backend Controllers:** `legacy/Backend/HRMSWebApi/HRMS.API/Controllers/`
2. **Legacy Frontend Services:** `legacy/Frontend/HRMS-Frontend/source/src/api/`
3. **Legacy UI Components:** `legacy/Frontend/HRMS-Frontend/source/src/pages/`
4. **This File:** `migration/KNOWN_ISSUES_AND_PATTERNS.md`

---

## Issue Log

| Date | Issue | Root Cause | Fix |
|------|-------|------------|-----|
| 2026-01-25 | Navigation not showing | Wrong permission filtering | Use menus array from login |
| 2026-01-25 | Profile 404 error | Wrong endpoint path | Use GetPersonalDetailsById/{id} |
| 2026-01-25 | Holiday flags missing | Used emoji instead of SVG | Add SVG icons, fix component |
| 2026-01-25 | DateOnly validation error | Sent "" instead of null | Send null for empty dates |
| 2026-01-25 | Export not working | Wrong endpoint path | Use /Employee/export |
| 2026-01-25 | Role list 404 | Wrong controller | Use /RolePermission/GetRolesList |

---

**Last Updated:** 2026-01-26
