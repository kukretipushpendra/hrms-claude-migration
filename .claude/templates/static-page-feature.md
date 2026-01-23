# Feature: {page-name}

## Identity
MODULE: core
FEATURE: {page-name}
TYPE: static-page | data-driven-page
CREATED: {date}

## Legacy References
FILES:
  - /legacy/*/Pages/{Page}.cshtml
  - /legacy/*/Pages/{Page}.cshtml.cs (if exists)
  - /legacy/*/wwwroot/css/{page-specific}.css (if exists, check page <link> tags abd inline, external css as well)


## Status
CURRENT: ready-for-dev
BACKEND: not-applicable | pending (if data-driven)
FRONTEND: pending
FRONTEND_QA: pending
INTEGRATION_QA: pending

## Dependencies
DEPENDS_ON: [layout-and-styles]

## Behavior Spec

### Route Configuration
PATH: /{route}
TITLE: "{page title from ViewData['Title']}"

### Legacy Analysis Notes
PAGE_TYPE: static | data-driven
HAS_DATABASE_QUERY: yes | no
CSS_CLASSES_USED: [list Bootstrap/CSS classes from legacy]
CUSTOM_STYLES: [any page-specific CSS]

### Data Requirements (if data-driven)
ENDPOINT: GET /api/{endpoint}
QUERY_PARAMS: {if any}
RESPONSE_SHAPE: See migration/api-contracts/{module}/{feature}.api.md

## Implementation Instructions

### For Sub-Agent

1. **Read Legacy Files**
   - Read the legacy .cshtml file to understand HTML structure
   - Read the .cshtml.cs file for any data queries
   - Note exact CSS classes, spacing, and layout

2. **Replicate 100%**
   - Same HTML structure (convert to JSX)
   - Same CSS classes, Copy whole .css, inline or internal css as It is.
   - Check <link> tag of legacy page to find out what css are used, copy same to modern
   - Same text content (word-for-word)
   - Same page title (document.title)

3. **React Patterns**
   - Use `useEffect` to set document.title
   - Use React Router `<Link>` for internal navigation
   - Use `href="#"` or Button for non-navigating links

### Component Location
- Create component at: src/pages/{Page}/{Page}.tsx

### Route Configuration
- Add route in App.tsx: `<Route path="/{route}" element={<{Page} />} />`

## Acceptance Criteria
- [ ] Route works at /{route}
- [ ] Page title matches legacy exactly
- [ ] Content matches legacy exactly (word-for-word)
- [ ] HTML structure matches legacy
- [ ] CSS classes match legacy
- [ ] CSS is copied from legacy and used as it is. Includes external, inline and internal CSS.
- [ ] Data loads correctly (if data-driven)
- [ ] Error handling works (if data-driven)

## Attempts
ATTEMPT_COUNT: 0
