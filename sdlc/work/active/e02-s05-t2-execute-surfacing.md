---
id: e02-s05-t2-execute-surfacing
kind: task
project: claude-skills
status: active
autonomy: attended
parent: e02-s05-module-surfacing
created: 2026-07-08
updated: 2026-07-08
---

## Outcome

ri-execute surfaces the module-tagged open questions and decisions for the modules
a task chain touches, as a lighter heads-up at chain start.

## Acceptance

- At the start of a task chain, ri-execute derives the modules the tasks touch and
  surfaces any matching open questions and decisions to the operator before running
  the chain — matching **scoped to the `area:` tag/field** (inline `[area: …]` in
  OPEN.md, YAML `area:` in decisions), same rule and vocabulary as t1, never a bare
  body grep.
- **No double-surfacing:** if ri-plan already surfaced this module context earlier in
  the same session (the plan→execute chain), ri-execute does not repeat it. It
  surfaces only when starting a chain cold, without a fresh plan pass — the
  decoupled case this task exists for.
- This is a heads-up, not a gate — it never blocks the chain; execution proceeds.
  (Distinct from the hygiene gate, which is ri-state's.)
- Surfacing reads existing tags only; no new tagging, no new store.
- No matches → surface nothing.
- Canonical and installed ri-execute copies are identical.

## Test specification

Instruction-file change; verify by coherence inspection:

- ri-execute gains a surfacing step at chain start that matches only inside the
  `area:` tag/field of OPEN.md and docs/decisions (both formats), by the modules in
  play — not a bare body grep.
- The step is explicitly non-blocking — it informs, it does not stop the chain.
- It does not repeat context ri-plan already surfaced in the same session; it fires
  on a cold chain start.
- Degrades quietly with no genuine matches; consistent with t1's scoped-match rule
  and module vocabulary (same positive-match behaviour on ri-plan-tagged decisions).

## Implementation notes

Edit `ri-skills/skills/ri-execute/SKILL.md` (canonical), then cp to install:

- Add a brief surfacing step at chain start: collect the modules the queued tasks
  touch (from their artefacts / the story), match **only inside the `area:`
  tag/field** in `/sdlc/OPEN.md` and `/sdlc/docs/decisions/` (both formats, per t1),
  and present matches as a heads-up before executing.
- Skip when redundant: if this same session already ran ri-plan and surfaced the
  module context for these modules, do not repeat it. The agent has the session
  context to know this — mirror the report-only-token reasoning (the same agent
  carries the chain). Surface only on a cold chain start without a fresh plan.
- Keep it light — ri-plan is the primary, richer surfacing point (it reads the
  code); this is the reminder for the decoupled case. Explicitly non-blocking.
- No matches → nothing surfaced.
- Depends on t1 (mirror its scoped-match rule and module vocabulary) and on the
  module tags existing (s02/s03).

## Status

active
