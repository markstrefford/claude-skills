---
name: ri-execute
description: Run one or more planned tasks from /sdlc/work/active/ through tests, implementation, verification and commit, chaining across tasks without re-asking, and mark tasks, stories and epics done as each completes, in a repo that uses the ri SDLC. Runs the story-close governance gate on repos with `security-gate: required`. Use when the operator wants planned work done or marked done — "do e02-s06-t1 and t2", "execute that story", "mark e04-s01 done", /ri-execute.
model: opus
effort: high
---

# ri-execute

Moves tasks from `/sdlc/work/active/` to `/sdlc/work/done/`. The operator's "go do these" is the approval for the whole chain, so asking again between tasks is a failure, not caution. What keeps an unattended chain safe is the verifier on each task and the governance gate at story close, not check-ins.

Work that still needs planning, designing or shaping goes to `ri-plan` or `ri-compile`.

## Config

Read `.ri/config.md` for `default-rigor` (tier), the test command (`test-command`, or per stack under `stacks:`), `branch-default` (usually `story-level`), `landing` (`merge` if absent), and `security-gate`, `footprint:` and `scanners:` for the story-close gate. If the config is missing, work at tier 3 and tell the operator — never assume a repo is low-risk.

## Working across a long chain

A chain can run for a long time and outlive a context compaction. The state lives in files, not in your memory: after a compaction, or whenever you are unsure where you are, re-read the current task file and `git log` on the branch before continuing. Report only what a tool result in this session shows — tests passing, a commit made, a file moved — and say plainly when something is unverified. To wait on a build, CI or a container, use Monitor with an until-condition rather than a sleep loop.

When the operator has authorised a chain, they are not watching it. For reversible steps that follow from the tasks, proceed. If your last paragraph is a plan or a promise ("next I'll…"), do that work now instead of ending the turn. Stop only for the conditions listed under "What stops the chain".

## Before the first task: prior context by module

Once per chain, pull open questions and decisions already tagged to the code the queued tasks touch, so a prior call isn't missed mid-execution. It is a heads-up, never a gate.

- Derive the modules from the task artefacts and parent story, in the tag vocabulary (the stack-relative unit; skill or agent name in this repo).
- Match only inside the tag: `[area: …]` in `/sdlc/OPEN.md`, `area:` frontmatter in `/sdlc/docs/decisions/`. Never a bare grep of the body.
- Skip it if `ri-plan` already surfaced the same context earlier in this session. No matches, nothing to say.

## Per task

### 1. Read the artefact

Confirm `kind: task`, `status: active`, and acceptance criteria present. A `blocked` task stops the chain: report the task and its blocker. At tier 3 every task needs a test specification, and a missing one stops the chain: the task needs Plan work first. At tier 2 Plan writes specs only for load-bearing tasks, so a task without one is mechanical: skip tests-first, implement, run the suite, and verify as usual.

Execute works on `/sdlc/work/active/` only. If pointed at a backlog item, promote it to active first; if it is a story or epic with no tasks yet, hand it to `ri-plan` instead of executing it in place.

### 2. Resolve tier and autonomy

Tier: the task's `tier:`, else the parent story's, else the repo default. Autonomy: the task's `autonomy:`, else the story's, else `attended`. Never raise autonomy yourself, even when the work looks safe — it is the operator's dial.

Tasks that introduce an architectural decision, change a public interface, or modify the verifier can't run at `autonomy: auto`. If one is set to `auto`, pause and report.

### 3. Branch

With `branch-default: main` and `landing: merge` (the tier-1 setting), commit on `main`. Otherwise, never commit code directly to `main`: work on the story's branch, named for the story id (`e04-s02`). If you are already on it, stay; if it exists (Compile or Plan may have cut it), check it out; if not, cut it from `main`. A task with no parent story gets a branch named for the task id. Never rebase or force-push — history is the audit trail.

### 4. Tests first (when the task has a test specification)

Write the tests the spec defines, run them, and confirm they fail the way the spec expects. If they pass before any implementation, something is wrong: stop and ask.

### 5. Implement

Write the least code that makes the tests pass. Anything else worth fixing that you notice goes to a file in `/sdlc/raw/`, not into this task. At tier 1 with no tests, implement, run the suite if one exists, and commit.

### 6. Verify (tier 2 and 3)

Invoke the `verifier` sub-agent (`ri-skills:verifier` when the set is installed as a plugin). Its brief is the task id and the commit before the task started — nothing about how you built it, because a reviewer told the implementer's story tends to confirm it. At tier 1, skip it unless the task touches something load-bearing (auth, payments, irreversible data writes); when in doubt, run it.

### 7. Close the task by autonomy

| Autonomy | Verifier passes (PASS or PASS WITH NOTES) | Verifier fails |
| --- | --- | --- |
| `attended` | Set `status: done`, move to `/sdlc/work/done/`, commit the work and the move together, continue | Stop, report, leave active |
| `review` | Write a short summary into the task body, commit, leave `status: active`, and pause the chain until the operator approves. Then mark it done (commit the move) and resume | Stop, report, leave active |
| `auto` | As `attended` | Stop, report, leave active |

No task is marked done at tier 2 or 3 without verifier sign-off. At tier 1 with no verifier run, a task is done once it is implemented, the suite (if any) passes, and it is committed. Commit messages are `<task-id>: <one-line outcome from the spec>`. A task's `id` never changes.

Move files with `git mv` when they are tracked. If git reports `not under version control` (a task file created this session and never committed), use `mv` and stage the new path by name. Never `git add -A`: it would sweep in an uncommitted `STATE.md`. The move is bookkeeping and must never fail the chain.

Questions for later that come up while working go to `OPEN.md` as they arise (format under "When the chain ends"), so they ride in the next commit on the branch.

If that was the last active task of its story, close the story now (see "Closing a story"), so a chain spanning several stories closes each before starting the next. Then go to the next task.

## What stops the chain

- A task is `blocked`, or lacks a test spec at tier 3
- A task's new tests pass before any implementation
- The verifier fails
- A `review` task completes
- An `auto` task falls in a constrained category (architecture, public interface, the verifier)
- Ambiguity that the artefact, the repo and the config can't resolve
- The governance gate blocks at story close

Nothing else does.

## Closing a story

Run as soon as a story's last active task is done.

1. **Gate.** Run the governance gate below when the repo requires it. A blocked gate stops the chain and the story stays active.
2. **Mark the story done** (see "Marking work done"). The `<story-id>: done` commit carries the gate verdict in its message, plus any `OPEN.md` appends not yet committed, including the gate's advisory findings.
3. **Epic close.** If the epic is now done (see the table below), move its doc drafts and mark it done in one `<epic-id>: done` commit, then hand off to `ri-archive` scoped to that epic. Archive owns the record and its own approval; don't reimplement it here. If the operator declines the archive, the epic stays done and unarchived.
4. **Filing.** If the work touched an architectural decision, runbook or strategy, hand off to `ri-file`.
5. **Land** the story (see "Landing a story"). It comes last so the archive record and filed docs travel with the story.

Under `autonomy: auto` nobody is there to approve an archive grouping or filed content, so steps 3 and 4 don't hand off. Mark the epic done if it is, append one `OPEN.md` line for each ("e05 is done and ready to archive", "e05-s02 produced a decision worth filing") in that commit or the story's, and land. The operator runs archive and file later, from `main`.

## When the chain ends

Whether it finished or stopped:

1. **Open questions.** Questions that stopped the chain go to the operator now. Questions that need their judgment later go to `/sdlc/OPEN.md`, appended one per line in operator grammar (create the file if needed; never rewrite or reorder existing lines). The `area:` tag is the code module the question touches, so it resurfaces when someone works there:

   ```
   - <YYYY-MM-DD> <question answerable from this line alone> [<task or story id>] [area: <module(s)>]
   ```

   Any not yet committed are on a story that hasn't landed (a landed story's done commit took them): commit them on its branch as `<story-id>: open questions`.

2. **STATE, last.** Invoke `ri-state` in `report-only` mode so its hygiene check reports but never blocks — an `auto` chain must not stall on a hygiene review. It runs last so the cursor reflects the gate and any epic close, and because it runs on a lighter model that stays in effect for the rest of the turn.
3. **Summary.** Short: tasks completed, pending review, stopped; what the verifier flagged; each gate verdict; stories landed and how; any epic close, and any archive or filing left for the operator. The operator can read the diffs and STATE for detail.

## Marking work done

A level is done when the level below it is done and its own check has passed. Marking done means setting `status: done`, refreshing `updated:`, moving the file to `/sdlc/work/done/` (with the same `git mv` fallback as a task move), and committing, on the branch the work is on, so the done state lands on `main` with the code. A story or epic marking commits as `<id>: done`, together with any `OPEN.md` appends not yet committed, including the gate's advisory findings.

| Level | Done when | Who triggers it |
| --- | --- | --- |
| Task | The verifier passes, with or without notes (tier 2 and 3), under `attended` or `auto`. At tier 1 without a verifier: implemented, suite passing, committed. A `review` task becomes done when the operator approves it after the pause; the chain then resumes from the next task. | This skill, per task |
| Story | Every task naming it as `parent:` is in done, and the governance gate is clean or not required. A blocked gate leaves the story active. | This skill, at story close |
| Epic | Every story in its roadmap is in done, and no story or task under it remains in active or backlog. A roadmap line with no story file yet is a story still to do. Check `main` as well as the current branch: an earlier story may have landed after this branch was cut, so a story in done on either counts, even if this branch still shows it active. | This skill, at the story close that completes it |

At epic close, before handing off to `ri-archive`, move any decision, runbook, strategy or architecture drafts co-located with the epic in `/sdlc/work/active/` to their `/sdlc/docs/` folders, in the `<epic-id>: done` commit. They are the epic's lasting output and must not be swept into the archive record.

The operator can also ask to mark something done directly ("mark e04-s01 done"), for work finished outside a chain. Apply the same conditions: confirm the children are done and, for a story on a `security-gate: required` repo, run the gate first. If a condition isn't met, say which, and don't mark it. If it is met, commit on the story's branch if one exists. An epic, or a story with no branch, commits on `main` under `merge`, or on a short `sdlc/<id>` branch opened as a pull request under `pull-request`. Then continue as in "Closing a story" from step 3.

## Landing a story

`landing:` in `.ri/config.md` decides how a done story reaches `main`. Either way, you never merge.

| `landing:` | At story close | Where the gate verdict goes |
| --- | --- | --- |
| `merge` (default) | Report the branch as ready; the operator merges it, by merge commit, not squash or rebase | The story's `<id>: done` commit; offer the same text as the merge commit message |
| `pull-request` | Push the story branch and open a pull request against `main` (`gh pr create`), titled with the story id and outcome | The `<id>: done` commit and the pull request body; reviewers, CI and branch protection attach there |

With `branch-default: main` there is nothing to land: the commits are already on `main`.

`merge` suits a single operator, who already gets review in-session from the verifier and the gate. `pull-request` suits a team, where the pull request is where a second person reviews. On a release-based repo, also carry each story's verdict into the release notes. Name the landing path in the summary.

## Story close: the governance gate

The verifier checks each task against its own spec. The gate reviews the whole story as one change, at the moment it becomes a merge candidate, to catch security and cross-task problems no single task's verifier can see.

**When it fires.** The chain moves a story's last active task to done, and `.ri/config.md` has `security-gate: required`. Once per story close, over the story's full diff: the story branch against `main`, or, with `branch-default: main`, from the commit before the story's first task. No flag, no gate. Tier-3 repos normally set the flag.

**What it runs.** These are independent; run them in parallel.

- `/code-review high` (`/code-review xhigh` at tier 3) over the story branch diff. Always runs. Pass the level explicitly: without one, the command reuses whatever level the operator last typed, and the gate's depth would vary by session.
- `/security-review` — only when the diff touches deployed code (see footprint). It compares against `origin`'s default branch; if there is no `origin`, or local `main` is ahead of it, say in the verdict that the review covered a different diff from the story's rather than reporting clean.
- Declared scanners. Each `scanners:` entry has a `command` and a `class`: `secret` (e.g. gitleaks), `dependency` (e.g. pip-audit, npm audit) or `code` (e.g. bandit). Run the named command and read its output; never reimplement the scan. `secret` scanners always run when the gate fires; `dependency` and `code` scanners follow the footprint rule. Map each tool's native severity to block or advisory; the default block threshold is high/critical, overridable per scanner with `block-threshold:`. A scanner that can't run (not installed, or a non-zero exit that isn't findings) blocks, never passes green.

**Footprint.** An optional `footprint:` map lists `internal:` and `deployed:` path globs. When present, classify the story's changed paths and run the security review only if any is deployed. The rules all lean toward running the review:

- Classify by changed path, not by what the story is about; one deployed path is enough.
- The most specific rule wins, by path-segment depth (`src/analysis/**`, depth 2, beats `src/**`). `**` matches across separators.
- An unmatched path counts as deployed. No map at all means everything is deployed.
- Equal-depth rules that conflict: ask the operator, defaulting to running the review; in an unattended `auto` run, just run it.
- A rename counts as deployed if either side is; a deleted deployed path still counts.

**Verdicts.**

| Finding | Disposition |
| --- | --- |
| Security finding, any severity | Blocks. The story isn't merge-ready; report now. The fix is new task work via `ri-plan`, or a trivial in-place fix followed by a re-run. |
| High-severity correctness bug | Blocks, as above. |
| Secret-scanner match | Blocks. |
| Dependency or code finding at or above the threshold | Blocks. |
| A declared scanner that couldn't run | Blocks. |
| Low-severity correctness, cleanup, or scanner finding below threshold | Advisory: append to `OPEN.md` tagged with the story id, and continue. |
| Clean | Merge-ready. Say so plainly. |

The gate produces a verdict; a clean verdict is what lets the story be marked done and landed. Record the verdict (clean, or the findings) where "Landing a story" says.
