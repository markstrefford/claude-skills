---
id: open-question-resolution
kind: decision
project: claude-skills
area: [ri-file, ri-compile, ri-plan]
sources: [work/active/e02-sdlc-lifecycle-hygiene.md, OPEN.md]
created: 2026-07-08
updated: 2026-07-08
verified-on: 2026-07-08
---

# ri-file owns resolving an open question, and escalates the disposition to the operator

**Decision:** `ri-file` owns the act of resolving an open question and draining it
from the queue — but it **escalates the disposition to the operator** rather than
deciding alone. On the operator's call the line leaves `OPEN.md` in the same step:
a durable answer becomes an area-tagged decision record, an answer that turns into
work becomes a backlog or active item, and a trivial close just deletes the line.
**Consequence:** the queue can't silently accumulate resolved items, every
resolution has a single owner and a defined exit, and the operator stays the judge
of what a resolution *means* — the skill does the bookkeeping, not the judging.

## Why

The queue was becoming a graveyard because no skill owned the exit. `ri-state`
refuses to touch `OPEN.md`; the acting skills only append. Something had to own
draining it. A dedicated new "resolve" skill was considered and rejected — it adds
surface for a job that is mostly bookkeeping. `ri-file` already owns turning
session outputs into durable records and already refuses filler, so the
question→decision drain is a natural extension of it.

The operator-escalation nuance matters: deciding whether a resolved question is
durable (record it), becomes work (queue it), or is trivial (drop it) is a
judgment call, not a mechanical one. `ri-file` surfaces the resolvable question and
its candidate disposition to the operator; the operator decides; `ri-file`
executes the drain. This keeps the skill from silently promoting or discarding
things the operator would have judged differently.

## Consequences

- `ri-file` gains an open-question-resolution path (built in s03): surface the
  question, escalate the disposition, then drain — write the area-tagged decision,
  move to backlog/active, or delete the line.
- Durable resolutions land as decision records under the area-tag convention
  (`sdlc-store-lifecycle` / `e02-s02`), so they are greppable by the code they
  touch.
- The operator is in the loop on every resolution's disposition; the skill never
  decides durability on its own.
- Unblocks planning of s03.

Implemented by story `e02-s03` (open-questions queue) under epic
`e02-sdlc-lifecycle-hygiene`.
