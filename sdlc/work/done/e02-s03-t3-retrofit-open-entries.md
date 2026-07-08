---
id: e02-s03-t3-retrofit-open-entries
kind: task
project: claude-skills
status: active
autonomy: attended
parent: e02-s03-open-questions-queue
created: 2026-07-08
updated: 2026-07-08
---

## Outcome

The existing open-questions entries carry module-area tags, so the queue is
consistent with the new convention rather than leaving old entries half-formed.

## Acceptance

- Each existing entry in `sdlc/OPEN.md` gains a module-area tag naming the code it
  concerns, alongside its existing work tag.
- The tags use the s02 module definition (the skill/module the question touches).
- No entry's wording or work tag is otherwise changed; this is a tag addition.

## Test specification

Document change; verify by inspection:

- Every line in OPEN.md's body carries both a work tag and a module-area tag.
- The module tags name real skills/modules (the e01 entries concern the autonomy
  gate work — tag them to the skills that work touches, e.g. the acting skills
  and/or the user-level CLAUDE.md template, per the s02 module definition).
- `git diff` shows only tag additions, no rewording.

## Implementation notes

- The three current entries are e01 autonomy-gate questions. Tag each with the
  code module(s) the question bears on. Where a question is about where shared
  behaviour lives (skills vs the CLAUDE.md template), the module is the affected
  skills and/or the template file — name them per the s02 definition.
- If a given entry's module is genuinely unclear from its text, tag it with the
  best-supported module and note the uncertainty for the operator rather than
  inventing a precise-looking but unfounded tag.
- Depends on t2 (the tag convention and format must exist first).

## Status

active
