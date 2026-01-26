# Permission System Analysis

**Date:** 2026-01-27
**Comparison:** Legacy React vs Modern Vue.js
**Status:** CRITICAL GAPS IDENTIFIED

---

## Executive Summary

**CRITICAL FINDING:** Modern Vue.js app has **incorrect permission format** causing permission checks to fail. Legacy uses `"Read.Role"` format while modern checks for `"ROLE.READ"` format.

**Impact:**
- Users can access UI elements without proper permissions
- Routes may be accessible without authorization
- API calls may be made without permission validation
- Security vulnerability in production

---

## 1. Legacy Permission System (React.js)

### 1.1 Permission Storage Structure

**Store:** `useModulePermissionsStore` (Zustand)
```typescript
type Permission = {
  permissionId: number;
  permissionName: string;
  isActive: boolean;
  permissionValue: string;  // e.g., "Read.Role", "Edit.PersonalDetails"
};

type Module = {
  moduleId: number;
  moduleName: string;
  isActive: boolean;
  permissions: Permission[];
};
```

**Storage:** `localStorage` key `"module-permissions"` via Zustand persist

### 1.2 Permission Value Format

**Constants:** `src/utils/constants.ts` - `permissionValue` object
```typescript
permissionValue = {
  ROLE: {
    READ: "Read.Role",
    VIEW: "View.Role",
    CREATE: "Create.Role",
    EDIT: "Edit.Role",
    DELETE: "Delete.Role",
  },
  PERSONAL_DETAILS: {
    READ: "Read.PersonalDetails",
    VIEW: "View.PersonalDetails",
    CREATE: "Create.PersonalDetails",
    EDIT: "Edit.PersonalDetails",
    DELETE: "Delete.PersonalDetails",
  },
  // ... 30+ more modules
}
```

**Format Pattern:** `"{Action}.{ModuleName}"`
- Action: Read, View, Create, Edit, Delete
- ModuleName: CamelCase (Role, PersonalDetails, EmploymentDetails, etc.)

### 1.3 Permission Check Implementation

**Function:** `src/utils/hasPermission.ts`
```typescript
export const hasPermission = (permissionValue: string): boolean => {
  const modules = useModulePermissionsStore.getState().modules;

  if (!modules.length) {
    return false;
  }

  return modules.some((module) =>
    module.permissions.some(
      (permission) =>
        permission.permissionValue === permissionValue && permission.isActive
    )
  );
};
```

**Check Logic:**
1. Retrieve modules from Zustand store
2. Iterate through all modules
3. Find permission where `permissionValue` matches exactly AND `isActive === true`
4. Return `true` if found, `false` otherwise

### 1.4 Permission Loading Flow

**Login → Store Permissions:**
```typescript
// UserLogin.tsx (line 74-76)
if (result.modulePermissions.modules) {
  setModulePermissions(result.modulePermissions.modules);
}
```

**Token Refresh → Update Permissions:**
```typescript
// httpInstance.ts (line 129-131)
if (result.modulePermissions.modules) {
  setModulePermissions(result.modulePermissions.modules);
}
```

**API Response Structure:**
```json
{
  "statusCode": 200,
  "message": "Success",
  "result": {
    "authToken": "...",
    "modulePermissions": {
      "modules": [
        {
          "moduleId": 1,
          "moduleName": "Role",
          "isActive": true,
          "permissions": [
            {
              "permissionId": 1,
              "permissionName": "Read Role",
              "isActive": true,
              "permissionValue": "Read.Role"
            }
          ]
        }
      ]
    }
  }
}
```

### 1.5 Usage Examples

**Route Protection:**
```typescript
// ProtectedRoute.tsx
<ProtectedRoute requiredPermission="Read.Role">
  <RolesPage />
</ProtectedRoute>
```

**Conditional UI Rendering:**
```typescript
// Roles/index.tsx (line 149)
{hasPermission(CREATE) && (
  <RoundActionIconButton onClick={() => navigate("/roles/add")} />
)}
```

**Dynamic Table Columns:**
```typescript
// Roles/index.tsx (line 90-115)
...(hasPermission(EDIT)
  ? [{ label: "Actions", accessor: "actions", ... }]
  : [])
```

**Dashboard Tiles:**
```typescript
// Dashboard/index.tsx (line 219-220)
{
  title: "Company Policy Document",
  isShow: hasPermission(COMPANY_POLICY.READ),  // "Read.CompanyPolicy"
}
```

---

## 2. Modern Permission System (Vue.js)

### 2.1 Permission Storage Structure

**Store:** `useAuthStore` (Pinia)
```typescript
export interface User {
  id: string;
  email: string;
  fullName: string;
  permissions: string[];  // Flattened array of permission values
}
```

**Extraction Logic:**
```typescript
// auth.store.ts (line 88-96)
function mapUserDataToUser(userData: UserData): User {
  const permissions: string[] = [];
  if (userData.modulePermissions?.modules) {
    for (const module of userData.modulePermissions.modules) {
      permissions.push(...module.permissions);
    }
  }
  return { ...user, permissions };
}
```

**Storage:** `localStorage` key `"userData"` with flattened permissions array

### 2.2 Permission Check Implementation

**Function:** `auth.store.ts` (line 261-263)
```typescript
function hasPermission(permission: string): boolean {
  return userPermissions.value.includes(permission);
}
```

**Check Logic:**
1. Get flattened permissions array from user state
2. Use array `.includes()` for exact string match
3. Return boolean result

### 2.3 Usage Examples

**Roles List View:**
```typescript
// RolesListView.vue (line 25-26)
const hasEditPermission = authStore.hasPermission('ROLE.EDIT');     // WRONG FORMAT!
const hasCreatePermission = authStore.hasPermission('ROLE.CREATE'); // WRONG FORMAT!
```

**Dashboard View:**
```typescript
// DashboardView.vue (line 70-76)
const hasAttendancePermission = computed(() =>
  authStore.hasPermission('Read.Attendance')  // CORRECT FORMAT
);
const hasCompanyPolicyPermission = computed(() =>
  authStore.hasPermission('Read.CompanyPolicy')  // CORRECT FORMAT
);
```

**Events List View:**
```typescript
// EventsListView.vue (line 27-30)
const hasReadPermission = computed(() => authStore.hasPermission('Read.Events'));
const hasCreatePermission = computed(() => authStore.hasPermission('Create.Events'));
const hasEditPermission = computed(() => authStore.hasPermission('Edit.Events'));
const hasDeletePermission = computed(() => authStore.hasPermission('Delete.Events'));
```

---

## 3. Critical Gaps Identified

### 3.1 CRITICAL: Inconsistent Permission Format

**Issue:** Modern app uses **two different formats** for permission checks:

1. **WRONG Format:** `"ROLE.READ"`, `"ROLE.CREATE"`, `"ROLE.EDIT"`
   - Used in: `RolesListView.vue`
   - Pattern: `"{MODULE_UPPERCASE}.{ACTION_UPPERCASE}"`

2. **CORRECT Format:** `"Read.Events"`, `"Create.CompanyPolicy"`, `"Edit.EmploymentDetails"`
   - Used in: `EventsListView.vue`, `DashboardView.vue`, most other views
   - Pattern: `"{Action}.{ModuleName}"` (matches legacy)

**Backend Reality:** .NET API returns permissions in format `"Read.Role"`, not `"ROLE.READ"`

**Impact:**
```typescript
// Backend returns:
permissions: ["Read.Role", "Edit.Role", "Create.Role"]

// Modern app checks:
hasEditPermission = authStore.hasPermission('ROLE.EDIT');  // ALWAYS FALSE!

// Result: User with Edit.Role permission CANNOT edit roles
```

**Affected Files:**
- `modern/frontend/src/views/roles/RolesListView.vue` (line 25-26)

### 3.2 Missing Permission Constants

**Legacy:** Centralized constants in `utils/constants.ts`
```typescript
import { permissionValue } from '@/utils/constants';
const { EDIT, CREATE } = permissionValue.ROLE;
```

**Modern:** Hardcoded strings everywhere
```typescript
authStore.hasPermission('Read.Events')  // Magic string, typo-prone
```

**Risk:**
- Typos in permission strings go undetected at compile time
- Inconsistent permission values across components
- Difficult to refactor if permission format changes
- No single source of truth

### 3.3 Permission Context Not Preserved

**Legacy:** Stores full module structure with `isActive` flag
```typescript
{
  moduleId: 1,
  moduleName: "Role",
  permissions: [
    { permissionId: 1, permissionValue: "Read.Role", isActive: true }
  ]
}
```

**Modern:** Flattens to string array, loses context
```typescript
permissions: ["Read.Role", "Edit.Role"]
```

**Lost Information:**
- Module grouping (which permissions belong to which module)
- Permission metadata (permissionId, permissionName)
- `isActive` status (though currently unused in checks)

**Potential Future Impact:** If backend adds permission metadata (e.g., expiry, conditional flags), modern app cannot consume it.

### 3.4 No Defensive Permission Checking

**Legacy:** Returns `false` if modules array is empty
```typescript
if (!modules.length) {
  return false;
}
```

**Modern:** Assumes permissions array exists
```typescript
return userPermissions.value.includes(permission);
// If userPermissions.value is undefined, crashes!
```

**Risk:** Potential runtime errors if permissions not loaded

### 3.5 Missing Route-Level Permission Guards

**Legacy:** Uses `ProtectedRoute` component
```typescript
<ProtectedRoute requiredPermission="Read.Role">
  <RolesPage />
</ProtectedRoute>
```

**Modern:** No equivalent found in analysis

**Risk:**
- Users can navigate directly to routes via URL without permission
- Permission checks only at component level (UI elements)
- Navigation guards may not enforce permissions

### 3.6 Permission Check Timing Issues

**Legacy:** Permissions loaded synchronously during login, stored in separate Zustand store with persistence

**Modern:** Permissions extracted during login and stored in user object

**Potential Race Condition:**
```typescript
// If component mounts before login completes:
const hasPermission = authStore.hasPermission('Read.Events');
// permissions array might be empty [], returns false incorrectly
```

**Missing:** Loading state or skeleton UI while permissions load

---

## 4. Security Implications

### 4.1 Authorization Bypass Risk

**Scenario:**
1. User logs in with limited permissions
2. Modern app checks `hasPermission('ROLE.EDIT')` (wrong format)
3. Backend returns `["Read.Role"]` (correct format)
4. Permission check returns `false` (correctly denies access)
5. User manually changes check to `hasPermission('Edit.Role')`
6. **If user HAD this permission**, UI would show edit buttons

**Current State:** No authorization bypass because wrong format FAILS checks (false negatives, not false positives)

**But:** If developer "fixes" by mapping to wrong format, creates vulnerabilities

### 4.2 Client-Side Only Validation

**Both Legacy and Modern:** Permissions only checked in frontend

**Missing:**
- Backend API permission validation (assumed present in .NET backend)
- Frontend cannot verify backend enforces same permissions
- No documentation of backend permission middleware

**Best Practice:** Backend MUST validate permissions on every API call, frontend checks are UX only

---

## 5. Recommendations

### 5.1 IMMEDIATE FIX (Critical)

**Fix incorrect permission format in `RolesListView.vue`:**
```typescript
// BEFORE (WRONG):
const hasEditPermission = authStore.hasPermission('ROLE.EDIT');
const hasCreatePermission = authStore.hasPermission('ROLE.CREATE');

// AFTER (CORRECT):
const hasEditPermission = authStore.hasPermission('Edit.Role');
const hasCreatePermission = authStore.hasPermission('Create.Role');
```

### 5.2 HIGH PRIORITY

1. **Create permission constants file:**
   ```typescript
   // modern/frontend/src/utils/permissions.ts
   export const PERMISSIONS = {
     ROLE: {
       READ: 'Read.Role',
       VIEW: 'View.Role',
       CREATE: 'Create.Role',
       EDIT: 'Edit.Role',
       DELETE: 'Delete.Role',
     },
     // ... mirror legacy constants.ts structure
   } as const;
   ```

2. **Implement route-level guards:**
   ```typescript
   // modern/frontend/src/router/guards.ts
   router.beforeEach((to, from, next) => {
     const requiredPermission = to.meta.permission;
     if (requiredPermission && !authStore.hasPermission(requiredPermission)) {
       next({ name: 'Unauthorized' });
     } else {
       next();
     }
   });
   ```

3. **Add defensive checks in `hasPermission()`:**
   ```typescript
   function hasPermission(permission: string): boolean {
     if (!user.value || !user.value.permissions) {
       return false;
     }
     return userPermissions.value.includes(permission);
   }
   ```

### 5.3 MEDIUM PRIORITY

1. **Audit all permission checks:**
   - Search codebase for `hasPermission` calls
   - Verify each uses correct format `"{Action}.{ModuleName}"`
   - Replace magic strings with constants

2. **Add TypeScript type safety:**
   ```typescript
   type PermissionValue = typeof PERMISSIONS[keyof typeof PERMISSIONS][keyof typeof PERMISSIONS[keyof typeof PERMISSIONS]];

   function hasPermission(permission: PermissionValue): boolean {
     // Now typos caught at compile time!
   }
   ```

3. **Document permission system:**
   - Create `/migration/docs/permission-system.md`
   - List all permissions with descriptions
   - Document expected backend response format
   - Add examples of correct usage

### 5.4 FUTURE ENHANCEMENTS

1. **Permission testing utilities:**
   ```typescript
   // modern/frontend/src/utils/test-helpers.ts
   export function createMockAuthStore(permissions: string[]) {
     return {
       user: { permissions },
       hasPermission: (p: string) => permissions.includes(p),
     };
   }
   ```

2. **Permission debugging:**
   ```typescript
   function hasPermission(permission: string): boolean {
     const result = userPermissions.value.includes(permission);
     if (import.meta.env.DEV && !result) {
       console.warn(
         `Permission denied: "${permission}". User has:`,
         userPermissions.value
       );
     }
     return result;
   }
   ```

3. **Consider keeping module structure:**
   - Instead of flattening to array, store full module structure
   - Benefits: Easier debugging, supports future metadata
   - Drawback: Slightly more complex permission checks

---

## 6. Test Cases

### 6.1 Permission Check Tests

```typescript
describe('hasPermission', () => {
  it('should return true for granted permission', () => {
    authStore.user = { permissions: ['Read.Role', 'Edit.Role'] };
    expect(authStore.hasPermission('Edit.Role')).toBe(true);
  });

  it('should return false for denied permission', () => {
    authStore.user = { permissions: ['Read.Role'] };
    expect(authStore.hasPermission('Edit.Role')).toBe(false);
  });

  it('should be case-sensitive', () => {
    authStore.user = { permissions: ['Read.Role'] };
    expect(authStore.hasPermission('read.role')).toBe(false);
    expect(authStore.hasPermission('Read.role')).toBe(false);
  });

  it('should handle empty permissions', () => {
    authStore.user = { permissions: [] };
    expect(authStore.hasPermission('Read.Role')).toBe(false);
  });

  it('should handle null user', () => {
    authStore.user = null;
    expect(authStore.hasPermission('Read.Role')).toBe(false);
  });
});
```

### 6.2 Integration Tests

```typescript
describe('RolesListView permissions', () => {
  it('should show edit button when user has Edit.Role permission', async () => {
    const wrapper = mount(RolesListView, {
      global: {
        plugins: [createTestingPinia({
          initialState: {
            auth: {
              user: { permissions: ['Read.Role', 'Edit.Role'] }
            }
          }
        })]
      }
    });

    await wrapper.vm.$nextTick();
    expect(wrapper.find('[data-test="edit-button"]').exists()).toBe(true);
  });

  it('should hide edit button when user lacks Edit.Role permission', async () => {
    const wrapper = mount(RolesListView, {
      global: {
        plugins: [createTestingPinia({
          initialState: {
            auth: {
              user: { permissions: ['Read.Role'] }
            }
          }
        })]
      }
    });

    await wrapper.vm.$nextTick();
    expect(wrapper.find('[data-test="edit-button"]').exists()).toBe(false);
  });
});
```

---

## 7. Comparison Matrix

| Feature | Legacy (React) | Modern (Vue) | Status |
|---------|----------------|--------------|--------|
| **Permission Format** | `"Read.Role"` | `"Read.Role"` AND `"ROLE.READ"` (mixed!) | ❌ BROKEN |
| **Permission Storage** | Separate Zustand store with modules | Flattened array in user object | ⚠️ DIFFERENT |
| **Permission Constants** | Centralized in `constants.ts` | Hardcoded strings | ❌ MISSING |
| **Type Safety** | None (TypeScript not enforced) | None | ⚠️ MISSING |
| **Route Guards** | `ProtectedRoute` component | Unknown | ⚠️ UNCLEAR |
| **Defensive Checks** | Empty array check | No null/undefined check | ⚠️ RISKY |
| **Permission Metadata** | Full module structure | Only permission values | ⚠️ LOST |
| **Persistence** | Zustand persist middleware | localStorage manual | ✅ EQUIVALENT |
| **Token Refresh** | Updates permissions | No refresh implementation visible | ❌ MISSING? |
| **Check Performance** | O(n*m) nested loop | O(n) array includes | ✅ BETTER |

---

## 8. Action Items

**CRITICAL (Fix Today):**
- [ ] Fix `RolesListView.vue` permission format (`ROLE.EDIT` → `Edit.Role`)
- [ ] Audit all `.vue` files for wrong permission format pattern
- [ ] Test roles page with different permission sets

**HIGH (Fix This Week):**
- [ ] Create `permissions.ts` constants file (mirror legacy)
- [ ] Replace all magic strings with constants
- [ ] Add defensive null checks to `hasPermission()`
- [ ] Document permission system in `/migration/docs/`

**MEDIUM (Next Sprint):**
- [ ] Implement route-level permission guards
- [ ] Add TypeScript strict typing for permissions
- [ ] Write unit tests for permission checks
- [ ] Add integration tests for permission-gated features

**FUTURE:**
- [ ] Add permission debugging in dev mode
- [ ] Create permission testing utilities
- [ ] Consider reverting to full module structure storage
- [ ] Implement permission refresh on token refresh

---

## 9. Conclusion

**The modern Vue.js app has a critical permission format mismatch in `RolesListView.vue` that prevents users from editing roles even when they have the correct permission.** This is a **false negative** (denying access when it should be granted), not a security vulnerability, but it blocks functionality.

The permission system is otherwise functional but lacks:
1. Centralized permission constants (maintainability risk)
2. Route-level guards (security risk)
3. Type safety (developer experience risk)

**Immediate action required** to fix permission format and establish permission constants before migrating more features.

---

**Report Generated:** 2026-01-27
**Analyst:** Claude Code
**Next Review:** After implementing fixes
