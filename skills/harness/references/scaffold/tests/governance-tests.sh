#!/usr/bin/env bash
# governance-tests.sh — Regression tests gating governance commits. Clauses 4, 5, 7, 8.
set -e
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
AGENTS_DIR="$PROJECT_DIR/.claude/agents"
LOG="$PROJECT_DIR/.claude/state/governance-log.jsonl"

failed=0
fail() { echo "FAIL: $1" >&2; failed=1; }

# Clause 8
ROLE_COUNT=$(find "$AGENTS_DIR" -maxdepth 1 -name '*.md' -type f 2>/dev/null | wc -l)
[ "$ROLE_COUNT" -lt 2 ] && fail "clause 8: role count $ROLE_COUNT below minimum 2"
[ "$ROLE_COUNT" -gt 20 ] && fail "clause 8: role count $ROLE_COUNT above maximum 20"

# Clause 4
[ ! -d "$PROJECT_DIR/.git" ] && fail "clause 4: not a git repository"

# Clause 7
if [ -s "$LOG" ]; then
  LAST_MIN=$(tail -n 1 "$LOG" | jq -r '.ts' 2>/dev/null | cut -c1-16 || echo "")
  if [ -n "$LAST_MIN" ]; then
    LAST_RUN_COUNT=$(grep -c "\"ts\": *\"${LAST_MIN}" "$LOG" 2>/dev/null || echo 0)
    [ "$LAST_RUN_COUNT" -gt 3 ] && fail "clause 7: most recent run applied $LAST_RUN_COUNT changes (max 3)"
  fi
fi

# Clause 10
if [ -d "$AGENTS_DIR/.archive" ]; then
  for d in "$AGENTS_DIR/.archive"/*; do
    [ -d "$d" ] || continue
    DIR_DATE=$(basename "$d")
    DIR_S=$(date -u -d "$DIR_DATE" +%s 2>/dev/null || echo 0)
    [ "$DIR_S" -eq 0 ] && fail "clause 10: archive dir name not a valid date: $d"
  done
fi
exit $failed
