# Feature Attempts Log

Tracks all feature implementation attempts for learning and debugging.

---

## Entry Format

```
### {module}/{feature} - Attempt {n}

DATE: YYYY-MM-DD
AGENT: backend-coder | frontend-coder
BRANCH: feature/{module}-{feature}
RESULT: qa-failed

QA_FEEDBACK:
  - {specific mismatch found}
  - {what was wrong}

LEGACY_REFERENCE:
  - {file}:{lines} - {what was missed or misunderstood}

LEARNINGS:
  - {what the next attempt should do differently}
  - {pattern to avoid}

---
```

## Example Entry

```
### orders/delete - Attempt 1

DATE: 2024-01-17
AGENT: backend-coder
BRANCH: feature/orders-delete
RESULT: qa-failed

QA_FEEDBACK:
  - Missing inventory restoration before delete
  - Refund not called synchronously

LEGACY_REFERENCE:
  - /legacy/Services/OrderService.cs:256-271 - Inventory restore happens first
  - /legacy/Services/OrderService.cs:273 - Refund is synchronous, not async

LEARNINGS:
  - Always check service call order in legacy
  - Check if operations are sync or async in legacy

---
```

## Log Entries

(Entries added automatically when QA fails a feature)

---

### assets/asset-management - Attempt 1

DATE: 2026-01-26
AGENT: frontend-coder
BRANCH: feature/assets-asset-management
RESULT: qa-failed

QA_FEEDBACK:
  - TypeScript build failed with enum declaration syntax errors
  - Missing quotes around route path in ITAssetTableToolbar.vue line 5
  - vue3-toastify import errors (module not found)
  - File type handling issue in ImportAssetDialog.vue line 70

SPECIFIC_ERRORS:
  - src/types/asset.types.ts:7,24,30,36 - "export enum" should be "export const enum" (TS1294 error)
  - src/components/assets/ITAssetTableToolbar.vue:5 - :to="/IT-Assets/add" should be :to="'/IT-Assets/add'"
  - Multiple files using vue3-toastify without package installed
  - ImportAssetDialog.vue:70 - selectedFile.value[0] needs null check before use

LEGACY_REFERENCE:
  - N/A - These are TypeScript configuration and syntax issues, not legacy parity issues

LEARNINGS:
  - Check TypeScript compiler options (erasableSyntaxOnly) when using enums - requires "const enum"
  - Always quote route paths in Vue templates
  - Verify toast notification library is installed or use project's standard approach
  - Add proper null checks for array access in file uploads

PATTERN_DETECTED:
  - Enum declaration issues likely affect other Wave 3/4 features (leave.types.ts also affected)
  - Toast notification approach inconsistent across project

---

### assets/asset-management - Attempt 2

DATE: 2026-01-26
AGENT: frontend-coder
BRANCH: feature/assets-asset-management
RESULT: qa-failed

QA_FEEDBACK:
  - TypeScript build failed with type assignment errors in ITAssetForm.vue
  - Form field types (number) don't match payload types (AssetType, AssetStatus, etc.)

SPECIFIC_ERRORS:
  - src/components/assets/ITAssetForm.vue:570 - Type 'number' is not assignable to type 'AssetType'
  - src/components/assets/ITAssetForm.vue:571 - Type 'number' is not assignable to type 'AssetStatus'
  - src/components/assets/ITAssetForm.vue:572 - Type 'number' is not assignable to type 'AssetCondition'
  - src/components/assets/ITAssetForm.vue:573 - Type 'number' is not assignable to type 'BranchLocation'

ROOT_CAUSE:
  - Form fields defined as useField<number> (lines 459-462)
  - But UpsertITAssetPayload expects AssetType, AssetStatus, AssetCondition, BranchLocation types
  - The const object pattern creates literal union types, not plain numbers

FIX_REQUIRED:
  - Change form field type definitions from:
    useField<number>('assetType')
    to:
    useField<AssetType>('assetType')
  - Apply same fix for assetStatus, assetCondition, and branch fields (lines 459-462)

LEGACY_REFERENCE:
  - N/A - TypeScript type system compliance issue

LEARNINGS:
  - When using const object pattern for enums, form fields must use the enum type, not number
  - TypeScript's structural typing means AssetType !== number even though values are numbers
  - Type declarations must match payload interface exactly

---

### exit/exit-management - Attempt 1

DATE: 2026-01-26
AGENT: frontend-coder
BRANCH: feature/exit-exit-management
RESULT: qa-failed

QA_FEEDBACK:
  - TypeScript build failed with 59 compilation errors
  - Missing dayjs dependency (used in 5 files)
  - Incorrect Zod validation syntax in AccountClearanceForm and HRClearanceForm
  - Enum type mismatches (number vs. KTStatusType, ResignationStatusType, EmployeeStatusType)
  - File upload type safety issues (File | undefined not assignable)
  - 21 ESLint warnings using 'any' types (max-warnings set to 0)
  - Auth store userId should be id

SPECIFIC_ERRORS:
  - src/components/exit/EarlyReleaseDialog.vue:6 + 4 more files - Cannot find module 'dayjs'
  - src/components/exit/AccountClearanceForm.vue:33 - Zod .refine() signature incorrect
  - src/components/exit/HRClearanceForm.vue:34 - Zod .refine() signature incorrect
  - src/components/exit/DepartmentClearanceForm.vue:93 - Type 'number' not assignable to 'KTStatusType'
  - src/components/exit/ExitEmployeeFilterForm.vue:69,77 - Type 'number' not assignable to enum types
  - src/components/exit/AccountClearanceForm.vue:91 - File | undefined type mismatch
  - src/views/exit/ResignationFormView.vue:35,177 - Property 'userId' does not exist, should be 'id'

ROOT_CAUSE:
  - dayjs package not installed
  - Same enum pattern issues as assets feature (const object creates literal union types)
  - Zod validation syntax changed (single argument, not two)
  - File upload needs proper null handling

FIX_REQUIRED:
  1. Install dayjs: npm install dayjs && npm install -D @types/dayjs
  2. Fix Zod .refine() in clearance forms: (val: any, ctx: any) => {...} becomes (val) => {...}
  3. Update form field types: useField<number> => useField<KTStatusType> (and similar)
  4. Add file null checks: fileInput.value?.files?.[0] || null
  5. Replace all 'any' types with proper TypeScript types
  6. Change authStore.user.userId to authStore.user.id

LEGACY_REFERENCE:
  - N/A - These are TypeScript/dependency issues, not legacy parity issues

LEARNINGS:
  - CRITICAL: Install dayjs before using date manipulation
  - Follow same enum type pattern as assets feature (see Attempt 2 above)
  - Zod validation syntax requires single argument function
  - Auth store user object uses 'id' property, not 'userId'
  - File uploads need explicit null handling for TypeScript strict mode

PATTERN_DETECTED:
  - Same enum type issues as assets feature - systematic issue across Wave 4 features
  - Missing dependency check should be part of initial setup
  - Zod validation pattern needs to be consistent across all forms

---
