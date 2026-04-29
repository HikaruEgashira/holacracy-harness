# Changelog

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
