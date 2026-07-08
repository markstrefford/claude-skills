---
id: sdlc-store-lifecycle
kind: decision
project: claude-skills
area: [ri-compile, ri-state, ri-plan, ri-execute, ri-file]
sources: [raw/sdlc-lifecycle-hygiene.md]
created: 2026-07-08
updated: 2026-07-08
verified-on: 2026-07-08
---

# Every SDLC store gets a defined exit and a forcing function that keeps it drained

**Decision:** Each store in the SDLC (capture zone, open-questions queue,
backlog, active work, decisions record) must have a defined way material leaves
it, not just enters it — and the state refresh runs a hygiene audit that flags
neglect and escalates to a review the operator must clear once it crosses a
threshold. **Consequence:** the stores stay legible on their own; the operator
stops paying a periodic archaeology tax to reconstruct what the state means.

## Why

The stores were silting up. The open-questions queue (`OPEN.md`) was the clearest
case: append-only, and holding three different lifecycles at once — live
questions that need a decision, resolved questions ("open action → we decided X →
closed") that are really decisions in disguise, and deferred actions that are
really backlog work. Two of those three had no defined way to leave the file, so
it grew into a pile that was meaningless months later. The active-work folder had
the same failure: "in progress" with nothing forcing a check that it still was.

The insight: nothing rotted because it was old. It rotted because entry was
defined and exit was not. Append-only with no drain is a guaranteed graveyard.

## The stance

- Every store holds one kind of thing and has a defined exit:
  - capture zone → drained by compile (nothing shaped stays there);
  - open-questions queue → live questions only, each removed on resolution to a
    decision, to the backlog, or to discard;
  - backlog → shaped-but-unstarted work, exits to active;
  - active → committed work, exits to done;
  - decisions record → durable calls only.
- Resolution drains the queue in the same step that records the answer. Queue
  length is then bounded by how many questions are genuinely live — small.
- The decisions record is kept thin deliberately: not every closed question
  becomes a decision, only durable consequential ones. Trivial closes die
  unrecorded. Bloat is controlled by thinness, area-tags and dates — so decisions
  stay greppable by area — not by volume.
- Open questions carry an area tag so they can be surfaced when work starts on
  that area, and answered in context rather than rediscovered cold.

## The forcing function, and how hard it bites

The hygiene audit runs at state refresh and **escalates at thresholds** — it
always reports flags, and once neglected items cross a count/age threshold it
becomes a review the operator must clear before the refresh passes silently.

The alternative considered was purely advisory (report flags, operator acts when
they choose). Advisory is lower friction; escalating is the stronger guarantee
that neglect cannot accumulate. Escalating was chosen — operator-approved —
because the whole point is a control that prevents the mess returning, not
another thing that itself gets ignored. The friction is accepted as the price of
the guarantee, and it is proportional-to-risk in the same spirit as the tier
system: quiet when the state is clean, insistent only when it is drifting.

## Consequences

- The shared skills (capture, compile, plan, execute, file, state) all change
  behaviour; the change propagates to every repo that runs ri-skills.
- Some operator friction at state refresh when state has been allowed to drift —
  by design.
- Existing messy state in other repos is not fixed by this decision; it makes the
  controls exist. Cleaning a legacy pile with them is separate per-repo work.

Implemented by epic `e02-sdlc-lifecycle-hygiene`.
