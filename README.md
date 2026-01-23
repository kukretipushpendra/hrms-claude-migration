# Tech-Agnostic Migration Framework

A reusable framework for migrating legacy applications to modern tech stacks using Claude Code CLI with **parallel execution via git worktrees**.

**Current stack:** React.js + .NET → Vue.js + Node.js/Express + SQL Server (same database)
**Adaptable to:** Any source/target combination via `/migrate-adapt`

## Philosophy

- **Legacy is source of truth**: When uncertain, always check the legacy code
- **100% parity**: Replicate exactly, no improvements or creativity
- **Parallel execution**: Multiple features developed simultaneously via git worktrees
- **Auto-merge on QA pass**: No human needed for merging, only for escalations
- **Externalized state**: Everything tracked in files, survives context limits

## Quick Start

### Prerequisites

**Windows users:**
- WSL2 with Docker installed
- Node.js stable version 24.x or later (v24.12.0 recommended)
  - [Recommended setup method: NVM](https://learn.microsoft.com/en-us/windows/dev-environment/javascript/nodejs-on-wsl)
- Claude CLI configured in WSL2

**All users:**
- Access to SQL Server (existing database)

### 1. Clone the Framework

```bash
git clone <this-repo> my-migration-project
cd my-migration-project
```

### 2. Run Setup Script

```bash
chmod +x ./setup-migration.sh
./setup-migration.sh
```

This creates all required folder structures.

### 3. Add Your Legacy Code

```bash
# Copy your .NET project into the legacy folder
cp -r /path/to/your/dotnet-project/* ./legacy/
```

### 4. Configure Database Connection (Required)

Update `.env` file with your SQL Server connection details:
- Set DB_HOST (server name)
- Set DB_INSTANCE (e.g., SQLEXPRESS for SQL Server Express)
- Configure DB_NAME, DB_USER, DB_PASSWORD
- See `.env.example` for all available options

### 5. Initialize Git

```bash
git add .
git commit -m "Initial migration setup with legacy code"
```

### 6. Adapt to Your Tech Stack (Optional)

If migrating from a non-.NET stack, run `/migrate-adapt` first:

```bash
# Open Claude Code CLI
claude

# Adapt framework to your stack (example: Laravel to React + NestJS)
/migrate-adapt "Target Stack: frontend: react, backend: nestjs, legacy is Frontend: blade and backend: laravel"
```

See [Adapting to Different Tech Stacks](#adapting-to-different-tech-stacks) for more examples.

### 7. Start Migration

```bash
# Initialize discovery and tech stack
/migrate-init
```

## Project Scaffolding

During `/migrate-init`, you'll be asked how to set up the modern projects:

### Option 1: Default Commands (Recommended)

**Node.js/Express Backend:**
```bash
cd modern/backend
npm init -y
npm install express cors dotenv mssql
npm install -D typescript @types/node @types/express @types/mssql ts-node nodemon
npx tsc --init
```

**Vue.js + Vite Frontend:**
```bash
cd modern/frontend
npm create vite@latest . -- --template vue-ts
npm install
npm install vue-router@4 pinia axios
```

### Option 2: Custom Commands

Provide your own npm commands for backend and frontend setup.

### Option 3: Manual Setup

Follow instructions and configure projects yourself.

### Option 4: Skip

Use if projects already exist.

## Directory Structure

```
project-root/
├── README.md                    # This file
├── HOW-TO-USE.md                # Detailed usage guide
├── CLAUDE.md                    # Claude Code instructions
├── setup-migration.sh           # Setup script
│
├── legacy/                      # Your .NET source code (read-only)
│
├── modern/
│   ├── backend/                 # Node.js/Express project
│   └── frontend/                # Vue.js + Vite project
│
├── worktrees/                   # Git worktrees (auto-created)
│
├── migration/
│   ├── manifest.md              # Progress tracking
│   ├── tech-stack.md            # Tech decisions
│   ├── workflow.md              # Workflow documentation
│   ├── statuses.md              # Status reference
│   ├── dependencies.md          # Module dependencies
│   │
│   ├── discovery/               # Populated by /migrate-init
│   │
│   ├── modules/                 # Feature tracking per module
│   │
│   ├── api-contracts/           # Backend-Frontend contracts (organized by {module}/{feature}.api.md)
│   │
│   └── logs/                    # Attempts and escalations
│
└── .claude/
    ├── agents/                  # Agent definitions
    ├── commands/                # Slash commands
    └── skills/                  # Skill definitions
```

## Commands Reference

| Command | Description |
|---------|-------------|
| `/migrate-adapt` | **Adapt framework to different tech stack** (run before /migrate-init) |
| `/migrate-init` | Analyze legacy, scaffold projects, create specs |
| `/migrate-next` | Implement next ready feature (recommended) |
| `/migrate-batch N` | Process N features sequentially |
| `/migrate-status` | Show progress and blockers |
| `/migrate-qa` | Verify and auto-merge on pass |
| `/migrate-human-review` | List features awaiting approval |
| `/migrate-human-review-fix` | Fix features marked for rework |
| `/migrate-resume` | Resume from last checkpoint |
| `/migrate-auto` | Auto mode until complete |
| `/migrate-rollback` | Rollback a merged feature |
| `/migrate-diff` | Compare legacy vs modern |
| `/migration-optimize` | Apply production optimizations (run after migration complete) |

For detailed command usage and workflows, see [HOW-TO-USE.md](HOW-TO-USE.md).

## Adapting to Different Tech Stacks

The framework is currently configured for React.js + .NET → Vue.js + Node.js/Express + SQL Server, but can be adapted to any stack combination.

### When to Use `/migrate-adapt`

Run `/migrate-adapt` **before** `/migrate-init` when your legacy/target stack is different from the current configuration.

### Example Commands

```bash
# Laravel (PHP) to React + NestJS
/migrate-adapt "Target Stack: frontend: react, backend: nestjs, legacy is Frontend: blade and backend: laravel"

# Django (Python) to Vue + FastAPI
/migrate-adapt "Target Stack: frontend: vue, backend: fastapi, legacy is Frontend: django templates and backend: django"

# Rails (Ruby) to React + NestJS
/migrate-adapt "Target Stack: frontend: react, backend: nestjs, legacy is Frontend: erb and backend: rails"

# Vue.js + Laravel to React + NestJS
/migrate-adapt "Target Stack: frontend: react, backend: nestjs, legacy is Frontend: vue.js and backend: laravel"

# Angular + Spring to React + NestJS
/migrate-adapt "Target Stack: frontend: react, backend: nestjs, legacy is Frontend: angular and backend: spring"
```

### What `/migrate-adapt` Does

1. **Updates tech-stack.md** - Configures source/target frameworks
2. **Modifies explorer agent** - Adjusts discovery patterns for legacy framework
3. **Updates coder agents** - Configures backend/frontend coders for target stack
4. **Creates/updates skills** - Ensures relevant framework skills exist
5. **Generates concept mappings** - Creates framework-to-framework translation guide

### Supported Frameworks

**Legacy (Source):**
- Backend: .NET MVC, Laravel, Django, Rails, Spring, Express
- Frontend: Razor, Blade, Django Templates, ERB, Vue.js, Angular

**Target (Modern):**
- Backend: NestJS, Express, FastAPI, Laravel, Django
- Frontend: React, Vue, Svelte, Angular

See [.claude/refs/tech-stack-mappings.md](.claude/refs/tech-stack-mappings.md) for detailed concept mappings.

## Tech Stack

### Current Configuration

| Layer | Technology |
|-------|------------|
| Frontend | Vue.js 3, TypeScript, Vite, Vue Router, Pinia |
| Backend | Node.js, Express, TypeScript |
| Database | SQL Server (existing - no migration) |
| DB Driver | mssql (node-mssql) |
| Parallelization | Git worktrees |

### Decided During /migrate-init

- Form handling (VeeValidate/FormKit)
- UI framework (must match legacy: Bootstrap/Foundation/Tailwind/etc.)
- Additional libraries as needed

## Database

This migration uses the **existing SQL Server database** - no database migration required.

```bash
# Connection info (configure in .env)
# Server: localhost or localhost\SQLEXPRESS
# Port: 1433 (default)
# Credentials in .env.example

# Test connection
npm run db:test
```

The backend uses the `mssql` (node-mssql) package to connect to SQL Server with connection pooling.

## Documentation

- **[HOW-TO-USE.md](HOW-TO-USE.md)**: Complete usage guide including:
  - Typical workflow with examples
  - All slash commands
  - Available agents and their roles
  - Feature status flow
  - Best practices and recommendations
  - Parallel workflow architecture
  - Automatic migration setup
  - Troubleshooting guide

- **[migration/statuses.md](migration/statuses.md)**: Detailed status definitions and transitions

## Contributing

This framework is designed to be forked and customized for your team's needs. If you ever feel something can be improved, please feel free to reach out to me **Rajesh Royal**

## License

Programmers.ai
