---
description: Migrate next ready feature through full cycle
allowed-tools: Read, Bash, Write, Edit, Task
---

# Migrate Next Feature

Sequential: Backend → Backend QA → Frontend → Frontend QA → Integration QA → Merge

## Thin Context: Main agent NEVER reads legacy/specs/code directly

## 1. Pre-flight Checks

### Check Foundation Gate
```bash
foundation_complete=$(grep "FOUNDATION_COMPLETE:" /migration/manifest.md | cut -d: -f2 | tr -d ' ')
```

If `false`, only process features with `TYPE: foundation`.

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

If none, check `backend-qa-passed` for frontend-only work. If nothing, report and exit.

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

## 5. Update Status

Edit feature file: `CURRENT: backend-in-progress`

## 6. Backend (Sequential)

```
Task (backend-coder): "Implement backend for {module}/{feature}
WORKTREE: worktrees/{module}-{feature}
FEATURE_FILE: migration/modules/{module}/features/{feature}.md
Return 'BACKEND_COMPLETE' when done."
```

WAIT for completion.

## 7. Backend QA

```
Task (qa-agent): "Backend QA for {module}/{feature}
WORKTREE: worktrees/{module}-{feature}
QA_TYPE: backend
Return 'BACKEND_QA_PASSED' or 'ESCALATED'."
```

If ESCALATED → Stop, update manifest, report.

**ATOMIC CHECKPOINT** → Save immediately after backend QA.

## 8. Contract Validation (Before Frontend)

```bash
contract_file="migration/api-contracts/{module}/{feature}.api.md"
if [ ! -f "$contract_file" ]; then
  echo "ERROR: No API contract for feature. Respawn backend-coder to create it."
  exit 1
fi

# Validate contract has required sections
grep -q "## Feature:" "$contract_file" || echo "WARNING: Contract missing feature header"
grep -q "## Endpoints" "$contract_file" || echo "ERROR: Contract missing endpoints section"
```

If validation fails, respawn backend-coder to fix contract.

## 9. Frontend

```
Task (frontend-coder): "Implement frontend for {module}/{feature}
WORKTREE: worktrees/{module}-{feature}
FEATURE_FILE: migration/modules/{module}/features/{feature}.md
API_CONTRACT: migration/api-contracts/{module}/{feature}.api.md
Return 'FRONTEND_COMPLETE' when done."
```

## 10. Frontend QA

```
Task (qa-agent): "Frontend QA for {module}/{feature}
WORKTREE: worktrees/{module}-{feature}
QA_TYPE: frontend
Return 'FRONTEND_QA_PASSED' or 'ESCALATED'."
```

**ATOMIC CHECKPOINT** → Save immediately after frontend QA.

## 11. Integration QA

```
Task (qa-agent): "Integration QA for {module}/{feature}
WORKTREE: worktrees/{module}-{feature}
QA_TYPE: integration
Return 'HUMAN_REVIEW' or 'ESCALATED'."
```

**ATOMIC CHECKPOINT** → Save immediately after integration QA.

## 12. Update Manifest

Update `/migration/manifest.md` with result:
- Remove from ACTIVE_WORKTREES
- Add to merge log
- Update progress counts
- Update FOUNDATION_COMPLETE if all foundation done

## Output

```
FEATURE MIGRATED: {module}/{feature}
Result: human-review | escalated
Checkpoint: saved (atomic)
Next: /migrate-next or /migrate-batch N
```
