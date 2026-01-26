#!/bin/bash
# Migration Framework Setup Script
# Run this in your project root to initialize the migration framework

set -e

echo "=========================================="
echo "  Migration Framework Setup"
echo "  Author: Rajesh Royal"
echo "=========================================="
echo ""

# Create directory structure
echo "Creating directory structure..."

mkdir -p legacy
mkdir -p modern/{backend,frontend}
mkdir -p migration/{discovery,modules,api-contracts,logs}
mkdir -p .claude/{agents,skills}

echo "  ✓ Created /legacy"
echo "  ✓ Created /modern/backend"
echo "  ✓ Created /modern/frontend"
echo "  ✓ Created /migration"
echo "  ✓ Created /.claude"

# Check if framework files exist
if [ ! -f "migration/manifest.md" ]; then
    echo ""
    echo "Creating base migration files..."

    # Create manifest
    cat > migration/manifest.md << 'MANIFEST'
# Migration Manifest

## State
STATUS: not-started
PHASE: initialization
CREATED: $(date +%Y-%m-%d)

## Paths
LEGACY: /legacy
BACKEND: /modern/backend
FRONTEND: /modern/frontend

## Progress
TOTAL_FEATURES: 0
COMPLETED: 0
IN_PROGRESS: 0
PERCENT: 0%

## Phase Checklist
- [ ] Discovery complete
- [ ] Tech stack decided
- [ ] Projects scaffolded
- [ ] Layer 1: Shared services
- [ ] Layer 2: Core modules
- [ ] Layer 3: Secondary modules
- [ ] Final integration

## Current Session
ACTIVE_FEATURE: none
ACTIVE_AGENT: none
LAST_UPDATE: $(date +%Y-%m-%d)
MANIFEST

    echo "  ✓ Created migration/manifest.md"
fi

# Create .gitignore if not exists
if [ ! -f ".gitignore" ]; then
    cat > .gitignore << 'GITIGNORE'
# Dependencies
node_modules/
.pnp/
.pnp.js

# Build
dist/
build/
.next/

# Environment
.env
.env.local
.env.*.local

# IDE
.idea/
.vscode/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Logs
*.log
npm-debug.log*

# Testing
coverage/

# Temp
*.tmp
*.temp
GITIGNORE

    echo "  ✓ Created .gitignore"
fi

echo ""
echo "=========================================="
echo "  Setup Complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo ""
echo "  1. Copy your legacy .NET code into /legacy folder"
echo ""
echo "  2. Initialize git (if not already):"
echo "     git init"
echo "     git add ."
echo "     git commit -m 'Initial migration setup'"
echo ""
echo "  3. Start Claude Code and run:"
echo "     /migrate-init"
echo ""
echo "=========================================="
