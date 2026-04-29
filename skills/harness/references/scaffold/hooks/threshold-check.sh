#!/usr/bin/env bash
# threshold-check.sh — SessionEnd hook. 24h cooldown + threshold + detached governance.
set -e
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
LOG="$PROJECT_DIR/.claude/state/governance-log.jsonl"
RUNS_LOG="$PROJECT_DIR/.claude/state/governance-runs.log"
mkdir -p "$(dirname "$LOG")"

# Cooldown (clause 6)
if [ -s "$LOG" ]; then
  LAST_TS=$(tail -n 1 "$LOG" | jq -r '.ts // empty' 2>/dev/null || echo "")
  if [ -n "$LAST_TS" ]; then
    NOW_S=$(date -u +%s)
    LAST_S=$(date -u -d "$LAST_TS" +%s 2>/dev/null || echo 0)
    DELTA=$((NOW_S - LAST_S))
    if [ "$DELTA" -lt 86400 ]; then exit 0; fi
  fi
fi

# Threshold check
if ! python3 "$PROJECT_DIR/.claude/hooks/check_thresholds.py"; then exit 0; fi

# Detached governance
(
  timeout 1800 claude -p "/governance auto-run" \
    --permission-mode bypassPermissions \
    --output-format stream-json \
    >> "$RUNS_LOG" 2>&1
) &
disown
exit 0
