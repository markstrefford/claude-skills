---
id: e04-s01-t03-stand-up-the-new-install
kind: task
project: claude-skills
parent: e04-s01-install-without-copy
status: active
autonomy: attended
created: 2026-08-09
updated: 2026-08-09
---

# Task — Stand up the new install alongside the old

## Outcome

The skills and agents load from this repo, both sets, proven working — with
the old install still in place.

## Acceptance

A session loads all fourteen skills and all six agents through the new
mechanism. Every workflow verb still answers to the name the operator types,
and every reviewer still answers to the name the skills call it by. Editing
a file in the repo changes what Claude runs. The old install is untouched.

## Decisions in plain terms

- **Nothing is removed in this task.** Standing the new one up next to the
  old is what makes the removal safe, and what makes backing out free.

## Test specification

Verification, not unit tests. Requires a session restart to observe, so
expect operator confirmation to close.

- All eight workflow skills load; all six research skills load.
- All six agents load, including the four sourced from outside the repo.
- **Every workflow verb resolves by the name the operator types.** Check
  from a repo other than this one — a name that only resolves here is not
  installed, it is coincidence.
- **Both reviewers resolve by bare name** when a skill invokes them. This
  is the silent one: if it breaks, the review gate stops firing and the
  symptom is an absence, not an error.
- An edit made in the repo is reflected in what Claude runs, on whatever
  terms the settled mechanism gives — immediately, or at next session
  start.
- Nothing fires twice. If the mechanism declares hooks of its own and the
  existing registration is still in place, the navigation guard would
  prompt twice per command.

Failure modes that must be caught:

- The four external agents no longer loading.
- The six research skills no longer loading, because only the documented
  source directory was covered.
- A verb or an agent that loads but no longer resolves under the name
  everything calls it by.

## Implementation notes

Two source directories feed one destination: `ri-skills/skills/` (eight
workflow verbs) and `orion/` (six research skills) both land in the skills
folder. `ri-skills/agents/` supplies two of the six agents; the other four
are external.

Depends on t01 for the mechanism and the layout call, and on t02 for the
backup and the reconciliation record. Do not start before both are closed.

## Status

active
