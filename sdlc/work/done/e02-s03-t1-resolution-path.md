---
id: e02-s03-t1-resolution-path
kind: task
project: claude-skills
status: active
autonomy: attended
parent: e02-s03-open-questions-queue
created: 2026-07-08
updated: 2026-07-08
---

## Outcome

ri-file has a defined open-question-resolution path: it surfaces a resolvable
question, escalates the disposition to the operator, then drains the entry from the
queue.

## Decisions in plain terms

Implements `docs/decisions/open-question-resolution.md` — ri-file owns the drain
and escalates the disposition (durable / becomes-work / trivial) to the operator
rather than deciding alone. No new decision here.

## Acceptance

- ri-file gains a "Resolving an open question" flow: read the question, propose its
  disposition, escalate to the operator for the call, then execute the drain in the
  same step — durable → write an area-tagged decision record; becomes-work → hand
  off to ri-compile to shape and route the backlog/active item; trivial → delete the
  line only.
- In every case the OPEN.md line is removed as part of resolution, so a resolved
  question never lingers.
- The flow reuses ri-file's existing decision-writing (area tag, slug id, durability
  bar) for the durable case, and hands the becomes-work case to ri-compile rather
  than re-implementing backlog/active routing.
- An explicit ownership statement is added (there is no existing ri-file rule to
  reconcile — ri-file has no OPEN reference today): ri-file removes on resolution,
  ri-state never touches OPEN, the raising skills only append.
- ri-state's own resolution narrative is aligned to match — it currently says the
  operator "or a skill on their behalf" deletes the line and files an ADR; update it
  to name ri-file as the remover and point at the area-tagged decision path.
- Canonical and installed copies of both edited skills (ri-file, ri-state) are
  identical (`diff -q`).

## Test specification

Instruction-file change; verify by coherence inspection:

- ri-file has a resolution section covering all three dispositions, each ending in
  the OPEN line's removal.
- The escalate-to-operator step is explicit — ri-file proposes, the operator
  decides disposition.
- The ownership statement is present and consistent across ri-file and ri-state
  (ri-file removes; ri-state never touches; raisers append). ri-state's old
  "a skill on their behalf deletes the line / files an ADR" wording now names
  ri-file and the area-tagged decision path.
- The durable case points at ri-file's existing ADR generation, and the
  becomes-work case hands off to ri-compile — neither is re-implemented inline.

## Implementation notes

Edit `ri-skills/skills/ri-file/SKILL.md` (canonical), then cp to install (parity):

- Add a "Resolving an open question" subsection to ri-file's file flow. Trigger:
  operator asks to resolve a question, or a skill hands ri-file a resolvable one.
  Steps: (1) read the question and its tags; (2) propose the disposition — durable
  decision, becomes-work, or trivial; (3) escalate to the operator for the call;
  (4) drain: durable → generate the ADR (existing ADR path, area-tagged) and delete
  the OPEN line; becomes-work → hand off to ri-compile to shape/route the
  backlog-or-active item, then delete the line; trivial → delete the line only.
  Commit as part of the resolution.
- becomes-work seam: ri-file does NOT re-implement backlog/active routing (that is
  ri-compile's owned logic). It hands the question to ri-compile as source material
  and removes the OPEN line once the work item exists.
- State the ownership plainly in ri-file: ri-state never touches OPEN; the raising
  skills only append; ri-file is the one skill that removes, and only as
  resolution. This is an additive statement — ri-file has no OPEN rule to undo.
- Also edit `ri-state/SKILL.md`: its OPEN-handling narrative (the "they, or a skill
  on their behalf, delete the line and file the resolution as an ADR" wording, and
  the "curated by the skills that raise and resolve" line) must name ri-file as the
  remover and point at the area-tagged decision path — so ri-state and ri-file tell
  the same story. Do not give ri-state any removal behaviour; it still only reads.
- cp both edited canonical skills (ri-file, ri-state) to their installs.
- Keep operator-grammar in operator-facing parts; drain mechanics can be concrete.

## Status

active
