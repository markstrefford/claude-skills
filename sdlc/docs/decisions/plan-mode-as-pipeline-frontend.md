---
id: plan-mode-as-pipeline-frontend
kind: decision
project: claude-skills
sources: [raw/plan-mode-as-pipeline-front-end.md]
created: 2026-07-08
updated: 2026-07-08
verified-on: 2026-07-08
---

# Let the platform own investigation; keep graduated execution as ours

**Decision:** Treat Claude Code's built-in plan mode as the front end of the
ri-skills pipeline — it owns the read-only investigation and plan-proposal
surface — while the skills keep the part the platform structurally can't do:
graduated execution (attended/review/auto autonomy, the per-task verifier, the
story-close governance gate). **Consequence:** future convergence work points at
this seam rather than at reimplementing plan mode; the skills stay thin by not
duplicating an investigation surface the platform already gives us.

## Why

Plan mode is a good investigation surface — read-only exploration that produces a
plan and gates on approval. But it is a single gate: plan-or-go, all-or-nothing
per plan. It cannot do graduated execution. The skills' distinctive value is
exactly that graduated control. So the two are complements, not competitors:
platform owns the front (investigation, plan presentation), skills own the back
(how much autonomy the execution runs with, and the checks around it).

The standing implication: don't rebuild plan mode's investigation surface inside
the skills. If convergence work happens, it should let the platform own the
investigation/plan-presentation primitive and keep the graduated-control workflow
as ours.

## Open questions (deferred, not blocking)

These were raised in the source note and are logged for later judgment rather
than resolved here:

- Does an approved plan-mode plan map cleanly onto a durable story/plan artefact,
  or is there an impedance mismatch between an ephemeral plan and a filesystem
  artefact?
- Would this actually reduce skill weight, or just add a handoff seam?
- Is a thin skill that ingests an approved plan-mode plan into active work worth
  building?

## Consequences

- Directional only — no skill changes land from this decision on its own. It sets
  where convergence effort should and shouldn't go.
- If the ingest question is answered yes later, it becomes its own small piece of
  work; this decision is the rationale it would cite.
