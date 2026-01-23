#!/bin/bash
#
# Claude CLI JSON Log Parser
# Parses JSON output from Claude CLI and trims messages >100 chars
#

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

# Auto-detect terminal width, subtract 20 for prefixes/icons
TERM_WIDTH=$(tput cols 2>/dev/null || echo 120)
DEFAULT_MAX=$((TERM_WIDTH - 20))
MAX_LENGTH=${1:-$DEFAULT_MAX}
INPUT_FILE="${2:-}"

# Print header
echo -e "${CYAN}${BOLD}"
echo "╔═══════════════════════════════════════════════════════════════════════════╗"
echo "║                   🤖 Claude CLI JSON Parser                               ║"
echo "╚═══════════════════════════════════════════════════════════════════════════╝"
echo -e "${RESET}"
echo -e "${DIM}Terminal: ${TERM_WIDTH} cols | Max message: ${MAX_LENGTH} chars (fits 1 line)${RESET}"
echo -e "${GRAY}───────────────────────────────────────────────────────────────────────────────${RESET}"
echo ""

# Function to truncate string
truncate_string() {
    local str="$1"
    local max="$2"
    if [[ ${#str} -gt $max ]]; then
        echo "${str:0:$max}${DIM}...${RESET}"
    else
        echo "$str"
    fi
}

# Parse JSON using jq
parse_json_line() {
    local line="$1"

    # Skip empty lines
    [[ -z "$line" ]] && return

    # Try to parse as JSON
    if ! echo "$line" | jq -e . >/dev/null 2>&1; then
        echo -e "${DIM}[Non-JSON]: $(truncate_string "$line" 80)${RESET}"
        return
    fi

    local msg_type=$(echo "$line" | jq -r '.type // "unknown"' 2>/dev/null)
    local model=$(echo "$line" | jq -r '.message.model // ""' 2>/dev/null)
    local uuid=$(echo "$line" | jq -r '.uuid // ""' 2>/dev/null)

    case "$msg_type" in
        "assistant")
            echo -e "${GREEN}${BOLD}▶ ASSISTANT${RESET} ${DIM}[${model:-unknown}]${RESET}"

            # Parse content array
            local content_count=$(echo "$line" | jq '.message.content | length' 2>/dev/null)

            for ((i=0; i<content_count; i++)); do
                local content_type=$(echo "$line" | jq -r ".message.content[$i].type" 2>/dev/null)

                case "$content_type" in
                    "text")
                        local text=$(echo "$line" | jq -r ".message.content[$i].text" 2>/dev/null)
                        echo -e "  ${CYAN}📝 Text:${RESET} $(truncate_string "$text" $MAX_LENGTH)"
                        ;;
                    "tool_use")
                        local tool_name=$(echo "$line" | jq -r ".message.content[$i].name" 2>/dev/null)
                        local tool_id=$(echo "$line" | jq -r ".message.content[$i].id" 2>/dev/null)
                        echo -e "  ${MAGENTA}🔧 Tool:${RESET} ${BOLD}$tool_name${RESET} ${DIM}[$tool_id]${RESET}"

                        # Show truncated input
                        local input=$(echo "$line" | jq -c ".message.content[$i].input" 2>/dev/null)
                        echo -e "     ${DIM}Input: $(truncate_string "$input" $MAX_LENGTH)${RESET}"
                        ;;
                esac
            done

            # Show usage if present
            local input_tokens=$(echo "$line" | jq -r '.message.usage.input_tokens // ""' 2>/dev/null)
            local output_tokens=$(echo "$line" | jq -r '.message.usage.output_tokens // ""' 2>/dev/null)
            if [[ -n "$input_tokens" && "$input_tokens" != "null" ]]; then
                echo -e "  ${YELLOW}📊 Tokens:${RESET} in=$input_tokens out=$output_tokens"
            fi
            ;;

        "user")
            echo -e "${BLUE}${BOLD}◀ USER${RESET}"

            # Parse user content
            local content_count=$(echo "$line" | jq '.message.content | length' 2>/dev/null)

            for ((i=0; i<content_count; i++)); do
                local content_type=$(echo "$line" | jq -r ".message.content[$i].type" 2>/dev/null)

                case "$content_type" in
                    "text")
                        local text=$(echo "$line" | jq -r ".message.content[$i].text" 2>/dev/null)
                        echo -e "  ${CYAN}📝 Text:${RESET} $(truncate_string "$text" $MAX_LENGTH)"
                        ;;
                    "tool_result")
                        local tool_id=$(echo "$line" | jq -r ".message.content[$i].tool_use_id" 2>/dev/null)
                        local is_error=$(echo "$line" | jq -r ".message.content[$i].is_error // false" 2>/dev/null)
                        local content=$(echo "$line" | jq -r ".message.content[$i].content" 2>/dev/null)

                        if [[ "$is_error" == "true" ]]; then
                            echo -e "  ${RED}❌ Tool Result:${RESET} ${DIM}[$tool_id]${RESET}"
                        else
                            echo -e "  ${GREEN}✅ Tool Result:${RESET} ${DIM}[$tool_id]${RESET}"
                        fi
                        echo -e "     ${DIM}$(truncate_string "$content" $MAX_LENGTH)${RESET}"
                        ;;
                esac
            done
            ;;

        *)
            echo -e "${GRAY}[${msg_type}]: $(truncate_string "$line" 80)${RESET}"
            ;;
    esac

    echo ""
}

# Process input
if [[ -n "$INPUT_FILE" && -f "$INPUT_FILE" ]]; then
    # Read from file
    while IFS= read -r line; do
        parse_json_line "$line"
    done < "$INPUT_FILE"
elif [[ ! -t 0 ]]; then
    # Read from stdin (pipe)
    while IFS= read -r line; do
        parse_json_line "$line"
    done
else
    # No input - show usage
    echo -e "${YELLOW}Usage:${RESET}"
    echo "  $0 [max_length] [file]       Parse JSON file"
    echo "  cat file.json | $0 [max_length]   Parse from stdin"
    echo "  tail -f file.json | $0 [max_length]   Stream parse"
    echo ""
    echo -e "${YELLOW}Examples:${RESET}"
    echo "  $0 100 claude-output.json"
    echo "  $0 50                        # Use 50 char limit"
    echo "  cat output.json | $0 200"
    echo ""
    echo -e "${YELLOW}Default max length:${RESET} 100 characters"
fi
