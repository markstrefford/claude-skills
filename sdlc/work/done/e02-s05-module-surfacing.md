---
id: e02-s05-module-surfacing
kind: story
project: claude-skills
status: done
autonomy: attended
parent: e02-sdlc-lifecycle-hygiene
sources: [work/active/e02-sdlc-lifecycle-hygiene.md, docs/decisions/sdlc-store-lifecycle.md]
created: 2026-07-08
updated: 2026-07-08
---

# Surface open questions and decisions by code module when work starts on it

## Executive summary

The earlier stories made every open question and decision carry a code-module tag.
This story cashes that in: when work starts on a piece of code, the questions and
decisions tagged to that module surface automatically, in context — so the
scoring question raised months ago is answered while you're already thinking about
scoring, not rediscovered cold. It is the reason the whole tagging effort exists,
and the last story in the epic. Planning is the natural moment: ri-plan already
reads the code a story touches, so it knows the modules and can pull the matching
tagged items before writing tasks; ri-execute does a lighter pull when a chain
starts. It changes what the skills show you at the right moment; it changes nothing
a product does.

## Outcome

- When ri-plan plans a story, it identifies the code modules the story touches
  (from the code it already reads) and surfaces the open questions and decisions
  tagged to those modules — so relevant prior context is answered or applied in
  the plan rather than lost.
- When ri-execute starts a task chain, it surfaces the same module-tagged questions
  and decisions for the modules in play, as a lighter heads-up.
- Surfacing is by the module tag established in s02/s03 — no new tagging, just
  reading what is already there.

## Out of scope / carry-forward

- No change to how questions or decisions are tagged (that is s02/s03, done). This
  story only reads the tags.
- No automatic answering or applying — surfacing puts the relevant items in front
  of the operator at the right moment; deciding what to do with them stays the
  operator's call (and resolution stays ri-file's path).

## Standing gate

Lands in ri-plan (primary surfacing, since it reads the code and knows the modules)
and ri-execute (lighter surfacing at chain start, and only when a plan pass didn't
just surface the same context). Both match **only inside the `area:` tag/field** of
`/sdlc/OPEN.md` (inline comma-list) and `/sdlc/docs/decisions/` (YAML list) — never a
bare body grep, or a decision that merely mentions a module would false-match. No
new store, no new tag. Tier-3 review applies.

The load-bearing assumption: the surfacer must derive the module token in the same
vocabulary the taggers used, and there is no registry to reconcile them. The story
manages this rather than deferring it — the match is scoped to the field, and a
positive-match smoke check (planning ri-plan-tagged work must surface its decisions)
distinguishes a broken matcher from a genuinely empty result, so the capstone can't
ship as a silent no-op.

## Acceptance

- ri-plan, after reading the code a story touches, surfaces the open questions and
  decisions whose module tag matches a module the story touches — before it writes
  the task sequence.
- ri-execute surfaces the same for the modules a task chain touches, at chain start.
- Surfacing reads the existing module tags; it introduces no new tagging and no new
  store.
- Both edited skill copies are in parity.

## Status

Both tasks done (t1–t2 in `/work/done/`). Acceptance verified: ri-plan surfaces
module-tagged questions and decisions after reading the code (agent-facing before
task generation, and in the operator presentation); ri-execute surfaces the same at
a cold chain start, non-blocking, without repeating what a plan pass just showed.
Matching is scoped to the `area:` tag/field across both formats; a positive-match
check on ri-plan-tagged decisions guards against a silent no-op. Skill copies in
parity. Merge-ready — completes the epic.
