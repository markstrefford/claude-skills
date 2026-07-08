---
project: claude-skills
updated: 2026-07-08
---

# STATE — claude-skills

## Active focus

`e02-sdlc-lifecycle-hygiene` — s01–s04 all **complete and merge-ready**; only s05
remains. s04 gave ri-state a hygiene audit (stale/decided/stalled/backlog flags
from fs+git) and an escalating, source-aware gate: a direct `/ri-state` holds an
acknowledgement gate once deterministic flags cross the threshold, while chain-end
runs report but never block. All s01–s04 tasks in `/work/done/`; all skill copies
in parity. `e01` also active.

- **e02** epic is `active`. s01–s04 done and merge-ready; **s05** (contextual
  surfacing by code module) is the only story left to complete the release. s05
  builds on s03's module tags (in place). Four decisions in `docs/decisions/`.
- **e01** epic is `active` with a four-story roadmap (s01 gate, s02 auto-progress,
  s03 tier-3 hygiene, s04 publication/README). No story planned yet.

## Immediate next

- Plan and build **e02 s05** (surface questions/decisions by code module when work
  starts) — the last story; completing it makes the epic whole for the release.
- Merge the whole `feature/sdlc-lifecycle-hygiene` branch once s05 lands (operator's
  call) — the release ships as one piece.

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
