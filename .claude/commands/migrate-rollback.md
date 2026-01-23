---
description: Rollback a merged feature if it breaks main
allowed-tools: Read, Bash, Write, Edit
---

# Migrate Rollback

Safely rollback a recently merged feature that caused issues on main.

## Arguments

`$ARGUMENTS` - Feature name (module/feature) or "last" for most recent merge

## Pre-flight Checks

1. Verify clean working directory
2. Check feature was actually merged (not still in worktree)
3. Verify rollback info exists in manifest

```bash
git status --porcelain
grep "LAST_MERGE:" /migration/manifest.md
```

## Process

### 1. Identify Merge Commit

```bash
# If "last" argument
merge_commit=$(git log --oneline --merges -1 | cut -d' ' -f1)

# If specific feature
merge_commit=$(git log --oneline --merges --grep="feat({module}): {feature}" -1 | cut -d' ' -f1)
```

### 2. Verify Merge Exists

```bash
if [ -z "$merge_commit" ]; then
  echo "ERROR: No merge commit found for {feature}"
  exit 1
fi
```

### 3. Get Parent Commit (Pre-merge State)

```bash
parent_commit=$(git rev-parse $merge_commit^1)
```

### 4. Create Rollback

**Option A: Revert (safer, preserves history)**
```bash
git revert -m 1 $merge_commit --no-edit
```

**Option B: Reset (destructive, use only if not pushed)**
```bash
# Only if NOT pushed to remote
git reset --hard $parent_commit
```

### 5. Update Feature Status

Edit feature file:
```markdown
CURRENT: rolled-back
ROLLBACK_DATE: {today}
ROLLBACK_REASON: {user-provided or "broke main"}
PREVIOUS_STATUS: human-review
```

### 6. Update Manifest

```markdown
LAST_ROLLBACK: {module}/{feature}
ROLLBACK_COMMIT: {revert commit hash}
ROLLBACK_DATE: {ISO timestamp}
```

### 7. Optionally Recreate Worktree

If user wants to fix and retry:
```bash
git worktree add worktrees/{module}-{feature} -b feature/{module}-{feature}-v2
```

## Output

```
ROLLBACK COMPLETE
=================
Feature: {module}/{feature}
Merge Commit: {hash}
Revert Commit: {hash}
Status: rolled-back

To retry migration:
  1. Fix the issue
  2. Set CURRENT: ready-for-dev
  3. Run /migrate-next

To investigate:
  git diff {parent_commit}..{merge_commit}
```

## Safety Rules

- **NEVER force push** without explicit user confirmation
- Prefer `git revert` over `git reset`
- Always update feature status to `rolled-back`
- Log rollback in manifest for tracking
- If feature was pushed to remote, ONLY use revert
