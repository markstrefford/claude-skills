---
id: e03-s02-t2-scanner-docs
kind: task
project: claude-skills
status: done
autonomy: attended
parent: e03-s02-scanners
created: 2026-07-09
updated: 2026-07-09
---

## Outcome

Declaring scanners is documented, with the run-scope rule, so operators can adopt it
and existing configs keep working unchanged.

## Acceptance

- The README governance-gate section states that a repo can declare scanners, how
  they run (secret always *within a firing gate*, regardless of footprint;
  dependency/code footprint-scoped), and their per-class disposition (secret →
  any match blocks; dependency/code → high/critical blocks, low/moderate advisory;
  a scanner that can't run blocks).
- The README config reference documents the optional `scanners:` declaration (tool,
  command, class) under `security-gate`, noting it is optional and additive.
- The tier-3 config example shows a scanner declaration consistent with the mechanism.
- Nothing implies scanners are required, or that omitting them changes gate behaviour.

## Test specification

Doc change; verify by inspection:

- README gate + config sections describe scanner declaration, run-scope, and
  disposition, agreeing with t1.
- The tier-3 example includes a scanner declaration with per-entry class.
- The docs and t1's mechanism agree (secret always; dependency/code footprint-scoped;
  block/advisory via the existing verdict).

## Implementation notes

- README "The story-close governance gate": add that declared scanners run at the
  gate — secret scanners always (within a firing gate, regardless of footprint),
  dependency/code scanners footprint-scoped like the security review — with per-class
  disposition (secret any-match blocks; dependency/code high/critical blocks, else
  advisory; a scanner that can't run blocks). Operator-grammar.
- README "Configure → `.ri/config.md`": document the optional `scanners:` block under
  `security-gate` (each entry: `command`, `class: dependency|code|secret`), optional
  and additive.
- `ri-skills/examples/config-tier-3.md`: add a scanners declaration (e.g. a secret
  scanner and a dependency scanner) as a worked illustration, alongside the footprint
  map from s01.
- Depends on t1 (docs must match the shipped mechanism).

## Status

active
