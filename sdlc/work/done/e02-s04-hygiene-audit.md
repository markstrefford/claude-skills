---
id: e02-s04-hygiene-audit
kind: story
project: claude-skills
status: done
autonomy: attended
parent: e02-sdlc-lifecycle-hygiene
sources: [work/active/e02-sdlc-lifecycle-hygiene.md, docs/decisions/hygiene-gate-escalation.md, docs/decisions/sdlc-store-lifecycle.md]
created: 2026-07-08
updated: 2026-07-08
---

# Add a hygiene audit at state refresh that flags neglect and escalates at thresholds

## Executive summary

The earlier stories gave each store a clean lifecycle; this one adds the forcing
function that keeps them clean without the operator having to remember to look.
When state is refreshed, ri-state runs a hygiene audit: it flags entries that have
gone stale, questions that look already-decided, and work that has stalled — and
once neglect crosses a threshold it escalates to a review the operator must clear.
Crucially it only *blocks* when the operator runs a state refresh directly; when
another skill refreshes state at the end of its own chain, the audit reports but
never blocks, so authorised autonomous work is never silently halted. This is the
control that stops the mess coming back; it is also the biggest behaviour change in
the epic, turning ri-state from a silent derivation into a gate. It changes how
state refresh behaves; it changes nothing a product does.

## Outcome

- A hygiene audit runs at every state refresh and flags neglect: open questions
  stale past a threshold or reading as already-decided, and active work that has
  stalled (no recent commit activity), plus a stale-backlog check.
- The audit escalates: it always reports its flags, and once they cross a
  threshold it becomes a review the operator must clear before a direct refresh
  passes.
- The gate is source-aware: it blocks only when the operator runs the refresh
  directly; when a skill refreshes state at chain end it reports and stays out of
  the way, so an authorised auto-run is never turned into a forced review.

## Out of scope / carry-forward

- Surfacing questions and decisions by code module when work starts is s05; this
  story is the neglect audit, not the contextual surfacing.
- Auto-fixing what the audit flags. The audit surfaces neglect and (on a direct
  refresh) insists it be addressed; the operator or a follow-on resolution does the
  fixing. The audit never edits OPEN or moves work itself.

## Standing gate

Lands mostly in ri-state, which gains two genuinely new capabilities: reading
commit history to judge staleness (today it derives only from artefact `updated:`
fields), and behaving differently by how it was invoked. The three skills that
call ri-state at chain end (ri-compile, ri-plan, ri-execute) must invoke it in
report-only mode so the gate never blocks mid-chain. Thresholds start as documented
defaults in the skill, tunable later. Tier-3 review applies — this is the change
most able to obstruct if it bites at the wrong moment, so the source-aware boundary
is load-bearing and must be exact.

## Acceptance

- A direct `/ri-state` run reports the hygiene flags and, once they cross the
  threshold, does not pass silently — it requires the operator to acknowledge or
  clear them.
- A ri-state run invoked by another skill at chain end reports the same flags but
  never blocks the chain.
- The audit flags: stale open questions, already-decided-looking questions, stalled
  active work (via commit history), and stale backlog items — each derived from the
  filesystem and git, not invented.
- Thresholds are stated as defaults in the skill and are easy to change.
- STATE stays within its length discipline; hygiene detail is reported to the
  operator, not bloated into the cursor file.

## Status

Both tasks done (t1–t2 in `/work/done/`). Operator checkpoint cleared: thresholds
agreed (active stalled flag > 2d / block > 5d; open question 30d/90d; backlog 60d
advisory), git-staleness branch-relative limitation accepted, acknowledgement-gate
semantics confirmed. Acceptance verified: the audit flags stale/already-decided/
stalled/stale-backlog from the filesystem and git; a direct `/ri-state` reports and
holds an acknowledgement gate once deterministic flags cross the threshold; a
report-only chain-end run never blocks; ri-state's identity sections reconciled; all
edited skill copies in parity. Merge-ready — story-close and merge are the
operator's call.
