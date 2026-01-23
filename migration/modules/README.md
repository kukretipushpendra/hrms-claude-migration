# Migration Modules

This directory contains feature specification files organized by module. Each module has its own subdirectory with individual feature markdown files.

## Directory Structure

```
modules/
  {module-name}/
    features/
      {feature-name}.md
```

**Example:**
```
modules/
  auth/
    features/
      login.md
      logout.md
      session.md
  orders/
    features/
      create.md
      list.md
      delete.md
```

## Feature File Template

Each feature file (`{feature}.md`) tracks the migration status and metadata:

```markdown
# {Module}: {Feature}

## Status
CURRENT: ready-for-dev
BACKEND: pending
BACKEND_QA: pending
FRONTEND: pending
FRONTEND_QA: pending
INTEGRATION_QA: pending

## Dependencies
DEPENDS_ON: [list of module/feature dependencies]

## Attempts
BACKEND_ATTEMPT_COUNT: 0
FRONTEND_ATTEMPT_COUNT: 0
INTEGRATION_ATTEMPT_COUNT: 0

## Legacy Reference
LEGACY_FILES: [paths to legacy source files]

## Notes
[Implementation notes, edge cases, special requirements]
```

## Status Values

| Status | Description |
|--------|-------------|
| `dependent` | Blocked by another feature |
| `blocked-dependencies` | Dependencies not complete |
| `blocked-circular` | Circular dependency detected |
| `ready-for-dev` | Ready to implement |
| `backend-in-progress` | Backend coder working |
| `backend-ready-for-qa` | Backend awaiting QA |
| `backend-qa-passed` | Backend verified |
| `backend-qa-failed` | Backend QA failed |
| `frontend-in-progress` | Frontend coder working |
| `frontend-ready-for-qa` | Frontend awaiting QA |
| `frontend-qa-passed` | Frontend verified |
| `frontend-qa-failed` | Frontend QA failed |
| `integration-qa` | Full stack QA in progress |
| `qa-passed` | All QA passed |
| `qa-failed` | Integration QA failed |
| `human-review` | Merged, awaiting human review |
| `rework` | Human requested AI rework |
| `complete` | Done |
| `escalated` | Failed 3 attempts |
| `rolled-back` | Reverted from main |

See [statuses.md](../statuses.md) for complete status documentation.

## Feature Lifecycle

```
ready-for-dev
    |
    v
backend-in-progress --> backend-ready-for-qa --> backend-qa-passed
    |                                                   |
    |                                                   v
    |                                     frontend-in-progress
    |                                                   |
    |                                                   v
    |                                     frontend-ready-for-qa
    |                                                   |
    |                                                   v
    |                                     frontend-qa-passed
    |                                                   |
    v                                                   v
                        integration-qa
                              |
                              v
                          qa-passed
                              |
                              v
                        human-review
                              |
                              v
                          complete
```

## Commands

| Command | Purpose |
|---------|---------|
| `/migrate-next` | Pick up next `ready-for-dev` feature |
| `/migrate-status` | Show all feature statuses |
| `/migrate-qa` | Run QA on pending features |
| `/migrate-human-review` | Review completed features |

## Notes

- Feature files are created during `/migrate-init` discovery phase
- Status updates are automatic as sub-agents complete work
- Failed QA retries up to 3x before escalation
- Foundation features must complete before non-foundation work begins
