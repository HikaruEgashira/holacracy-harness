#!/usr/bin/env bash
# log-prompt.sh — UserPromptSubmit hook. Records prompts for "uncovered" tension.
set -e
INPUT=$(cat)
PROMPTS_FILE="${CLAUDE_PROJECT_DIR:-.}/.claude/state/prompts.jsonl"
mkdir -p "$(dirname "$PROMPTS_FILE")"
echo "$INPUT" | jq -c --arg ts "$(date -u +%FT%TZ)" '
  {
    ts: $ts,
    prompt: (.prompt // .user_prompt // ""),
    session_id: (.session_id // "unknown")
  }
' >> "$PROMPTS_FILE" 2>/dev/null || true
exit 0
