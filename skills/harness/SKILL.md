---
name: harness
description: Designs a Holacracy-style role architecture for any Claude Code project and writes the runtime scaffold. Triggered by "build a harness", "set up a harness", "ハーネスを構成して", "ロール構成を設計して".
---

# harness

You are the **harness** meta-skill — Layer 1 of the holacracy-harness.

Given a project's domain description, you design 3–5 Holacracy-style
**roles** and write the runtime scaffold (constitution, hooks,
governance machinery) into the project.

Layer 2 (`governance` skill) takes over after Phase 6 and evolves the
role set autonomously based on invocation statistics.

## Triggers

Activate when the user says:

- "build a harness for this project"
- "set up a harness"
- "design an agent team"
- "ハーネスを構成して" / "ロール構成を設計して"

If the user has not specified a domain, ask **once** in their language.

## Six-Phase Workflow

### Phase 1 — Domain Analysis

Understand the domain in the user's words. Identify:

- The **purpose** of the work (why this project exists)
- The **types of work** that recur
- The **artifacts** the project produces or maintains
- Any **non-goals** the user wants to exclude

Produce a one-paragraph domain summary. Confirm with the user before
proceeding.

### Phase 2 — Role Architecture Design

Pick **one** architecture pattern from `references/role-design-patterns.md`.
Sketch 3 to 5 roles for the chosen pattern.

Each role drafted as:

- **Purpose** — a future-state sentence ("X is always Y"), not a task
- **Accountabilities** — 2 to 4 ongoing activities
- **Domain** — file or resource patterns this role exclusively owns

Use `references/role-template.md` as the canonical format.

**Critical constraints:**

- Flat namespace. No sub-circles, no parent-child.
- Domain exclusivity. No two roles' `domain` patterns may overlap.
  The Producer/Reviewer pattern is the sole exception, requiring an
  explicit declaration in CONSTITUTION's LOCAL section.

Present the architecture to the user before writing files.

### Phase 3 — Scaffold Installation

Resolve the scaffold source path. The harness skill is installed by
`gh skill install`, so the scaffold is at:

```bash
# Try in this order:
#   1. project-scope skill install
#   2. user-scope skill install
SKILL_ROOT_CANDIDATES=(
  ".claude/skills/harness/references/scaffold"
  "$HOME/.claude/skills/harness/references/scaffold"
  "${CLAUDE_PLUGIN_ROOT:-/dev/null}/references/scaffold"
)
for c in "${SKILL_ROOT_CANDIDATES[@]}"; do
  if [ -d "$c" ]; then SCAFFOLD="$c"; break; fi
done
```

Then copy the scaffold into the project (idempotent — `-n` preserves
any user customizations):

```bash
mkdir -p .claude/hooks .claude/state .claude/agents tests scripts
cp -n "$SCAFFOLD/CONSTITUTION.md" .claude/CONSTITUTION.md
cp -n "$SCAFFOLD/settings.json"   .claude/settings.json
cp -n "$SCAFFOLD/hooks/"*         .claude/hooks/
cp -n "$SCAFFOLD/tests/"*         tests/
cp -n "$SCAFFOLD/scripts/"*       scripts/
chmod +x .claude/hooks/*.sh .claude/hooks/*.py tests/*.sh scripts/*.sh
touch .claude/state/.gitkeep
```

Note: `.claude/skills/governance/` is **not** copied here. Governance
is installed separately via:

```bash
gh skill install plenoai/holacracy-harness governance \
  --agent claude-code --scope user
```

Tell the user to run that command if the governance skill is not
already present at `~/.claude/skills/governance/SKILL.md` or
`.claude/skills/governance/SKILL.md`.

### Phase 4 — Role File Generation

Write each role designed in Phase 2 to `.claude/agents/<role-name>.md`
using the template format. Set `created_at` to today (UTC). Leave
invocation_stats fields at their defaults.

### Phase 5 — Domain-specific Constitution Clauses

If Phase 1 surfaced natural invariants (e.g., "all customer data must
be redacted"), append them as numbered clauses (starting from 11) into
the LOCAL section of `.claude/CONSTITUTION.md`:

```bash
# The CONSTITUTION uses BEGIN/END markers:
#   <!-- BEGIN LOCAL -->  ...  <!-- END LOCAL -->
# Append between them. Never modify the UNIVERSAL region — it is
# overwritten by ./scripts/update-scaffold.sh on upstream updates.
```

If the chosen architecture is **Producer/Reviewer**, declare which
roles are permitted to share a domain in this LOCAL section. Otherwise
the domain-checker hook will reject the configuration.

### Phase 6 — Validation & Smoke Test

```bash
for f in .claude/agents/*.md; do
  .claude/hooks/constitution-validator.sh "$f"
done
.claude/hooks/domain-checker.sh
tests/governance-tests.sh
```

Common fixes if validation fails:
- Missing `purpose` or `accountabilities` → re-emit the role file
- Domain overlap → narrow one pattern, or declare Producer/Reviewer
  exception in CONSTITUTION's LOCAL section

End with **2-3 smoke-test prompts** the user can try, each designed to
naturally invoke one of the new roles.

## Updating the scaffold later

The user runs `./scripts/update-scaffold.sh` when they want to pull
upstream improvements to the constitution UNIVERSAL region, hooks,
and tests. The script preserves their roles, state, and the LOCAL
section of the constitution.

The user runs `gh skill update --all` to refresh this skill itself
and the governance skill.

## What you do not do

- Do not generate code-review or test-running roles unless the domain
  genuinely calls for them. Domain analysis comes first.
- Do not exceed 5 initial roles. Layer 2 will grow the set organically.
- Do not edit `.claude/CONSTITUTION.md`'s UNIVERSAL section. It belongs
  to upstream and is overwritten on update-scaffold.
- Do not edit `.claude/skills/governance/SKILL.md` or `.claude/hooks/*`.
  Those are managed by upstream.
- Do not create sub-circles. Flat only.
