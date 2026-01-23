#!/bin/bash

# Hook: Log user prompts to Prompts.md
# Triggered on: UserPromptSubmit

PROMPTS_FILE="Prompts.md"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
DATE_HEADER=$(date "+%Y-%m-%d")

# Read prompt from stdin (Claude Code passes prompt content via stdin)
PROMPT=$(cat)

# Skip empty prompts
if [ -z "$PROMPT" ]; then
  exit 0
fi

# Skip very short prompts (likely commands like /help)
if [ ${#PROMPT} -lt 10 ]; then
  exit 0
fi

# Get the next prompt number
if [ -f "$PROMPTS_FILE" ]; then
  LAST_NUM=$(grep -oP '### Prompt \K\d+' "$PROMPTS_FILE" | tail -1)
  NEXT_NUM=$((LAST_NUM + 1))
else
  NEXT_NUM=1
fi

# Escape special characters for markdown
ESCAPED_PROMPT=$(echo "$PROMPT" | sed 's/`/\\`/g')

# Append to Prompts.md
cat >> "$PROMPTS_FILE" << EOF

### Prompt $NEXT_NUM: User Prompt
**Time:** $TIMESTAMP

\`\`\`
$ESCAPED_PROMPT
\`\`\`

**Result:** [Pending - update after completion]

---
EOF

exit 0
