# Migration Framework Adaptation Guide

> How to adapt this framework for any source → target tech stack migration

## Overview

This migration framework is **tech-agnostic at its core**. The orchestration layer, workflow patterns, and safety features work regardless of what technologies you're migrating between.

**Adaptation effort**: ~30-40% of agent definitions
**Time estimate**: 2-3 days for a new tech stack pair

---

## Framework Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    TECH-AGNOSTIC LAYER                      │
│  (Keep 100% - No changes needed)                            │
│                                                             │
│  • Orchestrator pattern      • Git worktree isolation       │
│  • Thin context pattern      • Status flow tracking         │
│  • Foundation gate           • Dependency validation        │
│  • Smart retry/escalation    • Atomic checkpoints           │
│  • QA verification loop      • Human review workflow        │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                   TECH-SPECIFIC LAYER                       │
│  (Adapt for your stack)                                     │
│                                                             │
│  • explorer.md         → Source tech patterns               │
│  • backend-coder.md    → Target backend implementation      │
│  • frontend-coder.md   → Target frontend implementation     │
│  • db-schema-migrator.md → Database conversion rules        │
│  • Skills & references → Tech-specific knowledge            │
└─────────────────────────────────────────────────────────────┘
```

---

## Skill Usage Strategy

This framework uses **skills** to provide deep technical expertise to agents. Skills are loaded contextually based on the agent's needs.

### Current Skills

| Skill | Purpose | Used By | When Loaded |
|-------|---------|---------|-------------|
| **react-migration-expert** | React patterns, TypeScript, Vite tooling, migration best practices | frontend-coder | Feature implementation (80% of time) |
| **nestjs-expert** | NestJS patterns, DTOs, entities, guards, testing | backend-coder | Feature implementation (80% of time) |

### Skill Design Philosophy

1. **Reference-Based, Not Prescriptive**
   - Skills provide patterns and guidance, not rigid templates
   - Agents consult skills for knowledge, not file generation
   - Foundation setup is intentionally minimal (base Vite/NestJS)

2. **Progressive Enhancement**
   - Foundation: Minimal setup (start simple)
   - Development: Reference patterns as needed (consult skills)
   - Optimization: Apply advanced configs after migration complete (see `/migration-optimize`)

3. **Quality Gates Built-In**
   - **Frontend:** `npm run type-check` + `npm run lint` before every commit
   - **Backend:** NestJS CLI usage enforced, Context7 for documentation
   - Skills document these workflows clearly

### How Skills Are Used

**During Foundation Setup (Phase 8 of `/migration-init`):**
- Backend: Uses `nestjs-expert` for module structure, health endpoint patterns
- Frontend: Uses `react-migration-expert` for Router, API client, linting setup
- **Intentionally minimal:** No complex build configs, no prescriptive folder structures

**During Feature Migration:**
- Backend-coder references `nestjs-expert` for:
  - Controller/Service/Module patterns
  - DTO validation with class-validator
  - Entity definitions with Sequelize
  - Guard and Interceptor patterns

- Frontend-coder references `react-migration-expert` for:
  - Component patterns (compound components, custom hooks)
  - State management decisions (Context, Zustand, TanStack Query)
  - TypeScript typing patterns
  - Performance optimization strategies
  - Form handling with validation

**During Optimization (After Migration):**
- Use `/migration-optimize` command
- Frontend can selectively apply advanced Vite configs
- Bundle analysis and performance tuning

### Adding New Skills

When adapting framework for different tech stacks:

1. **Create skill file:** `.claude/skills/{name}/SKILL.md`
2. **Add reference docs:** `.claude/skills/{name}/references/*.md`
3. **Update agent:** Add `skills: [{name}]` to agent frontmatter
4. **Document usage:** Explain when and how agent uses skill

**Example for Django → FastAPI migration:**
```yaml
# .claude/skills/fastapi-expert/SKILL.md
---
name: fastapi-expert
description: FastAPI patterns, Pydantic models, async endpoints
triggers:
  - FastAPI
  - Pydantic
  - async
  - uvicorn
---
```

Then update backend-coder:
```yaml
skills:
  - fastapi-expert  # Instead of nestjs-expert
```

---

## Quick Start: Adapting for Your Stack

### Step 1: Copy the Framework

```bash
# Clone the framework
cp -r .claude/ your-project/.claude/
cp -r migration/ your-project/migration/

# Clear tech-specific content
rm -rf migration/discovery/*
rm -rf migration/modules/*
echo "" > migration/manifest.md
```

### Step 2: Update Tech Stack Config

Edit `migration/tech-stack.md`:

```markdown
# Tech Stack

| Layer | Source (Legacy) | Target (Modern) |
|-------|-----------------|-----------------|
| Backend | [YOUR SOURCE] | [YOUR TARGET] |
| Frontend | [YOUR SOURCE] | [YOUR TARGET] |
| Database | [YOUR SOURCE DB] | [YOUR TARGET DB] |
| ORM | [SOURCE ORM] | [TARGET ORM] |
```

### Step 3: Adapt the Agents

See detailed adaptation guides below for each source technology.

---

## Adaptation Guide by Source Technology

### Laravel (PHP) → React + Node.js

#### Directory Mapping

```
Laravel                          →  Modern Stack
────────────────────────────────────────────────────
app/Http/Controllers/           →  backend/src/modules/*/controllers/
app/Models/                     →  backend/src/modules/*/entities/
app/Http/Requests/              →  backend/src/modules/*/dto/
resources/views/                →  frontend/src/pages/
routes/web.php, api.php         →  backend/src/modules/*/routes/
database/migrations/            →  backend/src/database/migrations/
app/Http/Middleware/            →  backend/src/common/middleware/
```

#### Concept Mapping

| Laravel | NestJS/Express | React |
|---------|----------------|-------|
| Controller | Controller/Route Handler | - |
| Model (Eloquent) | Entity (Sequelize/Prisma) | - |
| Form Request | DTO + Validation Pipe | Zod Schema |
| Blade Template | - | React Component |
| Blade Component | - | React Component |
| Middleware | NestJS Guard/Interceptor | - |
| Service Provider | Module | - |
| Facade | Injectable Service | - |
| `{{ $var }}` | - | `{var}` JSX |
| `@foreach` | - | `.map()` |
| `@if/@else` | - | Ternary/&& |

#### Explorer Agent Updates

```markdown
# In /.claude/agents/explorer.md

## Laravel-Specific Discovery

### Directory Analysis
- `app/Http/Controllers/` - Controller classes
- `app/Models/` - Eloquent models
- `app/Http/Requests/` - Form validation
- `resources/views/` - Blade templates
- `routes/` - Route definitions
- `database/migrations/` - Schema migrations
- `config/` - Configuration files

### Pattern Detection
- Route model binding
- Form request validation rules
- Eloquent relationships (hasMany, belongsTo, etc.)
- Blade directives (@auth, @can, @foreach)
- Middleware groups
```

#### Database Migration (MySQL → PostgreSQL)

| MySQL | PostgreSQL |
|-------|------------|
| `TINYINT(1)` | `BOOLEAN` |
| `INT AUTO_INCREMENT` | `SERIAL` |
| `DATETIME` | `TIMESTAMP` |
| `TEXT` | `TEXT` |
| `ENUM('a','b')` | `VARCHAR` + CHECK |
| `JSON` | `JSONB` |

---

### Vue.js → React

#### Concept Mapping

| Vue.js | React |
|--------|-------|
| `<template>` | JSX return |
| `data()` | `useState` |
| `computed` | `useMemo` |
| `watch` | `useEffect` |
| `methods` | Functions |
| `props` | Props |
| `$emit` | Callback props |
| `v-if` | `{condition && ...}` |
| `v-for` | `.map()` |
| `v-model` | `value` + `onChange` |
| `v-bind:class` | `className={...}` |
| Vuex | Redux/Zustand/Context |
| Vue Router | React Router |
| `<slot>` | `children` prop |
| `provide/inject` | Context API |

#### Component Translation Example

**Vue.js (Source)**
```vue
<template>
  <div class="user-card">
    <h2>{{ user.name }}</h2>
    <p v-if="user.email">{{ user.email }}</p>
    <button @click="handleClick">Edit</button>
  </div>
</template>

<script>
export default {
  props: ['user'],
  methods: {
    handleClick() {
      this.$emit('edit', this.user.id)
    }
  }
}
</script>
```

**React (Target)**
```tsx
interface UserCardProps {
  user: User;
  onEdit: (id: number) => void;
}

export function UserCard({ user, onEdit }: UserCardProps) {
  return (
    <div className="user-card">
      <h2>{user.name}</h2>
      {user.email && <p>{user.email}</p>}
      <button onClick={() => onEdit(user.id)}>Edit</button>
    </div>
  );
}
```

---

### .NET MVC → React + Node.js

#### Directory Mapping

```
.NET MVC                         →  Modern Stack
────────────────────────────────────────────────────
Controllers/                    →  backend/src/modules/*/controllers/
Models/                         →  backend/src/modules/*/entities/
ViewModels/                     →  frontend/src/types/ + backend/dto/
Views/                          →  frontend/src/pages/
Views/Shared/                   →  frontend/src/components/
Services/                       →  backend/src/modules/*/services/
Data/Migrations/                →  backend/src/database/migrations/
```

#### Concept Mapping

| .NET MVC | NestJS | React |
|----------|--------|-------|
| Controller | Controller | - |
| Action | Route Handler | - |
| Model | Entity | - |
| ViewModel | DTO | Props/State |
| Razor View | - | Component |
| `@Html.Partial` | - | Component import |
| `@model` | - | Props interface |
| Data Annotations | class-validator | Zod |
| Entity Framework | Sequelize/Prisma | - |
| `DbContext` | Repository | - |
| Dependency Injection | NestJS DI | - |
| `[Authorize]` | `@UseGuards()` | - |
| `[HttpGet]` | `@Get()` | - |

#### Database Migration (SQL Server → PostgreSQL)

| SQL Server | PostgreSQL |
|------------|------------|
| `NVARCHAR(n)` | `VARCHAR(n)` |
| `NVARCHAR(MAX)` | `TEXT` |
| `DATETIME2` | `TIMESTAMP` |
| `BIT` | `BOOLEAN` |
| `UNIQUEIDENTIFIER` | `UUID` |
| `IDENTITY` | `SERIAL` |
| `MONEY` | `DECIMAL(19,4)` |
| `VARBINARY(MAX)` | `BYTEA` |

---

### Django (Python) → React + Node.js

#### Directory Mapping

```
Django                           →  Modern Stack
────────────────────────────────────────────────────
app/views.py                    →  backend/src/modules/*/controllers/
app/models.py                   →  backend/src/modules/*/entities/
app/serializers.py              →  backend/src/modules/*/dto/
app/templates/                  →  frontend/src/pages/
app/forms.py                    →  frontend/src/components/ (forms)
app/urls.py                     →  backend/src/modules/*/routes/
```

#### Concept Mapping

| Django | NestJS | React |
|--------|--------|-------|
| View/ViewSet | Controller | - |
| Model | Entity | - |
| Serializer | DTO | - |
| Template | - | Component |
| Form | - | React Hook Form |
| `{% for %}` | - | `.map()` |
| `{% if %}` | - | Conditional render |
| `{{ var }}` | - | `{var}` |
| Django ORM | Sequelize/Prisma | - |
| `@login_required` | `@UseGuards()` | - |
| Middleware | Middleware/Interceptor | - |

---

### Rails (Ruby) → React + Node.js

#### Directory Mapping

```
Rails                            →  Modern Stack
────────────────────────────────────────────────────
app/controllers/                →  backend/src/modules/*/controllers/
app/models/                     →  backend/src/modules/*/entities/
app/views/                      →  frontend/src/pages/
app/helpers/                    →  frontend/src/utils/
app/services/                   →  backend/src/modules/*/services/
db/migrate/                     →  backend/src/database/migrations/
```

#### Concept Mapping

| Rails | NestJS | React |
|-------|--------|-------|
| Controller | Controller | - |
| Action | Route Handler | - |
| Model (ActiveRecord) | Entity | - |
| View (ERB) | - | Component |
| Partial | - | Component |
| Helper | - | Utility function |
| Service Object | Service | - |
| `before_action` | Guard/Interceptor | - |
| Strong Parameters | DTO + Validation | - |
| `<%= %>` | - | `{}` |
| `<% if %>` | - | Conditional |
| `<% @items.each %>` | - | `.map()` |

---

## Agent Template Updates

### Explorer Agent Template

```markdown
# Explorer Agent - [SOURCE TECH]

## Purpose
Analyze legacy [SOURCE] codebase and create discovery documents.

## Directory Patterns
- [List source tech directories]
- [Explain what each contains]

## Discovery Outputs
1. `overview.md` - Framework version, dependencies, architecture
2. `modules.json` - Module/feature breakdown
3. `database-schema.md` - Tables, relationships
4. `ui-framework.json` - CSS framework, component library

## Pattern Detection
- [Source tech specific patterns to identify]
- [Relationships and dependencies]
- [Authentication patterns]
- [Validation patterns]

## Return Format
ACTION_COMPLETE
FILES: [discovery file paths]
STATS: modules=N, features=N
```

### Backend Coder Agent Template

```markdown
# Backend Coder Agent - [SOURCE] → [TARGET]

## Purpose
Implement [TARGET] backend from [SOURCE] legacy code.

## Input
- Legacy file paths
- Feature spec path
- API contract template

## Mappings
| [SOURCE] | [TARGET] |
|----------|----------|
| [concept] | [equivalent] |

## Output Structure
- `modules/{name}/`
  - `{name}.module.ts`
  - `{name}.controller.ts`
  - `{name}.service.ts`
  - `dto/`
  - `entities/`

## Parity Rules
- Match exact validation logic
- Same response shapes
- Same error messages
- Same status codes
```

### Frontend Coder Agent Template

```markdown
# Frontend Coder Agent - [SOURCE] → [TARGET]

## Purpose
Implement [TARGET] frontend from [SOURCE] templates/views.

## Input
- Legacy view/template paths
- API contract (from backend)
- Feature spec

## Mappings
| [SOURCE TEMPLATE] | [TARGET COMPONENT] |
|-------------------|-------------------|
| [syntax] | [equivalent] |

## Output Structure
- `pages/` - Route components
- `components/` - Reusable UI
- `hooks/` - Custom hooks
- `services/` - API calls

## Parity Rules
- Exact same layout
- Same CSS classes/styles
- Same form behavior
- Same validation messages
```

---

## Checklist: Adapting for New Stack

### Phase 1: Setup
- [ ] Copy framework structure
- [ ] Update `tech-stack.md`
- [ ] Clear previous discovery data

### Phase 2: Agent Updates
- [ ] Update `explorer.md` for source tech
- [ ] Update `backend-coder.md` for target backend
- [ ] Update `frontend-coder.md` for target frontend
- [ ] Update `db-schema-migrator.md` for DB conversion

### Phase 3: Skill References
- [ ] Add source tech knowledge to skills
- [ ] Add target tech patterns
- [ ] Update validation rules

### Phase 4: Test Run
- [ ] Run `/migrate-init` on sample project
- [ ] Verify discovery output
- [ ] Test one feature migration
- [ ] Validate QA checks work

---

## Common Target Stacks

| Target | Backend | Frontend | Database |
|--------|---------|----------|----------|
| MERN | Express | React | MongoDB |
| T3 | tRPC + Next.js | React | PostgreSQL |
| NestJS + React | NestJS | React | PostgreSQL |
| Next.js Full | Next.js API | Next.js | PostgreSQL |
| Fastify + Vue | Fastify | Vue 3 | PostgreSQL |

---

## FAQ

### Q: Do I need to rewrite the orchestrator?
**No.** The orchestrator is 100% tech-agnostic. It only manages workflow, not implementation.

### Q: What about the QA agent?
The QA agent needs **minor updates** to its checklists. The retry logic and workflow stay the same.

### Q: Can I migrate to a different frontend framework?
**Yes.** Just update `frontend-coder.md` with the target framework mappings (Vue, Angular, Svelte, etc.)

### Q: What if my source tech isn't listed?
Follow the same pattern:
1. Document directory structure
2. Map concepts to target
3. Update explorer for your source
4. Update coders for your target

### Q: Can I use this for mobile app migrations?
**Yes**, with additional agents for mobile-specific concerns (React Native, Flutter, etc.)

---

## Support Matrix

| Source | → React+Node | → Next.js | → Vue+Node |
|--------|--------------|-----------|------------|
| Laravel | ✅ Documented | ✅ Adaptable | ✅ Adaptable |
| .NET MVC | ✅ Documented | ✅ Adaptable | ✅ Adaptable |
| Django | ✅ Documented | ✅ Adaptable | ✅ Adaptable |
| Rails | ✅ Documented | ✅ Adaptable | ✅ Adaptable |
| Vue.js | ✅ Documented | ✅ Adaptable | N/A |
| Angular | ✅ Adaptable | ✅ Adaptable | ✅ Adaptable |
| Spring | ✅ Adaptable | ✅ Adaptable | ✅ Adaptable |

---

*Guide Version: 1.0.0*
