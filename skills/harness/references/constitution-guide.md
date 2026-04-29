# Constitution Guide

`.claude/CONSTITUTION.md` is the single fixed point. The `governance`
skill reads it before every run and must not violate any clause. Even
governance cannot edit the constitution itself.

## Two regions

The constitution is split by HTML comment markers:

```markdown
<!-- BEGIN UNIVERSAL -->
## Universal invariants
1. ...
10. ...
<!-- END UNIVERSAL -->

<!-- BEGIN LOCAL -->
## Domain-specific invariants
11. ...
<!-- END LOCAL -->
```

- **UNIVERSAL** is overwritten by `./scripts/update-scaffold.sh`.
  Do not edit between the markers.
- **LOCAL** is yours and the harness skill's. Phase 5 of the workflow
  appends domain-specific clauses here. Never overwritten.

## Universal clauses (1–10)

Provided by the scaffold. Cover:

- **Self-protection** (1, 9): governance can't delete itself or edit
  protected files
- **Role hygiene** (2, 3, 5): valid frontmatter, domain exclusivity,
  observation period before deletion
- **Provenance** (4): all changes go through Git
- **Auto-mode safety** (6, 7, 8, 10): cooldown, change-cap, role-count
  bounds, archive retention

## Domain-specific clauses (LOCAL)

Examples:

```markdown
## Domain-specific invariants  (customer support)
11. No role may persist customer PII to disk outside the redacted/ directory.
12. Roles handling escalations must log to escalation-log.jsonl.

## Domain-specific invariants  (research)
11. Every claim a role outputs must trace to a citation in sources/.
12. Roles must not delete primary sources, only annotate them.

## Domain-specific invariants  (writing)
11. Producer/Reviewer pattern is permitted between writer and editor on drafts/.
```

## Good clauses

A constitutional clause:

1. **Survives role changes.** When governance adds/removes/modifies
   roles, the clause should still hold. If a clause depends on a
   specific role's name, it belongs in the role file, not the constitution.
2. **Is mechanically checkable.** Either by validator script or simple
   pattern. Vague aspirations don't belong here.
3. **Encodes risk, not preference.** Genuinely harmful violations,
   not stylistic choices.

## What does NOT belong

- "Use Python 3.11" → `pyproject.toml`
- "Write commit messages in English" → commit hook
- "Keep coverage above 80%" → CI
- "The pr-reviewer role must be invoked on every PR" → role's
  `description` field
