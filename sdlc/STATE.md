---
project: claude-skills
updated: 2026-07-09
---

# STATE — claude-skills

## Active focus

`e03-governance-granularity` — making the story-close governance gate granular:
security review scoped by a per-repo footprint map (always code-review, security-
review only when a story touches externally-deployed code), then per-repo scanners
and invariant enforcement. Just compiled and senior-staff reviewed (READY WITH
NOTES — four grounding items carried into the s01 plan). On `feature/e03-
governance-granularity`, headed for v2.2.0. `e01` also active; `e02` shipped v2.1.0.

## In flight

- **e01** epic is `active` with a four-story roadmap (s01 gate, s02 auto-progress,
  s03 tier-3 hygiene, s04 publication/README). No story planned yet.
- **e02-sdlc-lifecycle-hygiene** is **done** — released as v2.1.0 and moved to
  `/work/done/` with all its stories. It gave the SDLC a full store lifecycle:
  backlog stage, module-tagged decisions record, live-only drained open-questions
  queue, ri-state hygiene audit + source-aware escalating gate, and module-based
  surfacing. Four decisions in `docs/decisions/`.

## Immediate next

- Plan **e03 s01** (footprint-scoped security review), carrying the four review
  grounding items into acceptance: absent map = today's behaviour; define
  "ambiguous"; unattended chains default-yes never stall; rename/delete semantics.
- `e01 s01` (autonomy gate) still waits on its three OPEN.md questions.

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
