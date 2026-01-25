# Migration Framework

Tech-agnostic migration framework using sub-agents and git worktrees.

**Current Migration:**
- **Legacy:** React.js + .NET WebAPI (SQL Server, Dapper)
- **Target:** Vue.js (TypeScript) + Node.js/Express (TypeScript) + SQL Server (same database)
- **Approach:** Frontend First

**Adaptable to:** Any source/target combination via `/migrate-adapt`

## Migration Strategy: Frontend First

```
┌─────────────────────────────────────────────────────────────────────────────┐
│ PHASE 1: FRONTEND MIGRATION (Current)                                       │
│ - Vue.js frontend talks to EXISTING .NET backend                            │
│ - No backend changes needed initially                                       │
│ - Full frontend parity with legacy React app                                │
└─────────────────────────────────────────────────────────────────────────────┘
                                    ↓
┌─────────────────────────────────────────────────────────────────────────────┐
│ PHASE 2: BACKEND MIGRATION (Later)                                          │
│ - Migrate .NET APIs to Node.js/Express                                      │
│ - Same SQL Server database (no DB migration)                                │
│ - Switch frontend to new backend incrementally                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Commands

| Command | Purpose |
|---------|---------|
| `/migrate-adapt` | **Adapt framework to different tech stack** |
| `/migrate-init` | Discover legacy, scaffold Vue.js project (Frontend First) |
| `/migrate-next` | Migrate next ready frontend feature |
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
/migrate-adapt "Legacy: Angular + Java Spring, Target: Vue.js + Express"
```

This updates agents, skills, and mappings for your specific migration.

## Directory Layout

```
/                           # Root - ONLY essential config files
  CLAUDE.md                 # Claude Code instructions
  README.md                 # Project readme
  package.json              # NPM workspace config
/legacy                     # Source of truth (read-only)
  /Frontend                 # React.js frontend (TypeScript, Vite, Zustand, MUI)
  /Backend                  # .NET 8 WebAPI (Dapper, SQL Server)
/modern/frontend            # Vue.js + Vite (TypeScript) - connects to .NET backend
/modern/backend             # Node.js/Express (Phase 2 - placeholder until frontend complete)
/migration/
  manifest.md               # Progress tracking + foundation gate
  tech-stack.md             # Tech stack details/decisions
  legacy-api-config.md      # .NET backend URL configuration
  KNOWN_ISSUES_AND_PATTERNS.md  # Common issues and fixes (MUST READ)
  discovery/                # modules.json, overview.md, etc.
  modules/{mod}/features/{feat}.md
  api-contracts/{mod}/{feat}.api.md    # .NET API contracts for Vue.js frontend
  adr/                      # Architecture Decision Records
  db/                       # Database analysis and scripts
  docs/                     # Documentation (guides, implementation notes)
  logs/                     # QA reports, attempts.md, escalations.md
  scripts/                  # Utility scripts (shell, SQL)
    tests/                  # Integration test scripts (JS)
```

## File Organization Rules

**IMPORTANT:** Keep project root clean. All generated files go to appropriate folders:

| File Type | Location | Examples |
|-----------|----------|----------|
| QA Reports/Summaries | `migration/logs/` | `*-qa-report.md`, `*-QA-SUMMARY.md` |
| Implementation Docs | `migration/docs/` | `*-IMPLEMENTATION.md`, guides |
| Test Scripts (JS) | `migration/scripts/tests/` | `test-*.js` |
| Utility Scripts | `migration/scripts/` | `*.sh`, `*.ps1`, `*.sql` |
| Session Prompts | `migration/docs/` | `Prompts.md` |
| API Contracts | `migration/api-contracts/{module}/` | `*.api.md` |
| Feature Status | `migration/modules/{mod}/features/` | `{feat}.md` |

**Root level ONLY:**
- `CLAUDE.md` - Claude instructions
- `README.md` - Project readme
- `package.json` / `package-lock.json` - NPM config
- `.gitignore`, `.env*` - Git/env config

## Core Principles

1. **Legacy = truth** - Replicate exactly, even if behavior seems wrong
2. **100% parity** - Same UI/UX, validation, responses
3. **Frontend First** - Vue.js connects to existing .NET backend initially
4. **Thin context** - Main agent dispatches, sub-agents do heavy work
5. **Feature tracking** - One status file per feature
6. **API Contracts** - Document .NET endpoints before frontend work
7. **Atomic checkpoints** - Save after each phase, not batch end
8. **Sub Agents Must use package scripts:** lint and format after done working.

## Foundation Gates (Frontend First)

### Frontend Foundation (Phase 1 - Required First)
1. `frontend-setup` - Vite, Vue Router, Pinia, API client pointing to .NET backend
2. `layout-and-styles` - Header, footer, nav, CSS framework (MUI equivalent)
3. `auth-pages` - Login, logout (using .NET JWT authentication)
4. `error-pages` - 404, error boundary

**Complete when:**
- Vue.js app loads in browser without errors
- Can authenticate against .NET backend
- Layout matches legacy React app
- Protected routes redirect to login
- API calls to .NET backend work

### Backend Foundation (Phase 2 - After Frontend Complete)
1. `database-setup` - mssql connection to SQL Server
2. `auth-module` - JWT (same tokens as .NET)
3. `core-middleware` - CORS, validation, error handling

**Complete when:** `/health` returns `{ status: "ok", database: "connected" }`

### Manifest Tracking
```markdown
# migration/manifest.md
APPROACH: frontend-first
PHASE: 1 - Frontend Migration

FRONTEND_FOUNDATION_COMPLETE: false
BACKEND_FOUNDATION_COMPLETE: false (Phase 2)

FRONTEND_COMPLETED: 0
FRONTEND_PERCENT: 0%
```

Non-foundation frontend features are **blocked** until `FRONTEND_FOUNDATION_COMPLETE: true`.

## Tech Stack

| Layer | Tech |
|-------|------|
| Legacy Frontend | React.js 18, TypeScript, Vite, Zustand, Material-UI, React Hook Form |
| Legacy Backend | .NET 8 WebAPI, Dapper, SQL Server, JWT |
| Modern Frontend | Vue.js 3, TypeScript, Vite, Pinia, VeeValidate + Zod, Vuetify (or MUI CSS) |
| Modern Backend | Node.js, Express, TypeScript, SQL Server (mssql driver) - Phase 2 |
| CSS | Same framework as legacy (Material-UI styles → Vuetify or equivalent) |

## Database

**Strategy:** Keep the same SQL Server database - no migration needed.

- Phase 1: Vue.js frontend connects to existing .NET backend
- Phase 2: Node.js/Express backend connects to same SQL Server using `mssql` driver

```bash
# Connection configured via environment variables
# See .env.example for SQL Server connection settings
# No Docker required - uses existing SQL Server instance
```

## Status Flow (Frontend First)

```
                        FRONTEND MIGRATION (Phase 1)
dependent → ready-for-dev → frontend-in-progress → frontend-qa → integration-qa → human-review → complete
                                    ↓                  ↓               ↓
                                qa-failed → retry (max 3) → escalated

                        BACKEND MIGRATION (Phase 2 - Later)
complete → backend-ready → backend-in-progress → backend-qa → switch-frontend → fully-migrated
```

Additional: `blocked-circular`, `blocked-dependencies`, `escalated`, `rolled-back`

## Safety Features

- **Dependency validation** - Features blocked until dependencies complete
- **Circular dependency detection** - Auto-detected and escalated
- **API Contract validation** - .NET API contract verified before frontend starts
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

## Legacy Architecture Reference

### Frontend (React.js)
- **State**: Zustand with localStorage persistence
- **Data Fetching**: SWR + Axios with interceptors
- **UI**: Material-UI v6 with Emotion CSS-in-JS
- **Forms**: React Hook Form + Yup validation
- **Routing**: React Router v6 with lazy loading
- **Auth**: JWT + Azure MSAL SSO

### Backend (.NET WebAPI)
- **Architecture**: Layered (API → Application → Infrastructure → Domain)
- **ORM**: Dapper (micro-ORM with raw SQL)
- **Auth**: JWT with refresh tokens, permission-based authorization
- **Jobs**: Quartz.NET for scheduled tasks
- **Logging**: Serilog with multiple sinks

## Vue.js Frontend Configuration

During frontend migration, Vue.js connects to existing .NET backend:

```typescript
// modern/frontend/src/services/api/http-client.ts
const httpClient = axios.create({
  baseURL: import.meta.env.VITE_API_URL, // Points to .NET backend
  timeout: 30000,
});
```

```bash
# modern/frontend/.env.development
VITE_API_URL=https://localhost:7001/api  # Existing .NET backend
```
