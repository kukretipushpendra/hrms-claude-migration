# Feature Statuses

Reference for all valid feature status values used in `/migration/modules/{module}/features/{feature}.md`

---

## Status Flow with Worktrees (SEQUENTIAL)

```
ready-for-dev
     │
     ├─► Create worktree: git worktree add worktrees/{name} -b feature/{name}
     │
     ▼
┌─────────────────────────────────────────────────────────────────┐
│                    BACKEND PHASE                                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  backend-in-progress                                             │
│       │                                                          │
│       ├─► Backend coder implements                               │
│       ├─► Creates API contract                                   │
│       │                                                          │
│       ▼                                                          │
│  backend-ready-for-qa                                            │
│       │                                                          │
│       ├─► QA agent reviews BACKEND ONLY                          │
│       │                                                          │
│       ├────────────────────────┬─────────────────────────┐       │
│       │                        │                         │       │
│       ▼                        ▼                         ▼       │
│  backend-qa-passed      backend-qa-failed          backend-qa-failed │
│       │                   (attempts < 3)            (attempts >= 3)  │
│       │                        │                         │       │
│       │                        ▼                         ▼       │
│       │                  Spawn backend-coder        ESCALATED    │
│       │                  to fix → re-QA                          │
│       │                                                          │
└───────┼──────────────────────────────────────────────────────────┘
        │
        │ API contract ready, backend verified
        ▼
┌─────────────────────────────────────────────────────────────────┐
│                   FRONTEND PHASE                                 │
│              (ONLY starts after backend-qa-passed)               │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  frontend-in-progress                                            │
│       │                                                          │
│       ├─► Frontend coder reads API contract                      │
│       ├─► Frontend coder implements                              │
│       │                                                          │
│       ▼                                                          │
│  frontend-ready-for-qa                                           │
│       │                                                          │
│       ├─► QA agent reviews FRONTEND ONLY                         │
│       │                                                          │
│       ├────────────────────────┬─────────────────────────┐       │
│       │                        │                         │       │
│       ▼                        ▼                         ▼       │
│  frontend-qa-passed     frontend-qa-failed         frontend-qa-failed │
│       │                   (attempts < 3)            (attempts >= 3)   │
│       │                        │                         │       │
│       │                        ▼                         ▼       │
│       │                  Spawn frontend-coder       ESCALATED    │
│       │                  to fix → re-QA                          │
│       │                                                          │
└───────┼──────────────────────────────────────────────────────────┘
        │
        │ Both backend and frontend verified separately
        ▼
┌─────────────────────────────────────────────────────────────────┐
│                  INTEGRATION PHASE                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  integration-qa                                                  │
│       │                                                          │
│       ├─► QA agent reviews FULL STACK                            │
│       ├─► Tests frontend ↔ backend integration                   │
│       ├─► Verifies end-to-end flow                               │
│       │                                                          │
│       ├────────────────────────┬─────────────────────────┐       │
│       │                        │                         │       │
│       ▼                        ▼                         ▼       │
│   qa-passed             integration-failed          integration-failed │
│       │                   (attempts < 3)            (attempts >= 3)    │
│       │                        │                         │       │
│       │                        ▼                         ▼       │
│       │                  Fix + re-QA                ESCALATED    │
│       │                                                          │
└───────┼──────────────────────────────────────────────────────────┘
        │
        ▼
AUTO-MERGE TO MAIN
     │
     ├─► git merge feature/{name}
     ├─► git worktree remove
     ├─► git branch -d
     │
     ▼
human-review (NOT complete yet!)
     │
     ├─► Human reviews merged code via /migrate-human-review
     │
     ├─────────────────────────────┐
     │                             │
     ▼                             ▼
Issues found                  Satisfied
     │                             │
     ▼                             ▼
/migrate-human-review-fix     Mark COMPLETE
     │                        (manually)
     ▼
Fix applied → human-review
```

---

## Status Definitions

| Status | Description | Phase | Next Action | Set By |
|--------|-------------|-------|-------------|--------|
| `dependent` | Blocked by another feature | - | Auto-updates when dependency completes | System |
| `blocked-dependencies` | Dependencies not yet complete | - | Wait for dependencies | System |
| `blocked-circular` | Circular dependency detected | - | Human intervention required | System |
| `ready-for-dev` | Ready to implement | - | Create worktree, dispatch backend-coder | System |
| `backend-in-progress` | Backend coder working | Backend | Wait for backend completion | Backend Coder |
| `backend-ready-for-qa` | Backend done, needs QA | Backend | Dispatch QA for backend review | Backend Coder |
| `backend-qa-passed` | Backend QA verified | Backend | Validate contract, dispatch frontend-coder | QA Agent |
| `backend-qa-failed` | Backend QA found issues | Backend | Retry or escalate | QA Agent |
| `frontend-in-progress` | Frontend coder working | Frontend | Wait for frontend completion | Frontend Coder |
| `frontend-ready-for-qa` | Frontend done, needs QA | Frontend | Dispatch QA for frontend review | Frontend Coder |
| `frontend-qa-passed` | Frontend QA verified | Frontend | Dispatch integration QA | QA Agent |
| `frontend-qa-failed` | Frontend QA found issues | Frontend | Retry or escalate | QA Agent |
| `integration-qa` | Full stack QA in progress | Integration | Wait for integration QA | QA Agent |
| `qa-passed` | All QA passed | Integration | Auto-merge, cleanup worktree | QA Agent |
| `qa-failed` | Integration QA failed | Integration | Fix + retry or escalate | QA Agent |
| `human-review` | Merged, awaiting human | - | Human reviews via /migrate-human-review | QA Agent |
| `rework` | Merged, human want AI to rework | - | Human reviews via /migrate-human-review | Human use `/migrate-human-review-fix` | Human
| `complete` | Done, merged, reviewed | - | None - finished | Human |
| `escalated` | Failed 3 attempts | - | Human investigates (auto-analysis generated) | QA Agent |
| `rolled-back` | Merged but reverted | - | Fix issue, set ready-for-dev | Human |

---

## Status Details

### `ready-for-dev`
Feature is ready to be picked up. Orchestrator will create a worktree.

```markdown
CURRENT: ready-for-dev
BACKEND: pending
BACKEND_QA: pending
FRONTEND: pending
FRONTEND_QA: pending
INTEGRATION_QA: pending
WORKTREE: (to be created)
```

---

### `backend-in-progress`
Backend coder is actively implementing.

```markdown
CURRENT: backend-in-progress
BACKEND: in-progress
BACKEND_QA: pending
FRONTEND: pending (BLOCKED - waiting for API contract)
FRONTEND_QA: pending
BRANCH: feature/orders-delete
WORKTREE: worktrees/orders-delete
```

---

### `backend-ready-for-qa`
Backend implementation complete, awaiting QA review.

```markdown
CURRENT: backend-ready-for-qa
BACKEND: complete
BACKEND_QA: pending
FRONTEND: pending (BLOCKED)
API_CONTRACT: migration/api-contracts/orders.api.md
BRANCH: feature/orders-delete
WORKTREE: worktrees/orders-delete
```

---

### `backend-qa-passed`
Backend QA verified. Frontend can now start.

```markdown
CURRENT: backend-qa-passed
BACKEND: complete
BACKEND_QA: passed
BACKEND_QA_DATE: 2024-01-17
FRONTEND: pending (UNBLOCKED - can start)
API_CONTRACT: migration/api-contracts/orders.api.md
```

**CRITICAL**: This status unblocks the frontend-coder.

---

### `backend-qa-failed`
Backend QA found issues. Backend coder will fix.

```markdown
CURRENT: backend-qa-failed
BACKEND: complete
BACKEND_QA: failed
BACKEND_QA_FEEDBACK: "Validation order incorrect - check line 45"
BACKEND_ATTEMPT_COUNT: 1
FRONTEND: pending (STILL BLOCKED)
```

---

### `frontend-in-progress`
Frontend coder is actively implementing.

```markdown
CURRENT: frontend-in-progress
BACKEND: complete
BACKEND_QA: passed
FRONTEND: in-progress
FRONTEND_QA: pending
```

---

### `frontend-ready-for-qa`
Frontend implementation complete, awaiting QA review.

```markdown
CURRENT: frontend-ready-for-qa
BACKEND: complete
BACKEND_QA: passed
FRONTEND: complete
FRONTEND_QA: pending
```

---

### `frontend-qa-passed`
Frontend QA verified. Ready for integration QA.

```markdown
CURRENT: frontend-qa-passed
BACKEND: complete
BACKEND_QA: passed
FRONTEND: complete
FRONTEND_QA: passed
FRONTEND_QA_DATE: 2024-01-17
INTEGRATION_QA: pending
```

---

### `integration-qa`
Full stack integration QA in progress.

```markdown
CURRENT: integration-qa
BACKEND: complete
BACKEND_QA: passed
FRONTEND: complete
FRONTEND_QA: passed
INTEGRATION_QA: in-progress
```

**Checks performed:**
- Frontend calls correct API endpoints
- Request/response shapes match
- Error handling works end-to-end
- Full user flow works

---

### `qa-passed`
All QA stages passed. Ready to merge.

```markdown
CURRENT: qa-passed
BACKEND_QA: passed
FRONTEND_QA: passed
INTEGRATION_QA: passed
QA_DATE: 2024-01-17
WORKTREE: worktrees/orders-delete (merging...)
```

Immediately followed by merge + worktree removal → `human-review`

---

### `human-review`
Code merged to main, awaiting human review.

```markdown
CURRENT: human-review
BACKEND: complete
FRONTEND: complete
BACKEND_QA: passed
FRONTEND_QA: passed
INTEGRATION_QA: passed
MERGED_DATE: 2024-01-18
MERGED_COMMIT: abc123
WORKTREE: (removed)
```

---

### `escalated`
Failed 3 QA attempts at any phase. Requires human investigation.

```markdown
CURRENT: escalated
ESCALATED_AT: backend-qa | frontend-qa | integration-qa
ATTEMPT_COUNT: 3
ESCALATED_DATE: 2024-01-17
WORKTREE: worktrees/orders-delete (PRESERVED)
```

**Auto-generated entry in `/migration/logs/escalations.md`** with:
- All 3 attempt details
- Detected pattern
- Suspected root cause
- Suggested action

---

### `rolled-back`
Feature was merged but caused issues on main and was reverted.

```markdown
CURRENT: rolled-back
ROLLBACK_DATE: 2024-01-18
ROLLBACK_REASON: "Broke payment integration on main"
ROLLBACK_COMMIT: def456
PREVIOUS_STATUS: human-review
```

**To retry**: Set `CURRENT: ready-for-dev` after fixing the issue.

---

### `blocked-circular`
Circular dependency detected between two features.

```markdown
CURRENT: blocked-circular
CIRCULAR_WITH: auth/session
DETECTED_DATE: 2024-01-17
```

**Requires human intervention** to break the circular dependency.

---

### `blocked-dependencies`
Feature dependencies are not yet complete.

```markdown
CURRENT: blocked-dependencies
DEPENDS_ON: auth/login, shared/layout
WAITING_FOR: auth/login (backend-in-progress)
```

**Auto-updates** when all dependencies reach `complete`.

---

## Sub-Status Reference

### Backend Status
| Value | Meaning |
|-------|---------|
| `pending` | Not started |
| `in-progress` | Backend coder working |
| `complete` | Implementation done |
| `n/a` | No backend (frontend-only feature) |

### Backend QA Status
| Value | Meaning |
|-------|---------|
| `pending` | Not reviewed yet |
| `in-progress` | QA reviewing |
| `passed` | QA approved |
| `failed` | QA found issues |

### Frontend Status
| Value | Meaning |
|-------|---------|
| `pending` | Not started (blocked until backend-qa-passed) |
| `in-progress` | Frontend coder working |
| `complete` | Implementation done |
| `n/a` | No frontend (API-only feature) |

### Frontend QA Status
| Value | Meaning |
|-------|---------|
| `pending` | Not reviewed yet |
| `in-progress` | QA reviewing |
| `passed` | QA approved |
| `failed` | QA found issues |

### Integration QA Status
| Value | Meaning |
|-------|---------|
| `pending` | Not reviewed yet |
| `in-progress` | QA reviewing full stack |
| `passed` | Integration verified |
| `failed` | Integration issues found |

---

## QA Types Summary

| QA Type | When | What's Reviewed | Reviewer |
|---------|------|-----------------|----------|
| Backend QA | After backend-ready-for-qa | API endpoints, validation, business logic | QA Agent |
| Frontend QA | After frontend-ready-for-qa | UI components, forms, client validation | QA Agent |
| Integration QA | After frontend-qa-passed | Full stack, API calls, end-to-end flow | QA Agent |

---

## Worktree Commands Reference

```bash
# List all worktrees
git worktree list

# Create worktree for feature
git worktree add worktrees/{module}-{feature} -b feature/{module}-{feature}

# Remove worktree (after merge)
git worktree remove worktrees/{module}-{feature}

# Force remove (if needed)
git worktree remove worktrees/{module}-{feature} --force

# Delete branch after merge
git branch -d feature/{module}-{feature}
```
