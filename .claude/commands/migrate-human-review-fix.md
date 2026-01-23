---
description: Fix features marked for rework based on human feedback
allowed-tools: Read, Glob, Grep, Bash, Write, Edit, Task
---

# Fix Rework Features

## 1. Find Rework Features

```bash
grep -l "CURRENT: rework" migration/modules/*/features/*.md
```

## 2. Read Feedback

For first rework feature, read:
- `HUMAN_FEEDBACK` field
- Legacy files in spec
- Current implementation

## 3. Dispatch Coder

Determine backend or frontend issue, then:

```
Task ({backend|frontend}-coder): "Fix rework for {module}/{feature}
WORKTREE: worktrees/{module}-{feature}
FEEDBACK: {human feedback}
Fix ONLY what was mentioned. Match legacy exactly."
```

## 4. Update Status

```markdown
CURRENT: ready-for-qa
HUMAN_FEEDBACK: (cleared)
```

## Output

```
REWORK FIX
==========
Feature: {module}/{feature}
Feedback: "{feedback}"
Fix: {what was changed}
Status: ready-for-qa

Next: /migrate-qa
```
