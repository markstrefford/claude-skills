---
id: e02-s05-t1-plan-surfacing
kind: task
project: claude-skills
status: done
autonomy: attended
parent: e02-s05-module-surfacing
created: 2026-07-08
updated: 2026-07-08
---

## Outcome

ri-plan surfaces the open questions and decisions tagged to the code modules a
story touches, before it writes the task sequence.

## Decisions in plain terms

This is the payoff of the module-tag convention set in s02/s03 — surface by
module at the moment work starts. The one choice: **planning is the primary
surfacing point**, because ri-plan already reads the code (step 2) and therefore
already knows the modules — no separate discovery needed.

## Acceptance

- After ri-plan reads the code a story touches, it derives the set of code modules
  involved, expressed in the **same module vocabulary the tags use** (skill/agent
  names here; the stack-relative code unit generally). The step notes plainly that
  this vocabulary is a convention with no registry, so the derived token must match
  the tag token — a mismatch silently surfaces nothing.
- The match is **scoped to the tag/field**, not a bare prose grep: in `/sdlc/OPEN.md`
  match only inside the `[area: …]` tag (inline comma-list); in
  `/sdlc/docs/decisions/` match only the `area:` frontmatter (YAML list). A decision
  that merely mentions a module in its body must NOT match.
- Surfaced context lands at **both** points it is needed: (1) agent-facing, before
  task generation, so the plan is informed by it; (2) in the operator-facing plan
  presentation, so the operator sees the prior context alongside the tasks.
- Surfacing reads existing tags only; it adds no tagging and no new store.
- A module with no matching entries surfaces nothing (no noise).
- Canonical and installed ri-plan copies are identical.

## Test specification

Instruction-file change; verify by coherence inspection plus one concrete match:

- ri-plan's flow gains a surfacing step after the code-reading step and before task
  generation, and the surfaced context also appears in the operator presentation.
- The step scopes matching to the `area:` tag/field in both stores (not prose), and
  names both physical formats (inline `[area: …]`, YAML `area: […]`).
- **Positive-match smoke check (guards against a silent no-op):** planning a story
  that touches the `ri-plan` skill must surface the decisions currently tagged
  `area: […ri-plan…]` (e.g. `sdlc-store-lifecycle`, `open-question-resolution`,
  `plan-mode-as-pipeline-frontend`). If that yields nothing, the match is broken,
  not empty. Confirm the step would surface them.
- Surfacing is presentation, not auto-resolution.
- The step degrades quietly when there are genuinely no matches — but the smoke
  check above distinguishes quiet-because-empty from quiet-because-broken.

## Implementation notes

Edit `ri-skills/skills/ri-plan/SKILL.md` (canonical), then cp to install (parity):

- Add a "Surface prior context by module" step immediately after step 2 ("Read the
  code") and before task generation (step 4), so the matches inform task-writing;
  and include the same matches in the operator presentation (step 7) so the operator
  sees them alongside the plan. Name both audiences explicitly.
- The step: (1) collects the code modules the story touches (from the code read),
  expressed in the same token space the tags use — note this vocabulary is a
  convention with no registry, so the derived token must equal the tag token or the
  match silently misses; (2) matches **only inside the `area:` tag/field** — in
  `/sdlc/OPEN.md` inside the inline `[area: …]` tag, in `/sdlc/docs/decisions/` in the
  YAML `area:` frontmatter — never a bare body grep; (3) surfaces the matches as
  "prior context for this code".
- Keep it operator-grammar in the presentation. Surfaced items are read-only here —
  resolving a surfaced question is still ri-file's path; applying a surfaced decision
  is the operator's call.
- No matches → surface nothing; do not manufacture a section. But verify against the
  positive-match smoke check in the test spec so a broken matcher isn't mistaken for
  an empty result.
- Depends on the module tags existing (s02/s03, done).

## Status

active
