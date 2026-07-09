---
project: claude-skills
updated: 2026-07-09
---

# STATE — claude-skills

## Active focus

Nothing active — the queue is clear. `e02` (lifecycle hygiene) shipped v2.1.0 and
`e03` (governance-gate granularity) shipped v2.2.0. `e01` (autonomy additions) is
parked in the backlog. Operator's call what comes next.

## In flight

- Nothing in `/work/active/`.
- **Backlog:** `e01-sdlc-autonomy-additions` — shaped and reviewed but never planned
  (Jiri's PR #1 ideas: shared act-or-check-in gate, continuous execution, tier-3
  hygiene, publication handling). Promote to active via ri-plan if picked up; three
  OPEN.md questions gate it.

## Immediate next

- Operator's call. If reviving e01, resolve its three OPEN.md questions first
  (chiefly where the shared act-or-check-in gate lives). Otherwise the shipped
  system is stable at v2.2.0.

## Blockers

- None.

## Open

- 3 items in OPEN.md — all gate the backlogged `e01`; module-area tagged.

## Notes

- This repo dogfoods its own SDLC: tier-3 config at `.ri/config.md`, `/sdlc/work/`
  and `/sdlc/docs/` live. `raw/` is empty; `/work/active/` is empty.
- Releases: v2.0.0 (SDLC v2), v2.1.0 (lifecycle hygiene + cd-guard hook),
  v2.2.0 (governance-gate granularity + merge-vs-PR landing convention). ri-skills
  lands release-based: tier-3 review rigour, merge + tag rather than per-story PRs.
- `version-pairing` / `public-deploy` enforcement parked (public-deploy is the
  coarse form of footprint; a repo with a footprint map doesn't need it).
- PR #1 (jiludvik2) stays open while e01 is backlogged; credit + close if it lands.
