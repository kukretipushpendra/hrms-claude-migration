# Legacy React.js HRMS - Initialization & Authentication Flow Analysis

## Executive Summary

The legacy HRMS application uses a sophisticated initialization flow with Azure MSAL SSO authentication, feature flags, module permissions, and multiple data fetching stages. All API calls go through an Axios instance with JWT token refresh interceptors.

---

## 1. Application Entry Point

### main.tsx - Root Initialization

**File:** `legacy/Frontend/HRMS-Frontend/source/src/main.tsx`

**Providers Hierarchy:**
```
ErrorBoundary
  └── ToastContainer (React Toastify)
      └── ThemeCustomization (Material-UI Theme)
          └── MsalProvider (Azure MSAL Authentication)
              └── ScrollTop
                  └── FeatureFlagProvider
                      └── CustomRoute (React Router)
```

**Key Initialization Steps:**
1. **MSAL Setup**: Azure AD authentication client initialized with config
2. **Feature Flag Provider**: Fetches feature flags from remote endpoint on mount
3. **Router Initialization**: React Router with routes defined in `routes.tsx`

---

## 2. Feature Flags - First API Call

### FeatureFlagProvider Initialization

**File:** `legacy/Frontend/HRMS-Frontend/source/src/contexts/FeatureFlagProvider.tsx`

**API Call #1 - Feature Flags:**
```typescript
// Called on app mount via useAsync with autoExecute: true
GET FEATURE_FLAGS_URL (from constants)

Response Format:
{
  flags: {
    enableExitEmployee: boolean,
    enableAttendance: boolean,
    enableLeave: boolean,
    enableITAsset: boolean,
    enableKPI: boolean,
    enableGrievance: boolean,
    // ... other feature flags
  },
  version: string
}
```

**Storage:**
- Stored in Zustand store: `useFeatureFlagStore`
- Persisted to localStorage key: from `FEATURE_FLAG_STORAGE_KEY` constant
- Version checked to prevent stale cache

**Purpose:**
- Controls visibility of menu items
- Controls access to feature-specific routes
- Enables/disables feature-specific dashboard widgets

---

## 3. Authentication Flow

### Login Methods

The app supports TWO login methods:

#### A. SSO Login (Primary)

**File:** `legacy/Frontend/HRMS-Frontend/source/src/pages/Login/auth-forms/SSOLogin.tsx`

**Flow:**
1. User clicks "Sign In with Microsoft" button
2. Azure MSAL popup appears
3. User authenticates via Microsoft 365
4. MSAL returns `idToken` and `accessToken`

**API Call #2 - SSO Authentication:**
```typescript
POST /Auth
Headers: {
  Authorization: Bearer <token>
}
Body: {
  msAuthToken: string  // Azure access token
}

Response:
{
  statusCode: 200,
  message: string,
  result: {
    authToken: string,           // JWT token for API calls
    refreshToken: string,
    firstName: string,
    lastName: string,
    roleId: string,
    roleName: string,
    userEmail: string,
    userId: string,
    userName: string,
    menus: [                     // User's permitted menus
      {
        mainMenu: string,
        mainMenuApiEndPoint: string,
        subMenus: [
          {
            subMenu: string,
            subMenuApiEndPoint: string
          }
        ]
      }
    ],
    modulePermissions: {
      modules: [
        {
          moduleId: number,
          moduleName: string,
          isActive: boolean,
          permissions: [
            {
              permissionId: number,
              permissionName: string,
              isActive: boolean,
              permissionValue: string  // e.g., "ROLE.READ"
            }
          ]
        }
      ]
    }
  }
}
```

**State Updates After Login:**
1. **useUserStore (Zustand):**
   - `isLoggedIn: true`
   - `isInternalUser: false`
   - `idToken: <msal_id_token>`
   - `accessToken: <msal_access_token>`
   - `userData: { ...result }`
   - Persisted to localStorage key: `"userToken"`

2. **useModulePermissionsStore (Zustand):**
   - `modules: result.modulePermissions.modules`
   - Persisted to localStorage key: `"module-permissions"`

3. **Navigation:**
   - Redirects to `/dashboard`

#### B. Internal User Login (Alternative)

**File:** `legacy/Frontend/HRMS-Frontend/source/src/pages/Login/auth-forms/UserLogin.tsx`

**API Call #2B - Internal User Authentication:**
```typescript
POST /Auth/Login
Headers: {
  X-API_KEY: "X3nvZJ7pQe5tKuL9Bd1aH8yWOm4Cx6Tf"
}
Body: {
  email: string,
  password: string
}

Response: Same as SSO login
```

**State Updates:** Same as SSO login, except `isInternalUser: true`

---

## 4. Post-Login Initialization

### App.tsx - Layout Decision

**File:** `legacy/Frontend/HRMS-Frontend/source/src/App.tsx`

```typescript
if (isLoggedIn) {
  return <ResponsiveDrawer><Outlet /></ResponsiveDrawer>
} else {
  return <Outlet />
}
```

### DashboardLayout - Menu Master

**File:** `legacy/Frontend/HRMS-Frontend/source/src/layout/Dashboard/index.tsx`

**On Mount:**
1. Calls `useGetMenuMaster()` hook
2. Shows `<Loader />` while `menuMasterLoading` is true
3. Redirects unauthenticated users to `/`
4. Redirects authenticated users on `/` to `/dashboard`

**Note:** `useGetMenuMaster()` uses SWR but returns static initial state (no actual API call):
```typescript
// File: legacy/Frontend/HRMS-Frontend/source/src/api/menu.ts
const initialState = {
  openedItem: "dashboard",
  openedComponent: "buttons",
  openedHorizontalItem: null,
  isDashboardDrawerOpened: false,
  isComponentDrawerOpened: true,
}
```

### Navigation Menu Rendering

**File:** `legacy/Frontend/HRMS-Frontend/source/src/layout/Dashboard/Drawer/DrawerContent/Navigation/index.tsx`

**Menu Filtering:**
1. Reads `userData.menus` from Zustand store (returned by login API)
2. Filters menu items based on:
   - User's permitted menus (from login response)
   - User's role (`userData.roleName`)
   - Feature flags (from `useFeatureFlagStore`)
3. Renders filtered navigation menu

**No Additional API Calls** - Uses data from login response

---

## 5. Dashboard Page Load

### Dashboard Component

**File:** `legacy/Frontend/HRMS-Frontend/source/src/pages/Dashboard/index.tsx`

**API Calls on Dashboard Load:**

Uses custom hook `useDashboardData` which triggers multiple API calls based on permissions.

### API Call #3 - Employee Count

```typescript
POST /Dashboard/GetEmployeesCount
Body: {
  from: string,  // YYYY-MM-DD
  to: string,    // YYYY-MM-DD
  days: number   // Default: current date - 7 days
}

Response:
{
  statusCode: 200,
  message: string,
  modelErrors: [],
  result: {
    activeEmployeeCount: number,
    newEmployeeCount: number,
    exitOrgEmployeeCount: number
  }
}
```

**Conditions:**
- Only called if user has permission: `EMPLOYMENT_DETAILS.READ`
- Triggered by date range change

### API Call #4 - Birthday List

```typescript
GET /Dashboard/GetBirthdayList

Response:
{
  statusCode: 200,
  message: string,
  modelErrors: [],
  result: [
    {
      id: number,
      firstName: string,
      middleName: string,
      lastName: string,
      profileImagePath: string,
      dob: string
    }
  ]
}
```

**Conditions:**
- Always called on dashboard mount

### API Call #5 - Work Anniversary List

```typescript
GET /Dashboard/GetWorkAnniversaryList

Response:
{
  statusCode: 200,
  message: string,
  modelErrors: [],
  result: [
    {
      id: number,
      firstName: string,
      middleName: string,
      lastName: string,
      joiningDate: string,
      profilePicPath: string
    }
  ]
}
```

**Conditions:**
- Always called on dashboard mount

### API Call #6 - Holiday List

```typescript
GET /Dashboard/GetHolidayList

Response:
{
  statusCode: 200,
  message: string,
  modelErrors: [],
  result: {
    india: [
      {
        date: string,
        day: string,
        location: string,
        title: string
      }
    ],
    usa: [...]
  }
}
```

**Conditions:**
- Always called on dashboard mount

### API Call #7 - Upcoming Holiday List

```typescript
GET /Dashboard/GetUpcomingHolidayList

Response: Same format as GetHolidayList
```

**Conditions:**
- Always called on dashboard mount

### API Call #8 - Upcoming Events

```typescript
GET /Dashboard/GetUpcomingEvents

Response:
{
  statusCode: 200,
  message: string,
  result: [
    {
      id: number,
      eventName: string,
      bannerFileName: string,
      startDate: string,
      status: string,
      venue: string
    }
  ]
}
```

**Conditions:**
- Only called if user has permission: `EVENTS.READ`

### API Call #9 - Published Company Policies

```typescript
POST /Dashboard/GetPublishedCompanyPolicies
Body: {
  from: string,  // YYYY-MM-DD
  to: string,    // YYYY-MM-DD
  days: number   // Default: 0
}

Response:
{
  statusCode: 200,
  message: string,
  result: [
    {
      id: number,
      name: string,
      updatedOn: string
    }
  ]
}
```

**Conditions:**
- Only called if user has permission: `COMPANY_POLICY.READ`
- Triggered by date range change

---

## 6. HTTP Client Configuration

### Axios Instance Setup

**File:** `legacy/Frontend/HRMS-Frontend/source/src/api/httpInstance.ts`

**Base Configuration:**
```typescript
const httpInstance = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL
});
```

**Request Interceptor:**
```typescript
// Adds to every request:
Headers: {
  Authorization: "Bearer <authToken>",
  Build-Version: "<buildVersion>"  // From localStorage
}

// Token source priority:
1. localStorage.getItem("paramToken")
2. localStorage.getItem("token")
3. JSON.parse(localStorage.getItem("userToken")).state.userData.authToken
```

**Response Interceptor - Token Refresh:**

When receiving `401 Unauthorized`:
1. Checks if already refreshing (prevents duplicate refresh calls)
2. Queues failed requests
3. Calls token refresh endpoint
4. Updates Zustand store with new tokens and permissions
5. Retries all queued requests with new token
6. If refresh fails, logs out user

**API Call (On 401) - Token Refresh:**
```typescript
POST /RefreshToken
Body: {
  accessToken: string,
  refreshToken: string
}

Response: Same format as login response
```

**Response Interceptor - Build Version Check:**

When receiving build version error:
1. Extracts new `buildVersion` from response
2. Updates `useAppUpdateStore`
3. Shows update dialog to user

---

## 7. Protected Route Handling

### ProtectedRoute Component

**File:** `legacy/Frontend/HRMS-Frontend/source/src/ProtectedRoute.tsx`

**Protection Logic:**
1. Checks `isLoggedIn` from Zustand
2. If not logged in → Redirect to `/`
3. If logged in:
   - Checks permission using `hasPermission(requiredPermission)`
   - Checks role (if `requiredRoles` specified)
   - If authorized → Render children
   - If not authorized → Redirect to `/unauthorized`

**Permission Check:**
- Uses `useModulePermissionsStore` (populated during login)
- Checks if user has specific permission value (e.g., `"ROLE.READ"`)

---

## 8. Complete API Call Sequence

### On App Load (Unauthenticated):

1. **GET** Feature Flags URL → `useFeatureFlagStore`

### On Login (SSO):

2. **POST** `/Auth` → `useUserStore` + `useModulePermissionsStore`

### On Dashboard Load (After Login):

3. **POST** `/Dashboard/GetEmployeesCount` (if has permission)
4. **GET** `/Dashboard/GetBirthdayList`
5. **GET** `/Dashboard/GetWorkAnniversaryList`
6. **GET** `/Dashboard/GetHolidayList`
7. **GET** `/Dashboard/GetUpcomingHolidayList`
8. **GET** `/Dashboard/GetUpcomingEvents` (if has permission)
9. **POST** `/Dashboard/GetPublishedCompanyPolicies` (if has permission)

### On Token Expiry:

10. **POST** `/RefreshToken` → Updates `useUserStore` + `useModulePermissionsStore`

---

## 9. State Management Summary

### Zustand Stores (Persisted to localStorage):

#### useUserStore
**localStorage key:** `"userToken"`
```typescript
{
  isLoggedIn: boolean,
  isInternalUser: boolean,
  idToken: string,           // MSAL token
  accessToken: string,       // MSAL token
  userData: {
    authToken: string,       // API JWT token
    refreshToken: string,
    firstName: string,
    lastName: string,
    roleId: string,
    roleName: string,
    userEmail: string,
    userId: string,
    userName: string,
    menus: Menu[]            // Navigation permissions
  }
}
```

#### useModulePermissionsStore
**localStorage key:** `"module-permissions"`
```typescript
{
  modules: [
    {
      moduleId: number,
      moduleName: string,
      isActive: boolean,
      permissions: [
        {
          permissionId: number,
          permissionName: string,
          isActive: boolean,
          permissionValue: string
        }
      ]
    }
  ]
}
```

#### useFeatureFlagStore
**localStorage key:** `FEATURE_FLAG_STORAGE_KEY` (from constants)
```typescript
{
  flags: {
    enableExitEmployee: boolean,
    enableAttendance: boolean,
    enableLeave: boolean,
    enableITAsset: boolean,
    enableKPI: boolean,
    enableGrievance: boolean
  },
  version: string
}
```

#### useProfileStore
**NOT persisted**
```typescript
{
  profileData: {
    userName: string,
    profileImageUrl: string
  }
}
```

---

## 10. Environment Configuration

### API Base URL

**File:** `legacy/Frontend/HRMS-Frontend/source/src/api/config.ts`

```typescript
export const API_BASE_URL = import.meta.env.VITE_API_BASE_URL;
```

**Expected Environment Variable:**
```bash
VITE_API_BASE_URL=https://localhost:7001/api
```

---

## 11. Standard API Response Format

All API responses follow this structure:

```typescript
{
  statusCode: number,      // 200, 400, 401, etc.
  message: string,         // Success/error message
  modelErrors?: string[],  // Validation errors
  result: T | null         // Actual data
}
```

---

## 12. Critical Patterns for Migration

### Authentication Flow:
1. Feature flags fetched FIRST (before login)
2. Login returns BOTH auth tokens AND permissions/menus
3. Navigation menu built from login response (no separate menu API call)
4. Token refresh handled transparently by Axios interceptor

### Dashboard Initialization:
1. Multiple parallel API calls on load
2. Permission-based conditional rendering
3. Date range drives some API calls (employee count, policies)
4. Feature flags control widget visibility

### State Persistence:
1. All auth state persisted to localStorage via Zustand
2. Feature flags versioned to prevent stale cache
3. Build version tracked separately

### Route Protection:
1. Two-level protection: login status + permissions
2. Permission values checked against module permissions store
3. Role-based access for some routes

---

## 13. API Endpoints Summary Table

| Order | Endpoint | Method | When Called | Permission Required | Response Data |
|-------|----------|--------|-------------|---------------------|---------------|
| 1 | Feature Flags URL | GET | App mount | None | Feature flags config |
| 2 | `/Auth` | POST | SSO login | None | User + tokens + permissions + menus |
| 2B | `/Auth/Login` | POST | Internal login | X-API_KEY header | Same as above |
| 3 | `/Dashboard/GetEmployeesCount` | POST | Dashboard load | EMPLOYMENT_DETAILS.READ | Employee counts |
| 4 | `/Dashboard/GetBirthdayList` | GET | Dashboard load | None | Birthday list |
| 5 | `/Dashboard/GetWorkAnniversaryList` | GET | Dashboard load | None | Anniversary list |
| 6 | `/Dashboard/GetHolidayList` | GET | Dashboard load | None | Holiday calendar |
| 7 | `/Dashboard/GetUpcomingHolidayList` | GET | Dashboard load | None | Upcoming holidays |
| 8 | `/Dashboard/GetUpcomingEvents` | GET | Dashboard load | EVENTS.READ | Events list |
| 9 | `/Dashboard/GetPublishedCompanyPolicies` | POST | Dashboard load | COMPANY_POLICY.READ | Policy documents |
| 10 | `/RefreshToken` | POST | On 401 error | None | Refreshed user + tokens + permissions |

---

## 14. Key Findings for Vue.js Migration

### Critical Dependencies:
1. **Feature flags MUST be loaded before routing** - Controls route availability
2. **Login response contains navigation structure** - No separate menu API
3. **Permissions control both routes and API calls** - Need permission checking utility
4. **Token refresh is automatic** - Axios interceptor pattern required

### State Requirements:
1. **Persistent auth store** - Pinia with localStorage plugin
2. **Permission store** - Separate from auth for granular checks
3. **Feature flag store** - Version-controlled cache
4. **Profile store** - Session-only (no persistence)

### API Client Requirements:
1. **Request interceptor** - Add Authorization + Build-Version headers
2. **Response interceptor** - Handle 401 with token refresh queue
3. **Build version dialog** - Show update prompt on version mismatch
4. **Base URL from env** - `VITE_API_BASE_URL`

### Dashboard Complexity:
1. **9 potential API calls** - Some parallel, some conditional
2. **Permission-based rendering** - Check before fetch
3. **Feature flag integration** - Hide/show widgets
4. **Date range state** - Drives multiple API calls

---

## 15. Recommendations for Migration

1. **Implement auth first** - SSO + Internal login parity
2. **Create permission composable** - `usePermission()` for route guards
3. **Build Axios instance** - Token refresh + interceptors
4. **Feature flag provider** - Load before router init
5. **Dashboard as reference** - Most complex page, test all patterns
6. **Permission checking** - Replicate `hasPermission()` utility exactly

---

## End of Analysis

**Generated:** 2026-01-27
**Source:** Legacy React.js HRMS Application
**Purpose:** Vue.js Migration Reference
