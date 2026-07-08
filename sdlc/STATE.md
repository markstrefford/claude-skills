---
project: claude-skills
updated: 2026-07-08
---

# STATE — claude-skills

## Active focus

`e02-sdlc-lifecycle-hygiene` — s01 (backlog stage), s02 (decisions record), and
s03 (open-questions queue lifecycle) all **complete and merge-ready**. s03 gave
ri-file a resolution path (escalate disposition, drain the entry), added the
module tag to the OPEN format across all four skills that document it, rewrote the
queue from append-only to live-only, and retrofitted existing entries. All s01–s03
tasks in `/work/done/`; skill copies in parity. s04–s05 remain. `e01` also active.

- **e02** epic is `active`. s01 (backlog stage), s02 (decisions record), s03
  (open-questions queue) done and merge-ready; s04–s05 remain (s04 hygiene audit
  with escalating gate, s05 contextual surfacing by code module). s04 is grounded
  by the `hygiene-gate-escalation` decision; s05 needs s03's module tags (now in
  place). Four decisions in `docs/decisions/`.
- **e01** epic is `active` with a four-story roadmap (s01 gate, s02 auto-progress,
  s03 tier-3 hygiene, s04 publication/README). No story planned yet.

## Immediate next

- Plan **e02 s04** (hygiene audit with escalating gate) — the meatiest story:
  turns ri-state into a source-aware gate (blocks on direct `/ri-state`, reports
  when auto-invoked) and adds git-log-based staleness detection. Worth an operator
  checkpoint before building.
- **s05** (surface questions/decisions by module) is unblocked once s04 lands.
- Merge **e02 s01 + s02 + s03** whenever ready (operator's call).

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
