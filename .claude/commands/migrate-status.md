---
description: Show migration progress and blockers
allowed-tools: Read, Glob, Grep, Bash
---

# Migration Status

## 1. Read State

```bash
cat /migration/manifest.md
grep -h "CURRENT:" migration/modules/*/features/*.md | sort | uniq -c
```

## 2. Count by Status

- complete, human-review, ready-for-qa, in-progress
- ready-for-dev, dependent, rework, escalated

## 3. Check Stale Worktrees

```bash
# List worktrees with age (hours since last commit)
for wt in worktrees/*/; do
  if [ -d "$wt" ]; then
    name=$(basename "$wt")
    last_commit=$(git -C "$wt" log -1 --format="%ct" 2>/dev/null || echo 0)
    now=$(date +%s)
    hours_old=$(( (now - last_commit) / 3600 ))
    echo "$name: ${hours_old}h since last commit"
  fi
done
```

**Stale threshold**: >2 hours without commit = STALE (needs attention)

## 4. Check Foundation Gate

```bash
grep "FOUNDATION_COMPLETE:" /migration/manifest.md
```

If `false`, non-foundation features are blocked.

## 5. Check Circular Dependencies

```bash
# Detect if any feature depends on a feature that depends on it
grep -h "DEPENDS_ON:" migration/modules/*/features/*.md | while read dep; do
  # Flag mutual dependencies
done
```

## 6. Output

```
MIGRATION STATUS
================
Phase: {phase}
Progress: {complete}/{total} ({percent}%)
Foundation Gate: OPEN | BLOCKED (foundation features pending)

By Status:
  complete: X
  human-review: X
  in-progress: X
  ready-for-dev: X
  dependent: X
  escalated: X

Active Worktrees:
  ✓ auth-login: 0.5h (backend-in-progress)
  ⚠ orders-create: 3h STALE (frontend-in-progress)
  ✓ products-list: 1h (qa-in-progress)

Needs Attention:
  - {module}/{feature}: escalated
  - {module}/{feature}: rework
  - {module}/{feature}: STALE worktree (>2h)

Blocked by Dependencies:
  - {module}/{feature}: waiting on {dep1}, {dep2}

Next Up:
  1. {module}/{feature} (ready-for-dev)
  2. {module}/{feature} (ready-for-dev)
```
