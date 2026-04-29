#!/usr/bin/env bash
# constitution-validator.sh — Verifies a role file against clauses 1, 2, 9, 10.
set -e
FILE="$1"
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
[ -z "$FILE" ] && { echo "usage: $0 <role-file>" >&2; exit 2; }

# Clause 9: protected paths
case "$FILE" in
  *CONSTITUTION.md|*settings.json)
    echo "violation of clause 9: protected file $FILE" >&2; exit 1;;
  */hooks/*|*/skills/governance/*)
    echo "violation of clause 9: protected directory $FILE" >&2; exit 1;;
esac

# Clause 1: governance SKILL.md must exist somewhere
GOV_SKILL_PROJ="$PROJECT_DIR/.claude/skills/governance/SKILL.md"
GOV_SKILL_USER="$HOME/.claude/skills/governance/SKILL.md"
if [ ! -f "$GOV_SKILL_PROJ" ] && [ ! -f "$GOV_SKILL_USER" ]; then
  echo "violation of clause 1: governance SKILL.md missing" >&2
  echo "  install via: gh skill install plenoai/holacracy-harness governance --agent claude-code --scope user" >&2
  exit 1
fi

# Clause 2: required frontmatter fields
if [ -f "$FILE" ]; then
  for field in name purpose accountabilities; do
    if ! grep -q "^${field}:" "$FILE"; then
      echo "violation of clause 2: missing field '${field}' in $FILE" >&2
      exit 1
    fi
  done
fi
exit 0
