# Role Architecture Patterns

Six patterns for arranging a flat set of Holacracy-style roles. Pick **one**
during Phase 2. Mixing patterns within a single project's initial design
is discouraged — Layer 2 (governance) can introduce hybrids later.

## 1. Pipeline

Sequential roles, each role's output is the next role's input.

**Use when:** the work has natural stages (research → draft → polish).
**Constraint:** flat sequence. No skip-ahead invocations.
**Example domains:** content production, document drafting, data ETL.

```
[ research ] → [ draft ] → [ polish ]
```

## 2. Fan-out / Fan-in

Multiple parallel roles + one integrator role merging their outputs.

**Use when:** the work decomposes into independent investigations whose
findings need consolidation.
**Constraint:** the integrator owns the merged artifact's domain.
**Example domains:** multi-source research, multi-perspective review.

## 3. Expert Pool

Several specialist roles, dispatched contextually. No fixed sequence.

**Use when:** incoming work varies; which specialist is needed depends
on the request.
**Constraint:** specialist domains must not overlap. Dispatch is by
main Claude — no dispatcher role.
**Example domains:** support triage, multi-language editing.

## 4. Producer / Reviewer

Two roles in tension: one produces, one critiques. Iterate until sign-off.

**Use when:** quality is paramount and self-review is insufficient.
**Constraint:** producer and reviewer have overlapping domains. This
is the **only sanctioned exception** to clause 3 (domain exclusivity).
Must be declared explicitly in CONSTITUTION's LOCAL section.
**Example domains:** writing, design, anything with a quality bar.

## 5. Supervisor

One coordinator role holds the mental model; specialists do the work.

**Use when:** the work is dynamic; sequence depends on intermediate
results.
**Constraint:** the supervisor's domain is the **plan** (e.g., `PLAN.md`),
not the artifacts. Specialists own the artifacts.
**Example domains:** complex investigations, project management.

## 6. Network

Roles connect peer-to-peer based on services they expose. No fixed topology.

**Use when:** the work is collaborative and exploratory; no natural sequence.
**Constraint:** each role declares accepted request kinds in
`accountabilities`. Most flexible, hardest to keep coherent.
**Example domains:** open-ended research, design exploration.

## Choosing

| If the domain is... | Use pattern |
|---|---|
| linear and staged | Pipeline |
| multi-perspective | Fan-out / Fan-in |
| reactive and varied | Expert Pool |
| quality-critical | Producer / Reviewer |
| dynamic and uncertain | Supervisor |
| exploratory | Network |

When in doubt, start with **Expert Pool** of 3 roles. Layer 2 governance
will introduce orderings if data shows recurring co-invocation patterns.

## Anti-patterns

- **Hierarchical Delegation** — explicitly excluded. Sub-circles violate
  the flat-namespace constraint.
- **All-purpose role** — a single role with 6+ accountabilities will be
  flagged by governance as "over-use" and split. Start narrow.
