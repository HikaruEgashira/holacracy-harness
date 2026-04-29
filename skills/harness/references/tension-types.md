# Tension Types

Six tensions detected automatically from invocation statistics by the
`governance` skill. This reference lets harness anticipate which
tensions are likely for the chosen architecture pattern.

| Tension | Detection rule | Proposal verb |
|---|---|---|
| Over-use | `invocations_30d` > 3 × median, role has ≥ 10 invocations | split |
| Under-use | `invocations_30d == 0` AND age > 7 days | delete |
| Failure | `success_rate < 0.7` AND `invocations_30d ≥ 5` | update |
| Overlap | same role pair > 5 times in `co_invocation` | merge or sharpen |
| Uncovered | ≥ 3 prompts with no Task invocation, semantically related | add |
| Override | git log shows user-edited a generated role file | restore + flag |

## Pattern-specific tendencies

- **Pipeline** — vulnerable to **over-use** at the bottleneck stage.
  Plan that role's accountabilities to be easily splittable.
- **Expert Pool** — commonly produces **uncovered** prompts as the user
  discovers needs. Keep roles narrow so adding new ones is cheap.
- **Producer/Reviewer** — can produce **override** tension if the
  reviewer is too strict. Leave room in instructions for tone calibration.
- **Supervisor** — over-use on supervisor itself usually means specialist
  domains are unclear. Sharpen them at design time.

This is why the harness skill caps initial roles at 5 — let governance
grow the set as data justifies it.
