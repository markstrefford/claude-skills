---
id: e02-s01-t4-promote-backlog-to-active
kind: task
project: claude-skills
status: done
autonomy: attended
parent: e02-s01-backlog-stage
created: 2026-07-08
updated: 2026-07-08
---

## Outcome

Starting work on a backlog item moves it into active, so a backlog item is
reachable by the planning and execution flow rather than stranded.

## Decisions in plain terms

The decision that every store has a defined exit is recorded in
`docs/decisions/sdlc-store-lifecycle.md` — "backlog exits to active". This task
implements that exit; it makes no new decision. The one choice it embodies:
**promotion happens when work starts, owned by the planning step** — because
planning a story is the moment work on it begins, so that is the natural and
single place to move the file, rather than scattering the move across skills.

## Acceptance

- A plainly stated rule exists: starting work on a backlog item moves its file
  from `sdlc/work/backlog/` to `sdlc/work/active/` before any planning or
  execution proceeds.
- The planning skill owns the move: when asked to plan a story that lives in the
  backlog, it promotes the story to active as its first step, then proceeds.
- The execution skill does not silently operate on a backlog item — if handed one
  directly, it promotes it (or defers to planning) rather than advancing work that
  still lives in the backlog.
- With t2 (compile routes in) and t3 (cursor surfaces it), the backlog now has a
  complete lifecycle: entrance, visibility, and a defined exit.
- The change is present and identical (on the promotion edit specifically) in both
  the distributable and installed copies of the affected skills — verified per the
  same targeted-diff discipline as t2, not by whole-file equality.

## Test specification

Instruction-file change; verification by coherence inspection:

- ri-plan's "Read the story and its surroundings" step names the backlog and
  states the promotion move; ri-plan no longer assumes the story is already in
  active.
- The promotion rule is consistent with ri-plan's existing hard rule that a story
  is planned once — promotion precedes planning, does not repeat it.
- ri-execute acknowledges the backlog: it advances only items in active, and a
  backlog item is promoted first.
- No skill is left implying a backlog item can be planned or executed in place.
- Targeted diff/grep confirms the promotion wording is identical between
  distributable and installed copies; the unrelated epic-numbering divergence in
  ri-compile is not touched.

## Implementation notes

Edit the canonical copies under `ri-skills/skills/…`, then sync each targeted
change to the matching `~/.claude/skills/…` copy (same caution as t2 — targeted
edits, never wholesale file copy):

- `ri-plan/SKILL.md`: in step 1 ("Read the story and its surroundings"), add: if
  the story lives in `/sdlc/work/backlog/`, move it to `/sdlc/work/active/` first
  (updating its `updated:` date), then continue. This is the backlog→active
  promotion — a story is only promoted when planning starts. Adjust the nearby
  wording that assumes the story is already in active.
- `ri-execute/SKILL.md`: add a short rule that execute advances items in active
  only; if pointed at a backlog item, promote it to active first (or hand back to
  planning if it has no tasks yet). Keep it minimal — planning is the primary
  promotion owner; this is the safety net.
- Keep the move mechanical and operator-grammar in any operator-facing text: "a
  backlog item becomes active when you start it."
- Do not add neglect/staleness handling — that is s04.

## Status

active
