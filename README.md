# holacracy-harness

**Self-Governing Agent Team Architect for Claude Code.** Two `gh skill`-installable skills that design Holacracy-style agent teams and then continuously evolve them.

[日本語](./README_JA.md)

## What this is

A single-repo plugin distributed via [`gh skill`](https://cli.github.com/manual/gh_skill_install). Two skills ship from this repo:

- **`harness`** (Layer 1) — designs the initial role architecture and writes the runtime scaffold
- **`governance`** (Layer 2) — autonomously adds, updates, and deletes roles based on invocation statistics

Both auto-update via `gh skill update --all`.

## Install

```bash
# Project-scope (skills available only in this project)
gh skill install HikaruEgashira/holacracy-harness harness    --agent claude-code --scope project
gh skill install HikaruEgashira/holacracy-harness governance --agent claude-code --scope project

# Or user-scope (available everywhere)
gh skill install HikaruEgashira/holacracy-harness harness    --agent claude-code --scope user
gh skill install HikaruEgashira/holacracy-harness governance --agent claude-code --scope user
```

Pin to a release: append `@v0.1.0`.

Requires `gh` ≥ v2.90.0.

## Use

In any git-initialized project where the skills are installed:

```bash
$ claude
> Build a harness for this project. We do <your domain>.
```

The `harness` skill walks the user through:

```
Phase 1: Domain Analysis
Phase 2: Role Architecture (one of 6 patterns)
Phase 3: Scaffold Installation (CONSTITUTION.md, hooks, tests)
Phase 4: Role File Generation (.claude/agents/)
Phase 5: Domain-specific Constitution Clauses
Phase 6: Validation & Smoke Test
```

After Phase 6, the project is fully wired:

```
your-project/
├── .claude/
│   ├── CONSTITUTION.md      # 10 universal + your local clauses
│   ├── settings.json        # 3 hooks wired
│   ├── agents/              # 3-5 generated roles, governance evolves these
│   ├── hooks/               # logging + threshold checking
│   └── state/               # stats.jsonl, prompts.jsonl, governance-log.jsonl
├── tests/governance-tests.sh
└── scripts/
    ├── init.sh
    └── update-scaffold.sh
```

The `governance` skill takes over from there. At every SessionEnd, the
threshold-check hook decides whether to launch `governance auto-run`.
The cooldown is 24 hours; auto-runs apply at most 3 changes per
invocation, on a branch named `governance/<UTC-date>`.

Auto-run is **opt-in**. Set `GOVERNANCE_AUTO_RUN=1` in your shell to
enable detached background runs from the hook. Pushing the resulting
branch to the remote is separately gated behind `GOVERNANCE_AUTO_PUSH=1`.
With neither flag set, threshold trips are logged but governance never
acts unsupervised.

## Architecture patterns

| Pattern | Use when |
|---|---|
| Pipeline | Linear, staged work |
| Fan-out / Fan-in | Multi-perspective investigation |
| Expert Pool | Reactive, varied requests |
| Producer / Reviewer | Quality-critical |
| Supervisor | Dynamic, plan-driven |
| Network | Exploratory |

## Updating

- **Skills** auto-update via `gh skill update --all`. Provenance is
  written into each skill's frontmatter; `gh skill` detects real
  content drift, not just version bumps.
- **Scaffold** in your project (CONSTITUTION universal section, hooks,
  tests) updates via `./scripts/update-scaffold.sh`. The script
  preserves your `.claude/agents/`, `.claude/state/`, and the LOCAL
  section of `CONSTITUTION.md`.

## Two-layer model

```
┌───────────────────────────────────────────┐
│  Layer 1: harness skill (gh skill)        │
│    designs initial roles                  │
│    auto-update via gh skill               │
└───────────────────────────────────────────┘
                  ↓ writes scaffold + roles into your project
┌───────────────────────────────────────────┐
│  Layer 2: governance skill (gh skill)     │
│    evolves roles based on stats           │
│    auto-update via gh skill               │
└───────────────────────────────────────────┘
```

Layer 1 happens once per project (or on demand). Layer 2 runs
continuously after that, bounded by an editable constitution.

## Repo layout

```
HikaruEgashira/holacracy-harness/
├── skills/
│   ├── harness/                              # Layer 1 skill
│   │   ├── SKILL.md
│   │   └── references/
│   │       ├── role-design-patterns.md       # 6 patterns
│   │       ├── role-template.md              # Holacracy role format
│   │       ├── tension-types.md
│   │       ├── constitution-guide.md
│   │       └── scaffold/                     # written into user project at Phase 3
│   │           ├── CONSTITUTION.md           # BEGIN/END markers
│   │           ├── settings.json
│   │           ├── hooks/
│   │           ├── tests/
│   │           └── scripts/
│   └── governance/                           # Layer 2 skill
│       ├── SKILL.md
│       └── references/
│           ├── tension-detection.md
│           └── proposal-priority.md
├── README.md, README_JA.md
├── CHANGELOG.md
└── LICENSE
```

## Inspirations

- Brian Robertson, *Holacracy Constitution v5.0*
- [revfactory/harness](https://github.com/revfactory/harness) — meta-skill structure, 6 architecture patterns
- Sakana AI / UBC, *Darwin Gödel Machine* — archive-based agent evolution
- Lu et al. (2024), *MorphAgent* — role clarity / differentiation metrics
- Hu et al. (2024), *EvoMAC* — textual backpropagation through agent networks
- Every, *Compound Engineering* — institutional knowledge accumulation

## License

Apache-2.0
