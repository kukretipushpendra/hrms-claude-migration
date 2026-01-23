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
  - /legacy/*/wwwroot/css/{page-specific}.css (if exists, check page <link> tags and inline, external css as well)


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
   - Same HTML structure (convert to Vue template)
   - Same CSS classes, Copy whole .css, inline or internal css as It is.
   - Check <link> tag of legacy page to find out what css are used, copy same to modern
   - Same text content (word-for-word)
   - Same page title (document.title)

3. **Vue.js Patterns**
   - Use `onMounted` to set document.title
   - Use Vue Router `<RouterLink>` for internal navigation
   - Use `href="#"` or `<button>` for non-navigating links

### Component Location
- Create component at: src/views/{Page}/{Page}View.vue

### Route Configuration
- Add route in router/index.ts:
```typescript
{
  path: '/{route}',
  name: '{PageName}',
  component: () => import('@/views/{Page}/{Page}View.vue'),
}
```

## Vue.js Page Template

### Static Page
```vue
<!-- src/views/{Page}/{Page}View.vue -->
<script setup lang="ts">
import { onMounted } from 'vue';

onMounted(() => {
  document.title = '{Page Title} - HRMS';
});
</script>

<template>
  <div class="page-container">
    <!-- HTML structure from legacy .cshtml -->
  </div>
</template>

<style scoped>
/* Page-specific styles from legacy */
</style>
```

### Data-Driven Page
```vue
<!-- src/views/{Page}/{Page}View.vue -->
<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { apiService } from '@/services/api';
import type { DataType } from '@/types/{module}.types';

const data = ref<DataType[]>([]);
const loading = ref(true);
const error = ref<string | null>(null);

const fetchData = async () => {
  try {
    loading.value = true;
    data.value = await apiService.get<DataType[]>('/api/{endpoint}');
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Failed to load data';
  } finally {
    loading.value = false;
  }
};

onMounted(() => {
  document.title = '{Page Title} - HRMS';
  fetchData();
});
</script>

<template>
  <div class="page-container">
    <div v-if="loading">Loading...</div>
    <div v-else-if="error" class="error">{{ error }}</div>
    <div v-else>
      <!-- Data display matching legacy -->
    </div>
  </div>
</template>
```

## Key Differences from React

| React | Vue.js |
|-------|--------|
| `useEffect(() => {}, [])` | `onMounted(() => {})` |
| `<Link to="/">` | `<RouterLink to="/">` |
| JSX `{condition && <div>}` | `<div v-if="condition">` |
| JSX `{items.map(i => <X />)}` | `<X v-for="i in items" :key="i.id" />` |
| `className` | `class` |
| `onClick={fn}` | `@click="fn"` |
| `<Route element={<Page />} />` | `component: () => import('@/views/Page.vue')` |

## Acceptance Criteria
- [ ] Route works at /{route}
- [ ] Page title matches legacy exactly
- [ ] Content matches legacy exactly (word-for-word)
- [ ] HTML structure matches legacy
- [ ] CSS classes match legacy
- [ ] CSS is copied from legacy and used as it is. Includes external, inline and internal CSS.
- [ ] Data loads correctly (if data-driven)
- [ ] Error handling works (if data-driven)
- [ ] Uses Vue Router `<RouterLink>` for navigation
- [ ] Uses `onMounted` for lifecycle (not `useEffect`)

## Attempts
ATTEMPT_COUNT: 0
