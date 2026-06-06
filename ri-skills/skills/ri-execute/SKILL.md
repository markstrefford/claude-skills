i---
name: ri-execute
description: Execute one or more tasks from the work queue in a Reimagined Industries repo. Triggers on explicit slash command (/ri-execute), task IDs in chat ("do e02-s06-t10 and t11"), or natural language signalling task execution ("go run those tasks", "execute that story", "do these three things in /work/active/"). The skill runs the per-task flow (branch, tests-first when applicable, implement, verify, commit, move to done) and chains across tasks autonomously, pausing only on verifier failure, review-autonomy completion, or genuine ambiguity. Use this skill whenever the operator wants to advance work from /sdlc/work/active/ — don't ask which verb to use, run.
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

For each task in the operator's list, in order:

### 1. Read the artefact

Open the task file. Confirm:

- `status: active` (not `blocked`, not already `done`)
- `kind: task`
- Acceptance criteria are stated
- Test specification is present (required for tier-2 and tier-3)

If status is `blocked`, stop the chain. Report which task is blocked and the blocker text. If the test spec is missing on a tier-2 or tier-3 task, stop the chain and tell the operator the task needs Plan-time work first.

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

### 8. Move to the next task

Unless the chain has stopped (review pause, verifier failure, blocked task, ambiguity), proceed to the next task in the list. Don't re-ask the operator.

## What stops the chain

Only these conditions:

- A task is `blocked` or its tests are missing on tier-2/tier-3
- The verifier fails
- A `review`-autonomy task completes (operator wants to see it before continuing)
- An `auto`-autonomy task falls in a constrained category (architecture, interfaces, verifier itself)
- Genuine ambiguity that can't be resolved by reading the artefact, the repo, or `.ri/config.md`

Everything else runs through. Re-asking the operator about the same chain they already authorised is a failure mode.

## When the chain ends

Whether the chain finished cleanly or stopped early:

1. **If execution surfaced questions that need the operator's judgment but aren't blocking** (deferred design calls, ambiguity the operator should think about, choices that aren't urgent but matter), append a one-line entry to `/sdlc/OPEN.md` for each:

   ```
   - <YYYY-MM-DD> <one-line question with enough context to answer without re-reading> [<task or story id>]
   ```

   Rules for OPEN.md writes:
   - Create the file if it doesn't exist.
   - Append only. Never overwrite or rearrange existing entries.
   - One question per line, operator-grammar.
   - Tag with the artefact id so the operator knows which work the question belongs to.

   Questions that stopped the chain (verifier failures, ambiguity that couldn't be resolved) belong in the operator conversation now, not OPEN.md. OPEN.md is for the deferred judgment queue.

2. Run `ri-state` to regenerate `/sdlc/STATE.md`. STATE will reflect the new OPEN.md count if anything was added.

3. If any architectural decisions, runbook updates, or strategy shifts were touched, hand off to `ri-file`.

4. Summarise to the operator: tasks completed, tasks pending review, tasks stopped, where the verifier flagged things.

Keep the summary short. The operator can read the diffs and STATE.md for detail.

## Hard rules

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
