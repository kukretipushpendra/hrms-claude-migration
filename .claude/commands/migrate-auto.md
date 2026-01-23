---
description: Automatic migration until complete (for auto-migrate.sh)
allowed-tools: Read, Glob, Grep, Bash, Write, Edit, Task
---

# Automatic Migration

Process features continuously. Use with `auto-migrate.sh` wrapper.

## Process

```
MAX_PER_SESSION = 10

while processed < MAX_PER_SESSION:
    1. Check foundation gate (block non-foundation if incomplete)
    2. Get next ready-for-dev feature with dependencies satisfied
    3. If none → check completion, exit
    4. Full cycle: backend → qa → frontend → qa → integration-qa → merge
    5. **ATOMIC CHECKPOINT after each phase** (not just at end)
    6. processed++
```

## Foundation Gate Check

```bash
foundation_complete=$(grep "FOUNDATION_COMPLETE:" /migration/manifest.md | cut -d: -f2 | tr -d ' ')
if [[ "$foundation_complete" != "true" ]]; then
    # Only process foundation features
    grep -l "TYPE: foundation" migration/modules/*/features/*.md | head -1
fi
```

## Dependency Validation

Before starting any feature:
```bash
deps=$(grep "DEPENDS_ON:" {feature_file})
for dep in $deps; do
    dep_status=$(grep "CURRENT:" migration/modules/*/$dep.md)
    if [[ "$dep_status" != *"complete"* ]]; then
        skip_feature=true
        break
    fi
done
```

## Atomic Checkpoint (CRITICAL)

Save checkpoint **IMMEDIATELY** after each phase completes, not at session end:

```markdown
CHECKPOINT: true
CHECKPOINT_REASON: phase_complete | session_limit
LAST_COMPLETED: {module}/{feature}
LAST_PHASE: backend-qa | frontend-qa | integration-qa
NEXT_FEATURE: {next}
CHECKPOINT_TIME: {ISO timestamp}
```

**Why atomic?** If session crashes mid-feature, resume knows exactly where to continue.

## Stale Worktree Detection

Before processing, check for stale worktrees:
```bash
for wt in worktrees/*/; do
  hours_old=$(( ($(date +%s) - $(git -C "$wt" log -1 --format="%ct")) / 3600 ))
  if [ $hours_old -gt 2 ]; then
    echo "WARNING: Stale worktree $wt (${hours_old}h)"
  fi
done
```

## Exit Codes

- `0`: More work (script continues)
- `1`: Migration complete (script stops)
- `2`: Error (script stops)
- `3`: All remaining features blocked by dependencies

## Output

```
SESSION COMPLETE
================
Processed: {count}
Completed: {total}/{features}
Remaining: {count}
Blocked: {count blocked by dependencies}
Stale Worktrees: {list if any}

CHECKPOINT SAVED (atomic after each phase)
```
