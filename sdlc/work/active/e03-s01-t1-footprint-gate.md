---
id: e03-s01-t1-footprint-gate
kind: task
project: claude-skills
status: active
autonomy: attended
parent: e03-s01-footprint-security
created: 2026-07-09
updated: 2026-07-09
---

## Outcome

The governance gate reads a per-repo footprint map and runs the security review
only when a story's changed files touch externally-deployed code — code review
still always runs.

## Decisions in plain terms

Implements the epic's stance (`work/active/e03-governance-granularity.md`): rigour
scoped to where it matters, failing safe toward running the review. The one choice:
**classify by changed path, not by story intent** — a story can span both surfaces,
so the diff decides, and any deployed path in it is enough to require the review.

## Acceptance

- In the gate's "What it runs" step, `/code-review` always runs; `/security-review`
  runs only when the story's changed-file set (the existing story-branch diff vs
  `main`) contains a path classified **deployed**.
- Classification rule stated plainly: match each changed path against the repo's
  footprint map; **the most specific rule wins, specificity measured by
  path-segment depth** (the rule whose matched prefix has the most path segments —
  e.g. `src/analysis/**` beats `src/**`); a `**` matches across separators; a path
  matching nothing is **deployed**; the security review runs if **any** changed path
  is deployed.
- **No footprint map present** → nothing classifies internal → all deployed → the
  security review runs on everything: identical to today. `security-gate: required`
  remains the master switch; the footprint block is optional and additive.
- **Ambiguous** is defined as *rules of equal path-segment depth that classify a
  path into conflicting footprints* — the only case the depth metric doesn't
  resolve; in that case the gate asks the operator and defaults to running the
  review. When the run is unattended (`auto`, no operator), it does not stall — it
  defaults to running.
- Rename/delete semantics stated: a rename classifies on either endpoint (deployed
  either side → run); a deleted deployed path still triggers the review.
- The gate's verdict table is unchanged in meaning — when the security review is
  skipped for an internal-only story, its "security finding blocks" row simply never
  triggers; code review's rows still apply.
- Canonical and installed ri-execute copies are identical.

## Test specification

Instruction-file change; verify by coherence inspection plus worked cases:

- The gate section names the footprint read, the classify-by-changed-path rule, the
  most-specific-wins + unmatched→deployed defaults, and the any-deployed→run rule.
- Absent-map, ambiguous, unattended, and rename/delete cases are each stated.
- **Mandatory worked check** against this self-contained sample map (inline here so
  it grounds against something real — coherence-only is insufficient for a security
  gate):

  ```
  footprint:
    internal: [ tests/**, src/analysis/** ]
    deployed: [ api/**, src/** ]
  ```

  - changed set `{ tests/foo.py }` → all internal → **code-review only**
  - changed set `{ api/x.py }` → deployed → **both reviews**
  - changed set `{ src/analysis/y.py }` → `src/analysis/**` (depth 2) beats `src/**`
    (depth 1) → internal → **code-review only** (exercises most-specific-wins)
  - changed set `{ src/other.py }` → matches `src/**` only → deployed → **both**
  - changed set `{ tests/foo.py, api/x.py }` → any deployed → **both**
  - **no footprint map** → everything deployed → **both** (identical to today)

- No path lets a deployed change skip the security review; no path lets an
  absent-map repo skip it.

## Implementation notes

Edit `ri-skills/skills/ri-execute/SKILL.md` (canonical), then cp to install:

- In "Story close: the governance gate" → "What it runs", split the two reviews:
  code-review always; security-review conditional on the footprint classification of
  the story's changed files (the same diff the gate already computes vs `main`).
- Add a short "Footprint scoping" paragraph defining: read `footprint:` from
  `.ri/config.md` (an `internal:` and a `deployed:` list of globs); classify each
  changed path, most-specific glob wins, unmatched → deployed; run security-review
  iff any changed path is deployed. State the four grounded cases (absent map =
  all-deployed; ambiguous = equal-specificity only, ask-then-default-yes;
  unattended = default-yes never stall; rename/delete = classify on either endpoint).
- Keep `security-gate: required` as the master switch — the footprint only scopes
  *which* review runs inside an already-firing gate; when the flag is absent the gate
  doesn't fire at all (unchanged).
- Do not touch the verdict table's dispositions; only the security-review's firing
  condition changes.
- Docs/example live in t2 — this task is the gate mechanism.

## Status

active
