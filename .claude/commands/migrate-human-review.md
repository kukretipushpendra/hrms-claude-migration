---
description: List features awaiting human approval
allowed-tools: Read, Glob, Grep
---

# Features Awaiting Human Review

## Find Features

```bash
grep -l "CURRENT: human-review" migration/modules/*/features/*.md
```

## Output

```
AWAITING HUMAN REVIEW
=====================
1. {module}/{feature}
   Branch: feature/{module}-{feature}
   File: migration/modules/{module}/features/{feature}.md

TO APPROVE:
  1. Review branch, test against legacy
  2. Edit feature file: CURRENT: complete
  3. Merge branch to main

TO REQUEST REWORK:
  1. Edit feature file:
     CURRENT: rework
     HUMAN_FEEDBACK: "Your feedback"
  2. Run /migrate-human-review-fix

TEST:
  git checkout feature/{module}-{feature}
  cd modern/backend && npm run start:dev
  cd modern/frontend && npm run dev
```
