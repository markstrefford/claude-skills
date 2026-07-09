---
project: claude-skills
updated: 2026-07-09
---

# STATE — claude-skills

## Active focus

`e01-sdlc-autonomy-additions` — absorbing Jiri's PR #1 ideas (autonomy gate,
auto-progress loop, tiered hygiene, publication handling). Compiled and reviewed;
not yet planned. The only active epic — `e03` shipped in **v2.2.0**.

## In flight

- **e01** epic is `active` with a four-story roadmap (s01 gate, s02 auto-progress,
  s03 tier-3 hygiene, s04 publication/README). No story planned yet.
- **e03-governance-granularity** is **done** — shipped v2.2.0 and moved to
  `/work/done/`. Made the story-close gate granular: `/security-review` runs only
  on stories touching externally-deployed code (per-repo footprint map), and a
  repo's declared scanners run under the same scoping (secret always;
  dependency/code footprint-scoped). s03 (invariant enforcement) was descoped —
  `public-deploy` is subsumed by the footprint map; `version-pairing` stays parked.

## Immediate next

- Plan **e01 s01** (the autonomy gate) — but resolve the three OPEN.md questions
  first, especially where shared gate behaviour lives.

## Blockers

- None hard. Three deferred calls in OPEN.md gate clean planning of e01 s01/s03/s04.

## Open

- 3 items in OPEN.md (all e01, module-area tagged).

## Notes

- This repo dogfoods its own SDLC: tier-3 config at `.ri/config.md`,
  `/sdlc/work/` and `/sdlc/docs/` live. `raw/` is empty.
- Releases: v2.0.0 (SDLC v2), v2.1.0 (lifecycle hygiene + cd-guard hook),
  v2.2.0 (governance-gate granularity: footprint-scoped security + scanners,
  plus the merge-vs-PR landing convention). ri-skills lands release-based:
  tier-3 review rigour, merge + tag rather than per-story PRs.
- `version-pairing` / `public-deploy` enforcement is parked (public-deploy is the
  coarse form of footprint; a repo with a footprint map doesn't need it).
- PR #1 (jiludvik2) stays open until e01's stories land, then gets credit + close.
