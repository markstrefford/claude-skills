---
id: e02-sdlc-lifecycle-hygiene
kind: epic
project: claude-skills
status: active
autonomy: attended
sources: [raw/sdlc-lifecycle-hygiene.md]
created: 2026-07-08
updated: 2026-07-08
---

# SDLC lifecycle hygiene

## Executive summary

The SDLC's own stores are silting up — the open-questions queue and the
active-work folder visibly, and the decisions record at risk of the same the
moment we start draining resolved questions into it. Material can enter each of
them, but nothing defines how it leaves, so they grow append-only until, months
later, the operator can't tell what an entry means or whether it still matters. This epic
gives every store a defined exit and adds one forcing function — a hygiene audit
that runs whenever state is refreshed — so the stores stay drained on their own.
The goal is state that stays legible without periodic manual archaeology. It
changes how the skills manage the filesystem; it changes nothing about what any
product does. Because it lives in the shared skills, the fix applies to every
repo that runs them, not just this one.

## Outcome

- A backlog stage for shaped-but-unstarted work, so nothing half-formed lingers
  in the capture zone or gets prematurely forced into active work.
- A decisions record that stays thin — only durable calls are filed, each tagged
  to its area and dated.
- An open-questions queue that holds only live questions, each tagged to the work
  it belongs to and removed the moment it is answered.
- A hygiene audit at every state refresh that flags stale, already-decided, or
  abandoned items and escalates to a review the operator must clear once neglect
  crosses a threshold.
- Relevant open questions surfaced automatically when work starts on the area
  they touch, so they get answered in context instead of rotting.

## Out of scope / carry-forward

- One-time cleanup of existing messy state in other repos (the constellation
  pile). This epic builds the controls; applying them to clear a legacy backlog
  is separate follow-on work, per repo, once the controls exist.
- Any move away from filesystem-as-source-of-truth. The model is unchanged; this
  only adds discipline to how the files are used.

## Standing gate

These changes touch the shared skills — capture, compile, plan, execute, file,
and state. They propagate to every repo that runs ri-skills, which is the
intended blast radius: the controls should be universal. But it means each story
ships as a change to skill behaviour and is reviewed at tier-3 rigor. No product
code is affected. The one judgment call the operator has already made — that the
hygiene audit has teeth (escalates to a required review at thresholds) rather
than being purely advisory — is recorded in the accompanying decision and should
not be re-litigated per story.

## Acceptance

- Every SDLC store has a documented entry and exit; none is append-only with no
  drain.
- Resolving an open question removes it from the queue in the same step that
  records the answer.
- A state refresh surfaces a hygiene list, and once neglected items cross the
  threshold it does not pass silently.
- Starting work on an area surfaces any open questions tagged to that area.

## Roadmap

- s01 — add a backlog stage for shaped-but-unstarted work, and make compile always drain the capture zone
  - t1 — establish the backlog store alongside active and done
  - t2 — teach compile to route shaped-but-unstarted work to the backlog and always empty the capture zone
  - t3 — teach the cursor to see the backlog and offer it as what to pick up next
  - t4 — give the backlog a defined exit: starting a backlog item promotes it to active
- s02 — tighten the existing decisions record so it holds only durable calls, area-tagged and dated
  - t1 — add an area tag to the decisions convention and sharpen the bar for what earns a record
  - t2 — retrofit this session's decision records with the area tag
- s03 — make the open-questions queue hold only live questions: tagged to their work and to the code module they touch, dated, and removed on resolution
  - t1 — give ri-file a resolution path that escalates the disposition and drains the entry
  - t2 — raise questions with a module tag and rewrite the queue's convention from append-only to live-only
  - t3 — retrofit existing queue entries with module tags
- s04 — add a hygiene audit at state refresh that flags neglect and escalates to a required review at thresholds
- s05 — surface relevant open questions and decisions automatically when work starts on the code module they touch

## Status

Compile done. Plan reads the code before writing tasks.
