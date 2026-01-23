# Shared Patterns Reference

## Thin Context Pattern

Main agent NEVER reads:
- Legacy code
- Discovery/spec contents
- Modern implementation

Main agent ONLY:
- Runs bash for status checks
- Dispatches sub-agents with file PATHS
- Receives: `ACTION_COMPLETE`, file paths, metrics

Sub-agents:
- Read files, do heavy work
- Write to files
- Return paths + counts only

## Sub-Agent Return Format

```
{ACTION}_COMPLETE
FILES: [paths created/modified]
STATS: key=value pairs
```

## 100% Parity Rules

- Match EXACT legacy behavior (even if "wrong")
- Same validation order and messages
- Same response shapes and status codes
- Same UI layout, spacing, colors, labels
- No improvements, no creativity
- Legacy code > spec when they conflict

## Status Flow

```
dependent → ready-for-dev → backend-in-progress → backend-qa → frontend-in-progress → frontend-qa → integration-qa → human-review → complete
                                 ↓                                ↓                         ↓
                             qa-failed → retry (max 3) → escalated
                                                              ↓
                                                         rolled-back (if merged feature breaks main)
```

Additional statuses:
- `blocked-circular`: Circular dependency detected, awaiting human intervention
- `blocked-dependencies`: Dependencies not yet complete

## Feature File Status Fields

```markdown
CURRENT: {status from flow above}
BACKEND: pending | in-progress | complete | not-applicable
BACKEND_QA: pending | passed | failed
FRONTEND: pending | in-progress | complete
FRONTEND_QA: pending | passed | failed
INTEGRATION_QA: pending | passed | failed
WORKTREE: worktrees/{module}-{feature}
DEPENDS_ON: {comma-separated feature names}
TYPE: crud | static-page | foundation
```

## Worktree Structure

```
worktrees/{module}-{feature}/
├── legacy/           # Read-only source
│   ├── Frontend/     # React.js app
│   └── Backend/      # .NET WebAPI
├── modern/
│   ├── backend/      # Node.js/Express (backend-coder)
│   └── frontend/     # Vue.js (frontend-coder)
└── migration/        # Status files
```

## Modern Backend Structure (Node.js/Express)

```
modern/backend/
├── src/
│   ├── app.ts                    # Express app setup
│   ├── server.ts                 # Entry point
│   ├── config/
│   │   ├── database.ts           # mssql connection pool
│   │   └── env.ts                # Environment variables
│   ├── middleware/
│   │   ├── auth.middleware.ts    # JWT verification
│   │   ├── validation.middleware.ts
│   │   └── error.middleware.ts
│   ├── modules/
│   │   └── {module}/
│   │       ├── {module}.routes.ts
│   │       ├── {module}.controller.ts
│   │       ├── {module}.service.ts  # Uses mssql queries
│   │       ├── dto/
│   │       └── types/
│   ├── types/
│   │   └── express.d.ts
│   └── utils/
│       └── errors.ts
├── package.json
├── tsconfig.json
└── .env
```

## Modern Frontend Structure (Vue.js)

```
modern/frontend/
├── src/
│   ├── views/                    # Page components
│   │   └── {module}/
│   │       └── {Feature}View.vue
│   ├── components/               # Reusable components
│   │   └── {module}/
│   ├── composables/              # Reusable logic (like React hooks)
│   │   └── use{Feature}.ts
│   ├── services/
│   │   └── api/
│   │       ├── axios-client.ts
│   │       └── {module}.service.ts
│   ├── stores/                   # Pinia stores
│   │   └── {module}.store.ts
│   ├── types/
│   │   └── {module}.types.ts
│   ├── router/
│   │   └── index.ts
│   ├── assets/
│   ├── styles/
│   ├── App.vue
│   └── main.ts
├── package.json
├── vite.config.ts
└── tsconfig.json
```

## Foundation Gates (Two-Phase)

**CRITICAL**: Both backend AND frontend have foundation phases. Check in manifest.md.

### Backend Foundation Gate
```bash
backend_foundation=$(grep "BACKEND_FOUNDATION_COMPLETE:" migration/manifest.md | cut -d: -f2 | tr -d ' ')
```

If `false`:
- ONLY process backend features with `TYPE: foundation`
- Block ALL non-foundation backend work

### Frontend Foundation Gate
```bash
frontend_foundation=$(grep "FRONTEND_FOUNDATION_COMPLETE:" migration/manifest.md | cut -d: -f2 | tr -d ' ')
```

If `false`:
- ONLY process frontend features with `TYPE: foundation`
- Block ALL non-foundation frontend work

### Foundation Feature Order

**Backend Foundation** (must complete first):
1. `database-setup` - DB connection, health check
2. `auth-module` - JWT/session authentication
3. `core-middleware` - CORS, validation, error handling

**Frontend Foundation** (after backend foundation):
1. `frontend-setup` - Vite, routing, API client configured
2. `layout-and-styles` - Header, footer, nav, CSS framework
3. `auth-pages` - Login, logout, protected routes only if applicable
4. `error-pages` - 404, error boundary, offline handling
5. `health-check-integration` - Verify frontend ↔ backend connection

### Foundation Complete Criteria

**Backend**: Health endpoint returns `{ status: "ok", database: { status: "connected" } }`

**Frontend**:
- App loads in browser without errors
- Can reach backend health endpoint
- Login/logout flow works end-to-end
- Layout displays correctly (header, footer, nav)
- 404 page works for unknown routes

## Dependency Validation

Before dispatching ANY feature:

```bash
deps=$(grep "DEPENDS_ON:" {feature_file})
for dep in $deps; do
  dep_status=$(grep "CURRENT:" migration/modules/*/$dep.md)
  if [[ "$dep_status" != *"complete"* ]]; then
    echo "BLOCKED: depends on incomplete $dep"
  fi
done
```

## Circular Dependency Detection

Before processing batch:

```bash
for feature in migration/modules/*/features/*.md; do
  name=$(basename "$feature" .md)
  deps=$(grep "DEPENDS_ON:" "$feature" | cut -d: -f2)
  for dep in $deps; do
    reverse=$(grep "DEPENDS_ON:.*$name" migration/modules/*/features/$dep.md)
    if [ -n "$reverse" ]; then
      echo "CIRCULAR: $name ↔ $dep"
    fi
  done
done
```

## Contract Validation (Before Frontend)

```bash
contract_file="migration/api-contracts/{module}/{feature}.api.md"
if [ ! -f "$contract_file" ]; then
  echo "ERROR: No API contract. Backend must create it."
fi
```

## Smart Retry Pattern (QA)

Different strategy based on attempt count:

| Attempt | Strategy |
|---------|----------|
| 1 | Specific feedback, same coder |
| 2 | Enhanced prompt with pattern analysis, suggest alternative approach |
| 3 | Escalate with auto-generated analysis |

## Atomic Checkpoint Pattern

Save checkpoint **IMMEDIATELY** after each phase:

```markdown
CHECKPOINT: true
CHECKPOINT_REASON: phase_complete
LAST_COMPLETED: {module}/{feature}
LAST_PHASE: backend-qa | frontend-qa | integration-qa
CHECKPOINT_TIME: {ISO timestamp}
```

## Stale Worktree Detection

```bash
for wt in worktrees/*/; do
  hours_old=$(( ($(date +%s) - $(git -C "$wt" log -1 --format="%ct")) / 3600 ))
  if [ $hours_old -gt 2 ]; then
    echo "⚠ STALE: $(basename $wt) (${hours_old}h)"
  fi
done
```

## Git Worktree Commands

```bash
# Create (with timestamp tracking)
git worktree add worktrees/{module}-{feature} -b feature/{module}-{feature}

# After QA pass
git checkout main && git merge feature/{module}-{feature} --no-ff
git worktree remove worktrees/{module}-{feature} --force
git branch -d feature/{module}-{feature}

# Rollback (if merged feature breaks main)
git revert -m 1 {merge_commit} --no-edit
```

## Auto-Escalation Entry

When escalating (3 failures), auto-generate `/migration/logs/escalations.md` entry with:
- Attempt history from attempts.md
- Detected pattern (e.g., "API version mismatch")
- Suspected root cause
- Suggested action for human

## React → Vue.js Conversion Quick Reference

| React | Vue 3 |
|-------|-------|
| `useState` | `ref()` |
| `useEffect(() => {}, [])` | `onMounted(() => {})` |
| `useEffect(() => {}, [dep])` | `watch(dep, () => {})` |
| `useMemo` | `computed()` |
| Custom Hook | Composable (`use{Name}.ts`) |
| `props.children` | `<slot />` |
| `onClick={fn}` | `@click="fn"` |
| `{condition && <div>}` | `<div v-if="condition">` |
| `.map(item => <X />)` | `<X v-for="item in items" />` |
| Zustand | Pinia |
| React Router | Vue Router |

## .NET → Node.js Conversion Quick Reference

| .NET | Node.js/Express |
|------|-----------------|
| Controller | Controller + Router |
| Service | Service class |
| Repository/Dapper | Service with mssql |
| [HttpGet] | `router.get()` |
| [Authorize] | `authMiddleware` |
| Data Annotations | Zod validators |
| `IActionResult` | `res.json()` |
| `@param` | `.input('param', sql.Type, value)` |
