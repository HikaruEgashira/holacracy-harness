# Role Template

Every role file under `.claude/agents/` follows this format exactly so
the `governance` skill can parse roles without surprises.

## File format

```markdown
---
name: <kebab-case-name>
description: <one-sentence trigger for Claude Code's auto-invocation>
purpose: <future-state sentence — "X is always Y", not a task>
accountabilities:
  - <continuous activity 1>
  - <continuous activity 2>
domains:
  - <glob or path pattern this role exclusively owns>
invocation_stats:
  invocations_30d: 0
  success_rate: null
  last_used: null
  created_at: <YYYY-MM-DD UTC>
---

You are the **<n>** role. Your purpose is to ensure <restate purpose>.

## How to do the work
<3 to 6 numbered steps>

## What you do not do
<2 to 4 explicit non-responsibilities>
```

## Key concepts

### Purpose vs. Description

- `description` is what Claude Code reads to decide *whether* to invoke.
  A trigger written for the matcher.
- `purpose` is *why this role exists*. A future state. Not a procedure.

| Bad purpose (procedural) | Good purpose (state) |
|---|---|
| "Reviews pull requests" | "Changes merged to main are safe and maintainable" |
| "Writes blog posts" | "The blog reflects current thinking accurately and on schedule" |

### Accountabilities

Continuous activities, present participle ("Reviewing X", "Maintaining Y").
Not tasks, not outputs.

### Domains

A `domain` is what the role **exclusively owns**. No other role may
modify items inside this domain.

Good: `tests/**`, `docs/decisions/*.md`, `PLAN.md`
Bad: `everything in this repo`, `code quality`

### Invocation stats

Read and written by `governance`. Do not edit by hand.

- `invocations_30d` — count in 30-day window
- `success_rate` — fraction without error; null if < 5
- `last_used` — UTC timestamp
- `created_at` — drives clause 5 (no deletion within 7 days)
