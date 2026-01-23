# Tech-Agnostic Migration Framework

A reusable framework for migrating legacy applications to modern tech stacks using Claude Code CLI with **parallel execution via git worktrees**.

**Default stack:** .NET → React + NestJS + PostgreSQL
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
- Basic Docker familiarity (not required but helpful)

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

### 4. Configure Docker (Optional)

Update `docker-compose.yml` in the project root as needed:
- Set project-specific container names
- Configure database names
- Adjust ports if conflicts exist with other containers
- Update .env.example file for the same changes

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

**NestJS Backend:**
```bash
npm i -g @nestjs/cli
cd modern/backend
nest new . --skip-git --package-manager npm
```

**React + Vite Frontend:**
```bash
cd modern/frontend
npm create vite@latest . -- --template react-ts
npm install
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
│   ├── backend/                 # NestJS project
│   └── frontend/                # React + Vite project
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

The framework defaults to .NET → React + NestJS + PostgreSQL, but can be adapted to any stack combination.

### When to Use `/migrate-adapt`

Run `/migrate-adapt` **before** `/migrate-init` when your legacy stack is NOT .NET MVC, or when you want a different target stack.

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

### Permanent (Non-negotiable)

| Layer | Technology |
|-------|------------|
| Frontend | React 19, TypeScript, React Hook Form, Zod, Vite |
| Backend | NestJS, PostgreSQL, Sequelize |
| Parallelization | Git worktrees |

### Decided During /migrate-init

- State management (TanStack Query/Zustand/Redux)
- UI framework (must match legacy: Bootstrap/Foundation/Tailwind/etc.)
- Additional libraries as needed

## Database

```bash
# Start PostgreSQL + pgAdmin
docker compose up -d

# Stop services
docker compose down

# Connection info
# PostgreSQL: localhost:5432
# pgAdmin: localhost:5050
# Credentials in .env.example
```

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
