---
id: e03-s02-t1-scanner-gate
kind: task
project: claude-skills
status: active
autonomy: attended
parent: e03-s02-scanners
created: 2026-07-09
updated: 2026-07-09
---

## Outcome

A repo declares its scanners in config, and the gate runs them at story close with
findings flowing through the existing verdict — secret scanners always, dependency
and code scanners footprint-scoped.

## Decisions in plain terms

Builds on s01's footprint scoping and the epic's stance. Two calls to confirm at
checkpoint:

- **Run-scope:** dependency and code scanners are footprint-scoped (run only when
  deployed code changed); secret scanners always run when the gate fires. Rationale:
  a leaked secret is dangerous regardless of surface, while a dependency audit on
  internal-only changes is wasted heavy work.
- **Disposition, per class** (the existing verdict rows don't fit all three the same
  way): a **secret** finding blocks — any match, no severity axis (this maps onto the
  existing "security finding, any severity, blocks" row unchanged). A **dependency**
  or **code** finding is severity-graded: high/critical blocks, low/moderate is
  advisory. And a declared scanner that **can't run** (missing, errors) surfaces and
  blocks — never passes green — per the epic's fail-toward-rigour stance.

## Acceptance

- The config schema lets a repo declare scanners under `security-gate`: each entry
  names the tool, the command to run it, and its class — `dependency`, `code`, or
  `secret`.
- At story close the gate runs the declared scanners: `secret` scanners always;
  `dependency` and `code` scanners under the same footprint rule as `/security-review`
  (run when any changed path is deployed). `/code-review` and the footprint rule
  from s01 are unchanged.
- Scanner findings disposition **per class**, extending (not silently reusing) the
  verdict table:
  - **secret** → any match blocks (the existing "security finding, any severity,
    blocks" row applies unchanged);
  - **dependency / code** → high or critical blocks; low or moderate is advisory
    (logged to `OPEN.md`, tagged with the story id, chain continues). This gradation
    is new for scanner findings and the verdict table gains a row or note saying so.
- **Severity normalization** is defined: each tool's native severity
  (`npm audit` low→critical, `pip-audit` CVSS, `bandit` severity×confidence,
  `gitleaks` none) maps to block-worthy (high/critical) versus advisory; a secret
  match is always block-worthy. A repo may set a per-scanner threshold; the default
  is high/critical blocks.
- **Scanner can't run** (not installed, non-zero exit for reasons other than
  findings) → surface and block; never pass green.
- Scanners run over the **story branch diff vs `main`**, the same scope as the
  reviews.
- The gate orchestrates the named command and reads its result — it does not
  reimplement the scan.
- No scanners declared → gate behaviour is exactly as after s01.
- Canonical and installed ri-execute copies are identical.

## Test specification

Instruction-file change; verify by coherence inspection:

- The gate's scanner text names: how scanners are declared (command + class), the
  run-scope rule (secret always; dependency/code footprint-scoped), the per-class
  disposition (secret any-match blocks; dependency/code high/critical blocks,
  low/moderate advisory), severity normalization, and the can't-run→block rule.
- The verdict table reflects the scanner dispositions (a row or note), rather than
  the prose claiming to reuse rows that don't carry the gradation.
- The existing one-line scanner mention (the `npm audit` / `pip-audit` / `bandit` /
  `gitleaks` line) is expanded into this defined behaviour, not left as a stub.
- No-scanners case leaves s01 behaviour intact.
- Worked check: with a declared `gitleaks` (secret) and `pip-audit` (dependency),
  an internal-only story runs `gitleaks` but not `pip-audit`; a story touching a
  deployed path runs both; a `gitleaks` match blocks; a low `pip-audit` advisory is
  logged, not blocking; a `pip-audit` that errors blocks.

## Implementation notes

Edit `ri-skills/skills/ri-execute/SKILL.md` (canonical), then cp to install:

- Replace the existing one-line scanner mention (the "Add dependency and secret
  scanners here too if the repo declares them…" line) with a defined step: the gate
  runs each scanner the repo declares. State the config shape (a `scanners:` list
  under `security-gate`, each with `command` and `class: dependency|code|secret`).
- Run-scope: `secret` scanners always run when the gate fires; `dependency` and
  `code` scanners run under the s01 footprint rule (only when a changed path is
  deployed). Reference s01's rule rather than restating it.
- Disposition, per class — and edit the verdict table to carry it, don't pretend the
  current rows already do: **secret** findings block on any match (the existing
  security row covers this verbatim); **dependency/code** findings block on
  high/critical and are advisory on low/moderate (a new gradation — add a scanner row
  or a note under the table). Define severity normalization: map each tool's native
  severity to block-worthy/advisory, secret always block-worthy, default threshold
  high/critical, optionally overridable per scanner in config.
- A declared scanner that can't run (missing tool, error exit) surfaces and blocks —
  never green. State it, citing the epic's fail-toward-rigour stance.
- Scanners run over the story branch diff vs `main` — same scope as the reviews.
- The gate orchestrates the named command and interprets its output; it never
  reimplements a scanner. Note the mechanical difference from the reviews: scanners
  are external CLI tools whose output the gate must read and normalize, not
  Claude-native review commands — so the normalization above is real work, not free.
- Docs/example are t2.

## Status

active
