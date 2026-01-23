---
description: Initialize migration - discover legacy, scaffold projects (Frontend First approach)
allowed-tools: Read, Glob, Grep, Bash, Write, Edit, AskUserQuestion, Task
---

# Initialize Migration (Frontend First Approach)

## Migration Strategy: Frontend First

```
┌─────────────────────────────────────────────────────────────────────────┐
│ PHASE 1: FRONTEND MIGRATION                                             │
│ - Vue.js frontend talks to EXISTING .NET backend                        │
│ - No backend changes needed initially                                   │
│ - Full frontend parity with legacy React app                            │
└─────────────────────────────────────────────────────────────────────────┘
                                    ↓
┌─────────────────────────────────────────────────────────────────────────┐
│ PHASE 2: BACKEND MIGRATION (Later)                                      │
│ - Migrate .NET APIs to Node.js/Express                                  │
│ - Same SQL Server database (no DB migration)                            │
│ - Switch frontend to new backend incrementally                          │
└─────────────────────────────────────────────────────────────────────────┘
```

## Thin Context: Main agent NEVER reads legacy/discovery/spec contents

## Phase 1: Prerequisites

```bash
ls -la legacy/ 2>/dev/null || echo "NO_LEGACY_FOLDER"
ls -la legacy/Frontend/ 2>/dev/null || echo "NO_FRONTEND_FOLDER"
ls -la legacy/Backend/ 2>/dev/null || echo "NO_BACKEND_FOLDER"
```

**Note**:
- No Docker required - we use the existing SQL Server database
- Frontend First: Vue.js app will talk to existing .NET backend during migration

## Phase 2: Verify Legacy .NET Backend is Running

```bash
# The existing .NET backend must be running for frontend development
# Ask user for the .NET backend URL
```

AskUserQuestion:
- What is the URL of the existing .NET backend API? (e.g., https://localhost:7001/api or http://localhost:5000/api)
- Is the .NET backend currently running and accessible?

Store in `/migration/legacy-api-config.md`:
```markdown
# Legacy API Configuration
LEGACY_API_URL: {user_provided_url}
LEGACY_API_RUNNING: true/false
```

## Phase 3: Discovery (Sub-Agent)

```
Task (explorer): "Analyze legacy at /legacy.
Focus on:
1. Frontend structure (React components, pages, routes, state management)
2. Backend API endpoints (controllers, response shapes)
3. UI framework (MUI/CSS)
Create discovery files. Return ONLY paths and counts."
```

Wait for: `DISCOVERY_COMPLETE` with stats.

**Expected discovery outputs:**
- `/migration/discovery/overview.md` - Tech stack summary
- `/migration/discovery/modules.md` - Module breakdown
- `/migration/discovery/frontend-routes.json` - All React routes
- `/migration/discovery/api-endpoints.json` - All .NET API endpoints
- `/migration/discovery/ui-framework.json` - CSS/UI framework details

## Phase 4: Document Existing API Contracts (CRITICAL)

**Before ANY frontend work, document all existing .NET API responses.**

```
Task (explorer): "Extract ALL API contracts from legacy .NET backend.
For each controller in legacy/Backend/**/Controllers/:
1. Extract endpoint URL, method, request/response shapes
2. Document authentication requirements
3. Create API contract file

Output: /migration/api-contracts/{module}/{endpoint}.api.md
Return ONLY paths created."
```

This is critical because Vue.js frontend must call EXACT same endpoints with SAME request/response shapes.

## Phase 5: Create Feature Specs (Parallel Sub-Agents)

```bash
cat migration/discovery/modules.json | jq -r '.modules[].name'
```

For each module IN PARALLEL:
```
Task (spec-writer): "Create specs for module '{module}'.
DISCOVERY: /migration/discovery/modules.json
Focus on FRONTEND features (React → Vue.js migration).
Return ONLY paths."
```

## Phase 6: Tech Stack Confirmation (User Discussion)

AskUserQuestion:
- State Management: Pinia (Recommended) | Vuex | None
- Form Handling: VeeValidate + Zod (Recommended) | FormKit | Native
- UI Framework: Vuetify (MUI equivalent) | Copy MUI CSS | Custom
- Ready to scaffold Vue.js project?

Write to `/migration/tech-stack.md`:
```markdown
# Tech Stack Configuration

## Migration Approach
APPROACH: Frontend First
PHASE: 1 - Frontend Migration

## Legacy Stack (Source)
| Layer | Technology |
|-------|------------|
| Frontend | React 18 + TypeScript + MUI |
| Backend | .NET 8.0 |
| Database | SQL Server |

## Modern Stack (Target)
| Layer | Technology |
|-------|------------|
| Frontend | Vue.js 3 + TypeScript + Vite + Pinia |
| Backend | Node.js + Express (Phase 2) |
| Database | SQL Server (same - no migration) |

## Frontend First Strategy
- Vue.js frontend connects to EXISTING .NET backend
- All API contracts documented from .NET controllers
- Backend migration happens AFTER frontend is complete

## Frontend Decisions
STATE_MANAGEMENT: Pinia
FORM_HANDLING: VeeValidate + Zod
UI_FRAMEWORK: {user_choice}
```

## Phase 7: Scaffold Vue.js Frontend Project

```bash
# Create frontend with Vite + Vue + TypeScript
cd modern
npm create vite@latest frontend -- --template vue-ts
cd frontend
npm install

# Install core dependencies
npm install vue-router@4 pinia axios
npm install vee-validate @vee-validate/zod zod

# Install dev dependencies
npm install -D eslint eslint-plugin-vue
npm install -D @typescript-eslint/eslint-plugin @typescript-eslint/parser
npm install -D prettier

# CSS framework (based on discovery)
# Option 1: Vuetify (MUI equivalent for Vue)
npm install vuetify@next @mdi/font

# Option 2: If copying MUI CSS directly, no additional install needed
```

## Phase 8: Frontend Foundation Setup (CRITICAL)

**CRITICAL**: Frontend foundation must be complete before ANY feature migration.

Use Sub-Agent with vuejs-migration-expert skill:

```
Task (frontend-coder with vuejs-migration-expert skill): "Setup frontend foundation for modern/frontend.

CRITICAL: This Vue.js app will connect to the EXISTING .NET backend at {LEGACY_API_URL}.

1. Read and implement ALL requirements from .claude/templates/frontend-foundation-setup.md
2. Configure axios/http-client to point to EXISTING .NET backend
3. Setup auth integration (use same JWT tokens from .NET backend)
4. Install linting and formatting tools
5. Create layout components matching legacy React app
6. Verify connection to .NET backend works

Return ONLY: paths created + verification result."
```

### 8.1 Configure HTTP Client for .NET Backend

```typescript
// modern/frontend/src/services/api/http-client.ts
import axios from 'axios';

// CRITICAL: Point to EXISTING .NET backend during frontend migration
const httpClient = axios.create({
  baseURL: import.meta.env.VITE_API_URL || 'https://localhost:7001/api',
  timeout: 30000,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Add JWT token to requests (same token format as .NET backend expects)
httpClient.interceptors.request.use((config) => {
  const token = localStorage.getItem('accessToken');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

// Handle 401 responses
httpClient.interceptors.response.use(
  (response) => response,
  async (error) => {
    if (error.response?.status === 401) {
      // Redirect to login
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

export default httpClient;
```

### 8.2 Environment Configuration

```bash
# modern/frontend/.env.development
# Point to EXISTING .NET backend
VITE_API_URL=https://localhost:7001/api

# modern/frontend/.env.production
# Will point to new Node.js backend AFTER Phase 2
VITE_API_URL=https://api.production.com
```

### 8.3 Frontend Package.json Scripts

```json
{
  "scripts": {
    "dev": "vite",
    "build": "vue-tsc && vite build",
    "preview": "vite preview",
    "lint": "eslint . --ext .vue,.ts,.tsx --report-unused-disable-directives --max-warnings 0",
    "lint:fix": "eslint . --ext .vue,.ts,.tsx --fix",
    "format": "prettier --write \"src/**/*.{vue,ts,tsx,json,css,scss,md}\"",
    "format:check": "prettier --check \"src/**/*.{vue,ts,tsx,json,css,scss,md}\"",
    "type-check": "vue-tsc --noEmit"
  }
}
```

### 8.4 ESLint Configuration

```javascript
// modern/frontend/.eslintrc.cjs
module.exports = {
  root: true,
  env: { browser: true, es2020: true, node: true },
  extends: [
    'eslint:recommended',
    'plugin:@typescript-eslint/recommended',
    'plugin:vue/vue3-recommended',
  ],
  parser: 'vue-eslint-parser',
  parserOptions: {
    parser: '@typescript-eslint/parser',
    ecmaVersion: 2020,
    sourceType: 'module',
  },
  plugins: ['@typescript-eslint'],
  rules: {
    'vue/multi-word-component-names': 'off',
    '@typescript-eslint/no-unused-vars': ['error', { argsIgnorePattern: '^_' }],
  },
};
```

### 8.5 Prettier Configuration

```json
// modern/frontend/.prettierrc
{
  "semi": true,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "es5",
  "printWidth": 100,
  "arrowParens": "always"
}
```

## Phase 9: Verify Frontend Foundation

**Frontend foundation is complete when:**

1. Vue.js app loads without errors
2. Can authenticate against .NET backend (login works)
3. Layout matches legacy React app (header, sidebar, footer)
4. Protected routes redirect to login
5. API calls to .NET backend work with JWT token
6. At least one page fetches data from .NET backend successfully

```bash
# Verify
cd modern/frontend
npm run dev
# Open http://localhost:5173
# Login should work against .NET backend
# Verify API calls work
```

## Phase 10: Create Manifest

Write `/migration/manifest.md`:

```markdown
# Migration Manifest

## State
STATUS: initialized
PHASE: frontend-migration
APPROACH: frontend-first
CREATED: {date}

## Paths
LEGACY_FRONTEND: /legacy/Frontend
LEGACY_BACKEND: /legacy/Backend
LEGACY_API_URL: {configured_url}
MODERN_FRONTEND: /modern/frontend
MODERN_BACKEND: /modern/backend (Phase 2)
WORKTREES_DIR: /worktrees

## Progress - Frontend Migration (Phase 1)
TOTAL_FRONTEND_FEATURES: {count}
FRONTEND_COMPLETED: 0
FRONTEND_IN_PROGRESS: 0
FRONTEND_READY_FOR_QA: 0
FRONTEND_PERCENT: 0%

## Progress - Backend Migration (Phase 2)
TOTAL_BACKEND_FEATURES: 0 (not started)
BACKEND_COMPLETED: 0
BACKEND_PERCENT: 0%

## Foundation Gate
FRONTEND_FOUNDATION_COMPLETE: false
BACKEND_FOUNDATION_COMPLETE: false (Phase 2)

## Active Worktrees
ACTIVE_WORKTREES: none
```

## Phase 11: Prepare Backend Structure (For Phase 2)

**Note**: Backend is NOT implemented yet, just create placeholder structure.

```bash
mkdir -p modern/backend
echo "# Node.js Backend (Phase 2)" > modern/backend/README.md
echo "This backend will be implemented AFTER frontend migration is complete." >> modern/backend/README.md
echo "Currently, the Vue.js frontend connects to the existing .NET backend." >> modern/backend/README.md
```

## Phase 12: Commit

```bash
git add migration/ modern/
git commit -m "chore: initialize frontend-first migration framework"
```

## Output

```
MIGRATION INITIALIZED (Frontend First Approach)

Phase 1: Frontend Migration
  - Legacy Frontend: React 18 + MUI
  - Target Frontend: Vue.js 3 + TypeScript + Pinia
  - API Backend: Existing .NET (unchanged)
  - Modules: N | Features: N

Phase 2: Backend Migration (Later)
  - Target Backend: Node.js + Express
  - Database: SQL Server (same)

Frontend Foundation: {COMPLETE|INCOMPLETE}

Next Steps:
  1. Verify .NET backend is running at {LEGACY_API_URL}
  2. Run /migrate-status to see feature queue
  3. Run /migrate-next to start frontend migration
```
