---
name: ri-execute
description: Execute one or more tasks from the work queue in a Reimagined Industries repo. Triggers on explicit slash command (/ri-execute), task IDs in chat ("do e02-s06-t10 and t11"), or natural language signalling task execution ("go run those tasks", "execute that story", "do these three things in /work/active/"). The skill runs the per-task flow (branch, tests-first when applicable, implement, verify, commit, move to done) and chains across tasks autonomously, pausing only on verifier failure, review-autonomy completion, or genuine ambiguity. When the chain closes a story on a repo whose `.ri/config.md` sets `security-gate: required`, it runs a governance gate (`/security-review` and `/code-review`) over the story branch before the story is merge-ready. Use this skill whenever the operator wants to advance work from /sdlc/work/active/ — don't ask which verb to use, run.
model: opus
---

# ri-execute

Advances tasks from `/sdlc/work/active/` through to `/sdlc/work/done/`. Chains multiple tasks without re-asking the operator between them.

## When to run this

The operator has named one or more tasks (by id, by reference to a story, or by description) and signalled they want work done now. Examples:

- "Go execute e02-s06-t10 and t11"
- "Do that story"
- "Run those three tasks while I get coffee"
- "/ri-execute e04-s02-t00"

If the operator is asking for the work to be planned, designed, or compiled rather than executed, this is the wrong skill. Hand off to `ri-plan`, `ri-frame`, or `ri-compile`.

## Read the repo config first

Before touching any task, read `.ri/config.md` at the repo root. The fields that matter:

- `default-rigor: tier-1 | tier-2 | tier-3` — sets the ceremony level for tasks that don't override
- `test-command` — how to invoke the test suite
- `branch-default` — usually `story-level`, occasionally `task-level`

If `.ri/config.md` doesn't exist, default to tier-3 (full rigor) and warn the operator. Don't silently assume the repo is low-risk.

## The per-task flow

**At chain start (once), surface prior context by module.** Before running the first task, pull the open questions and decisions already tagged to the code the queued tasks touch, so a relevant prior call isn't missed mid-execution. This is a non-blocking heads-up — never a gate; the chain proceeds regardless (the blocking hygiene gate is ri-state's, not this).

- Derive the modules the tasks touch (from their artefacts / the parent story), in the same vocabulary the tags use (skill/agent name here; the stack-relative code unit generally).
- Match **only inside the `area:` tag/field** — inline `[area: …]` in `/sdlc/OPEN.md`, YAML `area:` in `/sdlc/docs/decisions/` — never a bare body grep.
- Skip when redundant: if ri-plan already surfaced this module context earlier in the same session (the plan→execute chain), don't repeat it. Surface only on a cold chain start without a fresh plan pass. No matches → surface nothing.

For each task in the operator's list, in order:

### 1. Read the artefact

Open the task file. Confirm:

- `status: active` (not `blocked`, not already `done`)
- `kind: task`
- Acceptance criteria are stated
- Test specification is present (required for tier-2 and tier-3)

If status is `blocked`, stop the chain. Report which task is blocked and the blocker text. If the test spec is missing on a tier-2 or tier-3 task, stop the chain and tell the operator the task needs Plan-time work first.

Execute advances items in `/sdlc/work/active/` only. If pointed at an item still in `/sdlc/work/backlog/`, promote it to active first (starting a backlog item is its defined exit); if that item is a story or epic with no tasks yet, hand off to `ri-plan` rather than executing it in place. Planning is the primary promotion owner — this is the safety net.

### 2. Resolve the effective tier and autonomy

Tier resolution: task's `tier:` field if set, otherwise parent story's, otherwise repo default.

Autonomy resolution: task's `autonomy:` if set, otherwise parent story's, otherwise `attended`.

Hard constraint: tasks that introduce architectural decisions, change public interfaces, or modify the verifier itself can never run on `autonomy: auto`. If the assigned autonomy is `auto` and the task falls in those categories, pause and report.

### 3. Branch hygiene

Check the current branch. If on `main` and the task has a parent story, cut a branch named for the story id (`e04-s02`). If on `main` and the task has no parent, cut a branch named for the task id. If already on the correct branch from a previous task in the same story, stay there.

Never rebase. Never force-push.

### 4. Tests first (tier-2 and tier-3)

Write the tests defined in the task spec. Run them. Confirm they fail in the way the spec expects. If they pass before any implementation, something is wrong — stop and ask.

Tier-1 skips this step unless the task spec explicitly defines tests.

### 5. Implement

Write the minimum implementation that makes the tests pass. No scope creep. No "while I'm here" refactors. If something obvious needs fixing outside scope, capture it in `/sdlc/raw/` and keep going.

For tier-1 (no tests): implement, run the test suite if one exists for the project, commit when sensible.

### 6. Verify (tier-2 and tier-3)

Invoke the `verifier` sub-agent. It reads the task spec, the plan, and the diff with no memory of how the implementation was built. It reports alignment, test coverage, and drift.

Tier-1 skips the verifier unless the task involves anything load-bearing (auth, payments, data writes that can't be rolled back). When in doubt on tier-1, run the verifier.

### 7. Branch the outcome on autonomy

| Autonomy | Verifier passes | Verifier fails |
| --- | --- | --- |
| `attended` | Commit, set `status: done`, move file to `/sdlc/work/done/`, continue chain | Stop, report, leave task active |
| `review` | Commit, write a short summary in the task body, leave `status: active`, **pause the chain** | Stop, report, leave task active |
| `auto` | Commit, set `status: done`, move file to `/sdlc/work/done/`, continue chain | Stop, report, leave task active |

Commit message format: `<task-id>: <one-line outcome from the task spec>`. Reference the task id always.

**Moving the file to `/sdlc/work/done/`:** use `git mv` only when the task file is already tracked. If it reports `fatal: not under version control` (a task file created this session and never committed), fall back to plain `mv` and stage the result with `git add -A`. Never let the move step fail the chain — the move is bookkeeping, not work.

### 8. Move to the next task

Unless the chain has stopped (review pause, verifier failure, blocked task, ambiguity), proceed to the next task in the list. Don't re-ask the operator.

## What stops the chain

Only these conditions:

- A task is `blocked` or its tests are missing on tier-2/tier-3
- The verifier fails
- A `review`-autonomy task completes (operator wants to see it before continuing)
- An `auto`-autonomy task falls in a constrained category (architecture, interfaces, verifier itself)
- Genuine ambiguity that can't be resolved by reading the artefact, the repo, or `.ri/config.md`
- The governance gate blocks at story close (a security finding, or a high-severity correctness bug) — report and stop; the fix is new task work

Everything else runs through. Re-asking the operator about the same chain they already authorised is a failure mode.

## When the chain ends

Whether the chain finished cleanly or stopped early:

1. **If execution surfaced questions that need the operator's judgment but aren't blocking** (deferred design calls, ambiguity the operator should think about, choices that aren't urgent but matter), append a one-line entry to `/sdlc/OPEN.md` for each:

   ```
   - <YYYY-MM-DD> <one-line question with enough context to answer without re-reading> [<task or story id>] [area: <module(s)>]
   ```

   Rules for OPEN.md writes:
   - Create the file if it doesn't exist.
   - Append only. Never overwrite or rearrange existing entries. (Removing an entry happens only on resolution, and only `ri-file` does that — see its resolution flow.)
   - One question per line, operator-grammar.
   - Tag with the artefact id so the operator knows which work the question gates, and with an `area:` tag naming the code module(s) the question touches (the stack-relative code unit — Python module/package, JS/React module or component, skill/agent here; list more than one when it spans them). The area tag is what lets the question be surfaced when work later starts on that code.

   Questions that stopped the chain (verifier failures, ambiguity that couldn't be resolved) belong in the operator conversation now, not OPEN.md. OPEN.md is for the deferred judgment queue.

2. Run `ri-state` to regenerate `/sdlc/STATE.md` — a chain-end handoff, so invoke it in `report-only` mode (emit the report-only token) so its hygiene gate reports but never blocks the chain (an `auto` run must never stall on a hygiene review). STATE will reflect the new OPEN.md count if anything was added.

3. **If the chain just completed the last active task of a story, run the governance gate** (see below) before anything else. A story whose tasks are all in `/sdlc/work/done/` is a merge candidate, and the gate decides whether it's merge-ready.

4. If any architectural decisions, runbook updates, or strategy shifts were touched, hand off to `ri-file`.

5. Summarise to the operator: tasks completed, tasks pending review, tasks stopped, where the verifier flagged things, and the governance gate verdict if it ran.

Keep the summary short. The operator can read the diffs and STATE.md for detail.

## Story close: the governance gate

The per-task verifier checks each task against its own spec. The governance gate is different: it reviews the **whole story** as one change, at the moment it becomes a merge candidate, before it goes near `main`. This is where security and cross-task correctness get caught — problems no single task's verifier could see.

**When it fires.** When the chain moves a story's last active task to `done` (no tasks naming that story as parent remain in `/sdlc/work/active/`) **and** the repo's `.ri/config.md` carries `security-gate: required`. Tier-3 repos set this by default; tier-1 and tier-2 repos that omit it skip the gate. The gate runs once per story close, against the story branch's full diff versus `main` — not per task.

**What it runs.** Two existing Claude Code skills, over the story branch diff:

- `/code-review` — correctness bugs and reuse/simplification findings across the accumulated diff. **Always runs.**
- `/security-review` — security review of the branch's pending changes (injection, authz, secret handling, unsafe deserialisation, and the like). **Runs only when the story's changed files touch externally-deployed code** — see Footprint scoping below.

**Scanners.** A repo can declare scanners in `.ri/config.md` under `security-gate` — each entry a `command` to run and a `class`: `dependency` (e.g. `npm audit`, `pip-audit`), `code` (SAST, e.g. `bandit`), or `secret` (e.g. `gitleaks`). At story close the gate runs them, over the same story-branch diff vs `main` as the reviews. The gate orchestrates the named command and reads its output — it never reimplements the scan (note the mechanical difference from the reviews: scanners are external CLI tools whose result the gate must read and normalize).

- **When each runs.** `secret` scanners always run when the gate fires (a leaked secret is dangerous regardless of surface). `dependency` and `code` scanners run under the footprint rule above — only when a changed path is deployed.
- **Severity normalization.** Each tool's native severity (`npm audit` low→critical, `pip-audit` CVSS, `bandit` severity×confidence, `gitleaks` none) maps to block-worthy versus advisory; the default block threshold is high/critical, overridable per scanner in config. A secret match is always block-worthy.
- **Can't run.** A declared scanner that fails to run — not installed, or exits non-zero for a reason other than findings — surfaces and blocks; it never passes green (fail toward rigour).

**Footprint scoping.** A repo can declare a `footprint:` map in `.ri/config.md` — an `internal:` and a `deployed:` list of path globs — saying which code is externally reachable. When it does, the gate classifies the story's changed files (the same diff it already computes vs `main`) and runs `/security-review` only if any changed path is **deployed**. `/code-review` always runs regardless. Rules:

- **Classify by changed path, not story intent.** A story can span both surfaces; any deployed path in its diff is enough to require the security review.
- **Most specific rule wins, by path-segment depth** — the rule whose matched prefix has the most path segments (`src/analysis/**`, depth 2, beats `src/**`, depth 1). A `**` matches across separators.
- **Unmatched path → deployed.** Fail safe toward running the review.
- **No footprint map → every path is deployed** → the security review runs on everything, identical to today. `security-gate: required` stays the master on/off switch; the footprint block is optional and additive. When the flag is absent the gate doesn't fire at all.
- **Ambiguous** — only rules of *equal* path-segment depth classifying a path into conflicting footprints (the one case depth doesn't resolve) — put it to the operator, defaulting to running the review. If the run is **unattended** (an `auto` chain, no operator present), do not stall: default to running the review.
- **Renames and deletions** fall out of path-glob matching cleanly: a rename classifies on either endpoint (deployed on either side → run); a deleted deployed path still carries a deployed path and still triggers the review.

**What the verdict means.**

| Finding | Disposition |
| --- | --- |
| Security finding (any severity) on a `security-gate: required` repo | **Blocks.** Story is not merge-ready. Report to the operator now. The fix is new task work — hand the finding back to `ri-plan`, or fix in place if trivial and re-run the gate. |
| High-severity correctness bug from `/code-review` | **Blocks.** Same disposition as above. |
| Low-severity correctness or cleanup/simplification finding | **Advisory.** Append to `/sdlc/OPEN.md` (operator-grammar, tagged with the story id) and continue. Don't block a story on a cleanup. |
| Secret-scanner match | **Blocks.** Any match, no severity axis — a leaked secret is not merge-ready. |
| Dependency/code-scanner finding at or above the block threshold (default high/critical) | **Blocks.** Same disposition as a security finding. |
| Dependency/code-scanner finding below the threshold (low/moderate) | **Advisory.** Logged to `/sdlc/OPEN.md`, tagged with the story id; continue. |
| A declared scanner that can't run (missing, error exit) | **Blocks.** Surfaces the failure; never passes green (fail toward rigour). |
| Clean | Story is merge-ready. Say so plainly in the summary. Merging is the operator's action — the gate clears the path, it doesn't merge. |

The gate never merges and never marks the story `done` on its own — story-level state and the merge are the operator's call. Its job is to produce a verdict, block when the verdict is load-bearing, and route everything else to the right queue.

When a story is merge-ready, say how it should land, by tier (see the README's "Landing work — merge vs PR by tier"): tier-1 → local merge; tier-2 → PR if a senior-staff review ran at plan, else merge; tier-3 → PR (the PR carries the governance-gate evidence), unless the repo is release-based, in which case it merges and rolls into the next semver release. In release-based mode the PR is gone, so record the governance-gate verdict (clean, or the findings) in the story's close/merge commit — that keeps the evidence durable in git history. Name the expected landing path in the summary; the operator still makes the call.

## Hard rules

- Never merge or declare a story merge-ready on a `security-gate: required` repo without running the governance gate at story close
- Never let the governance gate itself merge a branch or mark a story done — it produces a verdict; the operator merges
- Never mark a task done without verifier sign-off on tier-2 or tier-3
- Never write implementation before tests on tier-2 or tier-3 if the spec defines tests
- Never edit a task's `id` field
- Never commit directly to `main` for code changes (doc-only edits to `/raw/` and `STATE.md` are the exception)
- Never escalate autonomy. If `attended`, stay `attended` even if the work looks safe
- Never re-ask the operator a question they answered in the chain instruction

## What the operator decides

- Which tasks to run, in what order
- Setting autonomy per story or per task before invoking this skill
- Reviewing the diff and verifier output on `review`-autonomy tasks
- Resolving verifier failures
- Whether to continue after the chain stops

## What this skill does without re-asking

Everything in steps 1–8 above for each task in the operator's list, subject to the stop conditions. The operator's instruction "go do these tasks" is the approval for the full chain. Per-task confirmation requests are noise.
