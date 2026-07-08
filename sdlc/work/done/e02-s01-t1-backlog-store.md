---
id: e02-s01-t1-backlog-store
kind: task
project: claude-skills
status: done
autonomy: attended
parent: e02-s01-backlog-stage
created: 2026-07-08
updated: 2026-07-08
---

## Outcome

A backlog store exists alongside active and done, documented where the work
stores are described and present in this repo.

## Acceptance

- `sdlc/work/backlog/` exists and is tracked by git (survives a fresh clone).
- The README describes the backlog as a stage in the work lifecycle, alongside
  active and done.
- Nothing in the change implies backlog is where in-flight work lives — it is the
  home for shaped-but-unstarted work only.

## Test specification

No runtime surface — this is a structural and documentation change. Verification
is by inspection:

- `git ls-files sdlc/work/backlog/` returns at least one tracked path (the
  keeper file), proving the empty store is committed.
- The README mentions the backlog store in the same place it mentions
  `/work/active/` and `/work/done/`, and describes it as shaped-but-unstarted
  work.
- No existing reference to the active/done pair is left describing the lifecycle
  as only two work stages where it should now read three.

## Implementation notes

- Create `sdlc/work/backlog/` with a `.gitkeep` — git does not track empty
  directories, so the store needs a keeper file to survive clone/install.
- Update `README.md` in three concrete spots, not just prose: (1) the
  "Filesystem as source of truth" principle that names `/work/active/` and
  `/work/done/`; (2) the directory-tree diagram of the `sdlc/` layout; and (3) the
  install scaffold command, which currently runs `mkdir -p … sdlc/work/active
  sdlc/work/done` and must also create `sdlc/work/backlog`. Otherwise the README
  lists backlog as a lifecycle stage its own setup command doesn't create.
  Operator-grammar — this is user-facing documentation.
- This task adds only the store and its documentation. The skills that read and
  write it change in t2 (compile routing) and t3 (cursor awareness); don't touch
  skill logic here.
- The store is a convention: in other repos it is created on first use by compile
  (t2). Here we create it directly because this repo is the dogfooded instance.

## Status

active
