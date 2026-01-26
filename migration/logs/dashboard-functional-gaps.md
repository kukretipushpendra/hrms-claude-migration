# Dashboard Functional Gaps Analysis

**Generated:** 2026-01-27
**Comparison:** Legacy React Dashboard vs. Modern Vue Dashboard

---

## CRITICAL GAPS - Date Filter Functionality

### 1. Missing "Custom Date Range" Option

**Legacy Behavior:**
- Date filter dropdown includes 4 options:
  - "Past 7 Days" (value: 7)
  - "Past 15 Days" (value: 15)
  - "Past 30 Days" (value: 30)
  - "Custom" (value: -1) ← **MISSING IN MODERN**

**Modern Behavior:**
- Only has 3 options:
  - "Last 7 Days" (value: '7')
  - "Last 30 Days" (value: '30')
  - "Last 90 Days" (value: '90')

**Impact:** Users cannot select custom date ranges in modern app.

**Files:**
- Legacy: `legacy/Frontend/HRMS-Frontend/source/src/pages/Dashboard/dashboardConstants.ts` (lines 46-51)
- Modern: `modern/frontend/src/views/dashboard/DashboardView.vue` (lines 50-54)

---

### 2. Missing Custom Date Picker Dialog

**Legacy Behavior:**
- When "Custom" is selected, opens a modal dialog (`CustomDatePicker` component)
- Dialog contains:
  - Start Date picker (maxDate: today)
  - End Date picker (minDate: startDate, maxDate: today)
  - Validation: both dates required
  - Error messages displayed if dates missing
  - Calculates days difference (endDate - startDate + 1)
  - Shows custom range in dropdown as "MMM Do, YYYY - MMM Do, YYYY"
  - Uses Material-UI DatePicker with Moment.js adapter

**Modern Behavior:**
- No custom date picker exists
- No dialog component

**Impact:** Complete feature missing - users cannot filter by custom date range.

**Files:**
- Legacy: `legacy/Frontend/HRMS-Frontend/source/src/pages/Dashboard/components/CustomDatePicker.tsx`
- Modern: **Does not exist**

---

### 3. Different Date Filter Option Labels

**Legacy:** "Past 7 Days", "Past 15 Days", "Past 30 Days"
**Modern:** "Last 7 Days", "Last 30 Days", "Last 90 Days"

**Differences:**
- Wording: "Past" vs "Last"
- Options: 7/15/30 vs 7/30/90 (missing 15, added 90, missing Custom)

**Impact:** User experience inconsistency.

---

## CRITICAL GAPS - API Integration

### 4. Date Filter Does Not Affect API Calls Correctly

**Legacy Behavior:**
- Date filter affects TWO endpoints:
  1. `GetEmployeesCount` (POST with `from`, `to`, `days`)
  2. `GetPublishedCompanyPolicies` (POST with `from`, `to`, `days`)
- Calculation logic in `useDashboardData.tsx`:
  - Calculates `from` and `to` dates based on `daySelectedValue`
  - `toDate = moment()` (today)
  - `fromDate = toDate.clone().subtract(daySelectedValue - 1, 'days')`
  - For custom range: uses `startDate` and `endDate`
- Other endpoints (birthdays, work anniversaries, holidays, events) are NOT affected by date filter

**Modern Behavior:**
- `selectedDays` ref is defined but only passed to `getEmployeesCount` and `getPublishedCompanyPolicies`
- Uses `days` parameter only (lines 112, 136)
- Does NOT calculate `from` and `to` dates
- API service uses conditional logic:
  ```typescript
  const requestBody = params.days && params.days > 0
    ? { days: params.days, from: null, to: null }
    : { days: 0, from: params.from || null, to: params.to || null };
  ```

**Problem:**
- Modern implementation never passes `from`/`to`, only `days`
- Backend logic might differ when receiving `days` vs `from`/`to` parameters
- Legacy calculates actual date range, modern just passes number

**Impact:** Date filtering might not work identically to legacy.

**Files:**
- Legacy: `legacy/Frontend/HRMS-Frontend/source/src/pages/Dashboard/index.tsx` (lines 40-54)
- Modern: `modern/frontend/src/views/dashboard/DashboardView.vue` (lines 105-144)

---

### 5. Missing "Past 15 Days" Option

**Legacy:** Offers 7, 15, 30, and Custom
**Modern:** Offers 7, 30, 90

**Impact:** Users cannot select 15-day filter option.

---

## WIDGET VISIBILITY GAPS

### 6. "Apply New" Tile Logic Difference

**Legacy Logic:**
```typescript
const enableAttendance = useFeatureFlag(FEATURE_FLAGS.enableAttendance);
const enableLeave = useFeatureFlag(FEATURE_FLAGS.enableLeave);
const enableApplyNew = enableAttendance || enableLeave;
```
- Checks TWO feature flags
- Shows "Apply New" if EITHER flag is enabled
- Inside tile, shows buttons based on specific permissions:
  - Leave button: `hasPermission(permissionValue.LEAVE_DETAILS.READ) && enableLeave`
  - Attendance button: `hasPermission(permissionValue.Attendance_Details.READ) && enableAttendance`

**Modern Logic:**
```typescript
const hasAttendancePermission = computed(() => authStore.hasPermission('Read.Attendance'));
const hasLeavePermission = computed(() => authStore.hasPermission('Read.Leave'));
const showApplyNewTile = computed(() => hasAttendancePermission.value || hasLeavePermission.value);
```
- Checks permissions only
- **Does NOT check feature flags**

**Impact:** Tile might show even if features are disabled by feature flags.

**Files:**
- Legacy: `legacy/Frontend/HRMS-Frontend/source/src/pages/Dashboard/index.tsx` (lines 181-184, 202-207)
- Legacy: `legacy/Frontend/HRMS-Frontend/source/src/pages/Dashboard/components/ApplyNew.tsx` (lines 10-50)
- Modern: `modern/frontend/src/views/dashboard/DashboardView.vue` (lines 62-68, 294-321)

---

### 7. Analytics Section Visibility Logic

**Legacy:**
```typescript
{userData.roleName !== role.EMPLOYEE && (
  <AnalyticsSection data={analyticsData} />
)}
```
- Checks `userData.roleName !== role.EMPLOYEE`
- Constant `role.EMPLOYEE` likely equals "EMPLOYEE"

**Modern:**
```typescript
const isEmployee = computed(() => {
  return authStore.user?.roleName === 'EMPLOYEE';
});

<v-row v-if="!isEmployee" class="mb-6">
```
- Same logic: hide for EMPLOYEE role
- **Appears correct**

**Status:** ✅ No gap (confirmed matching)

---

### 8. Widget Permission Checks

**Legacy:**
- Company Policy: `hasPermission(COMPANY_POLICY.READ)` → `permissionValue.COMPANY_POLICY.READ`
- Events: `hasPermission(EVENTS.READ)` → `permissionValue.EVENTS.READ`
- Employee Count: `hasPermission(EMPLOYMENT_DETAILS.READ)`
- Published Policies fetch: `hasPermission(COMPANY_POLICY.READ)`

**Modern:**
- Company Policy: `authStore.hasPermission('Read.CompanyPolicy')`
- Events: `authStore.hasPermission('Read.Events')`
- Employee Count: No explicit check (just `!isEmployee`)

**Gap:** Modern does not check `Read.EmploymentDetails` permission before fetching employee count.

**Impact:** Might fetch data user doesn't have permission to see.

**Files:**
- Legacy: `legacy/Frontend/HRMS-Frontend/source/src/pages/Dashboard/components/useDashboardData.tsx` (lines 181)
- Modern: `modern/frontend/src/views/dashboard/DashboardView.vue` (lines 110-120)

---

## HOLIDAY CALENDAR GAPS

### 9. Holiday Calendar Toggle State Persistence

**Legacy:**
- `holidayCalendarFlag` state managed in `useDashboardData` hook
- Defaults to "India"
- Flag selection persists across tile and modal
- Flag changes update both `filteredHolidays` and `filteredUpcomingHolidays`

**Modern:**
- `selectedLocation` local to `HolidayCalendarTile` component
- Defaults to "india"
- **Appears to match legacy behavior**

**Status:** ✅ No gap detected

---

### 10. Holiday Modal Implementation

**Legacy:**
- Opens Material-UI Dialog
- Shows PageHeader with "Holiday Calendar" title
- Close button (IconButton with CloseIcon)
- Flag selector inside modal
- Uses DataTable component with these columns:
  - SNO (index + 1)
  - DATE (formatted date)
  - DAY (day of week)
  - REMARKS (title)
  - LOCATION (location)
- Hides pagination (`hidePagination` prop)

**Modern:**
- Uses Vuetify Dialog
- Similar structure
- Uses v-table (Vuetify native table)
- Same columns
- **Appears to match legacy**

**Status:** ✅ No significant gap

---

## UI/STYLING GAPS

### 11. Dropdown Rendering with Custom Label

**Legacy:**
```tsx
renderValue={(value) =>
  !customLabel
    ? options.find((option) => option.value === value)?.label
    : customLabel
}
```
- When custom date range is applied, shows formatted range instead of option label
- Example: "Oct 1st, 2024 - Oct 15th, 2024"

**Modern:**
- No custom label rendering
- Always shows selected option title

**Impact:** Custom date range is not reflected in dropdown display.

---

### 12. Tile Background Classes

**Legacy:** `background={tile.background}` (0-6 numeric values)
**Modern:** `background-class="background-0"` (CSS class strings)

**Status:** Implementation difference but should achieve same visual result.

---

## DATA FETCHING GAPS

### 13. Conditional Fetching Based on Flags

**Legacy:**
```typescript
useEffect(() => {
  if (isCustomDayRange && !isSubmit) {
    return; // Skip API call if custom range dialog is open but not submitted
  }
  if (from && to) {
    if (hasPermission(EMPLOYMENT_DETAILS.READ)) fetchEmployeeCount();
    if (hasPermission(COMPANY_POLICY.READ)) fetchPublishedCompanyPolicies();
  }
}, [from, to, isSubmit]);
```
- Waits for `isSubmit` flag before making API calls when custom range is active
- Prevents premature API calls while user is still selecting dates

**Modern:**
- No custom date range, so no need for submit flag
- Fetches immediately when `selectedDays` changes

**Status:** Not a gap since custom range doesn't exist in modern.

---

### 14. API Call Timing on Mount

**Legacy:**
- Separate `useEffect` hooks for each data source
- Some conditional on feature flags (`isFetchBirthdays`, `isFetchWorkAnniversaries`, etc.)
- Birthday/anniversary/holidays fetch immediately
- Events/policies check permissions first

**Modern:**
```typescript
onMounted(() => {
  fetchDashboardData();
});
```
- Single fetch function
- All data fetched in parallel

**Status:** ✅ Modern approach is cleaner and should work correctly.

---

## SUMMARY OF GAPS

### High Priority (Blocking)
1. ❌ **Missing "Custom" date range option in dropdown**
2. ❌ **Missing CustomDatePicker dialog component**
3. ❌ **Date filter logic doesn't calculate from/to dates**
4. ⚠️ **"Apply New" tile doesn't check feature flags**
5. ⚠️ **Missing EMPLOYMENT_DETAILS.READ permission check for employee count**

### Medium Priority (UX Inconsistency)
6. ⚠️ **Different date filter labels** ("Past" vs "Last")
7. ⚠️ **Missing "Past 15 Days" option, has "Last 90 Days" instead**
8. ⚠️ **Custom date range not shown in dropdown after selection**

### Low Priority (Minor Differences)
9. ℹ️ Different implementation patterns (acceptable as long as behavior matches)

---

## RECOMMENDED FIXES

### Fix 1: Add Custom Date Range Feature
**Steps:**
1. Update `dayOptions` array to include `{ title: 'Custom', value: '-1' }`
2. Create `CustomDatePicker.vue` component matching legacy dialog
3. Add state variables: `startDate`, `endDate`, `isCustomDayRange`, `customDayRangeError`, etc.
4. Implement date picker logic with validation
5. Calculate `from` and `to` dates from custom range
6. Display custom range in dropdown using `renderValue` equivalent

### Fix 2: Correct Date Filter API Integration
**Steps:**
1. Add computed property to calculate `from` and `to` dates from `selectedDays`
2. Use Moment.js or Day.js: `fromDate = today - (selectedDays - 1)`, `toDate = today`
3. Pass calculated dates to API calls instead of just `days` parameter
4. Match legacy logic exactly: `fromDate.format("YYYY-MM-DD")`

### Fix 3: Add Feature Flag Support
**Steps:**
1. Implement `useFeatureFlag` composable in Vue
2. Check both permissions AND feature flags for "Apply New" tile
3. Update tile visibility logic:
   ```typescript
   const enableAttendance = useFeatureFlag('enableAttendance');
   const enableLeave = useFeatureFlag('enableLeave');
   const showApplyNewTile = computed(() =>
     (hasAttendancePermission.value && enableAttendance.value) ||
     (hasLeavePermission.value && enableLeave.value)
   );
   ```

### Fix 4: Add Missing Permission Check
**Steps:**
1. Add `Read.EmploymentDetails` permission check before fetching employee count
2. Update `fetchPermissionGatedData()` function:
   ```typescript
   if (!isEmployee.value && authStore.hasPermission('Read.EmploymentDetails')) {
     promises.push(getEmployeesCount({ days })...);
   }
   ```

### Fix 5: Update Date Filter Options
**Steps:**
1. Change labels from "Last" to "Past"
2. Replace "Last 90 Days" with "Past 15 Days"
3. Add "Custom" option
4. Match exact legacy options: 7, 15, 30, Custom

---

## FILES REQUIRING CHANGES

### Modern Files to Update:
1. `modern/frontend/src/views/dashboard/DashboardView.vue`
   - Add custom date range state and logic
   - Fix date filter options
   - Add feature flag checks
   - Add permission checks

2. `modern/frontend/src/components/dashboard/CustomDatePicker.vue` **(NEW FILE)**
   - Create custom date picker dialog
   - Implement validation
   - Match legacy styling

3. `modern/frontend/src/services/dashboard/dashboardService.ts`
   - Verify API parameter handling matches legacy

4. `modern/frontend/src/composables/useFeatureFlag.ts` **(NEW FILE if doesn't exist)**
   - Implement feature flag support

---

## TESTING CHECKLIST

After fixes:
- [ ] Verify "Past 7 Days" filters employee count correctly
- [ ] Verify "Past 15 Days" option exists
- [ ] Verify "Past 30 Days" filters company policies correctly
- [ ] Verify "Custom" option opens date picker dialog
- [ ] Verify custom date range validation (both dates required)
- [ ] Verify custom date range calculation (end - start + 1 days)
- [ ] Verify custom range displayed in dropdown after selection
- [ ] Verify "Apply New" tile hidden if both attendance and leave features disabled
- [ ] Verify "Apply New" buttons match permissions + feature flags
- [ ] Verify employee count fetch checks EMPLOYMENT_DETAILS.READ permission
- [ ] Verify holiday calendar toggle works (India/USA)
- [ ] Verify analytics hidden for EMPLOYEE role
- [ ] Verify all API calls use correct date format (YYYY-MM-DD)

---

**End of Analysis**
