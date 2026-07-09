---
id: e02-s02-decisions-record
kind: story
project: claude-skills
status: active
autonomy: attended
parent: e02-sdlc-lifecycle-hygiene
sources: [work/active/e02-sdlc-lifecycle-hygiene.md, docs/decisions/sdlc-store-lifecycle.md]
created: 2026-07-08
updated: 2026-07-08
---

# Tighten the decisions record so it holds only durable calls, area-tagged

## Executive summary

The decisions record already exists — ri-file files ADRs to the docs shelf with
dates and a filler-refusal bar. So this story is a tightening, not a build. It
adds one missing field, an area tag, so a decision can be found by the part of
the system it belongs to; and it sharpens the bar for what earns a record at all,
so the record stays thin as the later stories start draining resolved questions
into it. Getting this right now is what stops the decisions shelf becoming the
next graveyard once s03 wires the questions queue to drain here. It changes the
filing convention; it changes nothing a product does.

## Outcome

- Every decision record carries an area tag naming the code module(s) it touches
  (stack-relative: Python module, JS/React module or component, skill/agent here),
  so decisions are greppable by the code they concern (the hook the later
  surfacing story depends on).
- The bar for what becomes a decision record is explicit: only durable,
  consequential calls are filed; trivial closes die unrecorded. This keeps the
  record thin by design rather than by volume.
- The decision records already written this session carry the new tag, so the
  convention is dogfooded rather than just described.

## Out of scope / carry-forward

- Draining the open-questions queue into the decisions record is the questions
  story (s03). This story makes the record ready to receive durable, tagged
  decisions; wiring the queue's exit to it comes then.
- Surfacing decisions by area when work starts is the surfacing story (s05). This
  story provides the tag that makes surfacing possible; it doesn't build the
  surfacing itself.
- Adding the area axis to the open-questions queue is s03. Until then the queue
  keeps only its epic-id work tags; s02 does not retro-tag OPEN.
- Whether decision records keep descriptive slugs (this story's call) or move to
  numeric ids is settled here for decisions; it doesn't touch how work items
  (tasks/stories/epics) are numbered.

## Standing gate

The change lives in the filing skill and its distributable copy, so every repo
gains the area-tag convention. No product code is touched. Reviewed at tier-3
rigor because it governs how every repo records decisions.

The area tag is anchored to the **code**, at module granularity, and it is
stack-relative — it names the natural top-level code unit for whatever stack the
change lives in:

- Python → the module / package
- JavaScript / React → the top-level module or component
- skills / agents (this repo and agent repos) → the skill or agent

It names the unit(s) a decision touches, listed when the change spans more than
one, finer than a module (a single file) only when it genuinely is one file. It
is deliberately *not* an epic-id: epics stack over the same code (several epics
can all touch the same module in sequence), so an epic tag says nothing about
which code a decision concerns. Module granularity is the floor because a single
change often spans several files but rarely the whole system.

This is a new axis distinct from the epic-id work tags the open-questions queue
uses today (which mark which work a question gates and die when that work closes).
For the queue and the record to line up by module, the queue must gain the same
module-area axis — that is s03's work. This story establishes the axis on the
decisions side and defines it; it does not claim the two stores already share tags
(they do not).

## Acceptance

- The filing convention requires an area tag on every decision record, with a
  one-line explanation of what it is for.
- The durability bar is stated plainly: what earns a record versus what dies
  unrecorded, including closed questions.
- The filing skill's documented id convention for decisions matches actual
  practice (descriptive slugs), rather than a numeric prefix the repo's own
  records don't use.
- The two decision records from this session carry area tags.
- The distributable copy of the skill carries the same changes, so a fresh
  install behaves identically.

## Status

Both tasks done (t1–t2 in `/work/done/`). Acceptance verified: ri-file now
requires an `area` tag defined as a stack-relative code-module reference, decision
ids are descriptive slugs (doc corrected to match practice), the durability bar is
folded into the existing trivial-ADR rule, and this session's two decision records
carry module area tags. ri-file canonical == install. Merge-ready — story-close
and merge are the operator's call.
