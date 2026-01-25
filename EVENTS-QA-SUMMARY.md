# Events Management Integration QA Summary

**Date:** 2026-01-25
**Status:** QA_FAILED
**Feature:** events/events

---

## Verdict

**QA_FAILED: Backend not running + Frontend endpoint mismatches found**

---

## Critical Issues Found

### 1. Backend Service Not Running (BLOCKER)
- **Impact:** Cannot perform integration testing
- **Backend URL:** http://localhost:5281
- **Action Required:** Start .NET backend service

### 2. Get Event By ID - Endpoint Mismatch (HIGH)
- **Location:** `modern/frontend/src/services/events/eventsService.ts:34`
- **Current (WRONG):**
  ```typescript
  const response = await httpClient.get<ApiResponse<EventDetail>>(
    `${baseRoute}/GetEventById`,
    { params: { id } }
  );
  ```
  This calls: `/api/Event/GetEventById?id={id}`

- **Expected (CORRECT):**
  ```typescript
  const response = await httpClient.get<ApiResponse<EventDetail>>(
    `${baseRoute}/${id}`
  );
  ```
  Should call: `/api/Event/{id}`

- **Legacy Backend Route:**
  ```csharp
  [HttpGet]
  [Route("{id:long}")]
  public async Task<IActionResult> GetEventById(long id)
  ```

### 3. Delete Event - Endpoint Mismatch (HIGH)
- **Location:** `modern/frontend/src/services/events/eventsService.ts:112`
- **Current (WRONG):**
  ```typescript
  const response = await httpClient.delete<ApiResponse<null>>(
    `${baseRoute}/DeleteEvent`,
    { params: { id } }
  );
  ```
  This calls: `/api/Event/DeleteEvent?id={id}`

- **Expected (CORRECT):**
  ```typescript
  const response = await httpClient.delete<ApiResponse<null>>(
    `${baseRoute}/${id}`
  );
  ```
  Should call: `/api/Event/{id}`

- **Legacy Backend Route:**
  ```csharp
  [HttpDelete]
  [Route("{id:long}")]
  public async Task<IActionResult> Delete(long id)
  ```

### 4. Event Categories Using Mock Data (MEDIUM)
- **Location:** `modern/frontend/src/services/events/eventsService.ts:123`
- **Current:** Returns hardcoded mock data
- **Action Required:** Implement actual API call to GET /api/Event/GetEventCategoryList

---

## What Works Correctly

✅ **Get Events List** - POST /api/Event/GetEvents
- Correct endpoint
- Correct request structure (Filters, PageSize, StartIndex, SortColumnName, SortDirection)
- Correct Pascal case for all properties

✅ **Create Event** - POST /api/Event/CreateEvent
- Correct endpoint
- Correct multipart/form-data format
- Correct file upload handling

✅ **Update Event** - POST /api/Event/UpdateEvent
- Correct endpoint (POST, not PUT - matches legacy)
- Correct multipart/form-data format

✅ **EventsListView Component**
- Correct permission checks
- Correct pagination logic (1-based indexing)
- Correct sorting and filtering
- Correct data display with truncation and tooltips

---

## Required Fixes

### File: `modern/frontend/src/services/events/eventsService.ts`

**Fix 1: getEventById function (line 34-39)**

Replace:
```typescript
export async function getEventById(id: number): Promise<ApiResponse<EventDetail>> {
  const response = await httpClient.get<ApiResponse<EventDetail>>(`${baseRoute}/GetEventById`, {
    params: { id },
  });
  return response.data;
}
```

With:
```typescript
export async function getEventById(id: number): Promise<ApiResponse<EventDetail>> {
  const response = await httpClient.get<ApiResponse<EventDetail>>(`${baseRoute}/${id}`);
  return response.data;
}
```

**Fix 2: deleteEvent function (line 112-117)**

Replace:
```typescript
export async function deleteEvent(id: number): Promise<ApiResponse<null>> {
  const response = await httpClient.delete<ApiResponse<null>>(`${baseRoute}/DeleteEvent`, {
    params: { id },
  });
  return response.data;
}
```

With:
```typescript
export async function deleteEvent(id: number): Promise<ApiResponse<null>> {
  const response = await httpClient.delete<ApiResponse<null>>(`${baseRoute}/${id}`);
  return response.data;
}
```

**Fix 3: getEventCategories function (line 123-142)**

Replace mock implementation with actual API call:
```typescript
export async function getEventCategories(): Promise<ApiResponse<EventCategory[]>> {
  const response = await httpClient.get<ApiResponse<EventCategory[]>>(
    `${baseRoute}/GetEventCategoryList`
  );
  return response.data;
}
```

---

## Testing Instructions

After applying fixes:

1. **Start Backend:**
   ```bash
   cd legacy/Backend/HRMSWebApi/HRMS.API
   dotnet run
   ```

2. **Verify Backend Running:**
   ```bash
   curl http://localhost:5281/api/health
   ```

3. **Run Integration Tests:**
   ```bash
   node test-events-integration.js
   ```

4. **Expected Results:**
   - All 7 tests should pass
   - Events list loads correctly
   - Event detail view works
   - Event deletion works
   - Categories loaded from API

---

## Test Coverage

The integration test script covers:
1. ✅ Authentication (Login)
2. ✅ Get Events List (with filters)
3. ✅ Get Event By ID
4. ✅ Get Event Categories
5. ✅ Filtered Search
6. ✅ Pagination (multiple pages)
7. ✅ Sorting (asc/desc)

---

## Next Steps

1. **Frontend Coder:** Apply the 3 fixes to eventsService.ts
2. **Human Developer:** Start the .NET backend service
3. **QA Agent:** Re-run integration tests after fixes applied
4. **Expected Outcome:** All tests pass → Integration QA status updates to PASSED

---

## Files Involved

**Frontend Service:**
- `modern/frontend/src/services/events/eventsService.ts` (NEEDS FIXES)

**Frontend Components:**
- `modern/frontend/src/views/events/EventsListView.vue` (CORRECT)
- `modern/frontend/src/views/events/EventDetailView.vue` (needs backend running to test)
- `modern/frontend/src/views/events/EventCreateView.vue` (needs backend running to test)

**Backend Controller:**
- `legacy/Backend/HRMSWebApi/HRMS.API/Controllers/EventController.cs` (SOURCE OF TRUTH)

**API Contracts:**
- `migration/api-contracts/event/get-events.api.md` (CORRECT)
- `migration/api-contracts/event/get-event-by-id.api.md` (NEEDS UPDATE)
- `migration/api-contracts/event/create-event.api.md` (CORRECT)

**Test Scripts:**
- `test-events-integration.js` (CREATED, READY TO USE)

**QA Reports:**
- `migration/logs/events-qa-report-2026-01-25.md` (DETAILED REPORT)

---

## Status Update

**Feature Status File:** `migration/modules/events/features/events.md`

```markdown
CURRENT: frontend-in-progress
INTEGRATION_QA: failed
INTEGRATION_ATTEMPT_COUNT: 1
```

**Action:** Spawn frontend-coder to apply fixes
