---
id: e01-sdlc-autonomy-additions
kind: epic
project: claude-skills
status: active
autonomy: attended
sources: [raw/pr1-jiri-autonomy-additions.md]
created: 2026-06-06
updated: 2026-06-06
---

# Absorb the autonomy and hygiene additions into ri-skills

## Executive summary

An external contributor (Jiri, PR #1) proposed a set of additions to the old
single-file SDLC: a real model for when the agent acts on its own versus checks
in, a way to roll continuously through a story without stopping after every
task, and a handful of operational-hygiene habits. The single-file SDLC was
retired at v2.0.0, so the changes can't merge as written — but the ideas are
strong and worth folding into the ri-skills system. This epic absorbs them,
tiering the heavier items so they only switch on where they earn their keep.
It changes how the skills behave; it does not change what the skills are for.

## Outcome

- A shared decision gate the action skills consult before acting on their own.
- Continuous execution through a story, with a deliberate pause at the story's end.
- The operational-hygiene habits, switched on only for the most serious tier of work.
- Publication and README handling folded into the filing step.
- Jiri's contribution credited; PR #1 closed once the work lands.

## Out of scope / carry-forward

- No change to the verbs themselves or the tier model's definition.
- No new skills — this reshapes the behaviour of existing ones.
- How the gate is shared across the acting skills, and how each tier maps, are
  decided when each story is planned. The sharing question is open and tracked
  (see OPEN.md) — the skills are self-contained today, so there is no shared
  place for common behaviour to live yet; that call comes before s01 builds.

## Standing gate

The gate (s01) is the highest-risk story, but not because a wrong default is
hard to undo — a default is one line to change. The risk is that the gate has
no shared home in today's skills, so however it's expressed gets *copied into
every acting skill and every downstream tier-3 repo* — and that's expensive to
unwind once spread. The gate must also reconcile with the autonomy behaviour
the execution skill already has, or that skill ends up with two decision
models that can disagree. s01 plans and reviews first, ahead of the rest.

## Roadmap

- s01 — give the skills that act (execute, do, file) a shared "act or check in?" decision gate, including never touching a remote unattended; reconcile it with the autonomy behaviour execution already has
- s02 — let execution roll from one task to the next within a story, pausing at the story boundary (depends on s01's default being settled)
- s03 — add the tier-3-only operational-hygiene checks, after confirming which of them have a home in the current system
- s04 — fold README and publication *workflow* into the filing step (the remote-push safety rule itself lives in s01, with the gate)

## Acceptance

- Each story lands as its own coherent change with its own plan and review.
- The acting skills consult one gate, expressed once, not several drifting copies.
- The heavier hygiene habits are visibly gated to the top tier, not applied everywhere.
- The contributor's ideas are recognisably present in the shipped skills.

## Epic-close actions

- Credit Jiri's contribution and close PR #1 once the stories have landed.

## Status

**Parked in backlog (2026-07-09).** Shaped and reviewed but never planned; set
aside as unrelated to the governance/lifecycle line of work. Promote back to
`/work/active/` (via ri-plan) if picked up. PR #1 stays open until then. The three
OPEN.md questions tagged `e01` remain its gating items.

Compiled 2026-06-06 from PR #1. Tier-3 repo — senior-staff-engineer reviewed at
compile; load-bearing findings applied (gate has no shared home, gate points at
the acting skills not planning, push-safety belongs with the gate, s01→s02
dependency, ungrounded hygiene items flagged for plan). Stories are roadmap
one-liners; each gets planned and grounded against the actual skills when it
goes active. Three deferred calls are in OPEN.md. PR #1 stays open until the
work lands.
