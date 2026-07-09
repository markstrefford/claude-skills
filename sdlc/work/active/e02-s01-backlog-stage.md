---
id: e02-s01-backlog-stage
kind: story
project: claude-skills
status: active
autonomy: attended
parent: e02-sdlc-lifecycle-hygiene
sources: [work/active/e02-sdlc-lifecycle-hygiene.md, docs/decisions/sdlc-store-lifecycle.md]
created: 2026-07-08
updated: 2026-07-08
---

# Add a backlog stage and make compile drain the capture zone

## Executive summary

Today compile has only two homes for shaped work: active (which commits it to
work in flight) or the docs shelf. Anything shaped but not ready to start has
nowhere to go, so it lingers in the capture zone or gets forced prematurely into
active — the double-duty that makes the capture zone a junk drawer. This story
adds a third home, a backlog store for shaped-but-unstarted work, and makes the
rule explicit that compile never leaves a shaped item behind in the capture zone
(un-shaped captures may still wait there for a later pass — the inbox model is
preserved). It's the foundation the rest of the epic builds on: the later
stories that drain questions and audit for neglect all assume this store exists.
It changes where the skills put files; it changes nothing a product does.

## Outcome

- A backlog store exists as a first-class stage between the capture zone and
  active work, so shaped-but-unstarted work has a home of its own.
- Compile routes each shaped item to exactly one home — the docs shelf, the
  backlog, active work, or discard — so that no shaped item is left behind in the
  capture zone. Un-shaped captures may still wait there; the invariant is
  per-item, not "empty the folder on every run".
- The cursor is aware of the backlog, so work parked there is visible and
  surfaced as a candidate for what to pick up next.
- A backlog item has a defined way out: starting work on it moves it into active,
  so the store cannot become the append-only graveyard the epic exists to prevent.

## Out of scope / carry-forward

- The neglect audit over the backlog (flagging items that have sat too long)
  belongs to the hygiene-gate story later in the epic, not here. This story only
  establishes the store and makes it visible.
- Draining the open-questions queue into the backlog is the questions story
  later in the epic. This story makes the backlog a valid destination; wiring the
  queue's exit to it comes then.

## Standing gate

The change lives in the shared skills and their distributable copy, so every repo
that installs them gains the backlog store — the intended reach. The store is a
convention (a folder plus the skills that read and write it); it is created on
first use and documented where the other work stores are. No product code is
touched. Because these are the skills that govern every tier-3 repo, the edits
are reviewed at tier-3 rigor even though each is a documentation-level change.

## Acceptance

- There is a backlog store alongside active and done, documented where the work
  stores are described, and present in this repo.
- Compile's shape options include the backlog, and its rules state plainly that
  every shaped item leaves the capture zone for one defined home.
- The cursor reads the backlog and can name a backlog item as the next thing to
  pick up when nothing is in flight.
- Starting work on a backlog item promotes it into active, so it is reachable by
  the planning and execution flow rather than stranded.
- The distributable copy of the skills carries the same changes, so a fresh
  install behaves identically.

## Status

All four tasks done (t1–t4 in `/work/done/`). Acceptance verified: the backlog
store exists and is tracked; compile routes to it and drains the capture zone
per-item; the cursor reads it and offers it as Next; and starting a backlog item
promotes it to active. Skill copies are in parity (only ri-compile carries the
unrelated, unmerged epic-numbering divergence, tracked in OPEN). Merge-ready —
story-close and merge are the operator's call.
