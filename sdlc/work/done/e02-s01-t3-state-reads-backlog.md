---
id: e02-s01-t3-state-reads-backlog
kind: task
project: claude-skills
status: active
autonomy: attended
parent: e02-s01-backlog-stage
created: 2026-07-08
updated: 2026-07-08
---

## Outcome

The cursor reads the backlog store and can name a backlog item as the next thing
to pick up when nothing is in flight.

## Acceptance

- ri-state lists `sdlc/work/backlog/` among the stores it reads when deriving the
  cursor.
- The "Next" derivation may surface a backlog item as the candidate to pick up
  when the active queue is empty, instead of jumping straight to "operator's
  call".
- STATE stays operator-grammar and within its length discipline; backlog
  visibility is added without turning STATE into a second backlog listing.
- The distributable skill (`ri-skills/skills/ri-state/SKILL.md`) and the installed
  copy (`~/.claude/skills/ri-state/SKILL.md`) carry identical changes.

## Test specification

Instruction-file change; verification by coherence inspection:

- "backlog" appears in ri-state's "Read the repo first" step and in its
  "Next" derivation rule.
- The anti-drift and derived-not-invented principles are preserved — backlog is
  read from the filesystem like active and done, not invented.
- STATE's shape rules (operator-grammar, one artefact per line) are not violated
  by the addition.
- `diff` between distributable and installed copies shows no divergence.

## Implementation notes

Edit `ri-skills/skills/ri-state/SKILL.md` (canonical), then sync to
`~/.claude/skills/ri-state/SKILL.md`:

- In "Read the repo first", add a step to list `/sdlc/work/backlog/` and note its
  items, parallel to the existing active/done reads.
- In "Derivation rules" → "Next", extend the rule: when no task or story is
  queued in active, Next may point at a backlog item as the operator's likely
  pick, before falling back to "operator's call".
- Keep the change light. The neglect audit over the backlog (staleness flags) is
  s04's job, not this task — do not add audit logic here.
- Note for the record, do not fix here: the dogfooded `STATE.md` uses an expanded
  section format while the skill spec describes a compact under-30-line format.
  That drift predates this story and is out of scope; flag it if it obstructs the
  edit.

## Status

active
