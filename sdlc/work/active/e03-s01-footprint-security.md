---
id: e03-s01-footprint-security
kind: story
project: claude-skills
status: active
autonomy: attended
parent: e03-governance-granularity
sources: [work/active/e03-governance-granularity.md]
created: 2026-07-09
updated: 2026-07-09
---

# Scope the security review by footprint

## Executive summary

Today a gate-enabled repo runs the security review over every story, whatever it
touched. This story scopes that: at story close the gate always runs the code
review, but runs the security review only when the story's changed files touch
externally-deployed code, read from a per-repo footprint map. It spends the
heaviest check where there's an external surface and skips it where there isn't,
without ever weakening the guarantee — when in doubt the review still runs. The
mechanism lives in the shared gate; the map is per-repo. It changes when the
security review fires; it changes nothing a product does, and it leaves every
existing gate repo behaving exactly as it does now until it opts in with a map.

## Outcome

- At story close, the code review always runs; the security review runs only when
  the story's changed files touch externally-deployed code, decided from the diff.
- A repo declares a footprint map (which paths are externally deployed versus
  internal-only). The gate reads it and classifies the story's changed paths.
- Classification is conservative and unambiguous: the most specific rule wins, an
  unclassified path counts as deployed, and the security review runs if any changed
  path is deployed.
- Existing behaviour is preserved for repos with no map: with nothing to classify,
  every path counts as deployed, so the security review runs on everything — exactly
  as today. The `security-gate: required` flag stays the master on/off switch; the
  footprint map is strictly optional and additive.

## Out of scope / carry-forward

- The per-repo footprint maps themselves — this story ships the mechanism and a
  documented example, not any one repo's map (constellation declares its own).
- Scanners (s02) and invariant enforcement (s03) — separate stories; this one only
  scopes the security review.

## Standing gate

Lands in the shared gate (ri-execute) plus the config docs and the tier-3 example,
so every gate repo gains it. Reviewed at tier-3 rigour because it decides when a
security review fires — so the conservative defaults are load-bearing and must be
exact. Four points the senior-staff review flagged are carried into acceptance
below, not left to interpretation: absent-map compatibility, the definition of
"ambiguous", unattended-chain behaviour, and rename/delete classification. This
repo sets no `security-gate`, so the mechanism ships dormant here and is verified by
coherence, not by a live gate; constellation exercises it.

## Acceptance

- Always code review; security review only when a changed path is classified
  deployed. Most-specific rule wins; unclassified path → deployed.
- No footprint map → identical to today (all paths deployed, security review runs).
- "Ambiguous" is defined precisely — only equal-specificity conflicting rules — and
  in that case the gate asks the operator, defaulting to running the review.
- When the chain is unattended (an `auto` run with no operator present), the gate
  never stalls waiting for that answer — it defaults to running the review.
- A renamed path classifies on either endpoint (deployed on either side → run); a
  deleted deployed path still triggers the review — both fall out of path-glob
  matching over the diff.
- The config docs and the tier-3 example document the footprint map as an optional
  block, and existing configs without it parse unchanged.
- Edited skill copies are in parity.

## Status

Planned into tasks. Ready for execute.
