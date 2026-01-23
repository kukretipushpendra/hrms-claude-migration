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
- Target database (PostgreSQL, MySQL, MongoDB, etc.)

## Phase 1: Parse Tech Stack Specification

Extract from arguments or ask user:
```
LEGACY_FRONTEND: [extracted]
LEGACY_BACKEND: [extracted]
TARGET_FRONTEND: [extracted]
TARGET_BACKEND: [extracted]
TARGET_DATABASE: [extracted or default to PostgreSQL]
```

## Phase 2: Update Tech Stack Config

Write to `/migration/tech-stack.md`:
```markdown
# Tech Stack Configuration

| Layer | Source (Legacy) | Target (Modern) |
|-------|-----------------|-----------------|
| Frontend | {LEGACY_FRONTEND} | {TARGET_FRONTEND} |
| Backend | {LEGACY_BACKEND} | {TARGET_BACKEND} |
| Database | [from legacy] | {TARGET_DATABASE} |

## Adaptation Date
Generated: [timestamp]

## Concept Mappings
[Auto-generated based on stack combination]
```

## Phase 3: Update Explorer Agent

Edit `/.claude/agents/explorer.md`:
- Update description to reference LEGACY_BACKEND
- Update directory patterns for source framework
- Update discovery output format

**Framework-specific patterns to add:**

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

### Rails (Ruby)
```
- app/controllers/ → Controller classes
- app/models/ → ActiveRecord models
- app/views/ → ERB templates
- config/routes.rb → Route definitions
- db/migrate/ → Schema migrations
```

### Spring (Java)
```
- src/main/java/**/controller/ → REST controllers
- src/main/java/**/model/ → Entity classes
- src/main/java/**/repository/ → JPA repositories
- src/main/resources/templates/ → Thymeleaf templates
```

### Vue.js Frontend
```
- src/components/ → Vue components
- src/views/ → Page components
- src/store/ → Vuex/Pinia store
- src/router/ → Vue Router config
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

### For NestJS Target (default)
- Keep existing NestJS patterns
- Update skill reference to `nestjs-expert`

### For Express Target
- Update to Express routing patterns
- Create/reference `express-expert` skill

### For FastAPI Target
- Update to FastAPI patterns (Pydantic, async)
- Create/reference `fastapi-expert` skill

### For Laravel Target
- Update to Laravel patterns (Eloquent, controllers)
- Create/reference `laravel-expert` skill

### For Django Target
- Update to Django patterns (DRF, serializers)
- Create/reference `django-expert` skill

## Phase 5: Update/Create Frontend Coder Agent

Edit `/.claude/agents/frontend-coder.md`:

### For React Target (default)
- Keep existing React patterns
- Update skill reference to `react-migration-expert`

### For Vue Target
- Update to Vue 3 Composition API patterns
- Create/reference `vue-expert` skill
- Update component syntax mappings

### For Svelte Target
- Update to Svelte/SvelteKit patterns
- Create/reference `svelte-expert` skill

### For Angular Target
- Update to Angular patterns
- Create/reference `angular-expert` skill

## Phase 6: Create/Update Skills

Based on target stack, ensure appropriate skills exist:

### Backend Skills Matrix
| Target | Skill Name | Create If Missing |
|--------|------------|-------------------|
| NestJS | nestjs-expert | Exists |
| Express | express-expert | Create |
| FastAPI | fastapi-expert | Create |
| Laravel | laravel-expert | Create |
| Django | django-expert | Create |

### Frontend Skills Matrix
| Target | Skill Name | Create If Missing |
|--------|------------|-------------------|
| React | react-migration-expert | Exists |
| Vue | vue-expert | Create |
| Svelte | svelte-expert | Create |
| Angular | angular-expert | Create |

For each missing skill, create minimal SKILL.md with:
- Framework-specific patterns
- Directory structure conventions
- Common migration mappings

## Phase 7: Update Concept Mappings Reference

Create/update `/.claude/refs/concept-mappings.md` with bidirectional mappings:

```markdown
# {LEGACY_BACKEND} → {TARGET_BACKEND} Mappings

| {LEGACY_BACKEND} | {TARGET_BACKEND} |
|------------------|------------------|
| [concept] | [equivalent] |
...

# {LEGACY_FRONTEND} → {TARGET_FRONTEND} Mappings

| {LEGACY_FRONTEND} | {TARGET_FRONTEND} |
|-------------------|-------------------|
| [concept] | [equivalent] |
...
```

Use mappings from `docs/FRAMEWORK_ADAPTATION_GUIDE.md` as reference.

## Phase 8: Update Database Migrator

Edit `/.claude/agents/db-schema-migrator.md`:
- Update source database type detection
- Update target database syntax (PostgreSQL, MySQL, etc.)
- Update type conversion mappings

## Phase 9: Update Manifest Template

Ensure `/migration/manifest.md` template works for new stack.

## Phase 10: Update CLAUDE.md

Edit `/CLAUDE.md`:
- Update tech stack table
- Update any stack-specific references

## Phase 11: Validate Adaptation

Run checks:
```bash
# Verify all agent files are valid
ls -la .claude/agents/*.md

# Verify skills exist
ls -la .claude/skills/*/SKILL.md

# Verify tech-stack.md is updated
cat migration/tech-stack.md
```

## Phase 12: Summary Report

Output:
```
FRAMEWORK ADAPTED

Source Stack:
  - Frontend: {LEGACY_FRONTEND}
  - Backend: {LEGACY_BACKEND}

Target Stack:
  - Frontend: {TARGET_FRONTEND}
  - Backend: {TARGET_BACKEND}
  - Database: {TARGET_DATABASE}

Files Modified:
  - /.claude/agents/explorer.md
  - /.claude/agents/backend-coder.md
  - /.claude/agents/frontend-coder.md
  - /.claude/agents/db-schema-migrator.md
  - /migration/tech-stack.md
  - /CLAUDE.md

Skills Available:
  - [list relevant skills]

Next Steps:
  1. Run /migrate-init to discover legacy codebase
  2. Review generated discovery files
  3. Start migration with /migrate-next
```

## Common Stack Combinations

### Laravel → React + NestJS
- Blade templates → React components
- Eloquent → Sequelize entities
- Form Requests → DTOs + Zod
- Laravel routes → NestJS controllers

### Django → React + NestJS
- Django templates → React components
- Django ORM → Sequelize entities
- Serializers → DTOs
- URLConf → NestJS routes

### Vue.js → React
- `<template>` → JSX
- `data()` → useState
- `computed` → useMemo
- `watch` → useEffect
- Vuex → Zustand/Context
- Vue Router → React Router

### Angular → React
- Components → React components
- Services → Custom hooks + Context
- NgModules → Just imports
- RxJS → TanStack Query
- Angular Router → React Router

### .NET → NestJS (existing default)
- Controllers → NestJS Controllers
- ViewModels → DTOs
- Entity Framework → Sequelize
- Razor Views → React components
