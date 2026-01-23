# Migration Manifest

## State
STATUS: not-started
PHASE: initialization
CREATED: 2025-12-27

## Paths
LEGACY: /legacy
BACKEND: /modern/backend
FRONTEND: /modern/frontend
WORKTREES_DIR: /worktrees

## Progress
TOTAL_FEATURES: 0
COMPLETED: 0
HUMAN_REVIEW: 0
IN_PROGRESS: 0
READY_FOR_QA: 0
ESCALATED: 0
BLOCKED_DEPENDENCIES: 0
BLOCKED_CIRCULAR: 0
PERCENT: 0%

## Foundation Gate (GLOBAL)
```
# CRITICAL: Non-foundation features are BLOCKED until all foundation complete
# Foundation features: layout-and-styles, error-boundary, static pages
```
FOUNDATION_COMPLETE: false
FOUNDATION_FEATURES_TOTAL: 0
FOUNDATION_FEATURES_DONE: 0

## Active Worktrees (Parallel Work)
```
# Format: worktree-name: status (agent) | created: ISO-timestamp | age
# Example:
# auth-login: backend-in-progress (backend-coder) | created: 2024-01-15T10:30:00Z | 0.5h
# orders-create: qa-in-progress (qa-agent) | created: 2024-01-15T09:00:00Z | 2h
# products-list: ready-to-merge | created: 2024-01-15T08:00:00Z | 3h ⚠ STALE
```

ACTIVE_WORKTREES: none
STALE_WORKTREES: none

## Phase Checklist
- [ ] Discovery complete
- [ ] Tech stack decided
- [ ] Projects scaffolded
- [ ] Foundation complete (gate opens)
- [ ] Layer 1: Shared services
- [ ] Layer 2: Core modules
- [ ] Layer 3: Secondary modules
- [ ] Final integration

## Parallel Capacity
MAX_PARALLEL_FEATURES: 5
CURRENT_PARALLEL: 0

## Dependency Health
```
# Circular dependencies detected (require human intervention)
```
CIRCULAR_DEPENDENCIES: none
BLOCKED_FEATURES: none

## Last Actions
```
# Timestamp | Action | Feature | Result
```

LAST_UPDATE: 2025-12-27

## Merge Log
```
# Date | Feature | Branch | Commit
```

## Checkpoint (for auto-continuation)
```
# Atomic checkpoint: saved IMMEDIATELY after each phase, not at batch end
```
CHECKPOINT: false
CHECKPOINT_REASON: none
CHECKPOINT_AT: none
LAST_COMPLETED: none
LAST_PHASE: none
NEXT_FEATURE: none
CHECKPOINT_TIME: none
CONTEXT_USAGE: 0%

## Batch Mode
BATCH_SIZE: 5
BATCH_CURRENT: 0
BATCH_TARGET: 0

## Rollback Info
```
# Track merged features for potential rollback
# Date | Feature | Merge Commit | Parent Commit (for revert)
```
LAST_MERGE: none
ROLLBACK_AVAILABLE: false
