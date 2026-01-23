# Frontend Migration Execution Plan

## Executive Summary

This document provides a step-by-step command and execution plan for migrating a legacy frontend to a modern frontend architecture. The plan is module-wise, sequential, and designed for enterprise-scale migrations.

**Scope:** Frontend only (no backend migration)
**Approach:** Module-by-module incremental migration
**Strategy:** Strangler Fig Pattern - gradually replace legacy modules while maintaining system functionality

---

# PHASE 1: MODULE-WISE PLANNING

## Step 1.1: Discovery & Module Identification

### Command 1.1.1: Analyze Legacy Frontend Structure
```bash
# Create discovery output directory
mkdir -p migration/discovery

# Run discovery agent to analyze legacy frontend
/migrate-init
```

### Command 1.1.2: Generate Module Inventory
```
Task (explorer): "Analyze legacy frontend at /legacy/Frontend.
Create comprehensive module inventory:
1. List all top-level modules/features
2. Count components per module
3. Identify shared components
4. Map routing structure
5. Document state management usage

Output: migration/discovery/module-inventory.json"
```

### Expected Output: `migration/discovery/module-inventory.json`
```json
{
  "modules": [
    {
      "name": "authentication",
      "path": "src/modules/auth",
      "components": 12,
      "routes": ["/login", "/logout", "/forgot-password"],
      "stateSlices": ["authStore"],
      "dependencies": [],
      "complexity": "medium",
      "priority": "critical"
    },
    {
      "name": "dashboard",
      "path": "src/modules/dashboard",
      "components": 8,
      "routes": ["/", "/dashboard"],
      "stateSlices": ["dashboardStore"],
      "dependencies": ["authentication"],
      "complexity": "low",
      "priority": "high"
    }
    // ... more modules
  ],
  "sharedComponents": {
    "count": 45,
    "path": "src/components/shared",
    "categories": ["ui", "layout", "forms", "data-display"]
  },
  "totalComponents": 250,
  "totalRoutes": 85,
  "totalStateSlices": 15
}
```

---

## Step 1.2: Module Categorization

### Command 1.2.1: Categorize Modules by Type
```
Task (explorer): "Categorize all modules from module-inventory.json.

Categories:
1. FOUNDATION - Auth, Layout, Navigation, Error Handling
2. CORE - Essential business modules (Dashboard, User Profile)
3. CRUD - Standard data management modules
4. COMPLEX - Multi-step workflows, heavy integrations
5. STATIC - Simple display-only pages

Output: migration/discovery/module-categories.json"
```

### Expected Output: `migration/discovery/module-categories.json`
```json
{
  "foundation": [
    { "name": "authentication", "reason": "Required for all protected routes" },
    { "name": "layout", "reason": "App shell, header, sidebar, footer" },
    { "name": "error-handling", "reason": "Error boundaries, 404, offline" }
  ],
  "core": [
    { "name": "dashboard", "reason": "Primary landing page" },
    { "name": "user-profile", "reason": "User settings and preferences" }
  ],
  "crud": [
    { "name": "employees", "reason": "Standard CRUD operations" },
    { "name": "departments", "reason": "Standard CRUD operations" },
    { "name": "assets", "reason": "Standard CRUD with file uploads" }
  ],
  "complex": [
    { "name": "payroll", "reason": "Multi-step calculation workflow" },
    { "name": "reports", "reason": "Dynamic report generation" },
    { "name": "workflows", "reason": "Approval chains, state machines" }
  ],
  "static": [
    { "name": "help", "reason": "Documentation pages" },
    { "name": "about", "reason": "Static content" }
  ]
}
```

---

## Step 1.3: Migration Readiness Assessment

### Command 1.3.1: Assess Each Module's Readiness
```
Task (explorer): "For each module, assess migration readiness.

Evaluate:
1. Code quality (linting errors, type coverage)
2. Test coverage percentage
3. Documentation completeness
4. Technical debt indicators
5. External dependency count
6. API contract clarity

Output: migration/discovery/readiness-assessment.json"
```

### Readiness Criteria Matrix

| Criteria | GREEN (Ready) | YELLOW (Needs Work) | RED (Block) |
|----------|---------------|---------------------|-------------|
| Test Coverage | >70% | 40-70% | <40% |
| Type Coverage | >80% | 50-80% | <50% |
| Lint Errors | 0 | 1-10 | >10 |
| API Contracts | Documented | Partial | None |
| Dependencies | All mapped | Some unclear | Circular |
| Complexity | Low-Medium | High | Very High |

### Command 1.3.2: Generate Readiness Report
```bash
# Create readiness summary
cat > migration/discovery/readiness-report.md << 'EOF'
# Module Readiness Report

## Summary
- Total Modules: {count}
- Ready (GREEN): {count}
- Needs Work (YELLOW): {count}
- Blocked (RED): {count}

## Module Status

| Module | Readiness | Blockers | Action Required |
|--------|-----------|----------|-----------------|
| auth | GREEN | None | Ready to migrate |
| employees | YELLOW | Low test coverage | Add unit tests |
| payroll | RED | Circular deps | Refactor first |

EOF
```

---

## Step 1.4: Modern Tech Stack Definition

### Command 1.4.1: Document Tech Stack Decisions
```bash
cat > migration/tech-stack.md << 'EOF'
# Modern Frontend Tech Stack

## Core Framework
| Decision | Choice | Rationale |
|----------|--------|-----------|
| Framework | Vue.js 3 | Composition API, better TypeScript support |
| Language | TypeScript | Type safety, better IDE support |
| Build Tool | Vite | Fast HMR, modern bundling |

## State Management
| Decision | Choice | Rationale |
|----------|--------|-----------|
| Global State | Pinia | Official Vue store, TypeScript native |
| Server State | TanStack Query | Caching, sync, optimistic updates |
| Local State | Composables | Reusable reactive logic |

## Routing
| Decision | Choice | Rationale |
|----------|--------|-----------|
| Router | Vue Router 4 | Official, Composition API support |
| Code Splitting | Dynamic imports | Route-level lazy loading |

## Forms & Validation
| Decision | Choice | Rationale |
|----------|--------|-----------|
| Form Library | VeeValidate 4 | Vue-native, Composition API |
| Schema Validation | Zod | TypeScript-first, runtime validation |

## UI Framework
| Decision | Choice | Rationale |
|----------|--------|-----------|
| Component Library | Vuetify 3 / PrimeVue | Material Design, enterprise ready |
| CSS Approach | CSS Modules + Tailwind | Scoped styles, utility classes |

## Testing
| Decision | Choice | Rationale |
|----------|--------|-----------|
| Unit Tests | Vitest | Vite-native, fast |
| Component Tests | Vue Test Utils | Official testing library |
| E2E Tests | Playwright | Cross-browser, reliable |

## Quality
| Decision | Choice | Rationale |
|----------|--------|-----------|
| Linting | ESLint + eslint-plugin-vue | Standard Vue linting |
| Formatting | Prettier | Consistent code style |
| Type Checking | vue-tsc | Vue-aware TypeScript |

EOF
```

---

## Step 1.5: Dependency Mapping

### Command 1.5.1: Map Inter-Module Dependencies
```
Task (explorer): "Create dependency graph for all modules.

For each module, identify:
1. Modules it imports from (dependencies)
2. Modules that import from it (dependents)
3. Shared components used
4. State slices accessed
5. API endpoints consumed

Output: migration/discovery/dependency-graph.json"
```

### Expected Output: `migration/discovery/dependency-graph.json`
```json
{
  "modules": {
    "authentication": {
      "dependencies": [],
      "dependents": ["dashboard", "employees", "settings", "...all protected modules"],
      "sharedComponents": ["Button", "Input", "Form"],
      "stateAccess": ["authStore"],
      "apiEndpoints": ["/api/auth/login", "/api/auth/refresh"]
    },
    "employees": {
      "dependencies": ["authentication", "departments"],
      "dependents": ["attendance", "leave", "payroll"],
      "sharedComponents": ["Table", "Modal", "Form", "SearchBar"],
      "stateAccess": ["authStore", "employeeStore"],
      "apiEndpoints": ["/api/employees", "/api/employees/:id"]
    }
  },
  "circularDependencies": [],
  "criticalPath": ["authentication", "layout", "dashboard"]
}
```

### Command 1.5.2: Visualize Dependency Graph
```bash
# Generate dependency visualization
cat > migration/discovery/dependency-visualization.md << 'EOF'
# Module Dependency Graph

```
                    ┌─────────────────┐
                    │  Authentication │ (Foundation)
                    └────────┬────────┘
                             │
              ┌──────────────┼──────────────┐
              ▼              ▼              ▼
        ┌──────────┐  ┌──────────┐  ┌──────────┐
        │  Layout  │  │ Dashboard│  │  Profile │
        └────┬─────┘  └────┬─────┘  └──────────┘
             │              │
    ┌────────┴────────┐    │
    ▼                 ▼    ▼
┌──────────┐    ┌──────────┐
│Employees │───▶│Attendance│
└────┬─────┘    └────┬─────┘
     │               │
     ▼               ▼
┌──────────┐    ┌──────────┐
│  Leave   │    │ Payroll  │
└──────────┘    └──────────┘
```

## Dependency Rules
1. Foundation modules have NO dependencies
2. Core modules depend only on Foundation
3. CRUD modules depend on Foundation + Core
4. Complex modules can depend on CRUD modules
EOF
```

---

## Step 1.6: Migration Order Definition

### Command 1.6.1: Establish Migration Sequence
```bash
cat > migration/discovery/migration-order.md << 'EOF'
# Module Migration Order

## Ordering Principles
1. **Dependencies First** - Migrate dependencies before dependents
2. **Foundation First** - Core infrastructure before features
3. **Low Risk First** - Simple modules before complex
4. **High Value First** - Critical business modules prioritized

## Migration Waves

### Wave 0: Foundation (Week 1-2)
| Order | Module | Type | Complexity | Dependencies |
|-------|--------|------|------------|--------------|
| 0.1 | project-setup | foundation | low | none |
| 0.2 | shared-components | foundation | medium | none |
| 0.3 | layout | foundation | medium | shared-components |
| 0.4 | authentication | foundation | medium | layout |
| 0.5 | error-handling | foundation | low | layout |

### Wave 1: Core (Week 3-4)
| Order | Module | Type | Complexity | Dependencies |
|-------|--------|------|------------|--------------|
| 1.1 | dashboard | core | low | authentication |
| 1.2 | user-profile | core | low | authentication |
| 1.3 | settings | core | low | authentication |

### Wave 2: Primary CRUD (Week 5-8)
| Order | Module | Type | Complexity | Dependencies |
|-------|--------|------|------------|--------------|
| 2.1 | departments | crud | low | core |
| 2.2 | designations | crud | low | core |
| 2.3 | employees | crud | medium | departments |
| 2.4 | attendance | crud | medium | employees |
| 2.5 | leave | crud | medium | employees |

### Wave 3: Secondary CRUD (Week 9-12)
| Order | Module | Type | Complexity | Dependencies |
|-------|--------|------|------------|--------------|
| 3.1 | assets | crud | medium | employees |
| 3.2 | documents | crud | medium | employees |
| 3.3 | training | crud | medium | employees |
| 3.4 | benefits | crud | medium | employees |

### Wave 4: Complex Modules (Week 13-16)
| Order | Module | Type | Complexity | Dependencies |
|-------|--------|------|------------|--------------|
| 4.1 | payroll | complex | high | employees, attendance |
| 4.2 | reports | complex | high | all data modules |
| 4.3 | workflows | complex | high | all modules |

### Wave 5: Remaining & Cleanup (Week 17-20)
| Order | Module | Type | Complexity | Dependencies |
|-------|--------|------|------------|--------------|
| 5.1 | help | static | low | layout |
| 5.2 | about | static | low | layout |
| 5.3 | legacy-cleanup | cleanup | - | all |

EOF
```

---

## Step 1.7: Success Metrics Definition

### Command 1.7.1: Define Success Criteria
```bash
cat > migration/discovery/success-metrics.md << 'EOF'
# Migration Success Metrics

## Per-Module Success Criteria

### Functional Parity
- [ ] All legacy features replicated
- [ ] Same user workflows supported
- [ ] Same validation rules applied
- [ ] Same error messages displayed
- [ ] Same data displayed identically

### Quality Gates
| Metric | Threshold | Measurement |
|--------|-----------|-------------|
| Unit Test Coverage | ≥80% | Vitest coverage report |
| Type Coverage | 100% | vue-tsc --noEmit |
| Lint Errors | 0 | ESLint report |
| Build Success | Pass | Vite build |
| Accessibility | WCAG 2.1 AA | axe-core audit |

### Performance Benchmarks
| Metric | Target | Tool |
|--------|--------|------|
| First Contentful Paint | <1.5s | Lighthouse |
| Largest Contentful Paint | <2.5s | Lighthouse |
| Time to Interactive | <3.0s | Lighthouse |
| Bundle Size (gzipped) | <200KB initial | Vite build |
| Lighthouse Score | ≥90 | Lighthouse |

### Visual Regression
- [ ] Screenshot comparison passes (95% similarity)
- [ ] Responsive layouts verified (mobile, tablet, desktop)
- [ ] Cross-browser testing passed (Chrome, Firefox, Safari, Edge)

## Overall Migration Success
| Milestone | Criteria |
|-----------|----------|
| Foundation Complete | Auth works, layout renders, routing functional |
| 50% Complete | Core + Primary CRUD modules migrated |
| 90% Complete | All modules migrated except complex |
| 100% Complete | All modules migrated, legacy decommissioned |

## Rollback Criteria
Immediate rollback if:
- Critical business function unavailable
- Data integrity issues detected
- Performance degradation >50%
- Security vulnerability identified

EOF
```

---

# PHASE 2: MODULE-WISE IMPLEMENTATION

## Step 2.0: Project Scaffolding

### Command 2.0.1: Create Modern Frontend Project
```bash
# Navigate to modern directory
cd modern

# Create Vue.js project with Vite
npm create vite@latest frontend -- --template vue-ts

# Navigate to frontend
cd frontend

# Install core dependencies
npm install vue-router@4 pinia axios

# Install form handling
npm install vee-validate @vee-validate/zod zod

# Install UI framework (choose one)
npm install vuetify@next @mdi/font
# OR
npm install primevue primeicons

# Install dev dependencies
npm install -D vitest @vue/test-utils jsdom
npm install -D eslint eslint-plugin-vue @typescript-eslint/eslint-plugin
npm install -D prettier @vue/eslint-config-prettier
npm install -D @types/node
```

### Command 2.0.2: Configure Project Structure
```bash
# Create directory structure
mkdir -p src/{views,components,composables,services,stores,types,router,assets,styles}
mkdir -p src/components/{ui,layout,forms,data-display}
mkdir -p src/services/api
mkdir -p tests/{unit,e2e}
```

### Command 2.0.3: Configure Environment
```bash
# Create environment files
cat > .env.development << 'EOF'
VITE_API_URL=https://localhost:7001/api
VITE_APP_TITLE=HRMS
VITE_ENV=development
EOF

cat > .env.production << 'EOF'
VITE_API_URL=https://api.production.com
VITE_APP_TITLE=HRMS
VITE_ENV=production
EOF
```

---

## Step 2.1: Module Migration Template

For EACH module, execute the following sequential steps:

### Step 2.1.1: Code Isolation

#### Command: Create Module Feature Branch
```bash
# Create isolated worktree for module migration
git worktree add worktrees/{module-name} -b feature/migrate-{module-name}
cd worktrees/{module-name}
```

#### Command: Isolate Legacy Module Code
```
Task (explorer): "Extract and document legacy {module-name} module.

Extract:
1. All component files
2. State management files
3. Service/API files
4. Type definitions
5. Style files
6. Test files

Output to: migration/modules/{module-name}/legacy-extraction/
Include: file-manifest.json with all file paths"
```

#### Expected Output: `migration/modules/{module-name}/legacy-extraction/file-manifest.json`
```json
{
  "module": "{module-name}",
  "components": [
    "src/modules/{module}/components/List.tsx",
    "src/modules/{module}/components/Form.tsx",
    "src/modules/{module}/components/Detail.tsx"
  ],
  "state": [
    "src/store/{module}Store.ts"
  ],
  "services": [
    "src/services/{module}Service.ts"
  ],
  "types": [
    "src/types/{module}.types.ts"
  ],
  "styles": [
    "src/modules/{module}/styles/{module}.css"
  ],
  "tests": [
    "src/modules/{module}/__tests__/*.test.tsx"
  ]
}
```

---

### Step 2.1.2: Create Feature Specification

#### Command: Generate Migration Spec
```
Task (spec-writer): "Create migration specification for {module-name}.

Read legacy files from: migration/modules/{module-name}/legacy-extraction/
API Contract from: migration/api-contracts/{module-name}/

Generate:
1. Component mapping (legacy → modern)
2. State mapping (legacy store → Pinia)
3. API integration spec
4. Route definitions
5. Acceptance criteria

Output: migration/modules/{module-name}/features/{module-name}.md"
```

#### Expected Output: Feature Spec Template
```markdown
# Feature: {Module Name}

## Status
CURRENT: ready-for-dev
FRONTEND: pending
FRONTEND_QA: pending
TYPE: crud
DEPENDS_ON: authentication, {other-deps}

## Component Mapping

| Legacy (React) | Modern (Vue) | Notes |
|----------------|--------------|-------|
| {Module}List.tsx | {Module}ListView.vue | Main list view |
| {Module}Form.tsx | {Module}Form.vue | Create/Edit form |
| {Module}Detail.tsx | {Module}DetailView.vue | Detail view |

## State Mapping

| Legacy (Zustand) | Modern (Pinia) | Notes |
|------------------|----------------|-------|
| use{Module}Store | use{Module}Store | Direct mapping |
| items[] | items: ref([]) | Reactive array |
| selectedItem | selectedItem: ref(null) | Nullable ref |

## Routes

| Path | Component | Auth Required |
|------|-----------|---------------|
| /{module} | {Module}ListView | Yes |
| /{module}/new | {Module}Form | Yes |
| /{module}/:id | {Module}DetailView | Yes |
| /{module}/:id/edit | {Module}Form | Yes |

## API Endpoints

| Method | Endpoint | Request | Response |
|--------|----------|---------|----------|
| GET | /api/{module} | query params | Array<{Entity}> |
| GET | /api/{module}/:id | - | {Entity} |
| POST | /api/{module} | {Entity}DTO | {Entity} |
| PUT | /api/{module}/:id | {Entity}DTO | {Entity} |
| DELETE | /api/{module}/:id | - | void |

## Acceptance Criteria

- [ ] List view displays all records with pagination
- [ ] Search/filter functionality works
- [ ] Create form validates all fields
- [ ] Edit form pre-populates data
- [ ] Delete shows confirmation dialog
- [ ] Loading states displayed
- [ ] Error messages match legacy
```

---

### Step 2.1.3: Refactoring/Rewrite Strategy

#### Command: Implement Modern Module
```
Task (frontend-coder with vuejs-migration-expert skill): "Implement {module-name} module.

WORKTREE: worktrees/{module-name}
FEATURE_SPEC: migration/modules/{module-name}/features/{module-name}.md
LEGACY_CODE: migration/modules/{module-name}/legacy-extraction/
API_CONTRACT: migration/api-contracts/{module-name}/{module-name}.api.md

Implementation Order:
1. Types and interfaces
2. API service
3. Pinia store
4. Composables
5. Components (smallest → largest)
6. Views (list → detail → form)
7. Route registration

CRITICAL: 100% parity with legacy behavior.

Return 'FRONTEND_COMPLETE' with file paths."
```

#### Implementation Sub-Steps:

**2.1.3.1: Create Type Definitions**
```typescript
// src/types/{module}.types.ts
export interface {Entity} {
  id: number;
  // ... fields matching API contract
  createdAt: string;
  updatedAt: string;
}

export interface {Entity}CreateDTO {
  // ... create fields
}

export interface {Entity}UpdateDTO {
  // ... update fields
}

export interface {Entity}Filter {
  search?: string;
  page?: number;
  pageSize?: number;
  sortBy?: string;
  sortOrder?: 'asc' | 'desc';
}
```

**2.1.3.2: Create API Service**
```typescript
// src/services/api/{module}.service.ts
import httpClient from './http-client';
import type { {Entity}, {Entity}CreateDTO, {Entity}Filter } from '@/types/{module}.types';

export const {module}Service = {
  async getAll(filter?: {Entity}Filter) {
    const response = await httpClient.get<{Entity}[]>('/api/{module}', { params: filter });
    return response.data;
  },

  async getById(id: number) {
    const response = await httpClient.get<{Entity}>(`/api/{module}/${id}`);
    return response.data;
  },

  async create(data: {Entity}CreateDTO) {
    const response = await httpClient.post<{Entity}>('/api/{module}', data);
    return response.data;
  },

  async update(id: number, data: {Entity}UpdateDTO) {
    const response = await httpClient.put<{Entity}>(`/api/{module}/${id}`, data);
    return response.data;
  },

  async delete(id: number) {
    await httpClient.delete(`/api/{module}/${id}`);
  }
};
```

**2.1.3.3: Create Pinia Store**
```typescript
// src/stores/{module}.store.ts
import { defineStore } from 'pinia';
import { ref, computed } from 'vue';
import { {module}Service } from '@/services/api/{module}.service';
import type { {Entity}, {Entity}Filter } from '@/types/{module}.types';

export const use{Module}Store = defineStore('{module}', () => {
  // State
  const items = ref<{Entity}[]>([]);
  const selectedItem = ref<{Entity} | null>(null);
  const loading = ref(false);
  const error = ref<string | null>(null);

  // Getters
  const itemCount = computed(() => items.value.length);

  // Actions
  async function fetchAll(filter?: {Entity}Filter) {
    loading.value = true;
    error.value = null;
    try {
      items.value = await {module}Service.getAll(filter);
    } catch (e) {
      error.value = e instanceof Error ? e.message : 'Failed to fetch';
      throw e;
    } finally {
      loading.value = false;
    }
  }

  async function fetchById(id: number) {
    loading.value = true;
    try {
      selectedItem.value = await {module}Service.getById(id);
    } finally {
      loading.value = false;
    }
  }

  // ... create, update, delete actions

  return {
    items,
    selectedItem,
    loading,
    error,
    itemCount,
    fetchAll,
    fetchById,
  };
});
```

**2.1.3.4: Create Composables**
```typescript
// src/composables/use{Module}.ts
import { use{Module}Store } from '@/stores/{module}.store';
import { storeToRefs } from 'pinia';
import { onMounted } from 'vue';

export function use{Module}() {
  const store = use{Module}Store();
  const { items, loading, error } = storeToRefs(store);

  onMounted(() => {
    store.fetchAll();
  });

  return {
    items,
    loading,
    error,
    refresh: store.fetchAll,
  };
}
```

**2.1.3.5: Create Components**
```vue
<!-- src/views/{module}/{Module}ListView.vue -->
<script setup lang="ts">
import { use{Module} } from '@/composables/use{Module}';
import { useRouter } from 'vue-router';

const router = useRouter();
const { items, loading, error, refresh } = use{Module}();

function handleCreate() {
  router.push('/{module}/new');
}

function handleEdit(id: number) {
  router.push(`/{module}/${id}/edit`);
}

function handleView(id: number) {
  router.push(`/{module}/${id}`);
}
</script>

<template>
  <div class="{module}-list">
    <header class="page-header">
      <h1>{Module} List</h1>
      <button @click="handleCreate">Add New</button>
    </header>

    <div v-if="loading" class="loading">Loading...</div>
    <div v-else-if="error" class="error">{{ error }}</div>
    <div v-else>
      <table>
        <thead>
          <tr>
            <th>ID</th>
            <th>Name</th>
            <!-- ... columns -->
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="item in items" :key="item.id">
            <td>{{ item.id }}</td>
            <td>{{ item.name }}</td>
            <!-- ... columns -->
            <td>
              <button @click="handleView(item.id)">View</button>
              <button @click="handleEdit(item.id)">Edit</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>
```

---

### Step 2.1.4: State Management Migration

#### Command: Verify State Parity
```
Task (qa-agent): "Verify state management parity for {module-name}.

Compare:
1. Legacy store shape vs Pinia store shape
2. Action behaviors match
3. Derived state (getters/computed) match
4. Side effects handled identically
5. Error states handled identically

Test scenarios:
- Initial load state
- Loading state
- Success state
- Error state
- Empty state

Output: migration/modules/{module-name}/qa/state-parity-report.md"
```

#### State Migration Checklist
```markdown
## State Migration Checklist: {Module}

### Store Structure
- [ ] All state properties mapped
- [ ] Property types match
- [ ] Initial values match
- [ ] Nullable vs required matches

### Actions
- [ ] All actions implemented
- [ ] Action signatures match
- [ ] Side effects identical
- [ ] Error handling identical

### Getters/Computed
- [ ] All derived state implemented
- [ ] Computation logic matches
- [ ] Caching behavior matches

### Persistence
- [ ] localStorage keys match
- [ ] Serialization format matches
- [ ] Rehydration works correctly
```

---

### Step 2.1.5: Routing and Navigation Updates

#### Command: Register Module Routes
```typescript
// src/router/modules/{module}.routes.ts
import type { RouteRecordRaw } from 'vue-router';

export const {module}Routes: RouteRecordRaw[] = [
  {
    path: '/{module}',
    name: '{module}-list',
    component: () => import('@/views/{module}/{Module}ListView.vue'),
    meta: { requiresAuth: true, title: '{Module} List' }
  },
  {
    path: '/{module}/new',
    name: '{module}-create',
    component: () => import('@/views/{module}/{Module}Form.vue'),
    meta: { requiresAuth: true, title: 'Create {Module}' }
  },
  {
    path: '/{module}/:id',
    name: '{module}-detail',
    component: () => import('@/views/{module}/{Module}DetailView.vue'),
    meta: { requiresAuth: true, title: '{Module} Detail' }
  },
  {
    path: '/{module}/:id/edit',
    name: '{module}-edit',
    component: () => import('@/views/{module}/{Module}Form.vue'),
    meta: { requiresAuth: true, title: 'Edit {Module}' }
  }
];
```

#### Command: Update Main Router
```typescript
// src/router/index.ts
import { {module}Routes } from './modules/{module}.routes';

const routes: RouteRecordRaw[] = [
  // ... existing routes
  ...{module}Routes,
];
```

#### Navigation Verification Checklist
```markdown
## Navigation Checklist: {Module}

### Route Registration
- [ ] All routes registered
- [ ] Route names match legacy
- [ ] Path patterns match legacy
- [ ] Route params handled correctly

### Navigation Guards
- [ ] Auth guard applied
- [ ] Permission checks work
- [ ] Redirect logic matches

### Deep Linking
- [ ] Direct URL access works
- [ ] Query params preserved
- [ ] Browser back/forward works

### Navigation UI
- [ ] Menu items added
- [ ] Breadcrumbs work
- [ ] Active state highlighted
```

---

### Step 2.1.6: UI/UX Consistency Validation

#### Command: Visual Comparison Test
```
Task (qa-agent): "Perform UI/UX consistency validation for {module-name}.

Compare legacy vs modern:
1. Layout and spacing
2. Typography
3. Colors and theming
4. Component sizes
5. Icons and imagery
6. Loading states
7. Error states
8. Empty states
9. Responsive breakpoints

Method:
- Screenshot comparison (Percy/Chromatic)
- Manual visual inspection
- Responsive testing (320px, 768px, 1024px, 1440px)

Output: migration/modules/{module-name}/qa/visual-comparison-report.md"
```

#### UI/UX Validation Checklist
```markdown
## UI/UX Validation: {Module}

### Visual Parity
- [ ] Header layout matches
- [ ] Table/list layout matches
- [ ] Form layout matches
- [ ] Button styles match
- [ ] Input styles match
- [ ] Spacing matches (within 2px)
- [ ] Colors match (within #10 hex)

### Interaction Parity
- [ ] Click targets same size
- [ ] Hover states match
- [ ] Focus states match
- [ ] Loading spinners match
- [ ] Transition timing similar

### Responsive Parity
- [ ] Mobile layout matches
- [ ] Tablet layout matches
- [ ] Desktop layout matches
- [ ] Breakpoints aligned

### Accessibility
- [ ] Tab order correct
- [ ] ARIA labels present
- [ ] Color contrast passes
- [ ] Screen reader compatible
```

---

### Step 2.1.7: Testing Implementation

#### Command: Write Unit Tests
```typescript
// tests/unit/{module}/{module}.store.test.ts
import { describe, it, expect, beforeEach, vi } from 'vitest';
import { setActivePinia, createPinia } from 'pinia';
import { use{Module}Store } from '@/stores/{module}.store';
import { {module}Service } from '@/services/api/{module}.service';

vi.mock('@/services/api/{module}.service');

describe('{Module} Store', () => {
  beforeEach(() => {
    setActivePinia(createPinia());
    vi.clearAllMocks();
  });

  describe('fetchAll', () => {
    it('should fetch all items successfully', async () => {
      const mockItems = [{ id: 1, name: 'Test' }];
      vi.mocked({module}Service.getAll).mockResolvedValue(mockItems);

      const store = use{Module}Store();
      await store.fetchAll();

      expect(store.items).toEqual(mockItems);
      expect(store.loading).toBe(false);
      expect(store.error).toBe(null);
    });

    it('should handle errors', async () => {
      vi.mocked({module}Service.getAll).mockRejectedValue(new Error('Failed'));

      const store = use{Module}Store();

      await expect(store.fetchAll()).rejects.toThrow('Failed');
      expect(store.error).toBe('Failed');
    });
  });
});
```

#### Command: Write Component Tests
```typescript
// tests/unit/{module}/{Module}ListView.test.ts
import { describe, it, expect, vi } from 'vitest';
import { mount } from '@vue/test-utils';
import { createTestingPinia } from '@pinia/testing';
import {Module}ListView from '@/views/{module}/{Module}ListView.vue';

describe('{Module}ListView', () => {
  it('should render list of items', () => {
    const wrapper = mount({Module}ListView, {
      global: {
        plugins: [
          createTestingPinia({
            initialState: {
              {module}: {
                items: [{ id: 1, name: 'Test Item' }],
                loading: false,
              },
            },
          }),
        ],
      },
    });

    expect(wrapper.text()).toContain('Test Item');
  });

  it('should show loading state', () => {
    const wrapper = mount({Module}ListView, {
      global: {
        plugins: [
          createTestingPinia({
            initialState: {
              {module}: { items: [], loading: true },
            },
          }),
        ],
      },
    });

    expect(wrapper.text()).toContain('Loading');
  });
});
```

#### Command: Write E2E Tests
```typescript
// tests/e2e/{module}.spec.ts
import { test, expect } from '@playwright/test';

test.describe('{Module} Module', () => {
  test.beforeEach(async ({ page }) => {
    // Login first
    await page.goto('/login');
    await page.fill('[data-testid="email"]', 'test@example.com');
    await page.fill('[data-testid="password"]', 'password');
    await page.click('[data-testid="login-button"]');
    await page.waitForURL('/dashboard');
  });

  test('should display {module} list', async ({ page }) => {
    await page.goto('/{module}');
    await expect(page.locator('h1')).toContainText('{Module} List');
    await expect(page.locator('table')).toBeVisible();
  });

  test('should create new {module}', async ({ page }) => {
    await page.goto('/{module}/new');
    await page.fill('[data-testid="name-input"]', 'New Item');
    await page.click('[data-testid="submit-button"]');
    await expect(page).toHaveURL('/{module}');
    await expect(page.locator('table')).toContainText('New Item');
  });

  test('should edit existing {module}', async ({ page }) => {
    await page.goto('/{module}/1/edit');
    await page.fill('[data-testid="name-input"]', 'Updated Item');
    await page.click('[data-testid="submit-button"]');
    await expect(page.locator('.success-message')).toBeVisible();
  });
});
```

#### Test Coverage Requirements
```bash
# Run tests with coverage
npm run test:coverage

# Expected output:
# ----------------------|---------|----------|---------|---------|
# File                  | % Stmts | % Branch | % Funcs | % Lines |
# ----------------------|---------|----------|---------|---------|
# {module}/             |   >80   |   >75    |   >80   |   >80   |
#   store.ts            |   >90   |   >85    |   >90   |   >90   |
#   service.ts          |   >90   |   >85    |   >90   |   >90   |
#   composables/        |   >80   |   >75    |   >80   |   >80   |
#   components/         |   >70   |   >65    |   >70   |   >70   |
# ----------------------|---------|----------|---------|---------|
```

---

### Step 2.1.8: Quality Assurance

#### Command: Run Full QA Suite
```bash
# Lint check
npm run lint

# Type check
npm run type-check

# Unit tests
npm run test:unit

# Component tests
npm run test:component

# Build verification
npm run build

# E2E tests (against .NET backend)
npm run test:e2e
```

#### Command: QA Agent Verification
```
Task (qa-agent): "Full QA verification for {module-name}.

WORKTREE: worktrees/{module-name}
QA_TYPE: frontend
API_TARGET: Existing .NET backend

Execute:
1. Run all automated tests
2. Perform manual testing checklist
3. Compare behavior with legacy
4. Document any discrepancies

Acceptance:
- All tests pass
- No visual regressions
- Behavior matches legacy exactly
- Performance within thresholds

Return 'FRONTEND_QA_PASSED' or 'QA_FAILED' with details."
```

#### QA Checklist Template
```markdown
## QA Checklist: {Module}

### Automated Tests
- [ ] Unit tests pass (100%)
- [ ] Component tests pass (100%)
- [ ] E2E tests pass (100%)
- [ ] Lint errors: 0
- [ ] Type errors: 0

### Manual Testing
- [ ] Happy path works
- [ ] Edge cases handled
- [ ] Error scenarios work
- [ ] Loading states display
- [ ] Empty states display

### Cross-Browser
- [ ] Chrome ✓
- [ ] Firefox ✓
- [ ] Safari ✓
- [ ] Edge ✓

### Performance
- [ ] Page load < 2s
- [ ] No memory leaks
- [ ] No console errors

### Accessibility
- [ ] Keyboard navigation works
- [ ] Screen reader compatible
- [ ] Color contrast passes
```

---

### Step 2.1.9: Gradual Rollout Strategy

#### Command: Feature Flag Setup
```typescript
// src/config/feature-flags.ts
export const featureFlags = {
  modules: {
    '{module}': {
      enabled: import.meta.env.VITE_FF_{MODULE}_ENABLED === 'true',
      rolloutPercentage: Number(import.meta.env.VITE_FF_{MODULE}_ROLLOUT) || 0,
    },
  },
};

export function isModuleEnabled(moduleName: string, userId?: string): boolean {
  const flag = featureFlags.modules[moduleName];
  if (!flag?.enabled) return false;

  if (flag.rolloutPercentage === 100) return true;
  if (flag.rolloutPercentage === 0) return false;

  // Hash-based consistent rollout
  if (userId) {
    const hash = hashCode(userId);
    return (hash % 100) < flag.rolloutPercentage;
  }

  return false;
}
```

#### Rollout Phases
```markdown
## Rollout Plan: {Module}

### Phase 1: Internal Testing (Day 1-3)
- Rollout: 0% (manual access only)
- Audience: QA team, developers
- Feedback: Slack channel #migration-feedback
- Rollback trigger: Any blocking bug

### Phase 2: Beta Users (Day 4-7)
- Rollout: 5%
- Audience: Internal power users
- Monitoring: Error rates, performance
- Rollback trigger: Error rate >1%

### Phase 3: Gradual Rollout (Day 8-14)
- Day 8: 10%
- Day 10: 25%
- Day 12: 50%
- Day 14: 75%
- Monitoring: Business metrics, user feedback
- Rollback trigger: Significant metric degradation

### Phase 4: Full Rollout (Day 15+)
- Rollout: 100%
- Legacy module deprecated
- Monitor for 7 days before removal
```

#### Command: Configure Rollout
```bash
# .env.production
VITE_FF_{MODULE}_ENABLED=true
VITE_FF_{MODULE}_ROLLOUT=5  # Start with 5%
```

---

### Step 2.1.10: Fallback Strategy

#### Command: Implement Fallback Routes
```typescript
// src/router/fallback.ts
import { featureFlags, isModuleEnabled } from '@/config/feature-flags';

export function registerFallbackRoutes(router: Router) {
  router.beforeEach((to, from, next) => {
    const moduleName = to.path.split('/')[1];

    if (moduleName && !isModuleEnabled(moduleName)) {
      // Redirect to legacy app
      const legacyUrl = `${LEGACY_APP_URL}${to.fullPath}`;
      window.location.href = legacyUrl;
      return;
    }

    next();
  });
}
```

#### Rollback Procedure
```markdown
## Rollback Procedure: {Module}

### Immediate Rollback (< 5 minutes)
1. Set feature flag to 0%:
   ```bash
   VITE_FF_{MODULE}_ROLLOUT=0
   ```
2. Deploy config change
3. Users automatically routed to legacy

### Hotfix Rollback (< 1 hour)
1. Identify failing commit
2. Revert merge:
   ```bash
   git revert -m 1 {merge-commit}
   ```
3. Deploy reverted build
4. Notify stakeholders

### Full Rollback (> 1 hour)
1. Disable feature flag completely
2. Remove module routes from production
3. Deploy clean build
4. Post-mortem meeting
5. Fix issues in development
6. Re-start rollout process
```

---

## Step 2.2: Module Migration Execution Commands

### For Each Module, Execute in Order:

```bash
# ============================================
# MODULE: {module-name}
# ============================================

# 1. Create worktree
git worktree add worktrees/{module-name} -b feature/migrate-{module-name}
cd worktrees/{module-name}

# 2. Run migration command
/migrate-next

# 3. Or manually dispatch:
Task (frontend-coder): "Migrate {module-name} module
WORKTREE: worktrees/{module-name}
FEATURE_FILE: migration/modules/{module-name}/features/{module-name}.md
API_CONTRACT: migration/api-contracts/{module-name}/{module-name}.api.md"

# 4. Run QA
/migrate-qa

# 5. After QA passes, merge
git checkout main
git merge feature/migrate-{module-name} --no-ff
git push origin main

# 6. Cleanup
git worktree remove worktrees/{module-name}
git branch -d feature/migrate-{module-name}

# 7. Update manifest
/migrate-status
```

---

## Summary: Complete Migration Sequence

```
┌─────────────────────────────────────────────────────────────────────────────┐
│ PHASE 1: PLANNING                                                            │
├─────────────────────────────────────────────────────────────────────────────┤
│ 1.1 Discovery & Module Identification                                        │
│ 1.2 Module Categorization (Foundation/Core/CRUD/Complex/Static)             │
│ 1.3 Migration Readiness Assessment                                          │
│ 1.4 Modern Tech Stack Definition                                            │
│ 1.5 Dependency Mapping                                                       │
│ 1.6 Migration Order Definition (Waves)                                       │
│ 1.7 Success Metrics Definition                                               │
└─────────────────────────────────────────────────────────────────────────────┘
                                     │
                                     ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│ PHASE 2: IMPLEMENTATION (Per Module)                                         │
├─────────────────────────────────────────────────────────────────────────────┤
│ For each module in migration order:                                          │
│                                                                              │
│ 2.1.1 Code Isolation         → Extract legacy module                        │
│ 2.1.2 Feature Specification  → Create migration spec                        │
│ 2.1.3 Refactoring/Rewrite    → Implement modern module                      │
│ 2.1.4 State Management       → Migrate to Pinia                             │
│ 2.1.5 Routing Updates        → Register Vue Router routes                   │
│ 2.1.6 UI/UX Validation       → Visual comparison testing                    │
│ 2.1.7 Testing                → Unit, Component, E2E tests                   │
│ 2.1.8 Quality Assurance      → Full QA suite                                │
│ 2.1.9 Gradual Rollout        → Feature flag controlled release              │
│ 2.1.10 Fallback Strategy     → Rollback procedures ready                    │
│                                                                              │
│ ──────────────────────────────────────────────────────────────────────────  │
│ Repeat for each module until 100% migration complete                         │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Appendix: Quick Reference Commands

```bash
# Initialize migration
/migrate-init

# Check status
/migrate-status

# Migrate next module
/migrate-next

# Migrate multiple modules
/migrate-batch 5

# Run QA on pending
/migrate-qa

# View human review queue
/migrate-human-review

# Resume after interruption
/migrate-resume

# Rollback if needed
/migrate-rollback {module-name}

# Compare implementations
/migrate-diff {module-name}
```
