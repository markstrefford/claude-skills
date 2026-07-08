---
project: claude-skills
updated: 2026-07-08
---

# STATE — claude-skills

## Active focus

`e02-sdlc-lifecycle-hygiene` — s01 (backlog stage) and s02 (decisions record
tightening) both **complete and merge-ready**. s02 added the `area` tag defined as
a stack-relative code-module reference (operator's call: module granularity, not
epic-id, not concept slug), settled decision ids as descriptive slugs, and folded
the durability bar into ri-file. All s01/s02 tasks in `/work/done/`; skill copies
in parity. s03–s05 remain. `e01` also active.

- **e02** epic is `active`. s01 (backlog stage) and s02 (decisions record) done
  and merge-ready; s03–s05 remain (s03 OPEN questions-only, module-area-tagged +
  drain on resolution, s04 hygiene audit with escalating gate, s05 contextual
  surfacing by code module). Two decisions in `docs/decisions/`
  (`sdlc-store-lifecycle`, `plan-mode-as-pipeline-frontend`), now module-area
  tagged.
- **e01** epic is `active` with a four-story roadmap (s01 gate, s02 auto-progress,
  s03 tier-3 hygiene, s04 publication/README). No story planned yet.

## Immediate next

- Plan **e02 s03** (OPEN questions-only, module-area-tagged, drained on
  resolution) — but first resolve its OPEN.md question (who owns OPEN resolution).
- **s04** also waits on its OPEN.md question (hygiene gate behaviour at
  skill-invoked chain end). **s05** (surface by module) needs s03's area tags.
- Merge **e02 s01 + s02** whenever ready (operator's call).

## Blockers

- None hard. Deferred calls in OPEN.md gate clean planning of e01 s01/s03/s04 and
  e02 s03/s04.

## Open

- 5 items in OPEN.md.

## Notes

- This repo dogfoods its own SDLC: tier-3 config at `.ri/config.md`,
  `/sdlc/work/` and `/sdlc/docs/` live.
- `raw/` still holds three behavioural notes (`cd-ask-not-needed` — resolved by
  the cd-guard hook and dischargeable; `comments-changes`, `reduce_verbosity` —
  pending a fold into the global CLAUDE.md, not skills work).
- The cd-guard hook and its docs sit on branch `feature/cd-repo-guard-hook`.
- The e02 compile artefacts are uncommitted, pending a dedicated branch.
- PR #1 (jiludvik2) stays open until e01's stories land, then gets credit + close.
