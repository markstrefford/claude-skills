---
id: e04-s01-t05-cut-over-the-hook
kind: task
project: claude-skills
parent: e04-s01-install-without-copy
status: active
autonomy: attended
created: 2026-08-09
updated: 2026-08-09
---

# Task — Cut over the navigation hook

## Outcome

The navigation hook runs from this repo too, so it stops being the one
surface that still drifts silently.

## Acceptance

The hook still behaves as documented — quiet when Claude moves around
inside the current repo, asking when it leaves — it fires once and not
twice, and editing it in the repo changes what runs.

## Decisions in plain terms

- **The hook gets the same treatment as the skills.** It is copied by the
  same instructions and carries the same defect; leaving it out would mean
  fixing two thirds of a problem and documenting the fix as complete.

## Test specification

Verification, not unit tests.

- The hook fires: moving around inside the current repo is silent, moving
  outside it prompts.
- **It fires once.** If the settled mechanism declares the hook and the
  existing registration is still in place, every command prompts twice.
  Exactly one route to the hook survives this task.
- An edit to the hook in the repo changes what runs, on the same terms the
  settled mechanism gives the skills.
- The registration resolves after the cutover.
- Removing the install and redoing it from the documented instructions
  produces a working hook.

Failure modes that must be caught:

- A registration pointing at a path that no longer exists. This fails
  quietly — the guard simply stops guarding, and the only symptom is Claude
  leaving the repo without asking.
- Two registrations both live, so the guard double-prompts.

## Implementation notes

The hook is `ri-skills/hooks/cd-repo-guard.sh`, installed to the hooks
folder by README step 4 and registered separately in the user settings file
as a pre-tool command on every shell call, pointing at a home-relative
path.

The registration is a second surface: whatever the mechanism does to the
file, the registered path has to keep resolving, and there must be exactly
one route.

`ri-skills/hooks/README.md` carries its own copy of the install and
registration instructions, and its own verification procedure. It goes
stale at cutover the same way the root instructions do — t06 owns updating
both.

Depends on t01 for the mechanism.

## Status

active
