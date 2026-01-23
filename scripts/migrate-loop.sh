#!/bin/bash
# migrate-loop.sh - External loop that runs /migrate-next until complete
#
# Usage: ./migrate-loop.sh
#
# The Stop hook handles: marking human-review complete, committing, cleaning worktrees
# This script handles: running Claude sessions in a loop until 100% complete

set -e

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
MANIFEST="$PROJECT_DIR/migration/manifest.md"

get_completion() {
    [ ! -f "$MANIFEST" ] && echo "0" && return
    local total=$(grep "^TOTAL_FEATURES:" "$MANIFEST" 2>/dev/null | awk '{print $2}')
    local complete=$(grep "^COMPLETED:" "$MANIFEST" 2>/dev/null | awk '{print $2}')
    [ "${total:-0}" -eq 0 ] && echo "0" || echo "$((${complete:-0} * 100 / total))"
}

count_ready() {
    grep -rl "CURRENT: ready-for-dev" "$PROJECT_DIR/migration/modules/"*/features/*.md 2>/dev/null | wc -l || echo "0"
}

echo "=== Migration Loop Started ==="

while true; do
    completion=$(get_completion)
    ready=$(count_ready)

    echo ""
    echo "Progress: ${completion}% | Ready: ${ready} features"

    # Check if done
    if [ "$completion" -eq 100 ]; then
        echo "✅ Migration 100% COMPLETE!"
        break
    fi

    # Check if any features ready
    if [ "$ready" -eq 0 ]; then
        echo "⚠️ No ready features. Check /migrate-status for blockers."
        break
    fi

    # Run Claude with /migrate-next (bypass permissions, streaming output)
    echo "▶️ Running: claude --dangerously-skip-permissions '/migrate-next'"
    claude --dangerously-skip-permissions -p --output-format stream-json --verbose "/migrate-next" 2>&1 | "$PROJECT_DIR/parse-claude-json.sh" || true
    echo "▶️ Finishing: claude --dangerously-skip-permissions '/migrate-next'"

    # Run Claude with /migrate-next (bypass permissions, streaming output)
    echo "▶️ Running: claude --dangerously-skip-permissions '/migrate-next'"
    claude --dangerously-skip-permissions -p --output-format stream-json --verbose "Human Review is passed, mark them complete, commit and remove worktree" 2>&1 | "$PROJECT_DIR/parse-claude-json.sh" || true
    echo "▶️ Finishing: claude --dangerously-skip-permissions '/migrate-next'"

    # Small delay between sessions
    sleep 2
done

echo ""
echo "=== Migration Loop Ended ==="
