---
project: claude-skills
updated: 2026-08-09
---

# STATE — claude-skills

## Active focus

`e04` (SDLC contract consolidation) compiled and active. The workflow's
vocabulary lives in three places that disagree — the per-repo `SDLC.md`, the
skills, and the work trees — and nothing detects the difference. Six stories:
fix distribution first, then single-source the contract, then correct the
skills that emit vocabulary, then leave a drift check behind.

## In flight

- `e04-sdlc-contract-consolidation` — epic compiled, no stories broken out yet.

## Immediate next

- Answer the three questions in OPEN.md, or plan `s01` (stop the skills and
  agents bundle being a copy). `s01` gates the rest — until an edit to a skill
  lands where it is stored, any correction made in this epic can be silently
  overwritten by the next install.

## Blockers

- None. The OPEN questions shape `s01`/`s02` and `s05` but don't block planning.

## Open

- 3 items in OPEN.md.

## Notes

- This repo dogfoods its own SDLC: tier-3 config at `.ri/config.md`, `/sdlc/work/`
  and `/sdlc/docs/` live.
- `/sdlc/raw/` is gitignored, so draining it deletes unrecoverably. Both raw
  captures (`t31-sdlc-vocabulary-alignment`, `fix-the-install-no-copy`) are
  retained rather than drained; the epic references them as sources.
- Releases: v2.0.0 (SDLC v2), v2.1.0 (lifecycle hygiene + cd-guard hook),
  v2.2.0 (governance-gate granularity + merge-vs-PR landing convention). ri-skills
  lands release-based: tier-3 review rigour, merge + tag rather than per-story PRs.
- `e01` parked as done (superseded by v2.x). **PR #1 (jiludvik2) can now be closed
  with thanks** — it will never be built as written (v1-based).
- `version-pairing` / `public-deploy` enforcement parked (public-deploy is the coarse
  form of footprint).
- `e04` touches other repos at `s05`. Nothing is committed outside this repo
  without operator approval per repo.
