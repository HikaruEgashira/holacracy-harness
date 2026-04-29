#!/usr/bin/env bash
# log-invocation.sh — PostToolUse(Task) hook. Appends one record to stats.jsonl.
set -e
INPUT=$(cat)
STATS_FILE="${CLAUDE_PROJECT_DIR:-.}/.claude/state/stats.jsonl"
mkdir -p "$(dirname "$STATS_FILE")"
echo "$INPUT" | jq -c --arg ts "$(date -u +%FT%TZ)" '
  {
    ts: $ts,
    role: (.tool_input.subagent_type // .tool_input.agent // "unknown"),
    success: (
      if (.tool_response.is_error // false) then false
      elif (.tool_response.error // null) != null then false
      else true
      end
    ),
    duration_ms: (.duration_ms // 0),
    session_id: (.session_id // "unknown")
  }
' >> "$STATS_FILE" 2>/dev/null || true
exit 0
