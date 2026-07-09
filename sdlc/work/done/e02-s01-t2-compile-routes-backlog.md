---
id: e02-s01-t2-compile-routes-backlog
kind: task
project: claude-skills
status: done
autonomy: attended
parent: e02-s01-backlog-stage
created: 2026-07-08
updated: 2026-07-08
---

## Outcome

Compile can send shaped-but-unstarted work to the backlog, and its rules state
plainly that the capture zone is always drained of anything shaped.

## Decisions in plain terms

This task implements the decision already recorded in
`docs/decisions/sdlc-store-lifecycle.md` — every store has a defined exit and the
capture zone drains completely. No new decision is made here.

## Acceptance

- Compile's list of output shapes includes a backlog item — shaped work not being
  started now — routed to `sdlc/work/backlog/`.
- Compile's rules carry the invariant that every shaped item exits the capture
  zone to exactly one home (docs, backlog, active, or discard) and nothing shaped
  remains in raw.
- Compile's file-moves handle a backlog item the same way they handle an active
  item, including the source-reference-then-delete-raw discipline.
- The backlog change is present and identical in both the distributable skill
  (`ri-skills/skills/ri-compile/SKILL.md`) and the installed copy
  (`~/.claude/skills/ri-compile/SKILL.md`) — verified on the backlog edit
  specifically, NOT by making the two whole files byte-identical (they legitimately
  diverge today on an unrelated, unmerged epic-numbering paragraph — see notes).

## Test specification

Instruction-file change; verification is by coherence inspection, not unit tests:

- The word "backlog" appears in ri-compile's output-shape list, in its
  file-moves handling, and in an explicit drain-the-capture-zone invariant.
- The existing routing to `work/active/` and `docs/…` is preserved, not
  replaced — backlog is added as a peer, not a substitute.
- No contradiction is introduced with `ri-capture`'s standing rule that only
  compile deletes raw (that rule stays true and unchanged).
- The drain invariant reads per-shaped-item ("nothing shaped stays in raw"), not
  per-folder ("empty raw every run") — partial compile of a subset of raw must
  remain valid.
- A targeted `diff` (or grep) confirms the backlog paragraphs are byte-identical
  between the two copies. A full-file diff is expected to still show the
  epic-numbering paragraph divergence and that is fine — do not "fix" it here.

## Implementation notes

Edit `ri-skills/skills/ri-compile/SKILL.md` (canonical/distributable), then sync
the identical change to `~/.claude/skills/ri-compile/SKILL.md`:

- In "Propose the output shape", add a bullet: **backlog item** — shaped work
  that is real but not being started now; goes to `/sdlc/work/backlog/`. Keep the
  existing task/story/epic/decision/… options.
- Add the invariant near the file-moves section and/or hard rules: "Every shaped
  item leaves the capture zone for exactly one home — docs, backlog, active, or
  discard. Nothing shaped stays in raw." This makes explicit what was previously
  only implied by the delete-after-compile step.
- In "File moves", add backlog as a write target parallel to `work/active/`:
  write the artefact to `/sdlc/work/backlog/`, confirm `sources:` references the
  raw path, delete raw only after the artefact is written. Same discipline as
  active.
- Leave the epic/story/task body-structure rules untouched — a backlog item is
  still a normal artefact; only its destination folder differs from active.
- CAUTION on the sync: make the same targeted backlog edit to each copy
  independently. Do NOT copy the canonical file wholesale over the installed one —
  the installed copy carries an epic-numbering paragraph (from the unmerged
  `feature/ri-compile-epic-numbering` branch) that the canonical copy on this
  branch does not, and a wholesale copy would silently delete it. Reconciling that
  paragraph is a separate concern (merge that branch); it is out of scope here.

## Status

active
