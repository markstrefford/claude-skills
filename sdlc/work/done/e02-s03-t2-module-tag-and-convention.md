---
id: e02-s03-t2-module-tag-and-convention
kind: task
project: claude-skills
status: done
autonomy: attended
parent: e02-s03-open-questions-queue
created: 2026-07-08
updated: 2026-07-08
---

## Outcome

Every question raised carries a module-area tag alongside its work tag, and the
queue documents itself as live-questions-only rather than append-only.

## Decisions in plain terms

Uses the module-area definition set in s02 (`docs/decisions/sdlc-store-lifecycle`
+ the ri-file area convention) so the queue and the decisions record line up by the
same code unit. No new decision.

## Acceptance

- The three skills that raise questions (ri-compile, ri-plan, ri-execute) append a
  module-area tag to each question, in addition to the existing work-id tag — using
  the s02 module definition (stack-relative code unit, list-capable).
- ri-state's *documented* OPEN entry format (it narrates the shape even though it
  never writes OPEN) is updated to the same two-tag shape, so all four skills that
  describe the format agree. Do not give ri-state any write behaviour.
- The shared OPEN-writing format across all four skills shows both tags.
- `sdlc/OPEN.md`'s header describes the queue as holding live questions only —
  added by the acting skills, removed on resolution by ri-file — and no longer
  calls itself "append-only". The acting skills still only append (they never
  remove); the append-only phrasing is corrected without weakening that.
- All four edited skill copies are in parity (canonical == install).

## Test specification

Instruction-file change; verify by coherence inspection:

- All four skills that document the OPEN format (ri-compile, ri-plan, ri-execute,
  ri-state) show the two-tag shape — no skill left carrying the old single-tag form.
- The raising skills' own "append only, never rearrange" rules still hold for them
  (they add, never remove) — the change is that removal exists and is owned by
  ri-file; ri-state still only reads.
- OPEN.md header no longer says "append-only"; it states live-questions-only and
  names ri-file as the remover.
- Canonical == install for ri-compile, ri-plan, ri-execute, ri-state.

## Implementation notes

Edit canonical copies then cp to install (all in parity):

- In each of `ri-compile`, `ri-plan`, `ri-execute` SKILL.md, extend the OPEN-writing
  format line to carry a module-area tag next to the work-id tag, e.g.
  `- <date> <question> [<work-id>] [area: <module(s)>]`. Add a one-line note that
  the area is the code module(s) the question touches, per the s02 definition.
- In `ri-state/SKILL.md`, update its documented OPEN entry format (lines ~77-85) to
  the same two-tag shape. ri-state describes the format but never writes it — this
  is a doc-consistency fix so the fourth carrier doesn't go stale. Leave ri-state's
  read-only behaviour unchanged.
- Update `sdlc/OPEN.md`'s header: replace "Append-only, one per line." with a line
  that says the queue holds live questions only — appended by the acting skills,
  removed on resolution by ri-file (see the resolution path) — one per line, each
  tagged with the work it gates and the code module it touches.
- Do not change the acting skills' own append-only discipline (they still never
  remove or rearrange); only ri-file removes, at resolution.

## Status

active
