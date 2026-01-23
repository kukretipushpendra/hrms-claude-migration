---
description: Migrate next ready feature through full cycle
allowed-tools: Read, Bash, Write, Edit, Task
---

# Migrate Next Feature (Frontend First Approach)

## Migration Strategy

```
┌─────────────────────────────────────────────────────────────────────────────┐
│ PHASE 1: FRONTEND MIGRATION (Current)                                       │
│ Sequential: Frontend → Frontend QA → Integration QA → Merge                 │
│ Frontend connects to EXISTING .NET backend                                  │
└─────────────────────────────────────────────────────────────────────────────┘
                                    ↓
┌─────────────────────────────────────────────────────────────────────────────┐
│ PHASE 2: BACKEND MIGRATION (Later - use /migrate-next-backend)              │
│ Sequential: Backend → Backend QA → Switch Frontend → Integration QA → Merge │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Thin Context: Main agent NEVER reads legacy/specs/code directly

## 1. Pre-flight Checks

### Check Foundation Gate (Two-Phase)

```bash
# Phase 1: Frontend Foundation
frontend_foundation=$(grep "FRONTEND_FOUNDATION_COMPLETE:" migration/manifest.md | cut -d: -f2 | tr -d ' ')

# Phase 2: Backend Foundation (for backend migration later)
backend_foundation=$(grep "BACKEND_FOUNDATION_COMPLETE:" migration/manifest.md | cut -d: -f2 | tr -d ' ')
```

**For Frontend Migration (Phase 1):**
- If `frontend_foundation` is `false`, only process features with `TYPE: foundation`
- Backend foundation not required for frontend migration (uses existing .NET backend)

### Check Legacy .NET Backend is Running

```bash
legacy_api_url=$(grep "LEGACY_API_URL:" migration/legacy-api-config.md | cut -d: -f2- | tr -d ' ')
curl -s "$legacy_api_url/health" || echo "WARNING: .NET backend may not be running"
```

### Check for Circular Dependencies

```bash
# Run circular detection on ready features
grep -l "CURRENT: ready-for-dev" migration/modules/*/features/*.md | while read f; do
  name=$(basename "$f" .md)
  deps=$(grep "DEPENDS_ON:" "$f" | cut -d: -f2)
  # Check if any dep depends back on name
done
```

## 2. Get Next Feature

```bash
grep -l "CURRENT: ready-for-dev" migration/modules/*/features/*.md 2>/dev/null | head -1
```

If none, check `frontend-qa-passed` for integration work. If nothing, report and exit.

Extract: MODULE and FEATURE from path.

## 3. Validate Dependencies

```bash
deps=$(grep "DEPENDS_ON:" {feature_file} | cut -d: -f2)
for dep in $deps; do
  dep_status=$(grep "CURRENT:" migration/modules/*/$dep.md 2>/dev/null)
  if [[ "$dep_status" != *"complete"* ]]; then
    echo "BLOCKED: {feature} depends on incomplete: $dep"
    # Skip to next ready feature or exit
  fi
done
```

If blocked, set `CURRENT: blocked-dependencies` and try next feature.

## 4. Create Worktree

```bash
git worktree add worktrees/{module}-{feature} -b feature/{module}-{feature}
```

Track creation time in manifest for stale detection.

## 5. Verify API Contract Exists (From .NET Backend)

**CRITICAL:** Before frontend work, verify API contract was documented from .NET backend.

```bash
contract_file="migration/api-contracts/{module}/{feature}.api.md"
if [ ! -f "$contract_file" ]; then
  echo "ERROR: No API contract. Run explorer to document .NET endpoint first."
  echo "Expected: $contract_file"
  exit 1
fi

# Validate contract has required sections
grep -q "## Endpoints" "$contract_file" || echo "ERROR: Contract missing endpoints section"
grep -q "### Response" "$contract_file" || echo "ERROR: Contract missing response shapes"
```

If contract missing, dispatch explorer agent to document .NET API:

```
Task (explorer): "Document API contract for {module}/{feature}
SOURCE: legacy/Backend/**/Controllers/
OUTPUT: migration/api-contracts/{module}/{feature}.api.md
Return 'CONTRACT_COMPLETE' with file path."
```

## 6. Update Status

Edit feature file: `CURRENT: frontend-in-progress`

## 7. Frontend Implementation (Vue.js)

```
Task (frontend-coder with vuejs-migration-expert skill): "Implement frontend for {module}/{feature}
WORKTREE: worktrees/{module}-{feature}
FEATURE_FILE: migration/modules/{module}/features/{feature}.md
API_CONTRACT: migration/api-contracts/{module}/{feature}.api.md

CRITICAL: Connect to EXISTING .NET backend at {LEGACY_API_URL}
- Use documented API contract (same endpoints as .NET)
- Same request/response shapes
- Same authentication (JWT from .NET)

Return 'FRONTEND_COMPLETE' when done."
```

WAIT for completion.

## 8. Frontend QA

```
Task (qa-agent): "Frontend QA for {module}/{feature}
WORKTREE: worktrees/{module}-{feature}
QA_TYPE: frontend
API_TARGET: .NET backend at {LEGACY_API_URL}

Verify:
1. Vue.js app loads without errors
2. Component renders correctly
3. API calls to .NET backend work
4. UI matches legacy React app exactly
5. Forms validate same as legacy
6. Error handling matches legacy

Return 'FRONTEND_QA_PASSED' or 'ESCALATED'."
```

**ATOMIC CHECKPOINT** → Save immediately after frontend QA.

## 9. Integration QA (Frontend ↔ .NET Backend)

```
Task (qa-agent): "Integration QA for {module}/{feature}
WORKTREE: worktrees/{module}-{feature}
QA_TYPE: integration
API_TARGET: .NET backend at {LEGACY_API_URL}

Verify:
1. Full user flow works end-to-end
2. Data persists correctly
3. Edge cases handled same as legacy
4. No regressions in dependent features

Return 'HUMAN_REVIEW' or 'ESCALATED'."
```

**ATOMIC CHECKPOINT** → Save immediately after integration QA.

## 10. Merge to Main

After QA passes:

```bash
cd worktrees/{module}-{feature}
git checkout main
git merge feature/{module}-{feature} --no-ff -m "feat({module}): migrate {feature} frontend to Vue.js"
```

## 11. Cleanup Worktree

```bash
git worktree remove worktrees/{module}-{feature} --force
git branch -d feature/{module}-{feature}
```

## 12. Update Manifest

Update `/migration/manifest.md`:
- Remove from ACTIVE_WORKTREES
- Add to merge log
- Update progress counts: `FRONTEND_COMPLETED: +1`
- Update `FRONTEND_PERCENT: X%`
- Update FRONTEND_FOUNDATION_COMPLETE if all frontend foundation done

Update feature file: `CURRENT: complete`

## Output

```
FEATURE MIGRATED: {module}/{feature}
Phase: Frontend Migration (Vue.js)
Backend: Using existing .NET backend
Result: human-review | escalated
Checkpoint: saved (atomic)

Frontend Progress: X/Y features (Z%)

Next: /migrate-next or /migrate-batch N
```

---

# Backend Migration (Phase 2) - Use After Frontend Complete

## /migrate-next-backend

**Only run after ALL frontend features are migrated.**

### Pre-flight for Backend Migration

```bash
# Verify frontend migration complete
frontend_percent=$(grep "FRONTEND_PERCENT:" migration/manifest.md | cut -d: -f2 | tr -d ' %')
if [ "$frontend_percent" != "100" ]; then
  echo "ERROR: Frontend migration not complete ($frontend_percent%)"
  echo "Complete frontend migration before starting backend"
  exit 1
fi

# Check backend foundation
backend_foundation=$(grep "BACKEND_FOUNDATION_COMPLETE:" migration/manifest.md | cut -d: -f2 | tr -d ' ')
if [ "$backend_foundation" == "false" ]; then
  echo "Backend foundation must be complete first"
  echo "Run /migrate-init to setup Node.js/Express backend"
fi
```

### Backend Migration Workflow

1. **Implement Node.js/Express endpoint** (matches .NET exactly)
2. **Backend QA** (compare responses to .NET)
3. **Switch Frontend** to new endpoint
4. **Integration QA** with new backend
5. **Merge**

```
Task (backend-coder with nodejs-express-expert skill): "Implement backend for {module}/{feature}
WORKTREE: worktrees/{module}-{feature}-backend
FEATURE_FILE: migration/modules/{module}/features/{feature}.md
API_CONTRACT: migration/api-contracts/{module}/{feature}.api.md

CRITICAL: Match EXACT same response shapes as .NET backend
- Same status codes
- Same error messages
- Same validation order
- Use mssql for SQL Server (same database)

Return 'BACKEND_COMPLETE' when done."
```

---

## Status Flow (Frontend First)

```
                          FRONTEND MIGRATION (Phase 1)
dependent → ready-for-dev → frontend-in-progress → frontend-qa → integration-qa → human-review → complete
                                    ↓                  ↓               ↓
                                qa-failed → retry (max 3) → escalated

                          BACKEND MIGRATION (Phase 2 - Later)
complete → backend-ready → backend-in-progress → backend-qa → switch-frontend → integration-qa → fully-migrated
```

## Foundation Features Order

### Frontend Foundation (Must complete first)
1. `frontend-setup` - Vite, Vue Router, Pinia, API client to .NET
2. `layout-and-styles` - Header, footer, nav, CSS (MUI equivalent)
3. `auth-pages` - Login, logout (using .NET auth)
4. `error-pages` - 404, error boundary

### Backend Foundation (Phase 2)
1. `database-setup` - mssql connection to SQL Server
2. `auth-module` - JWT (same tokens as .NET)
3. `core-middleware` - CORS, validation, error handling
