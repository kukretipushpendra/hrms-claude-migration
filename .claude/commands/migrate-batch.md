---
description: Process N features in batch mode sequentially
allowed-tools: Read, Bash, Write, Edit, Task
---

# Batch Migration

Process multiple features through full cycle: Backend → Backend QA → Frontend → Frontend QA → Integration QA → Merge

## Thin Context: Main agent NEVER reads legacy/specs/code

## Arguments

`$ARGUMENTS` - Number of features (default: 5)

## Process

### 1. Check Checkpoint

```bash
cat /migration/manifest.md | grep -A5 "CHECKPOINT"
```

Resume from `NEXT_FEATURE` if checkpoint exists.

### 2. Check Foundation Gate

```bash
grep "FOUNDATION_COMPLETE:" /migration/manifest.md
```

If `false`, check if current feature is foundation. Non-foundation features are BLOCKED until gate opens.

### 3. Get Ready Features (with dependency check)

```bash
# Get ready features
grep -l "CURRENT: ready-for-dev" migration/modules/*/features/*.md 2>/dev/null | head -n $BATCH_SIZE
```

For each feature, verify dependencies are `complete` before proceeding:
```bash
grep "DEPENDS_ON:" {feature_file} | while read dep; do
  dep_status=$(grep "CURRENT:" migration/modules/*/$dep.md 2>/dev/null)
  if [[ "$dep_status" != *"complete"* ]]; then
    echo "BLOCKED: $feature depends on incomplete: $dep"
  fi
done
```

### 4. Loop: Process Each Feature

For each feature, run `/migrate-next` flow:

1. **Validate dependencies** → If blocked, skip to next
2. Create worktree
3. Dispatch backend-coder → WAIT
4. Dispatch qa-agent (backend) → WAIT → If ESCALATED, skip to next
5. **ATOMIC CHECKPOINT** → Save immediately after backend QA
6. Dispatch frontend-coder → WAIT
7. Dispatch qa-agent (frontend) → WAIT → If ESCALATED, skip to next
8. **ATOMIC CHECKPOINT** → Save immediately after frontend QA
9. Dispatch qa-agent (integration) → WAIT
10. **ATOMIC CHECKPOINT** → Save immediately after merge
11. Next feature...

### 5. Atomic Checkpoint (after each phase)

**CRITICAL**: Save checkpoint IMMEDIATELY after each successful phase, not at end of batch.

```markdown
CHECKPOINT: true
CHECKPOINT_REASON: phase_complete
BATCH_CURRENT: {count}
BATCH_TARGET: {requested}
LAST_COMPLETED: {module}/{feature}
LAST_PHASE: backend-qa | frontend-qa | integration-qa
NEXT_FEATURE: {next ready or "none"}
CHECKPOINT_TIME: {ISO timestamp}
```

### 6. Save Final Checkpoint

```markdown
CHECKPOINT: true
CHECKPOINT_REASON: batch_complete
BATCH_CURRENT: {count}
BATCH_TARGET: {requested}
LAST_COMPLETED: {feature}
NEXT_FEATURE: {next ready or "none"}
```

## Output

```
BATCH COMPLETE
==============
Processed: {count}
Human Review: {passed}
Escalated: {failed}
Skipped (blocked): {blocked by dependencies}
Remaining: {total remaining}

Next: /migrate-batch N or /migrate-human-review
```

## Rules

- One feature at a time through full cycle
- **Validate dependencies before starting feature**
- **Atomic checkpoint after each phase** (prevents duplicate work on resume)
- Frontend WAITS for backend QA (needs API contract)
- Each QA phase has 3 retry limit
- Sub-agents do all heavy work
- Non-foundation features blocked until foundation complete
