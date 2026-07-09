---
id: e03-s01-t2-footprint-docs
kind: task
project: claude-skills
status: done
autonomy: attended
parent: e03-s01-footprint-security
created: 2026-07-09
updated: 2026-07-09
---

## Outcome

The footprint map is documented as an optional config block, and the tier-3 example
shows it, so operators can adopt it and existing configs keep parsing unchanged.

## Acceptance

- The README's governance-gate section states that the security review is
  footprint-scoped (always code-review; security-review only on deployed changes),
  with the conservative defaults.
- The README's `.ri/config.md` reference documents the optional `footprint:` block
  (`internal:` / `deployed:` glob lists) alongside `security-gate`, noting that it
  is optional and that its absence preserves today's behaviour.
- The tier-3 config example carries a footprint map as a worked illustration.
- Nothing implies the footprint block is required, or that omitting it changes the
  gate's behaviour.

## Test specification

Doc change; verify by inspection:

- README governance-gate + config sections describe footprint scoping and the
  optional block with its defaults.
- The tier-3 example includes a footprint map consistent with the mechanism (t1).
- The docs and t1's mechanism agree (most-specific-wins, unmatched→deployed,
  any-deployed→run, absent-map=today).

## Implementation notes

- README "The story-close governance gate" section: add that `/security-review` is
  footprint-scoped — always code-review, security-review only when changed files
  touch deployed code — with the most-specific-wins / unmatched→deployed / absent-
  map=today defaults in one or two lines. Keep it operator-grammar.
- README "Configure → Per-repo `.ri/config.md`": add the optional `footprint:` block
  under/near `security-gate`, with `internal:` and `deployed:` glob lists and a note
  that it is optional and additive (omit it → security review runs on everything).
- `ri-skills/examples/config-tier-3.md`: add a footprint map as a worked example
  (mirror the shape of constellation's, but as an illustrative sample, not that repo).
- Depends on t1 (docs must match the shipped mechanism).

## Status

active
