---
description: Adapt migration framework to a different tech stack
allowed-tools: Read, Glob, Grep, Bash, Write, Edit, AskUserQuestion, Task
argument-hint: "Target Stack: frontend: <framework>, backend: <framework>, legacy is Frontend: <framework> and backend: <framework>"
---

# Adapt Migration Framework to New Tech Stack

Parse the tech stack specification from: `$ARGUMENTS`

If no arguments provided, ask user for:
- Legacy frontend framework (React, Vue, Angular, Blade, Razor, etc.)
- Legacy backend framework (.NET, Laravel, Django, Rails, Spring, etc.)
- Target frontend framework (React, Vue, Svelte, Angular, etc.)
- Target backend framework (NestJS, Express, FastAPI, Laravel, Django, etc.)
- Target database (PostgreSQL, MySQL, SQL Server - same, MongoDB, etc.)

## Phase 1: Parse Tech Stack Specification

Extract from arguments or ask user:
```
LEGACY_FRONTEND: [extracted]
LEGACY_BACKEND: [extracted]
TARGET_FRONTEND: [extracted]
TARGET_BACKEND: [extracted]
TARGET_DATABASE: [extracted or "same" to keep existing database]
MIGRATION_APPROACH: [frontend-first | backend-first | parallel]
```

## Phase 2: Update Tech Stack Config

Write to `/migration/tech-stack.md`:
```markdown
# Tech Stack Configuration

## Migration Approach
APPROACH: {frontend-first | backend-first | parallel}
PHASE: 1 - {Frontend | Backend} Migration

## Legacy Stack (Source)
| Layer | Technology |
|-------|------------|
| Frontend | {LEGACY_FRONTEND} |
| Backend | {LEGACY_BACKEND} |
| Database | {detected from legacy} |

## Modern Stack (Target)
| Layer | Technology |
|-------|------------|
| Frontend | {TARGET_FRONTEND} |
| Backend | {TARGET_BACKEND} |
| Database | {TARGET_DATABASE} |

## Adaptation Date
Generated: [timestamp]

## Concept Mappings
[Auto-generated based on stack combination]
```

## Phase 3: Update Explorer Agent

Edit `/.claude/agents/explorer.md`:
- Update description to reference LEGACY_BACKEND and LEGACY_FRONTEND
- Update directory patterns for source framework
- Update discovery output format

**Framework-specific patterns to add:**

### React Frontend (Legacy)
```
- src/components/ → React components
- src/pages/ or src/views/ → Page components
- src/hooks/ → Custom hooks
- src/store/ → State management (Redux/Zustand)
- src/services/ → API services
- src/types/ → TypeScript types
```

### Vue.js Frontend
```
- src/components/ → Vue components (.vue SFCs)
- src/views/ → Page components
- src/composables/ → Composable functions
- src/stores/ → Pinia stores
- src/services/ → API services
- src/router/ → Vue Router config
```

### .NET Backend (Legacy)
```
- Controllers/ → API controllers
- Services/ → Business logic
- Models/ → Entity classes
- DTOs/ → Data transfer objects
- Data/ → DbContext, repositories
```

### Node.js/Express Backend
```
- src/modules/{module}/ → Feature modules
  - {module}.routes.ts → Express router
  - {module}.controller.ts → Request handlers
  - {module}.service.ts → Business logic with mssql
  - dto/ → Zod schemas
  - types/ → TypeScript interfaces
- src/middleware/ → Express middleware
- src/config/ → Database, environment config
```

### Laravel (PHP)
```
- app/Http/Controllers/ → Controller classes
- app/Models/ → Eloquent models
- resources/views/ → Blade templates
- routes/web.php, api.php → Route definitions
- database/migrations/ → Schema migrations
```

### Django (Python)
```
- app/views.py → View functions/classes
- app/models.py → Django ORM models
- app/templates/ → Django templates
- app/urls.py → URL routing
- app/serializers.py → DRF serializers
```

### Angular Frontend
```
- src/app/components/ → Angular components
- src/app/services/ → Injectable services
- src/app/models/ → TypeScript interfaces
- src/app/modules/ → Feature modules
```

## Phase 4: Update/Create Backend Coder Agent

Edit `/.claude/agents/backend-coder.md`:

### For Node.js/Express Target (Current Default)
- Express routing patterns with TypeScript
- mssql for SQL Server database access
- Zod for validation
- Reference `nodejs-express-expert` skill

### For NestJS Target
- NestJS patterns (modules, controllers, services)
- TypeORM or Sequelize for database
- class-validator for validation
- Reference `nestjs-expert` skill

### For FastAPI Target
- FastAPI patterns (Pydantic, async)
- SQLAlchemy for database
- Reference `fastapi-expert` skill

### For Laravel Target
- Laravel patterns (Eloquent, controllers)
- Reference `laravel-expert` skill

## Phase 5: Update/Create Frontend Coder Agent

Edit `/.claude/agents/frontend-coder.md`:

### For Vue.js Target (Current Default)
- Vue 3 Composition API with `<script setup>`
- Pinia for state management
- VeeValidate + Zod for forms
- Vue Router for routing
- Reference `vuejs-migration-expert` skill

### For React Target
- React 18+ with hooks
- Zustand or Redux for state
- React Hook Form + Zod for forms
- React Router for routing
- Reference `react-migration-expert` skill

### For Svelte Target
- Svelte/SvelteKit patterns
- Reference `svelte-expert` skill

### For Angular Target
- Angular patterns
- Reference `angular-expert` skill

## Phase 6: Create/Update Skills

Based on target stack, ensure appropriate skills exist:

### Backend Skills Matrix
| Target | Skill Name | Status |
|--------|------------|--------|
| Node.js/Express | nodejs-express-expert | Current |
| NestJS | nestjs-expert | Available |
| FastAPI | fastapi-expert | Create if needed |
| Laravel | laravel-expert | Create if needed |
| Django | django-expert | Create if needed |

### Frontend Skills Matrix
| Target | Skill Name | Status |
|--------|------------|--------|
| Vue.js | vuejs-migration-expert | Current |
| React | react-migration-expert | Available |
| Svelte | svelte-expert | Create if needed |
| Angular | angular-expert | Create if needed |

For each missing skill, create minimal SKILL.md with:
- Framework-specific patterns
- Directory structure conventions
- Common migration mappings

## Phase 7: Update Concept Mappings Reference

Update `/.claude/refs/tech-stack-mappings.md` with bidirectional mappings.

### Current Migration: React.js → Vue.js 3

| React.js | Vue.js 3 |
|----------|----------|
| Function Component | `<script setup>` SFC |
| `useState(initial)` | `ref(initial)` |
| `useMemo(() => ..., [deps])` | `computed(() => ...)` |
| `useEffect(() => {}, [])` | `onMounted(() => {})` |
| `useEffect(() => {}, [dep])` | `watch(dep, () => {})` |
| Custom Hook | Composable (`use{Name}.ts`) |
| `props.children` | `<slot />` |
| `onClick={handler}` | `@click="handler"` |
| `{condition && <div>}` | `<div v-if="condition">` |
| `{items.map(i => <X />)}` | `<X v-for="i in items" />` |
| Zustand store | Pinia store |
| React Router | Vue Router |
| React Hook Form | VeeValidate |

### Current Migration: .NET → Node.js/Express

| .NET WebAPI | Node.js/Express |
|-------------|-----------------|
| Controller | Controller + Router |
| Service | Service class |
| Repository/Dapper | Service with mssql |
| `[HttpGet]` | `router.get()` |
| `[Authorize]` | `authMiddleware` |
| Data Annotations | Zod validators |
| `IActionResult` | `res.json()` |
| `@param` | `.input('param', sql.Type, value)` |

## Phase 8: Update Database Config

Edit `/.claude/agents/db-schema-migrator.md` or database config:

### Same Database (No Migration)
- **Current:** SQL Server → SQL Server (same)
- Use `mssql` driver in Node.js/Express
- No schema migration needed
- Same connection string format

### PostgreSQL Target
- Sequelize or TypeORM
- Generate migrations from legacy schema

### MySQL Target
- mysql2 driver or Sequelize
- Generate migrations

## Phase 9: Update Manifest Template

Ensure `/migration/manifest.md` template includes:
- `MIGRATION_APPROACH: frontend-first | backend-first`
- `FRONTEND_FOUNDATION_COMPLETE: false`
- `BACKEND_FOUNDATION_COMPLETE: false`
- Progress tracking for both phases

## Phase 10: Update CLAUDE.md

Edit `/CLAUDE.md`:
- Update tech stack table
- Update migration approach description
- Update command descriptions

## Phase 11: Validate Adaptation

Run checks:
```bash
# Verify all agent files are valid
ls -la .claude/agents/*.md

# Verify skills exist
ls -la .claude/skills/*/SKILL.md

# Verify tech-stack.md is updated
cat migration/tech-stack.md

# Verify refs are updated
cat .claude/refs/tech-stack-mappings.md
```

## Phase 12: Summary Report

Output:
```
FRAMEWORK ADAPTED

Source Stack:
  - Frontend: {LEGACY_FRONTEND}
  - Backend: {LEGACY_BACKEND}
  - Database: {LEGACY_DATABASE}

Target Stack:
  - Frontend: {TARGET_FRONTEND}
  - Backend: {TARGET_BACKEND}
  - Database: {TARGET_DATABASE}

Migration Approach: {frontend-first | backend-first | parallel}

Files Modified:
  - /.claude/agents/explorer.md
  - /.claude/agents/backend-coder.md
  - /.claude/agents/frontend-coder.md
  - /.claude/refs/tech-stack-mappings.md
  - /migration/tech-stack.md
  - /CLAUDE.md

Skills Available:
  - Frontend: {skill-name}
  - Backend: {skill-name}

Next Steps:
  1. Run /migrate-init to discover legacy codebase
  2. Review generated discovery files
  3. Start migration with /migrate-next
```

---

## Common Stack Combinations

### React → Vue.js + .NET → Node.js/Express (CURRENT)
**Migration Approach:** Frontend First

**Frontend (Phase 1):**
- React components → Vue SFCs with `<script setup>`
- useState → ref()
- useEffect → onMounted/watch
- Zustand → Pinia
- React Router → Vue Router
- React Hook Form → VeeValidate + Zod
- **API Target:** Existing .NET backend

**Backend (Phase 2):**
- .NET Controllers → Express routes + controllers
- Entity Framework/Dapper → mssql driver
- Data Annotations → Zod schemas
- **Database:** Same SQL Server (no migration)

### React → Vue.js (Frontend Only)
- `<template>` + `<script setup>` syntax
- `ref()` and `reactive()` for state
- `computed()` for derived state
- `watch()` and `watchEffect()` for side effects
- Pinia for global state
- Vue Router for routing

### Vue.js → React
- Vue SFCs → React function components
- `ref()` → `useState()`
- `computed()` → `useMemo()`
- `watch()` → `useEffect()`
- Pinia → Zustand/Redux
- Vue Router → React Router

### .NET → NestJS
- Controllers → NestJS Controllers (decorators similar)
- Services → Injectable services
- Entity Framework → TypeORM/Sequelize
- Data Annotations → class-validator
- Middleware → NestJS Guards/Interceptors

### Laravel → Node.js/Express
- Blade templates → Frontend framework
- Eloquent → Service with SQL driver
- Form Requests → Zod schemas
- Laravel routes → Express Router
- Auth middleware → Express middleware

### Django → Node.js/Express
- Django templates → Frontend framework
- Django ORM → Service with SQL driver
- Serializers → Zod DTOs
- URLConf → Express routes
- @login_required → authMiddleware

### Angular → React
- Components → React components
- Services → Custom hooks + Context
- NgModules → Just imports
- RxJS → TanStack Query
- Angular Router → React Router

### Angular → Vue.js
- Components → Vue SFCs
- Services → Composables or Pinia
- @Input/@Output → defineProps/defineEmits
- *ngIf/*ngFor → v-if/v-for
- RxJS → ref + watch
