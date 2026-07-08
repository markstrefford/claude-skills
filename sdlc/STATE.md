---
project: claude-skills
updated: 2026-07-08
---

# STATE — claude-skills

## Active focus

`e02-s01-backlog-stage` — **complete and merge-ready**. Added the backlog
work-stage, made compile drain the capture zone per-item, taught the cursor to
read the backlog, and gave it a defined exit (backlog→active promotion, owned by
ri-plan). All four tasks in `/work/done/`; skill copies in parity. Merge is the
operator's call. Parent epic `e02-sdlc-lifecycle-hygiene` and `e01` remain active.

- **e02** epic is `active`. s01 (backlog stage) done and merge-ready; s02–s05
  remain (s02 tighten decisions record, s03 OPEN questions-only + drain on
  resolution, s04 hygiene audit with escalating gate, s05 contextual OPEN
  surfacing). Accompanied by two decisions in `docs/decisions/`
  (`sdlc-store-lifecycle`, `plan-mode-as-pipeline-frontend`).
- **e01** epic is `active` with a four-story roadmap (s01 gate, s02 auto-progress,
  s03 tier-3 hygiene, s04 publication/README). No story planned yet.

## Immediate next

- Merge **e02 s01** (operator's call), then plan **e02 s02** (tighten the
  decisions record) — unblocked.
- Before **e02 s03** and **s04** plan, resolve their two OPEN.md questions (who
  owns OPEN resolution; how the hygiene gate behaves at skill-invoked chain end).
- Reconcile the install/source drift (merge `feature/ri-compile-epic-numbering`)
  so the ri-compile numbering paragraph lands in the repo.

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
