---
project: claude-skills
updated: 2026-07-09
---

# STATE — claude-skills

## Active focus

Nothing active, backlog empty, OPEN clear — the queue is fully drained at v2.2.0.
`e02` (lifecycle hygiene) shipped v2.1.0, `e03` (governance-gate granularity) shipped
v2.2.0, and `e01` (v1-based autonomy additions) is parked as done, superseded.
Operator's call what comes next.

## In flight

- Nothing in `/work/active/` or `/work/backlog/`.

## Immediate next

- Operator's call. The shipped system is stable at v2.2.0 with a clear queue.

## Blockers

- None.

## Open

- 0 items in OPEN.md.

## Notes

- This repo dogfoods its own SDLC: tier-3 config at `.ri/config.md`, `/sdlc/work/`
  and `/sdlc/docs/` live. `raw/`, `/work/active/`, `/work/backlog/` all empty.
- Releases: v2.0.0 (SDLC v2), v2.1.0 (lifecycle hygiene + cd-guard hook),
  v2.2.0 (governance-gate granularity + merge-vs-PR landing convention). ri-skills
  lands release-based: tier-3 review rigour, merge + tag rather than per-story PRs.
- `e01` parked as done (superseded by v2.x); its ideas largely exist by other routes.
  **PR #1 (jiludvik2) can now be closed with thanks** — it will never be built as
  written (v1-based).
- `version-pairing` / `public-deploy` enforcement parked (public-deploy is the coarse
  form of footprint).
