---
id: e04-s01-t06-document-install-and-uninstall
kind: task
project: claude-skills
parent: e04-s01-install-without-copy
status: active
autonomy: attended
created: 2026-08-09
updated: 2026-08-09
---

# Task — Document the install, and an uninstall

## Outcome

Someone who has only cloned the repo can install it, get everything, and
remove it again cleanly.

## Acceptance

Following the instructions from a fresh clone produces a working setup —
including the research skills, which the current instructions never
mention. Following the uninstall leaves nothing from this repo behind. Both
install documents agree.

## Decisions in plain terms

- **An uninstall is part of the install.** Without one there is no way to
  prove the install is clean, and no way for anyone else to back out of it.
- **Two install documents is one too many, but both get updated.** The hook
  has its own instructions alongside the main ones. Whether they merge is a
  judgement made here; what is not acceptable is one of them going stale.

## Test specification

Verification, not unit tests.

Exercised from a clone at a path other than the working one, so
machine-specific assumptions surface:

- The documented install produces all eight workflow skills, all six
  research skills, both repo agents, and the working hook.
- It does not disturb agents or skills already present from elsewhere.
- The documented uninstall removes everything the install added, and
  nothing else — content from other sources survives it.
- Install, uninstall, reinstall leaves the same working state as the first
  install, with no stale copies shadowing repo versions.
- The hook's own instructions and the main ones describe the same install.

Failure mode that must be caught: instructions that work only because the
clone happens to sit where the machine already expects it.

## Implementation notes

Current install is README steps 2 to 4: two copy commands for skills and
agents, an append into the user instructions file, and the hook copy plus
its registration. Step 2 says the distributable set lives under
`ri-skills/`, which is why the research skills have no route.

`ri-skills/hooks/README.md` repeats the hook install, registration and
verification. Both documents change here.

The step-3 append (standing behaviour into the user's instructions file)
and the tier config examples are copies by design — seed files the user
edits afterwards. They stay copies; say so, so the next reader doesn't
mistake them for the same defect.

The install section also carries two steps both numbered five. Fix while
rewriting.

Depends on t04 and t05 — the instructions describe what those tasks
actually built.

## Status

active
