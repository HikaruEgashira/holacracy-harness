#!/usr/bin/env bash
# domain-checker.sh — Enforces clause 3: no two roles may declare overlapping domains.
set -e
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
AGENTS_DIR="$PROJECT_DIR/.claude/agents"

EXTRACT='
  /^---$/ { fm = !fm; next }
  fm && /^name:/ { gsub(/^name:[[:space:]]*/, ""); name = $0 }
  fm && /^domains:/ { in_domains = 1; next }
  fm && in_domains && /^[[:space:]]*-/ {
    gsub(/^[[:space:]]*-[[:space:]]*"?/, "")
    gsub(/"?$/, "")
    print name "\t" $0
  }
  fm && in_domains && !/^[[:space:]]*-/ && !/^domains:/ { in_domains = 0 }
'

PAIRS=$(
  for f in "$AGENTS_DIR"/*.md; do
    [ -e "$f" ] || continue
    awk "$EXTRACT" "$f"
  done | sort -k2
)

DUPS=$(
  echo "$PAIRS" | awk -F'\t' '
    {
      key = $2
      if (key in seen && seen[key] != $1) {
        print "conflict: domain " key " owned by both " seen[key] " and " $1
        bad = 1
      } else { seen[key] = $1 }
    }
    END { exit bad }
  '
) || {
  echo "$DUPS" >&2
  echo "violation of clause 3: domain overlap" >&2
  exit 1
}
exit 0
