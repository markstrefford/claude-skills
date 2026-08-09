---
id: e04-s01-t01-settle-the-mechanism
kind: task
project: claude-skills
parent: e04-s01-install-without-copy
status: done
autonomy: attended
created: 2026-08-09
updated: 2026-08-09
---

# Task — Settle the mechanism against the real install

## Outcome

Establish which install mechanism actually works here, and record the call
with its consequences, before anything is cut over.

## Acceptance

The operator can read one short record that says which mechanism was
chosen, what was tested to prove it works, what it costs, what happens when
the clone moves, and where the research skills end up living. No cutover
work starts until that record exists.

## Decisions in plain terms

- **The mechanism is chosen against evidence, not preference.** Two
  candidates reach the outcome and they fail differently; picking one
  without testing is how the current install got here.
- **Whether an edit takes effect in a running session or only at next start
  is the deciding property.** It is the difference between editing the
  workflow while using it and having to restart to see a change, and it is
  the trade the story's staging problem turns on.
- **Where the research skills live is settled here, not later.** It is a
  property of the mechanism — whatever installs the workflow verbs has to
  install them too — so deciding it downstream would mean the cutover
  guessing and the documentation rubber-stamping.

## Test specification

Verification, not unit tests — this task produces evidence and a decision,
no shipped code.

Candidates:

1. **Per-item symlink** — each skill, agent and hook linked individually
   into the existing folders.
2. **Platform plugin** — this repo registered as a local marketplace and
   installed through the plugin mechanism.

A whole-directory symlink is eliminated on paper, not tested: the
destination folders each carry content from more than one source, so
redirecting a folder wholesale cannot preserve them. Record the
elimination and its ground.

For each candidate that loads, establish:

- Does Claude discover and load a skill through it at session start?
- Does a sub-agent load through it?
- Does an edit to a file take effect in the running session, or only at
  next start?
- **Do the slash names still resolve** — all eight workflow verbs, invoked
  as the operator invokes them today?
- **Do the agents still resolve by bare name?** Every skill invokes its
  reviewers by name alone. If the mechanism namespaces them, those
  invocations stop resolving and the tier-3 review gate silently stops
  firing, here and in every other repo.
- Does the mechanism declare hooks of its own, such that a hook already
  registered in settings would fire twice?
- Does a branch switch or checkout in the repo change what a running
  session executes?
- What happens when the clone is moved or removed?
- Does it work for a fresh clone at an arbitrary path, with no
  machine-specific setup?
- Can it carry both skill sources and leave content from other sources
  untouched?

Probe with throwaway names, never by replacing a live skill, agent or hook.
The current install must remain intact and working throughout — nothing
here removes or overwrites anything under the read-from folders.

## Implementation notes

The install today is `cp -r ri-skills/skills/*` and `cp -r
ri-skills/agents/*` (README step 2), plus the hook copy and its
registration (step 4). The two skill sources in this repo are
`ri-skills/skills/` (eight workflow verbs) and `orion/` (six research
skills); the README documents only the first, and the second's install
exists nowhere.

The plugin mechanism is live on this machine, but only with a single
GitHub-sourced marketplace registered — there is no local-path marketplace
here, and the recorded metadata is inconsistent about pinning (one of four
installed plugins carries a commit reference). Whether a local marketplace
serves from a working tree or from committed state is therefore **unknown
and is exactly what this task must test.** Do not assume it behaves like
the GitHub-sourced case; that assumption would eliminate the only candidate
that might preserve a staging step, which is the trade the story's standing
gate asks to be settled.

Verification of "loads at session start" cannot be observed from inside a
running session. Expect to need a separate session, or the operator's
confirmation, to close this task.

Record the outcome as a decision artefact — this choice outlives the task,
and later stories need to know why the working tree is or is not live.

## Status

done — mechanism settled and recorded in install-by-symlink.md
