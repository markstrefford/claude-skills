---
id: e03-s02-scanners
kind: story
project: claude-skills
status: done
autonomy: attended
parent: e03-governance-granularity
sources: [work/active/e03-governance-granularity.md]
created: 2026-07-09
updated: 2026-07-09
---

# Wire a repo's declared dependency and secret scanners into the gate

## Executive summary

The gate already mentions that a repo can name scanners (`npm audit`, `pip-audit`,
`bandit`, `gitleaks`), but there is no way to declare them and no defined behaviour
when they run. This story makes that real: a repo declares its scanners in config,
the gate runs them at story close alongside the reviews, and their findings flow
into the same block-versus-advisory verdict the reviews already use. It reuses the
footprint scoping from s01 so dependency and code scanners run where a security
review would — while secret scanning always runs, because a leaked secret is
dangerous no matter which code it sits in. The gate orchestrates whatever the repo
names; it never reimplements a scanner. It changes what the gate runs; it changes
nothing a product does.

## Outcome

- A repo declares its scanners in `.ri/config.md` — which tools, and how each is
  invoked — and the gate runs them at story close, orchestrating without
  reimplementing.
- Scanner findings disposition through the gate verdict, **per class**: a secret
  match blocks (no severity axis); a dependency or code finding blocks on
  high/critical and is advisory on low/moderate; a scanner that can't run blocks
  rather than passing green.
- Scanner run-scope follows a clear rule: dependency and code scanners are
  footprint-scoped like the security review (run when deployed code changed);
  **secret scanning always runs** within a firing gate, regardless of footprint.
- Declaring no scanners leaves the gate exactly as it is after s01.

## Out of scope / carry-forward

- Bundling or shipping any specific scanner. The gate calls what the repo names; the
  operator installs and configures the tools.
- The invariant checks (version-pairing, public-deploy) — that is s03.

## Standing gate

Lands in the shared gate (ri-execute), the config schema, and the docs/example, so
every gate repo can adopt it. The scanner list and commands are per-repo. Tier-3
review applies. Two design calls to confirm at plan checkpoint: (1) **run-scope** —
dependency and code scanners footprint-scoped (deployed changes only) while secret
scanning always runs within a firing gate; (2) **disposition** — secret findings
block on any match, dependency/code findings block on high/critical and are advisory
below, a scanner that can't run blocks (fail toward rigour). Both are the recommended,
security-conservative defaults, but they decide when the gate blocks — the operator's
call.

## Acceptance

- The config schema lets a repo declare scanners, each with the command that runs it
  and its class (dependency / code / secret), so the gate knows how to run it and
  when.
- At story close the gate runs the declared scanners: secret scanners always;
  dependency and code scanners under the same footprint scoping as the security
  review. Findings disposition per class: secret any-match blocks; dependency/code
  high/critical blocks and low/moderate advisory; a scanner that can't run blocks.
- No scanners declared → gate behaviour is unchanged from s01.
- The docs and the tier-3 example show how to declare scanners and state the run-
  scope rule.
- Edited skill copies are in parity.

## Status

Both tasks done (t1-t2 in /work/done/). Checkpoint cleared: run-scope (secret always, dependency/code footprint-scoped) and per-class disposition (secret any-match blocks, dependency/code high-crit blocks else advisory, can't-run blocks) confirmed. Gate + verdict table + docs + tier-3 example all carry it; ri-execute in parity. Merge-ready.
