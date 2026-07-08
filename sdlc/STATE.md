---
project: claude-skills
updated: 2026-07-08
---

# STATE — claude-skills

## Active focus

`e02-s01-backlog-stage` — the foundation story of the lifecycle-hygiene epic:
add a backlog work-stage and make compile drain shaped items from the capture
zone. Planned into four tasks (t1–t4), senior-staff reviewed (NEEDS WORK →
load-bearing findings applied: backlog exit added as t4, sync landmine defused).
Ready for execute. Parent epic `e02-sdlc-lifecycle-hygiene` and `e01` remain
active.

## In flight

- **e02** epic is `active` with a five-story roadmap (s01 backlog stage + drain
  raw, s02 tighten decisions record, s03 OPEN questions-only + drain on
  resolution, s04 hygiene audit with escalating gate, s05 contextual OPEN
  surfacing). No story planned yet. Accompanied by two decisions in
  `docs/decisions/` (`sdlc-store-lifecycle`, `plan-mode-as-pipeline-frontend`).
- **e01** epic is `active` with a four-story roadmap (s01 gate, s02 auto-progress,
  s03 tier-3 hygiene, s04 publication/README). No story planned yet.

## Immediate next

- Execute **e02 s01** tasks t1→t4 in sequence (store → compile routes in → cursor
  reads → promotion exit).
- Before **e02 s03** and **s04** plan, resolve their two OPEN.md questions (who
  owns OPEN resolution; how the hygiene gate behaves at skill-invoked chain end).

## Blockers

- None hard. Deferred calls in OPEN.md gate clean planning of e01 s01/s03/s04 and
  e02 s03/s04.

## Open

- 6 items in OPEN.md.

## Notes

- This repo dogfoods its own SDLC: tier-3 config at `.ri/config.md`,
  `/sdlc/work/` and `/sdlc/docs/` live.
- `raw/` still holds three behavioural notes (`cd-ask-not-needed` — resolved by
  the cd-guard hook and dischargeable; `comments-changes`, `reduce_verbosity` —
  pending a fold into the global CLAUDE.md, not skills work).
- The cd-guard hook and its docs sit on branch `feature/cd-repo-guard-hook`.
- The e02 compile artefacts are uncommitted, pending a dedicated branch.
- PR #1 (jiludvik2) stays open until e01's stories land, then gets credit + close.
