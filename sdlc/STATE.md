---
project: claude-skills
updated: 2026-08-10
---

# STATE — claude-skills

## Active focus

`e04` — retire `SDLC.md` and single-source the vocabulary. Paused after
`s01-t02` at the operator's call; picked up at a quieter time.

The installed skills at `~/.claude/` are current — all eight workflow verbs
and both agents match the repo, so nothing is stale while this sits.

## In flight

- `e04-sdlc-contract-consolidation` — epic active, `s01` part-executed,
  `s02`–`s06` not yet compiled.
- `e04-s01-install-without-copy` — `t01` and `t02` done, `t03`–`t06`
  pending.

## Immediate next

- **Merge `t03` and `t04` before executing either.** They assume a new
  install can stand up alongside the old one. With symlinks it cannot —
  the link replaces the copy at the same path, so linking *is* removing.
  The safety is the backup from `t02`, not a parallel install. One cutover
  task, not two.
- Then `t05` (hook) and `t06` (install and uninstall docs).

## Blockers

- None. Paused by choice, not blocked.

## Open

- 0 items in OPEN.md.

## Notes

- Install mechanism settled: per-item symlinks from a clone that stays in
  `~/Development`. Recorded with its costs in `install-by-symlink.md`,
  co-located with the epic.
- **The working tree becomes live at cutover** — a branch switch will change
  what every session runs. Not yet true; it becomes true at `t03`.
- Backup of the pre-cutover install at `~/claude-install-backup-20260809`
  (22 files, includes the settings hooks block). `t03`/`t04` depend on it.
  Do not delete until the cutover is closed.
- Four agents in `~/.claude/agents/` exist in no git repository anywhere —
  `code-quality-reviewer`, `performance-auditor`, `software-architect`,
  `test-guardian`. Backed up, not adopted; any cutover must leave them.
- `/sdlc/raw/` is gitignored by design. `t31-sdlc-vocabulary-alignment` and
  `fix-the-install-no-copy` are held there: the epic is operator-grammar, so
  the census figures and the per-skill change list live only in those notes.
- `e04` touches other repos at `s05`. Nothing is committed outside this repo
  without operator approval per repo.
- Releases: v2.0.0 (SDLC v2), v2.1.0 (lifecycle hygiene + cd-guard hook),
  v2.2.0 (governance-gate granularity). Lands release-based: merge + tag.
- `e01` parked as done (superseded by v2.x). **PR #1 (jiludvik2) can now be
  closed with thanks** — it will never be built as written (v1-based).
