# Changelog

## [Unreleased]

### Changed
- **BREAKING**: Phase 1 reframed from "Domain Analysis" to "Anchor
  Circle Articulation". The free-form domain summary is replaced by
  an explicit Anchor Circle Purpose (Holacracy v5) authored by the
  user, written to `.claude/ANCHOR.md`.
- **BREAKING**: Role schema adds required `serves_purpose` field
  (CONSTITUTION clause 11). `HARNESS_STRICT_PURPOSE=1` makes the
  validator fail-closed; default is warn for one release.
- **BREAKING**: CONSTITUTION LOCAL section renamed from
  "Domain-specific invariants" to "Anchor Circle Policies".
  Numbering shifts to start at 13 (after new clauses 11/12).
- **BREAKING**: `governance` may not modify `.claude/ANCHOR.md`
  (clause 12); it is human-authored.
- `update-scaffold.sh` preserves `.claude/ANCHOR.md` like LOCAL.
- Architecture Patterns reframed as non-normative role-arrangement
  heuristics; `governance` does not consult them.
- Phase 5 reframed as Anchor Circle Policies generation.

### Added
- `.claude/ANCHOR.md` template at
  `skills/harness/references/scaffold/ANCHOR.md`.
- CONSTITUTION clauses 11 (`serves_purpose` required) and 12
  (ANCHOR.md is read-only to governance).
- Validator checks for `serves_purpose` presence and ANCHOR.md
  existence.

## [0.1.0] — Unreleased

### Added
- `harness` skill (Layer 1) with 6-Phase workflow:
  Domain Analysis → Architecture → Scaffold Installation →
  Role Generation → Domain Clauses → Validation
- `governance` skill (Layer 2) for autonomous role evolution
- 6 architecture patterns: Pipeline, Fan-out/Fan-in, Expert Pool,
  Producer/Reviewer, Supervisor, Network
- 6 tension types: over-use, under-use, failure, overlap,
  uncovered, override
- Scaffold ships under `skills/harness/references/scaffold/`:
  CONSTITUTION.md (UNIVERSAL/LOCAL markers), hooks, tests, scripts
- `update-scaffold.sh` syncs upstream scaffold while preserving
  agents/, state/, and CONSTITUTION LOCAL section
- Both skills installable via `gh skill install` and auto-updatable
  via `gh skill update --all`
- English and Japanese documentation
- `.claude/.gitignore` shipped with scaffold to keep `state/` out of
  Git (PII protection — `prompts.jsonl` contains user input)
- GitHub Actions CI: shellcheck, python compile + ruff, SKILL.md
  frontmatter validation, and a scaffold-smoke job that materializes
  the scaffold and runs all validators end-to-end

### Changed
- **BREAKING (auto-mode behavior)**: SessionEnd `threshold-check.sh`
  no longer spawns a detached `claude -p '/governance auto-run'`
  with `bypassPermissions` by default. The spawn is gated behind
  `GOVERNANCE_AUTO_RUN=1` and the permission mode is configurable
  via `GOVERNANCE_PERMISSION_MODE` (defaults to `acceptEdits`).
  Without these env vars, threshold trips are recorded in
  `governance-log.jsonl` as `verb: "threshold-trip"` but no
  detached process is launched.
- **BREAKING (auto-push)**: `governance` no longer pushes the
  `governance/<UTC-date>` branch automatically. Push is opt-in via
  `GOVERNANCE_AUTO_PUSH=1`.
- Repo references updated from `plenoai/holacracy-harness` to
  `HikaruEgashira/holacracy-harness` to match the canonical origin.

### Fixed
- macOS/BSD compatibility: `date -u -d "$ISO_TS"` (GNU-only) replaced
  with portable Python ISO-8601 parsing in `threshold-check.sh` and
  `governance-tests.sh`. Previously, the cooldown clause-6 check
  silently bypassed itself on macOS by falling back to epoch 0.
- `governance-tests.sh` clause-7 grep counter no longer breaks on
  zero matches (`grep -c` exit 1 + `echo 0` produced multi-line
  output that crashed integer comparison).
- `log-invocation.sh` and `log-prompt.sh` now write hook errors to
  `.claude/state/hook-errors.log` instead of `/dev/null`, so jq
  failures are debuggable.
