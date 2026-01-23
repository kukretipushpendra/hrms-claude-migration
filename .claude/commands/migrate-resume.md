---
description: Resume migration from last checkpoint
allowed-tools: Read, Glob, Grep, Bash, Write, Edit, Task
---

# Resume Migration

## 1. Read Checkpoint

```bash
grep -A10 "CHECKPOINT" /migration/manifest.md
```

## 2. If No Checkpoint

Report no checkpoint and suggest `/migrate-init`, `/migrate-next`, or `/migrate-status`.

## 3. Resume

If `CHECKPOINT: true`:
1. Display checkpoint info (last completed, next feature)
2. Check for incomplete work: `grep -l "CURRENT: in-progress" migration/modules/*/features/*.md`
3. Clear checkpoint: `CHECKPOINT: false`
4. Run batch processing (equivalent to `/migrate-batch 5`)

## Output

```
RESUMING FROM CHECKPOINT
========================
Last: {last_completed}
Next: {next_feature}
Processing...
```
