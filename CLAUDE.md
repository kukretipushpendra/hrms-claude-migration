# Migration Framework

Tech-agnostic migration framework using sub-agents and git worktrees.

**Default stack:** .NET → React + NestJS + PostgreSQL
**Adaptable to:** Any source/target combination via `/migrate-adapt`

## Commands

| Command | Purpose |
|---------|---------|
| `/migrate-adapt` | **Adapt framework to different tech stack** |
| `/migrate-init` | Discover legacy, scaffold projects |
| `/migrate-next` | Migrate next ready feature |
| `/migrate-batch N` | Migrate N features sequentially |
| `/migrate-status` | Show progress, blockers, stale worktrees |
| `/migrate-qa` | Run QA on pending features |
| `/migrate-human-review` | List features awaiting approval |
| `/migrate-human-review-fix` | Fix features marked for rework |
| `/migrate-resume` | Resume from last checkpoint |
| `/migrate-auto` | Auto-migrate until complete |
| `/migrate-rollback` | Rollback a merged feature |
| `/migrate-diff` | Compare legacy vs modern implementation |
| `/migration-optimize` | Apply production optimizations (run AFTER migration complete) |

### Adapting to Different Tech Stacks

Run `/migrate-adapt` BEFORE `/migrate-init` to configure for your stack:

```bash
/migrate-adapt "Target Stack: frontend: vue.js, backend: laravel and legacy is Frontend: React.js and backend .Net"
```

This updates agents, skills, and mappings for your specific migration.

## Directory Layout

```
/legacy             # Source of truth (read-only)
/modern/backend     # NestJS, PostgreSQL, Sequelize
/modern/frontend    # React + Vite
/migration/
  discovery/        # modules.json, overview.md, etc.
  manifest.md       # Progress tracking + foundation gate
  modules/{mod}/features/{feat}.md
  api-contracts/{mod}/{feat}.api.md    # Feature-based Backend→Frontend contracts
  logs/             # attempts.md, escalations.md
  tech-stack.md     # Tech stack details/decisions
```

## Core Principles

1. **Legacy = truth** - Replicate exactly, even if behavior seems wrong
2. **100% parity** - Same UI/UX, validation, responses
3. **Thin context** - Main agent dispatches, sub-agents do heavy work
4. **Feature tracking** - One status file per feature
5. **Two-phase foundation** - Backend AND frontend foundation must complete before features
6. **Atomic checkpoints** - Save after each phase, not batch end
7. **Sub Agents Must use package scripts:** lint and format after done working.

## Foundation Gates (Two-Phase)

**Both backend AND frontend have foundation phases that must complete first.**

### Backend Foundation (Phase 1)
1. `database-setup` - DB connection, health check endpoint
2. `auth-module` - JWT/session authentication
3. `core-middleware` - CORS, validation, error handling

**Complete when:** `/health` returns `{ status: "ok", database: "connected" }`

### Frontend Foundation (Phase 2)
1. `frontend-setup` - Router, API client, env config
2. `layout-and-styles` - Header, footer, nav, CSS framework
3. `auth-pages` - Login, logout, protected routes
4. `error-pages` - 404, error boundary

**Complete when:**
- App loads in browser without errors
- `/health` page shows backend connected
- Login/logout flow works
- Layout displays correctly
- 404 page works for unknown routes

### Manifest Tracking
```markdown
# migration/manifest.md
BACKEND_FOUNDATION_COMPLETE: true
FRONTEND_FOUNDATION_COMPLETE: true
```

Non-foundation features are **blocked** until both gates are `true`.

## Tech Stack

| Layer | Tech |
|-------|------|
| Frontend | React 19, TypeScript, Vite, React Hook Form + Zod |
| Backend | NestJS, PostgreSQL, Sequelize |
| Infra | Docker Compose |
| CSS | Same framework as legacy (Bootstrap version, etc.) |

## Database

```bash
docker compose up -d      # Start PostgreSQL + pgAdmin
docker compose down       # Stop
# PostgreSQL: localhost:5432 | pgAdmin: localhost:5050
# Credentials in .env.example
```

## Status Flow

```
dependent → ready-for-dev → backend-in-progress → backend-qa
→ frontend-in-progress → frontend-qa → integration-qa → human-review → complete
                                                              ↓
                                                         rolled-back
```

Additional: `blocked-circular`, `blocked-dependencies`, `escalated`

## Safety Features

- **Dependency validation** - Features blocked until dependencies complete
- **Circular dependency detection** - Auto-detected and escalated
- **Contract validation** - API contract verified before frontend starts
- **Stale worktree detection** - Warns on worktrees >2h without commits
- **Smart retry** - Different strategy on 2nd failure (pattern analysis)
- **Auto-escalation** - Generates analysis entry on 3rd failure

Failed QA retries up to 3x with progressive strategy, then escalates.

## Sub-Agent Pattern

Main agent receives file PATHS, not contents:
```
ACTION_COMPLETE
FILES: [paths]
STATS: modules=5, features=23
```

See `/.claude/refs/patterns.md` for detailed patterns.
