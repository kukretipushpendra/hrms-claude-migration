#!/bin/bash
#
# auto-migrate.sh - Fully automatic .NET to TypeScript migration
#
# This script runs Claude Code's /migrate-auto command repeatedly
# until the entire migration is complete. No user interaction needed.
#
# Usage:
#   ./auto-migrate.sh              # Run with default batch size
#   ./auto-migrate.sh --batch 10   # Custom batch size
#   ./auto-migrate.sh --dry-run    # Show what would be done
#   ./auto-migrate.sh --yolo       # Skip permission prompts (REQUIRED for auto mode)
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
BATCH_SIZE=5
DRY_RUN=false
YOLO_MODE=false  # Skip permission prompts (required for full automation)
MAX_SESSIONS=50  # Safety limit
DELAY_BETWEEN_SESSIONS=3

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --batch)
            BATCH_SIZE="$2"
            shift 2
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --yolo|-y)
            YOLO_MODE=true
            shift
            ;;
        --max-sessions)
            MAX_SESSIONS="$2"
            shift 2
            ;;
        --help)
            echo "Usage: ./auto-migrate.sh [options]"
            echo ""
            echo "Options:"
            echo "  --batch N        Number of features per session (default: 5)"
            echo "  --max-sessions N Maximum sessions to run (default: 50)"
            echo "  --yolo, -y       Skip permission prompts (REQUIRED for automation)"
            echo "  --dry-run        Show what would be done without executing"
            echo "  --help           Show this help message"
            echo ""
            echo "Example:"
            echo "  ./auto-migrate.sh --yolo --batch 5"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Check prerequisites
check_prerequisites() {
    echo -e "${BLUE}Checking prerequisites...${NC}"

    # Check if claude CLI is available
    if ! command -v claude &> /dev/null; then
        echo -e "${RED}Error: 'claude' CLI not found. Please install Claude Code CLI.${NC}"
        exit 1
    fi

    # Check if migration folder exists
    if [ ! -d "migration" ]; then
        echo -e "${RED}Error: 'migration' folder not found. Run /migrate-init first.${NC}"
        exit 1
    fi

    # Check if manifest exists
    if [ ! -f "migration/manifest.md" ]; then
        echo -e "${RED}Error: 'migration/manifest.md' not found. Run /migrate-init first.${NC}"
        exit 1
    fi

    echo -e "${GREEN}Prerequisites OK${NC}"
}

# Get migration status from manifest
get_status() {
    local status=$(grep "^STATUS:" migration/manifest.md | cut -d' ' -f2)
    echo "$status"
}

# Get completed count
get_completed() {
    local completed=$(grep "^COMPLETED:" migration/manifest.md | cut -d' ' -f2)
    echo "$completed"
}

# Get total features
get_total() {
    local total=$(grep "^TOTAL_FEATURES:" migration/manifest.md | cut -d' ' -f2)
    echo "$total"
}

# Count remaining features
count_remaining() {
    local ready=$(grep -l "CURRENT: ready-for-dev" migration/modules/*/features/*.md 2>/dev/null | wc -l)
    local in_progress=$(grep -l "CURRENT: in-progress" migration/modules/*/features/*.md 2>/dev/null | wc -l)
    echo $((ready + in_progress))
}

# Check if migration is complete
is_complete() {
    local status=$(get_status)
    if [ "$status" == "complete" ]; then
        return 0
    fi

    local remaining=$(count_remaining)
    if [ "$remaining" -eq 0 ]; then
        return 0
    fi

    return 1
}

# Print progress bar
print_progress() {
    local completed=$(get_completed)
    local total=$(get_total)

    if [ "$total" -eq 0 ]; then
        echo -e "${YELLOW}No features discovered yet. Run /migrate-init first.${NC}"
        return
    fi

    local percent=$((completed * 100 / total))
    local filled=$((percent / 2))
    local empty=$((50 - filled))

    printf "${BLUE}Progress: ["
    printf "%${filled}s" | tr ' ' '='
    printf "%${empty}s" | tr ' ' '-'
    printf "] ${percent}%% (${completed}/${total})${NC}\n"
}

# Main migration loop
run_migration() {
    local session=1

    echo -e "${GREEN}"
    echo "======================================"
    echo "   AUTO-MIGRATION STARTING"
    echo "======================================"
    echo -e "${NC}"
    echo "Batch size: $BATCH_SIZE features per session"
    echo "Max sessions: $MAX_SESSIONS"
    if $YOLO_MODE; then
        echo -e "${YELLOW}YOLO mode: ON (permission prompts skipped)${NC}"
    else
        echo -e "${RED}WARNING: YOLO mode OFF - sub-agents will prompt for permissions${NC}"
        echo -e "${YELLOW}For full automation, use: ./auto-migrate.sh --yolo${NC}"
    fi
    echo ""

    print_progress
    echo ""

    if $DRY_RUN; then
        echo -e "${YELLOW}DRY RUN MODE - No changes will be made${NC}"
        echo ""
    fi

    while [ $session -le $MAX_SESSIONS ]; do
        # Check if complete
        if is_complete; then
            echo -e "${GREEN}"
            echo "======================================"
            echo "   MIGRATION COMPLETE!"
            echo "======================================"
            echo -e "${NC}"
            print_progress

            local escalated=$(grep "^ESCALATED:" migration/manifest.md | cut -d' ' -f2)
            if [ "$escalated" -gt 0 ]; then
                echo -e "${YELLOW}Note: $escalated features were escalated for human review.${NC}"
                echo "Run /migrate-human-review to see them."
            fi

            return 0
        fi

        echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${BLUE}Session $session of $MAX_SESSIONS${NC}"
        echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

        # Build claude command with optional flags
        CLAUDE_CMD="claude --print"
        if $YOLO_MODE; then
            CLAUDE_CMD="$CLAUDE_CMD -y"  # Skip permission prompts
        fi
        CLAUDE_CMD="$CLAUDE_CMD \"/migrate-batch $BATCH_SIZE\""

        if $DRY_RUN; then
            echo "[DRY RUN] Would execute: $CLAUDE_CMD"
            echo ""
            sleep 1
        else
            # Run Claude Code with migrate-batch command
            echo "Running: $CLAUDE_CMD"
            echo ""

            # Execute claude and capture output
            if eval $CLAUDE_CMD; then
                echo ""
                echo -e "${GREEN}Session $session completed successfully${NC}"
            else
                local exit_code=$?
                if [ $exit_code -eq 1 ]; then
                    # Exit code 1 means migration complete
                    echo -e "${GREEN}Migration signaled complete${NC}"
                    break
                else
                    echo -e "${RED}Session failed with exit code $exit_code${NC}"
                    echo "Check logs and run /migrate-status for details"
                    return 1
                fi
            fi
        fi

        print_progress
        echo ""

        # Increment session
        session=$((session + 1))

        # Brief delay between sessions
        if [ $session -le $MAX_SESSIONS ] && ! is_complete; then
            echo -e "${YELLOW}Waiting ${DELAY_BETWEEN_SESSIONS}s before next session...${NC}"
            sleep $DELAY_BETWEEN_SESSIONS
            echo ""
        fi
    done

    if [ $session -gt $MAX_SESSIONS ]; then
        echo -e "${YELLOW}"
        echo "======================================"
        echo "   MAX SESSIONS REACHED"
        echo "======================================"
        echo -e "${NC}"
        echo "Reached maximum of $MAX_SESSIONS sessions."
        echo "Run ./auto-migrate.sh again to continue."
        print_progress
        return 0
    fi
}

# Main execution
main() {
    echo -e "${GREEN}"
    echo "╔════════════════════════════════════════╗"
    echo "║   .NET → TypeScript Auto-Migration     ║"
    echo "║   Author: Rajesh Royal                 ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "${NC}"

    check_prerequisites
    echo ""

    run_migration

    echo ""
    echo -e "${BLUE}Migration session ended.${NC}"
}

# Run main
main
