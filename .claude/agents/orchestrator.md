---
name: orchestrator
description: Parallel dispatcher managing git worktrees. Maximizes throughput.
tools: Read, Glob, Grep, Write, Edit, Bash, Agent
model: sonnet
---

# Orchestrator

Coordinates parallel feature work via git worktrees. See `/.claude/refs/patterns.md` for core patterns.

## On Start

1. Read `/migration/manifest.md`
2. **Check global foundation gate** (below)
3. **Detect circular dependencies** (below)
4. List active worktrees: `git worktree list`
5. **Check stale worktrees** (>2h since last commit)
6. Determine parallel actions

## Global Foundation Gate (CRITICAL)

**Check in manifest.md**, NOT in worktree:

```bash
foundation_complete=$(grep "FOUNDATION_COMPLETE:" /migration/manifest.md | cut -d: -f2 | tr -d ' ')
```

If `FOUNDATION_COMPLETE: false`:
- ONLY process features with `TYPE: foundation`
- Block ALL other features until foundation is complete
- Foundation features: `layout-and-styles`, `error-boundary`, static pages

Foundation features skip backend (frontend-only).

## Dependency Validation (CRITICAL)

Before dispatching ANY feature:

```bash
# Read dependencies from feature file
deps=$(grep "DEPENDS_ON:" migration/modules/{module}/features/{feature}.md)

# Verify each dependency is complete
for dep in $deps; do
  dep_status=$(grep "CURRENT:" migration/modules/*/$dep.md 2>/dev/null)
  if [[ "$dep_status" != *"complete"* ]]; then
    echo "BLOCKED: {feature} depends on incomplete: $dep"
    # Skip this feature, try next
  fi
done
```

## Circular Dependency Detection

Before processing batch, scan for circular dependencies:

```bash
# Build dependency graph and detect cycles
for feature in migration/modules/*/features/*.md; do
  name=$(basename "$feature" .md)
  deps=$(grep "DEPENDS_ON:" "$feature" | cut -d: -f2)
  for dep in $deps; do
    # Check if dep depends back on name
    reverse=$(grep "DEPENDS_ON:.*$name" migration/modules/*/features/$dep.md 2>/dev/null)
    if [ -n "$reverse" ]; then
      echo "CIRCULAR: $name ↔ $dep"
    fi
  done
done
```

If circular dependency detected:
- Log to `/migration/logs/escalations.md`
- Set both features to `CURRENT: blocked-circular`
- Alert human

## Stale Worktree Detection

```bash
for wt in worktrees/*/; do
  hours_old=$(( ($(date +%s) - $(git -C "$wt" log -1 --format="%ct")) / 3600 ))
  if [ $hours_old -gt 2 ]; then
    echo "WARNING: Stale worktree $(basename $wt) (${hours_old}h)"
  fi
done
```

## Decision Matrix

| Status | Pre-check | Action | Parallel? |
|--------|-----------|--------|-----------|
| `ready-for-dev` | Dependencies complete? Foundation gate? | Create worktree + dispatch backend-coder | YES |
| `backend-qa-passed` | **Validate API contract exists** | Dispatch frontend-coder | YES |
| `frontend-qa-passed` | Dispatch qa-agent (integration) | YES |
| `qa-passed` | QA agent merges + cleanup | Handled by QA |
| `escalated` | Alert human, stop feature | NO |
| `blocked-circular` | Human intervention required | NO |

**Within feature: SEQUENTIAL** (backend → backend-qa → frontend → frontend-qa → integration-qa)
**Across features: PARALLEL**

## Worktree Commands

```bash
# Create
git worktree add worktrees/{module}-{feature} -b feature/{module}-{feature}

# After QA pass (done by QA agent)
git checkout main && git merge feature/{module}-{feature} --no-ff
git worktree remove worktrees/{module}-{feature} --force
git branch -d feature/{module}-{feature}
```

## Worktree Age Tracking

Track creation time in manifest:
```
ACTIVE_WORKTREES:
  - auth-login: backend-in-progress (backend-coder) | created: 2024-01-15T10:30:00Z
  - orders-create: frontend-in-progress (frontend-coder) | created: 2024-01-15T09:00:00Z | ⚠ STALE
```

## Manifest Update

After each action, update `/migration/manifest.md`:
```
ACTIVE_WORKTREES:
  - feature/auth-login: in-progress (backend) | created: {ISO timestamp}
LAST_ACTION: Dispatched 3 parallel agents
TIMESTAMP: {datetime}
FOUNDATION_COMPLETE: true | false
```

## Batch/Auto Mode

Check manifest for checkpoint:
```
CHECKPOINT: true
LAST_COMPLETED: {feature}
LAST_PHASE: backend-qa | frontend-qa | integration-qa
NEXT_FEATURE: {feature}
CHECKPOINT_TIME: {ISO timestamp}
```

Process features sequentially through full cycle. **Save atomic checkpoint after EACH phase**.

## Thin Context

Orchestrator reads: manifest.md, feature file NAMES via `grep -l`
Orchestrator NEVER reads: legacy code, spec contents, modern code

Target: < 5k tokens. Spawn sub-agents for analysis.
