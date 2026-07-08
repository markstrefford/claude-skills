---
id: hygiene-gate-escalation
kind: decision
project: claude-skills
area: [ri-state]
sources: [work/active/e02-sdlc-lifecycle-hygiene.md, OPEN.md]
created: 2026-07-08
updated: 2026-07-08
verified-on: 2026-07-08
---

# The hygiene gate blocks only on a direct operator state-refresh, never on an auto-invoked one

**Decision:** The escalating hygiene gate blocks — requires the operator to clear
flagged neglect before the refresh passes — **only when `ri-state` is invoked
directly by the operator** (`/ri-state`, the deliberate "where are we" moment).
When `ri-state` is auto-invoked by another skill at chain end
(compile / plan / execute), it **reports the flags but never blocks**.
**Consequence:** the gate keeps its teeth at the moment the operator is actually
looking, without ever silently converting an authorised auto-run chain into a
forced hygiene review.

## Why

`ri-state` is called two ways: directly by the operator, and automatically by
other skills at the end of their chains. The epic's decision to give the hygiene
audit teeth (escalate at thresholds — see `sdlc-store-lifecycle`) created a risk:
if an auto-invoked refresh could block, an authorised auto-execute chain would
stall on a hygiene review the operator never asked for, in the middle of work they
had already greenlit. That would turn a safety control into an obstruction.

Splitting behaviour by invocation source resolves it. The direct `/ri-state` call
is the operator choosing to take stock — the right place to insist neglect be
cleared. The auto-invoked call is mid-flow — the right place to surface flags but
stay out of the way. Teeth where they help, quiet where they'd obstruct;
proportional-to-risk, in the same spirit as the tier system.

## Consequences

- `ri-state` gains an invocation-source awareness (built in s04): block-on-flags
  when called directly, report-only when called by another skill.
- Autonomous chains (`ri-execute` on `auto`) are never silently halted by the gate.
- The operator still cannot let neglect accumulate unseen — it blocks the next
  time they run `/ri-state` themselves.
- Unblocks planning of s04.

Implemented by story `e02-s04` (hygiene audit) under epic
`e02-sdlc-lifecycle-hygiene`.
