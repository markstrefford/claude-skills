---
project: claude-skills
updated: 2026-07-08
---

# STATE — claude-skills

## Active focus

`e02-sdlc-lifecycle-hygiene` — **complete. All five stories done and merge-ready.**
The SDLC now has a full store lifecycle: backlog stage (s01), module-tagged
decisions record (s02), live-only drained open-questions queue (s03), ri-state
hygiene audit + source-aware escalating gate (s04), and module-based surfacing of
questions/decisions when work starts (s05). Every task in `/work/done/`; all skill
copies in parity; four decisions filed. Ships as one release on
`feature/sdlc-lifecycle-hygiene` — merge is the operator's call. `e01` still active.

- **e02** epic is `active` and **complete** — all five stories done and
  merge-ready, awaiting merge as one ri-skills release. Four decisions in
  `docs/decisions/`. On merge, the epic and its stories move to `/work/done/`.
- **e01** epic is `active` with a four-story roadmap (s01 gate, s02 auto-progress,
  s03 tier-3 hygiene, s04 publication/README). No story planned yet.

## Immediate next

- Cut the ri-skills release: merge `feature/sdlc-lifecycle-hygiene` (and
  `feature/cd-repo-guard-hook`) into `main` — operator's call. On merge, move the
  e02 epic + stories to `/work/done/`.
- Revisit the two behavioural `raw/` notes (`comments-changes`, `reduce_verbosity`)
  → global CLAUDE.md, when you're ready.

## Blockers

- None hard. Deferred calls in OPEN.md gate clean planning of e01 s01/s03/s04 and
  e02 s03/s04.

## Open

- 3 items in OPEN.md.

## Notes

- This repo dogfoods its own SDLC: tier-3 config at `.ri/config.md`,
  `/sdlc/work/` and `/sdlc/docs/` live.
- `raw/` still holds three behavioural notes (`cd-ask-not-needed` — resolved by
  the cd-guard hook and dischargeable; `comments-changes`, `reduce_verbosity` —
  pending a fold into the global CLAUDE.md, not skills work).
- The cd-guard hook and its docs sit on branch `feature/cd-repo-guard-hook`.
- The e02 compile artefacts are uncommitted, pending a dedicated branch.
- PR #1 (jiludvik2) stays open until e01's stories land, then gets credit + close.
