---
id: e02-s03-open-questions-queue
kind: story
project: claude-skills
status: active
autonomy: attended
parent: e02-sdlc-lifecycle-hygiene
sources: [work/active/e02-sdlc-lifecycle-hygiene.md, docs/decisions/open-question-resolution.md]
created: 2026-07-08
updated: 2026-07-08
---

# Make the open-questions queue hold only live questions, module-tagged and drained on resolution

## Executive summary

The open-questions queue is the store that rots fastest: it is append-only today,
so answered questions and decisions-in-disguise pile up until, months later, no
one can tell what is still live. This story gives the queue the two things it
lacks — a defined exit and a way to find an entry by the code it concerns. It adds
the resolution path (owned by ri-file, escalating the disposition to the operator,
per the resolution decision), makes every raised question carry a module-area tag
alongside its work tag, and rewrites the queue's own convention from "append-only"
to "questions in, resolved items out". This is the store the whole epic was
provoked by; getting its lifecycle right is the point. It changes how the skills
manage the queue; it changes nothing a product does.

## Outcome

- A resolved question leaves the queue in the same step its answer is recorded:
  durable answers become area-tagged decisions, answers that become work become
  backlog or active items, trivial closes just delete the line — with the operator
  deciding which, and ri-file doing the bookkeeping.
- Every question raised carries a module-area tag (the code it touches) alongside
  its existing work tag, so it can later be surfaced when work starts on that code.
- The queue's stated convention is "live questions only" — added by the acting
  skills, removed on resolution by ri-file — not "append-only".

## Out of scope / carry-forward

- Auditing the queue for neglect (flagging stale or already-decided entries) is the
  hygiene-gate story (s04). This story defines the clean lifecycle; s04 polices it.
- Surfacing questions by module when work starts is s05. This story provides the
  module tag that makes surfacing possible.

## Standing gate

Touches ri-file (gains the resolution path), the three skills that raise questions
(ri-compile, ri-plan, ri-execute, which add the module tag), and ri-state — which
never writes OPEN but independently *documents* both the entry format and the
resolution story, so it must be updated in step or it becomes the stale fourth copy
this epic exists to prevent. Plus the queue file's own header. All skill copies are
currently in parity, so each edit lands in the canonical copy and is synced to the
install. No product code. Tier-3
review applies. The module-area tag must use the same definition s02 established
for decisions, so the queue and the decisions record line up by module.

## Acceptance

- ri-file has a defined open-question-resolution path: surface the question,
  escalate the disposition to the operator, then drain to a decision, to
  backlog/active, or by deletion — the line always leaves the queue on resolution.
- The three raising skills add a module-area tag to every question they append,
  using the s02 module definition; ri-state's documented copy of the format and
  resolution story is updated to match, so no skill carries a stale version.
- The queue file documents the live-questions-only convention and the two-tag
  shape; it no longer describes itself as append-only.
- Existing queue entries carry module-area tags (dogfooded).
- All edited skill copies are in parity (canonical == install).

## Status

All three tasks done (t1–t3 in `/work/done/`). Acceptance verified: ri-file has a
resolution path that escalates the disposition and drains the entry; all four
skills that document the OPEN format carry the two-tag shape (work + module);
OPEN.md is now live-questions-only with ri-file named as remover; existing entries
retrofitted with module tags. All edited skill copies in parity. Merge-ready —
story-close and merge are the operator's call.
