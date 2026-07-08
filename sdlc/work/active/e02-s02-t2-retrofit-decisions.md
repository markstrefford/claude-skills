---
id: e02-s02-t2-retrofit-decisions
kind: task
project: claude-skills
status: active
autonomy: attended
parent: e02-s02-decisions-record
created: 2026-07-08
updated: 2026-07-08
---

## Outcome

The decision records already written this session carry the new area tag, so the
convention is dogfooded rather than only described.

## Acceptance

- `docs/decisions/sdlc-store-lifecycle.md` and
  `docs/decisions/plan-mode-as-pipeline-frontend.md` each carry an `area:` field
  matching the convention t1 defines — the code module(s) the decision touches,
  i.e. the skill(s) here.
- The area values name the actual skills each decision concerns (not an abstract
  label and not an epic-id), so starting work on any of those skills will surface
  the decision later.
- No other content in those records changes — this is a frontmatter addition, not
  a rewrite.

## Test specification

Document change; verification by inspection:

- Both decision files have an `area:` frontmatter field listing skill modules.
- The values are skill names (the module unit for this repo), not epic-ids and not
  concept slugs.
- `git diff` on each file shows only the frontmatter addition.

## Implementation notes

- `docs/decisions/sdlc-store-lifecycle.md` touches the SDLC skill set, so its area
  is those skills: `area: [ri-compile, ri-state, ri-plan, ri-execute, ri-file]`.
  A cross-cutting decision legitimately lists several modules — that is the point,
  not a smell.
- `docs/decisions/plan-mode-as-pipeline-frontend.md` concerns the pipeline skills,
  so `area: [ri-compile, ri-plan, ri-execute]`.
- Use the skill names as they appear under `ri-skills/skills/`. If a decision's
  module set is genuinely ambiguous, note it for the operator rather than guessing.
- Depends on t1 (the convention must exist before retrofitting to it).

## Status

active
