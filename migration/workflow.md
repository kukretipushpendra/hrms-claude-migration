# Parallel Migration Workflow

## Core Concept: Git Worktrees for True Parallelization

Each feature gets its own isolated git worktree. Multiple agents work simultaneously on different features.

```
project-root/
├── main repo (protected)
│   ├── legacy/
│   ├── modern/
│   └── migration/
│
└── worktrees/                          ← Parallel work happens here
    ├── auth-login/                     ← Agent A: backend in progress
    │   ├── legacy/
    │   ├── modern/
    │   └── migration/
    ├── orders-create/                  ← Agent B: frontend in progress
    ├── products-list/                  ← Agent C: QA in progress
    └── users-profile/                  ← Ready to merge
```

## Workflow Diagram

```
                              ┌─────────────────────────────────────┐
                              │         ORCHESTRATOR                │
                              │   (Parallel Dispatch Manager)       │
                              └─────────────────────────────────────┘
                                             │
              ┌──────────────────────────────┼──────────────────────────────┐
              │                              │                              │
              ▼                              ▼                              ▼
    ┌─────────────────┐            ┌─────────────────┐            ┌─────────────────┐
    │ Feature A       │            │ Feature B       │            │ Feature C       │
    │ Worktree        │            │ Worktree        │            │ Worktree        │
    └────────┬────────┘            └────────┬────────┘            └────────┬────────┘
             │                              │                              │
             ▼                              ▼                              ▼
    ┌─────────────────┐            ┌─────────────────┐            ┌─────────────────┐
    │ Backend Coder   │            │ Frontend Coder  │            │ QA Agent        │
    │ (in worktree)   │            │ (in worktree)   │            │ (in worktree)   │
    └────────┬────────┘            └────────┬────────┘            └────────┬────────┘
             │                              │                              │
             ▼                              ▼                              │
    ┌─────────────────┐            ┌─────────────────┐                     │
    │ ready-for-qa    │            │ ready-for-qa    │                     │
    └────────┬────────┘            └────────┬────────┘                     │
             │                              │                              │
             ▼                              ▼                              ▼
    ┌─────────────────┐            ┌─────────────────┐            ┌─────────────────┐
    │ QA Agent        │            │ QA Agent        │            │ PASS?           │
    └────────┬────────┘            └────────┬────────┘            └────────┬────────┘
             │                              │                              │
       ┌─────┴─────┐                  ┌─────┴─────┐                  ┌─────┴─────┐
       │           │                  │           │                  │           │
       ▼           ▼                  ▼           ▼                  ▼           ▼
    ┌──────┐   ┌──────┐           ┌──────┐   ┌──────┐           ┌──────┐   ┌──────┐
    │ PASS │   │ FAIL │           │ PASS │   │ FAIL │           │MERGE │   │RETRY │
    └──┬───┘   └──┬───┘           └──┬───┘   └──┬───┘           │  +   │   │  or  │
       │          │                  │          │               │CLEAN │   │ESCAL │
       ▼          ▼                  ▼          ▼               └──────┘   └──────┘
    ┌──────────────────┐         ┌──────────────────┐
    │ Auto-Merge       │         │ Retry (max 3)    │
    │ + Delete Worktree│         │ or Escalate      │
    └──────────────────┘         └──────────────────┘
```

## Feature Lifecycle in Worktree

### 1. Feature Picked (ready-for-dev)
```bash
# Orchestrator creates worktree
git worktree add worktrees/{module}-{feature} -b feature/{module}-{feature}
```

### 2. Backend Development
- Backend-coder agent works in `worktrees/{module}-{feature}/`
- Implements in `modern/backend/src/modules/{module}/`
- Commits to feature branch
- Updates status: `BACKEND: complete`

### 3. Frontend Development
- Frontend-coder agent works in same worktree
- Implements in `modern/frontend/src/`
- Commits to feature branch
- Updates status: `FRONTEND: complete`, `CURRENT: ready-for-qa`

### 4. QA Verification
- QA agent reviews in worktree
- Compares against legacy code (source of truth)
- **PASS**: Proceeds to merge
- **FAIL**: Triggers retry or escalation

### 5a. QA Pass → Auto-Merge
```bash
# QA agent handles this automatically
git checkout main
git merge feature/{module}-{feature} --no-ff
git worktree remove worktrees/{module}-{feature}
git branch -d feature/{module}-{feature}
```
Status: `CURRENT: complete`

### 5b. QA Fail → Retry
- Increment `ATTEMPT_COUNT`
- Log to `attempts.md`
- Set `CURRENT: ready-for-dev`
- Coder agent fixes in same worktree
- QA again

### 5c. QA Fail (3rd time) → Escalate
- Set `CURRENT: escalated`
- Log to `escalations.md`
- KEEP worktree for human investigation
- Human intervenes

## Parallel Capacity

The orchestrator can manage multiple worktrees simultaneously:

```
ACTIVE_WORKTREES:
  - worktrees/auth-login: backend-in-progress
  - worktrees/auth-register: qa-in-progress
  - worktrees/orders-create: frontend-in-progress
  - worktrees/orders-list: ready-for-qa (dispatching QA)
  - worktrees/products-search: ready-to-merge (QA passed)
```

**Recommended parallel limit**: 3-5 features at once
(Depends on complexity and available context)

## Commands

| Command | Action |
|---------|--------|
| `git worktree list` | See all active worktrees |
| `git worktree add worktrees/{name} -b {branch}` | Create new worktree |
| `git worktree remove worktrees/{name}` | Remove worktree |
| `git branch -d {branch}` | Delete merged branch |

## Key Benefits

1. **True Parallelization**: Multiple features developed simultaneously
2. **Isolation**: Each feature in its own directory, no conflicts
3. **Atomic Merges**: Each feature merges independently
4. **Easy Rollback**: Delete worktree + branch to abandon
5. **Clear Progress**: Worktree count = active work items
