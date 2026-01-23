---
description: Run QA on features ready for testing
allowed-tools: Read, Glob, Grep, Bash, Write, Edit, Task
---

# Run QA Verification

## 1. Find Features Ready for QA

```bash
grep -l "CURRENT: ready-for-qa" migration/modules/*/features/*.md
grep -l "CURRENT: backend-ready-for-qa" migration/modules/*/features/*.md
grep -l "CURRENT: frontend-ready-for-qa" migration/modules/*/features/*.md
```

## 2. Dispatch QA Agent

For each feature:

```
Task (qa-agent): "QA for {module}/{feature}
WORKTREE: worktrees/{module}-{feature}
QA_TYPE: {backend|frontend|integration}
Return result."
```

QA agent handles:
- Verification against legacy (source of truth)
- Retry loops (max 3 attempts)
- Escalation on failure
- Merge on integration pass

## 3. Output

```
QA RESULTS
==========
{module}/{feature}: PASSED → human-review
{module}/{feature}: FAILED → retry (attempt 2)
{module}/{feature}: ESCALATED → needs human

Next: /migrate-human-review
```
