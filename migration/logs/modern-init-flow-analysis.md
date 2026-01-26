# Modern Vue.js App - Initialization & Authentication Flow Analysis

**Date:** 2026-01-27
**Purpose:** Document API calls made on app init/login and identify differences from legacy React app

---

## Application Initialization Flow

### 1. App Entry (`main.ts`)

```typescript
// Creates Vue app with Pinia, Router, Vuetify
createApp(App)
  .use(pinia)
  .use(router)
  .use(vuetify)
  .mount('#app')
```

**No API calls made at this stage.**

---

### 2. App Component (`App.vue`)

```typescript
onMounted(async () => {
  if (authStore.accessToken && !authStore.user) {
    await authStore.loadUser();
  }
});
```

**Behavior:**
- Checks if `accessToken` exists in localStorage (persisted from previous session)
- If token exists but user data is NOT in memory, calls `authStore.loadUser()`

**API Calls:**
- **NONE** - `loadUser()` only reads from localStorage, does NOT call backend
- If localStorage has no `userData`, it forces logout (session invalid)

**Issue Identified:**
- Modern app does NOT re-validate token on page refresh
- Legacy React app likely does similar (Zustand persistence)

---

### 3. Router Navigation Guard (`router/index.ts`)

```typescript
router.beforeEach(async (to, from, next) => {
  // Update page title
  document.title = `${to.meta.title || 'HRMS'} | HRMS`;

  if (to.meta.requiresAuth) {
    if (!authStore.isAuthenticated) {
      // Try to load user from stored token
      if (authStore.accessToken) {
        await authStore.loadUser();
        if (authStore.isAuthenticated) {
          next();
          return;
        }
      }
      // Redirect to login
      next({ name: 'login', query: { redirect: to.fullPath } });
      return;
    }
  }

  // Redirect authenticated users away from login pages
  if ((to.name === 'login' || to.name === 'internal-login') && authStore.isAuthenticated) {
    next({ name: 'dashboard' });
    return;
  }

  next();
});
```

**API Calls:**
- **NONE** - Only checks localStorage

---

### 4. Layout Initialization (`AppLayout.vue`)

**Component loads on authenticated routes.**

**Data fetched:**
- **NONE** - No API calls
- Reads user data from auth store (already in memory)
- Filters navigation menu based on `user.menus` array (from login response)

**Navigation Filtering:**
- Uses `filterNavigation()` function from `config/navigation.ts`
- Filters nav items by comparing with `user.menus` array (from login response)
- Dashboard always shows
- Role-based items (Settings, Developer) checked against `user.roleName`

---

### 5. Dashboard Initialization (`DashboardView.vue`)

**On mount, fetches dashboard data:**

```typescript
onMounted(() => {
  fetchDashboardData();
});
```

**API Calls Made (in parallel):**

1. **`GET /Dashboard/GetBirthdayList`** - No permission required
2. **`GET /Dashboard/GetWorkAnniversaryList`** - No permission required
3. **`GET /Dashboard/GetUpcomingHolidayList`** - No permission required

**Then fetches permission-gated data:**

4. **`POST /Dashboard/GetEmployeesCount`** (if NOT employee role)
   - Body: `{ days: 30, from: null, to: null }`
   - Requires: `ReadEmploymentDetails` permission

5. **`GET /Dashboard/GetUpcomingEvents`** (if has `Read.Events` permission)

6. **`POST /Dashboard/GetPublishedCompanyPolicies`** (if has `Read.CompanyPolicy` permission)
   - Body: `{ days: 30, from: null, to: null }`

**Default Parameters:**
- `selectedDays = '30'` (Last 30 Days filter)

---

## Authentication Flow

### Login (Internal User)

**Endpoint:** `POST /Auth/Login`

**Request:**
```json
{
  "Email": "user@example.com",
  "Password": "password"
}
```

**Headers:**
```
X-API_KEY: X3nvZJ7pQe5tKuL9Bd1aH8yWOm4Cx6Tf
```

**Response:**
```json
{
  "statusCode": 200,
  "message": "Success",
  "result": {
    "authToken": "JWT_TOKEN",
    "refreshToken": "REFRESH_TOKEN",
    "firstName": "John",
    "lastName": "Doe",
    "roleId": "1",
    "roleName": "SUPER_ADMIN",
    "userEmail": "john@example.com",
    "userId": "123",
    "userName": "johndoe",
    "menus": [
      {
        "mainMenu": "Employees",
        "mainMenuApiEndPoint": "/employees",
        "subMenus": [
          {
            "subMenu": "Employees List",
            "subMenuApiEndPoint": "/employees/employee-list"
          }
        ]
      }
    ],
    "modulePermissions": {
      "modules": [
        {
          "moduleId": 1,
          "moduleName": "Employees",
          "permissions": ["Read.Employees", "Create.Employees", "Update.Employees"]
        }
      ]
    }
  }
}
```

**Stored in localStorage:**
- `accessToken` - JWT token
- `refreshToken` - Refresh token
- `isInternalUser` - `"true"`
- `userData` - Full user object (flattened with permissions array)

**Stored in Pinia:**
- `user` - Mapped user object
- `accessToken`
- `refreshToken`
- `isInternalUser`

---

### Login (SSO User)

**Endpoint:** `POST /Auth`

**Request:**
```json
{
  "MsAuthToken": "MSAL_TOKEN"
}
```

**No `X-API_KEY` header required.**

**Response:** Same as internal login

**Stored in localStorage:**
- Same as internal login but `isInternalUser = "false"`

---

### Token Refresh

**Endpoint:** `POST /Auth/RefreshToken`

**Request:**
```json
{
  "RefreshToken": "REFRESH_TOKEN"
}
```

**Response:** Same as login (new tokens)

**Triggered by:**
- NOT IMPLEMENTED - HTTP interceptor returns 401, clears tokens, redirects to login
- Legacy likely has similar behavior

**Missing:**
- Automatic token refresh on 401
- Refresh token rotation

---

### Logout

**Process:**
1. Clear Pinia state
2. Clear localStorage (`accessToken`, `refreshToken`, `isInternalUser`, `userData`)
3. Redirect to `/login`

**No API call to backend.**

---

## Comparison with Legacy React App

### Similarities

1. **State Management:**
   - Both use Zustand/Pinia with localStorage persistence
   - Both store full user data in localStorage to avoid re-fetching on refresh

2. **Navigation Filtering:**
   - Both filter nav menu based on `menus` array from login response
   - Both check role restrictions (e.g., SUPER_ADMIN for Settings)

3. **Dashboard Data Fetching:**
   - Both fetch same endpoints on dashboard load
   - Both fetch permission-gated data conditionally
   - Both default to 30 days filter

4. **No Token Re-validation:**
   - Neither app re-validates token on page refresh
   - Both rely on 401 response to trigger logout

5. **API Key for Internal Login:**
   - Both send `X-API_KEY` header for internal login endpoint

### Differences

#### Modern Vue.js App

**Missing:**
- No profile picture fetch on init
- No user profile endpoint call
- Simpler loadUser() - only reads localStorage

**Pros:**
- Cleaner separation of concerns
- Uses composition API (more maintainable)
- Better TypeScript types for API responses

#### Legacy React App

**Additional Features:**
- Custom date range picker for dashboard filter
- Employee Survey tile (commented out)
- Holiday calendar toggle (India/USA)
- More complex day filter logic

**State Management:**
- Separate stores for user, profile, module permissions
- More granular state updates

---

## API Calls Summary

### On App Init (page refresh with valid token):
- **NONE** - Reads from localStorage only

### On Login:
1. `POST /Auth/Login` or `POST /Auth`

### On Dashboard Load:
1. `GET /Dashboard/GetBirthdayList`
2. `GET /Dashboard/GetWorkAnniversaryList`
3. `GET /Dashboard/GetUpcomingHolidayList`
4. `POST /Dashboard/GetEmployeesCount` (conditional)
5. `GET /Dashboard/GetUpcomingEvents` (conditional)
6. `POST /Dashboard/GetPublishedCompanyPolicies` (conditional)

### On Token Expiry:
- **NONE** - 401 triggers logout and redirect to login

---

## Missing API Calls (vs Expected)

### Expected but NOT Called:

1. **`GET /User/Profile` or `/Employee/GetEmployeeById`**
   - Should fetch complete user profile on init
   - Currently relies only on login response data

2. **`POST /Auth/RefreshToken` (automatic)**
   - Should refresh token before expiry (proactive)
   - Currently only clears tokens on 401 (reactive)

3. **`GET /ModulePermissions` or similar**
   - Permissions come from login response
   - No separate permissions endpoint call

4. **`GET /Menu/GetUserMenus` or similar**
   - Menus come from login response
   - No separate menu endpoint call

---

## Potential Issues

### 1. No Token Re-validation on Refresh
**Impact:** If token expires while app is idle, user won't know until next API call
**Fix:** Add token expiry check and refresh on app init

### 2. No Automatic Token Refresh
**Impact:** User gets logged out unexpectedly when token expires
**Fix:** Implement refresh token rotation in HTTP interceptor

### 3. User Data Only from Login
**Impact:** If user data changes (role, permissions), requires re-login to see updates
**Fix:** Periodically refresh user data or on specific actions

### 4. No Profile Picture/Avatar Fetch
**Impact:** User initials shown instead of profile picture
**Status:** May be intentional (profile pictures in login response?)

### 5. localStorage-Only Session Recovery
**Impact:** If localStorage is tampered with, app may behave incorrectly
**Fix:** Validate token with backend on app init (optional health check)

---

## Recommendations

### High Priority

1. **Implement automatic token refresh**
   - Decode JWT expiry time
   - Refresh 5 minutes before expiry
   - Handle refresh failures gracefully

2. **Add token validation on app init**
   - Optional: `GET /Auth/Validate` or similar
   - Or accept current behavior (401 on first API call)

### Medium Priority

3. **Fetch user profile separately**
   - Add `GET /User/Profile` call after login
   - Update user data periodically (e.g., on focus)

4. **Add session timeout warning**
   - Show modal 5 minutes before token expires
   - Allow user to extend session or logout

### Low Priority

5. **Add profile picture support**
   - Check if profile picture URL is in login response
   - If not, add separate fetch endpoint

6. **Implement permission refresh**
   - Periodically check for permission changes
   - Or add websocket/SSE for real-time updates

---

## Conclusion

**Current State:**
- Modern Vue.js app successfully replicates legacy React authentication flow
- Dashboard API calls match legacy behavior
- Navigation filtering matches legacy logic
- No critical missing API calls for basic functionality

**Key Difference:**
- Modern app is simpler - relies heavily on login response data
- Legacy app may have more API calls (need to verify with network tab)
- Both apps have similar session management (no automatic refresh)

**Next Steps:**
1. Test login flow with real .NET backend
2. Verify dashboard API responses match expected format
3. Compare network tab of legacy vs modern on dashboard load
4. Document any additional API calls discovered during testing

---

**Analysis Complete.**
