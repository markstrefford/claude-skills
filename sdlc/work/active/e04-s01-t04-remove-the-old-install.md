---
id: e04-s01-t04-remove-the-old-install
kind: task
project: claude-skills
parent: e04-s01-install-without-copy
status: active
autonomy: attended
created: 2026-08-09
updated: 2026-08-09
---

# Task — Remove the old install

## Outcome

The copies are gone, so there is one place to edit and nothing shadowing
it.

## Acceptance

No repo-authored copy remains in the read-from folders. Everything that
loaded before still loads. Content from other sources is untouched. The
operator can back this out from the backup in one step.

## Decisions in plain terms

- **This is the destructive step, and it is deliberately alone.** Separating
  it from standing the new install up means the removal can be reverted
  without unwinding anything else.

## Test specification

Verification, not unit tests. Requires a session restart to observe.

Before removing:

- The backup from t02 exists and has been proven to restore.
- The new install is confirmed working from t03.

After removing:

- All fourteen skills and all six agents still load.
- All verb and agent names still resolve, checked from a repo other than
  this one.
- No stale copy remains that shadows a repo version — an edit in the repo
  changes what runs, with no exceptions.
- The four external agents are still present and still load.

Failure mode that must be caught: a copy left in place that takes
precedence over the repo version, so edits appear to do nothing. That is
the original defect wearing a different hat, and it would be invisible
until someone changed a skill and wondered why.

## Implementation notes

Removal covers only what this repo installed. The four external agents stay
exactly where they are.

Depends on t03. If anything in t03's verification is unconfirmed, this task
does not start — the whole reason it is separate is that the previous state
is still there to fall back on.

## Status

active
