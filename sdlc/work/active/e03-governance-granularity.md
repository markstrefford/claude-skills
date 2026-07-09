---
id: e03-governance-granularity
kind: epic
project: claude-skills
status: active
autonomy: attended
sources: [raw/footprint-scoped-security-gate.md]
created: 2026-07-09
updated: 2026-07-09
---

# Governance-gate granularity

## Executive summary

The story-close governance gate is all-or-nothing today: on a repo that requires
the gate, the security review runs over every story regardless of what it touched.
That spends the heaviest check on work that has no external surface, and it makes
the gate slower and noisier than it needs to be. This epic makes the gate granular
— rigour scoped to where it actually matters. First, security review runs only on
stories that touch externally-reachable code, while code review still runs on
every story. Then the same gate gains a home for the per-repo scanners and the
invariant checks already parked in the README. The mechanism lives in the shared
skills; each repo declares what its own surface is. It changes how the gate decides
what to run; it changes nothing a product does.

## Outcome

- Security review runs only where it is warranted — on stories that change
  externally-deployed code — while code review still runs on every story.
- Each repo declares its own footprint (which code is externally reachable versus
  internal-only); the gate reads it to decide, per story, whether the security
  review is needed.
- The same gate becomes the home for the currently-parked granularity work:
  per-repo dependency and secret scanners, and enforcement of the version-pairing
  and public-deploy invariants.

## Out of scope / carry-forward

- The per-repo footprint maps themselves — each repo declares its own; this epic
  builds the mechanism that reads them, not any one map.
- Changing what the security or code reviews actually check. This epic changes
  *when* they run and *what else* the gate orchestrates, not the reviews' content.

## Standing gate

The reusable mechanism lands in the shared skills — the governance gate in
ri-execute, the per-repo config schema, and the docs — so every gate-enabled repo
gains it. The footprint map, the scanner declarations, and the invariant values are
per-repo config, not part of this epic's build. Because this governs how every
tier-3 repo's security review fires, the changes are reviewed at tier-3 rigour, and
the conservative defaults matter: when the gate can't classify a path, it must fail
toward running the security review, never toward skipping it.

## Acceptance

- On a gate-enabled repo, a story that touches only internal code runs code review
  alone; a story that touches any externally-deployed code also runs the security
  review — decided from the story's changed files, not the story's stated intent.
- Classification is unambiguous and conservative: the most specific footprint rule
  wins, an unclassified path is treated as deployed, and a genuinely ambiguous path
  is put to the operator (defaulting to running the review).
- The roadmap's later stories (scanners, invariant enforcement) attach to the same
  gate without reshaping it.

## Roadmap

- s01 — scope the security review by footprint: always code-review, security-review only when a story touches externally-deployed code
  - t1 — the gate reads a repo's footprint map and runs security-review only on deployed changes
  - t2 — document the optional footprint block and show it in the tier-3 config example
- s02 — wire a repo's declared dependency and secret scanners into the same gate
- s03 — enforce the version-pairing and public-deploy invariants at the gate rather than only reading them

## Status

Compile done. Plan reads the code before writing tasks.
