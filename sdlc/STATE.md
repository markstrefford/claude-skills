---
project: claude-skills
updated: 2026-07-09
---

# STATE — claude-skills

## Active focus

`e01-sdlc-autonomy-additions` — absorbing Jiri's PR #1 ideas (autonomy gate,
auto-progress loop, tiered hygiene, publication handling). Compiled and reviewed;
not yet planned. This is the only active epic — `e02` shipped in **v2.1.0**.

## In flight

- **e01** epic is `active` with a four-story roadmap (s01 gate, s02 auto-progress,
  s03 tier-3 hygiene, s04 publication/README). No story planned yet.
- **e02-sdlc-lifecycle-hygiene** is **done** — released as v2.1.0 and moved to
  `/work/done/` with all its stories. It gave the SDLC a full store lifecycle:
  backlog stage, module-tagged decisions record, live-only drained open-questions
  queue, ri-state hygiene audit + source-aware escalating gate, and module-based
  surfacing. Four decisions in `docs/decisions/`.

## Immediate next

- Plan **e01 s01** (the autonomy gate) — but resolve the three OPEN.md questions
  first, especially where shared gate behaviour lives.

## Blockers

- None hard. Three deferred calls in OPEN.md gate clean planning of e01 s01/s03/s04.

## Open

- 3 items in OPEN.md (all e01, now module-area tagged).

## Notes

- This repo dogfoods its own SDLC: tier-3 config at `.ri/config.md`,
  `/sdlc/work/` and `/sdlc/docs/` live.
- `raw/` is empty — the two behavioural notes were folded into the global
  `~/.claude/CLAUDE.md` (Keep responses tight; Code comments); `cd-ask-not-needed`
  was resolved by the cd-guard hook and discarded.
- v2.1.0 shipped: e02 lifecycle hygiene + the cd-guard hook, merged to `main`.
- PR #1 (jiludvik2) stays open until e01's stories land, then gets credit + close.
