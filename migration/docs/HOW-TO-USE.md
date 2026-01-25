# How to Use This Framework

A comprehensive guide to the tech-agnostic migration framework using Claude Code CLI.

**Current stack:** React.js + .NET → Vue.js + Node.js/Express + SQL Server (same database)
**Adaptable to:** Any source/target combination via `/migrate-adapt`

## Table of Contents

- [Adapting to Your Tech Stack](#adapting-to-your-tech-stack)
- [Typical Workflow](#typical-workflow)
- [Slash Commands](#slash-commands)
- [Available Agents](#available-agents)
- [Feature Status Flow](#feature-status-flow)
- [Recommendations and Best Practices](#recommendations-and-best-practices)
- [Parallel Workflow Architecture](#parallel-workflow-architecture)
- [Fully Automatic Migration](#fully-automatic-migration)
- [Feature Spec Format](#feature-spec-format)
- [Git Worktree Commands](#git-worktree-commands)
- [Troubleshooting](#troubleshooting)

---

## Adapting to Your Tech Stack

The framework is currently configured for React.js + .NET → Vue.js + Node.js/Express + SQL Server. If your stack is different, run `/migrate-adapt` **before** `/migrate-init`.

### When to Use `/migrate-adapt`

| Your Legacy Stack | Run `/migrate-adapt`? |
|-------------------|----------------------|
| .NET MVC with Razor | No (default) |
| Laravel with Blade | **Yes** |
| Django with Templates | **Yes** |
| Rails with ERB | **Yes** |
| Vue.js frontend | **Yes** |
| Angular frontend | **Yes** |
| Spring Boot | **Yes** |

### How to Run `/migrate-adapt`

```bash
# Interactive mode (will ask questions)
/migrate-adapt

# With arguments (recommended)
/migrate-adapt "Target Stack: frontend: react, backend: nestjs, legacy is Frontend: blade and backend: laravel"
```

### Example: Laravel to React + NestJS

```
1. Copy Laravel project to /legacy folder
2. Run: /migrate-adapt "Target Stack: frontend: react, backend: nestjs, legacy is Frontend: blade and backend: laravel"
3. Framework adapts:
   - Explorer updated to look for Controllers/, Models/, resources/views/
   - Concept mappings created (Eloquent → Sequelize, Blade → JSX)
   - Skills configured for Laravel patterns
4. Run: /migrate-init (continues as normal)
```

### What Gets Modified

| File | Changes |
|------|---------|
| `/migration/tech-stack.md` | Source/target framework configuration |
| `/.claude/agents/explorer.md` | Discovery patterns for legacy framework |
| `/.claude/agents/backend-coder.md` | Target backend patterns |
| `/.claude/agents/frontend-coder.md` | Target frontend patterns |
| `/.claude/refs/concept-mappings.md` | Framework translation guide |
| `/CLAUDE.md` | Tech stack references |

### Supported Stack Combinations

**Legacy Backends:** .NET MVC, Laravel, Django, Rails, Spring, Express
**Legacy Frontends:** Razor, Blade, Django Templates, ERB, React.js, Vue.js, Angular
**Target Backends:** Node.js/Express, NestJS, FastAPI, Laravel, Django
**Target Frontends:** Vue.js, React, Svelte, Angular
**Target Databases:** SQL Server (same DB), PostgreSQL, MySQL, MongoDB

### After Adaptation

The framework works exactly the same:
1. `/migrate-init` discovers legacy using adapted patterns
2. `/migrate-next` implements features with correct mappings
3. Agents use framework-specific skills and patterns

---

## Typical Workflow

### Single Feature Migration (Recommended)

```
1. Run /migrate-next
2. Test the implementation
3. If passed → Run /migrate-human-review "feature x is passing human review"
4. If failed → Update feature doc with rework status and feedback
5. Run /migrate-human-review-fix
6. Test again and repeat from step 3
```

### Complete Migration Workflow (Start to Finish)

```
1. Setup:
   - Place legacy code in /legacy folder
   - (If not .NET) Run /migrate-adapt to configure for your stack
   - Run /migrate-init (discovers legacy, creates specs, scaffolds modern projects)

2. Foundation Phase:
   - Backend foundation features auto-migrate (database, auth, health)
   - Frontend foundation features auto-migrate (router, layout, auth pages)
   - Verify: Both backend and frontend can run and connect

3. Feature Migration:
   - Run /migrate-next repeatedly
   - Test each feature
   - Use /migrate-human-review to approve
   - Use /migrate-human-review-fix if issues found

4. All Features Complete:
   - Run /migrate-status (should show 100% complete)
   - All QA passed, all features merged to main branch

5. Optimization (OPTIONAL):
   - Run /migration-optimize
   - Analyzes bundle size, applies production configs
   - Adds code splitting, minification, compression
   - Only run AFTER all features are tested and working
```

### Example: Migrating "Order Item Delete" Feature

1. **Main agent analyzes the task** and spawns the backend-coder
2. **Backend coder** implements the feature and creates an API contract at `/migration/api-contracts/{module}/{feature}.api.md`
3. **QA agent** verifies backend against legacy implementation
   - **Pass**: Worktree merged and deleted
   - **Fail**: Creates issues and respawns backend-coder (retries up to 3 times, then escalates)
4. **Frontend coder** is spawned after backend QA passes
5. **QA agent** verifies frontend (same retry logic applies)
6. **Integration QA** checks frontend-backend integration and API contract compliance
7. **Human review**: Feature marked as `human-review` for your verification
   - **Approved**: Use `/migrate-human-review` to mark complete
   - **Issues found**: Set status to `rework` with `HUMAN_FEEDBACK` in `/migration/modules/{module}/{module.featurex.md}` and use `/migrate-human-review-fix`
8. You can also Use `/migrate-diff` to check if any difference in legacy and modern
---

## Slash Commands

| Command | Description |
|---------|-------------|
| `/migrate-adapt` | **Adapt framework to different tech stack** - Run BEFORE /migrate-init if not using .NET |
| `/migrate-init` | Analyze legacy codebase, brainstorm tech stack, scaffold projects, create feature specs |
| `/migrate-next` | Pick and implement the next ready feature (recommended approach) |
| `/migrate-batch N` | Process N features in sequence with checkpoint support |
| `/migrate-status` | Show progress, active worktrees, blockers, and queue |
| `/migrate-resume` | Resume from last checkpoint after context limit or interruption |
| `/migrate-qa` | Verify implementation and auto-merge on pass |
| `/migrate-human-review` | List escalated features needing human help |
| `/migrate-human-review-fix` | Fix features marked for rework based on human feedback |
| `/migrate-auto` | Full auto mode until complete or context limit |
| `/migrate-rollback` | Rollback a merged feature if issues are found |
| `/migrate-diff` | Compare legacy vs modern implementation |
| `/migration-optimize` | Apply production optimizations (bundle analysis, code splitting) - **Run AFTER migration is complete** |

---

## Available Agents

The framework uses specialized sub-agents that work in isolated git worktrees.

### Orchestrator

- **Purpose**: Coordinates parallel feature work via git worktrees
- **Responsibilities**:
  - Manages global foundation gate
  - Detects circular dependencies
  - Validates feature dependencies
  - Dispatches appropriate coders
  - Maintains thin context (reads manifest, not code)

### Explorer

- **Purpose**: Analyzes legacy .NET codebase
- **Outputs**:
  - `/migration/discovery/overview.md` - Framework and structure
  - `/migration/discovery/modules.json` - Module definitions
  - `/migration/discovery/database-schema.md` - Database structure
  - `/migration/discovery/ui-framework.json` - CSS/UI framework details

### Spec Writer

- **Purpose**: Creates feature specifications from legacy code
- **Outputs**: `/migration/modules/{module}/features/{feature}.md`
- **Includes**: Legacy file references, validation rules, behavior specs

### Backend Coder

- **Purpose**: Implements Node.js/Express backend in isolated worktrees
- **Expertise**: Express, TypeScript, SQL Server + mssql driver, REST APIs, JWT authentication
- **Outputs**:
  - Routes, controllers, services, DTOs, types
  - API contract at `/migration/api-contracts/{module}/{feature}.api.md`

### Frontend Coder

- **Purpose**: Implements Vue.js frontend in isolated worktrees
- **Prerequisites**: Backend complete, API contract exists
- **Expertise**: Vue.js 3, TypeScript, Pinia, Vite, Vue Router
- **Outputs**: Components, views, composables, services, types

### QA Agent

- **Purpose**: Verifies implementation against legacy at each phase
- **QA Types**:
  - **Foundation QA**: CSS, layout, static pages, error boundary
  - **Backend QA**: API, validation, business logic, API contract
  - **Frontend QA**: UI elements, forms, validation messages
  - **Integration QA**: Full stack flow, API calls, error handling
- **Behavior**: Retries up to 3 times with smart retry strategy, then escalates

### DB Schema Migrator

- **Purpose**: Connects to existing SQL Server database using mssql driver
- **Handles**: Connection pooling, Dapper → mssql query conversion, stored procedures

---

## Feature Status Flow

```
ready-for-dev
     │
     ├─► Create worktree
     │
     ▼
┌─────────────────────────────────────────┐
│            BACKEND PHASE                 │
│  backend-in-progress                     │
│       ↓                                  │
│  backend-ready-for-qa                    │
│       ↓                                  │
│  backend-qa-passed / failed              │
│  (failed: retry 3x → escalate)           │
└─────────────────────────────────────────┘
     │
     ▼
┌─────────────────────────────────────────┐
│           FRONTEND PHASE                 │
│  frontend-in-progress                    │
│       ↓                                  │
│  frontend-ready-for-qa                   │
│       ↓                                  │
│  frontend-qa-passed / failed             │
│  (failed: retry 3x → escalate)           │
└─────────────────────────────────────────┘
     │
     ▼
┌─────────────────────────────────────────┐
│         INTEGRATION PHASE                │
│  integration-qa                          │
│       ↓                                  │
│  qa-passed / failed                      │
│  (failed: retry 3x → escalate)           │
└─────────────────────────────────────────┘
     │
     ▼
AUTO-MERGE → human-review → complete
```

### All Possible Statuses

| Status | Description |
|--------|-------------|
| `dependent` | Blocked by another feature |
| `blocked-dependencies` | Dependencies not yet complete |
| `blocked-circular` | Circular dependency detected |
| `ready-for-dev` | Ready to implement |
| `backend-in-progress` | Backend coder working |
| `backend-ready-for-qa` | Backend done, awaiting QA |
| `backend-qa-passed` | Backend QA verified |
| `backend-qa-failed` | Backend QA found issues |
| `frontend-in-progress` | Frontend coder working |
| `frontend-ready-for-qa` | Frontend done, awaiting QA |
| `frontend-qa-passed` | Frontend QA verified |
| `frontend-qa-failed` | Frontend QA found issues |
| `integration-qa` | Full stack QA in progress |
| `qa-passed` | All QA passed, ready to merge |
| `qa-failed` | Integration QA failed |
| `human-review` | Merged, awaiting human review |
| `rework` | Human requested AI to rework |
| `complete` | Done, merged, reviewed |
| `escalated` | Failed 3 attempts, needs human |
| `rolled-back` | Merged but reverted |

---

## Recommendations and Best Practices

### Use `/migrate-next` Over `/migrate-batch`

- **`/migrate-next`** focuses on one feature at a time
- **`/migrate-batch N`** works but has limitations:
  - Running 5-6 parallel features may degrade quality
  - Hits `/compact` limitations
  - Loses context frequently

### For Parallel Execution

Use multiple terminals with different features:
```bash
# Terminal 1
/migrate-next "Do feature auth/login"

# Terminal 2
/migrate-next "Do feature orders/list"
```

**Important**: Ensure features don't have dependencies on each other.

### Context Management

- Always use `/clear` after completing a feature
- The main agent checks dependencies automatically
- Features may show as blocked if dependencies aren't complete

### When AI Makes Repeated Mistakes

1. Note the pattern
2. Update `CLAUDE.md` or relevant agent files
3. Report to framework developer

---

## Parallel Workflow Architecture

```
                    ORCHESTRATOR
                         │
         ┌───────────────┼───────────────┐
         │               │               │
         ▼               ▼               ▼
    worktree A      worktree B      worktree C
   (auth-login)   (orders-create)  (products-list)
```

### Within Each Worktree (Sequential)

```
Backend Coder → Backend QA → Frontend Coder → Frontend QA → Integration QA
```

### Key Benefits

1. **True Parallelization**: Multiple features developed simultaneously
2. **Isolation**: Each feature in its own worktree, no conflicts
3. **Auto-Merge**: QA agent merges to main automatically on pass
4. **Easy Rollback**: Delete worktree + branch to abandon
5. **Max 3 Retries**: Auto-escalate after 3 QA failures

---

## Fully Automatic Migration

Run the entire migration without interaction:

```bash
# Make script executable (first time only)
chmod +x auto-migrate.sh

# Run full migration
./auto-migrate.sh

# Or with custom batch size
./auto-migrate.sh --batch 10
```

### How It Works

```
Session 1: /migrate-batch 5
  ✓ student/list
  ✓ student/detail
  ✓ student/create
  → Checkpoint saved, exits

Session 2: /migrate-batch 5 (auto-started)
  ✓ courses/list
  ...

Session N:
  🎉 Migration complete!
```

**Note**: No real-time feedback. Output shows only when a Claude session ends.

### Real Talk: Why Fully Automatic Won't Work (Yet)

> *"But Rajesh, I'm too lazy. Can't I just run a script in YOLO mode and wake up to 'Migration complete 🎉'?"*

I get it. I really do. The dream of running `./auto-migrate.sh` before bed and waking up to a fully migrated codebase is tempting. But here's the hard truth from **200+ hours of hands-on Claude Code experience** across small, medium, and large .NET projects:

**It. Will. Fail.**

Even with a perfectly crafted shell script that loops through slash commands indefinitely, you'll hit walls:

#### What Actually Happens in Practice

```
Hour 1:   ✓ 3 features migrated successfully
Hour 2:   ✓ 2 more features, looking good!
Hour 3:   ✗ AI misinterprets a legacy quirk, implements wrong behavior
Hour 4:   ✗ Same mistake propagates to 2 dependent features
Hour 5:   ✗ QA passes (because QA inherited the same misunderstanding)
Hour 6:   💀 You now have 5 features with subtly wrong behavior
          that all "passed" QA and Human Review (as you did automation)
```

#### Why Human-in-the-Loop is Non-Negotiable (For Now)

1. **Legacy code has undocumented quirks** - The AI will make reasonable assumptions that are reasonably wrong
2. **Business logic isn't always logical** - That weird edge case exists for a reason only humans at your company know
3. **QA can only verify what it understands** - If the spec is wrong, QA validates the wrong thing
4. **Errors compound silently** - One misunderstanding cascades through dependencies
5. **Context drift** - After 10+ features, the AI's understanding subtly shifts from reality

#### The Realistic Workflow

```
You:     /migrate-next
Claude:  [implements feature]
You:     [5 min review] "Looks good" OR "Wait, that validation is wrong because..."
Claude:  [fixes based on your domain knowledge]
You:     /migrate-human-review "feature x is approved"
You:     /clear
You:     /migrate-next
[repeat]
```

Yes, it's more work. But you end up with a **correct** migration, not a "completed" migration you'll spend weeks debugging.

#### Will This Change?

Probably. AI is advancing fast. In 1-2 years, a single prompt like *"Migrate this .NET app to TypeScript with 100% parity"* might actually work. But as of January 2025, **active human supervision is the difference between a successful migration and a plausible-looking disaster**.

Trust me on this one. I learned it the hard way so you don't have to.

---

## Feature Spec Format

Each feature is tracked in `/migration/modules/{module}/features/{feature}.md`:

```markdown
# Feature: delete

## Identity
MODULE: orders
FEATURE: delete
CREATED: 2024-01-15

## Legacy References
FILES:
  - /legacy/Controllers/OrderController.cs (lines 145-189)
  - /legacy/Services/OrderService.cs (lines 234-298)

## Status
CURRENT: ready-for-dev
BACKEND: pending
FRONTEND: pending
WORKTREE: (to be created)
BRANCH: (none)

## Dependencies
DEPENDS_ON:
  - shared/payment-refund (complete)

## Behavior Spec
ENDPOINT: DELETE /api/orders/{id}

VALIDATION:
  - Order must exist → 404
  - Order must belong to user → 403

LOGIC:
  1. Call PaymentService.Refund()
  2. Restore inventory
  3. Soft delete order

RESPONSE:
  - Success: 204 No Content
  - Errors: 400, 403, 404

## Attempts
ATTEMPT_COUNT: 0
```

---

## Git Worktree Commands

```bash
# List all active worktrees
git worktree list

# Create worktree for a feature
git worktree add worktrees/{module}-{feature} -b feature/{module}-{feature}

# Remove worktree after merge
git worktree remove worktrees/{module}-{feature}

# Delete merged branch
git branch -d feature/{module}-{feature}
```

---

## Post-Migration Optimization

**IMPORTANT**: Only run optimization AFTER all features are complete and tested.

### When to Optimize

✅ **Run `/migration-optimize` when:**
- All features are migrated and merged
- All QA has passed
- Application works correctly in dev mode
- You're ready to prepare for production deployment

❌ **DON'T run optimization:**
- During active feature migration
- Before QA approval
- If build is already failing
- If bundle size is already optimal (< 200KB gzipped)

### What `/migration-optimize` Does

1. **Analyzes bundle size** - Identifies large dependencies and optimization opportunities
2. **Applies Vite optimizations** - Manual chunking, minification, console removal
3. **Configures code splitting** - Separates vendor code from app code for better caching
4. **Sets up bundle visualization** - Tools to monitor bundle size over time
5. **Applies TypeScript strict mode** (optional) - Additional type safety checks

### Optimization Results

Typical improvements:
- **Bundle size reduction**: 20-40% smaller
- **Load time improvement**: Faster initial page load
- **Better caching**: Vendor chunks cached separately
- **Cleaner production code**: Console logs removed, minified

### Example Output

```
OPTIMIZATION COMPLETE

Baseline: 1.2 MB
Optimized: 850 KB
Reduction: 29.2%

Chunks created:
- vendor-react.js: 180 KB
- vendor-utils.js: 95 KB
- app.js: 575 KB

Next: Deploy to staging and monitor performance
```

### Testing Optimized Build

```bash
cd modern/frontend

# Build with optimizations
npm run build

# Preview production build locally
npm run preview

# Test in browser at http://localhost:4173
# Verify: All routes load, no console errors, functionality works
```

### When Optimization Isn't Needed

For small applications (< 50 components), the base Vite setup is usually sufficient. Only optimize if:
- Bundle size is noticeably large (> 500KB)
- Initial load time is slow
- Preparing for production deployment
- Need better caching strategy

---

## Troubleshooting

### Context Window Filling Up

- Features are tracked per-file, not accumulated
- Each agent reads only what it needs
- State persists in files, not in memory
- Orchestrator dispatches to worktrees, doesn't hold context

### Feature Keeps Failing

- After 3 failures, feature is escalated
- Worktree is preserved for human investigation
- Check `/migration/logs/escalations.md` for details

### Dependency Blocking

- Check `/migration/dependencies.md`
- Complete dependency features first
- Dependencies auto-unblock when complete

### Merge Conflicts

- Each feature works in isolated worktree
- Conflicts rare but possible on shared files
- Resolve in worktree, then continue QA
