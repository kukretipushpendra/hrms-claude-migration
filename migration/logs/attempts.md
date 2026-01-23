# Feature Attempts Log

Tracks all feature implementation attempts for learning and debugging.

---

## Entry Format

```
### {module}/{feature} - Attempt {n}

DATE: YYYY-MM-DD
AGENT: backend-coder | frontend-coder
BRANCH: feature/{module}-{feature}
RESULT: qa-failed

QA_FEEDBACK:
  - {specific mismatch found}
  - {what was wrong}

LEGACY_REFERENCE:
  - {file}:{lines} - {what was missed or misunderstood}

LEARNINGS:
  - {what the next attempt should do differently}
  - {pattern to avoid}

---
```

## Example Entry

```
### orders/delete - Attempt 1

DATE: 2024-01-17
AGENT: backend-coder
BRANCH: feature/orders-delete
RESULT: qa-failed

QA_FEEDBACK:
  - Missing inventory restoration before delete
  - Refund not called synchronously

LEGACY_REFERENCE:
  - /legacy/Services/OrderService.cs:256-271 - Inventory restore happens first
  - /legacy/Services/OrderService.cs:273 - Refund is synchronous, not async

LEARNINGS:
  - Always check service call order in legacy
  - Check if operations are sync or async in legacy

---
```

## Log Entries

(Entries added automatically when QA fails a feature)

---
