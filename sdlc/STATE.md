---
project: claude-skills
updated: 2026-08-09
---

# STATE — claude-skills

## Active focus

`e04` — retire `SDLC.md` and single-source the vocabulary. The workflow
describes itself in three places that disagree, and nothing detects it. All
seven repos in scope. Six stories: fix distribution first, state the
vocabulary once, correct the skills that emit it, retire the per-repo file,
leave a drift check behind.

## In flight

- `e04-sdlc-contract-consolidation` — epic compiled, no stories broken out yet.

## Immediate next

- Plan `s01` (stop the skills and agents bundle being a copy). It gates the
  rest — until an edit to a skill lands where it is stored, any correction
  made in this epic can be silently overwritten by the next install.

## Blockers

- None.

## Open

- 0 items in OPEN.md.

## Notes

- This repo dogfoods its own SDLC: tier-3 config at `.ri/config.md`, `/sdlc/work/`
  and `/sdlc/docs/` live.
- `/sdlc/raw/` is gitignored by design — a dumping ground, not history. Both
  captures (`t31-sdlc-vocabulary-alignment`, `fix-the-install-no-copy`) are held
  there until the stories that need their detail are planned: the epic is
  operator-grammar, so the census figures and the per-skill change list live
  only in the raw notes.
- Releases: v2.0.0 (SDLC v2), v2.1.0 (lifecycle hygiene + cd-guard hook),
  v2.2.0 (governance-gate granularity + merge-vs-PR landing convention). ri-skills
  lands release-based: tier-3 review rigour, merge + tag rather than per-story PRs.
- `e01` parked as done (superseded by v2.x). **PR #1 (jiludvik2) can now be closed
  with thanks** — it will never be built as written (v1-based).
- `version-pairing` / `public-deploy` enforcement parked (public-deploy is the coarse
  form of footprint).
- `e04` touches other repos at `s05`. Nothing is committed outside this repo
  without operator approval per repo.
