---
name: ri-plan
description: Break an active or backlog story into a grounded sequence of tasks, reading the code it touches before writing any task spec, in a repo that uses the ri SDLC. Use when a story is ready to be decomposed before execution — "plan that story", "what's the breakdown", /ri-plan <story-id>.
model: opus
effort: high
---

# ri-plan

Decomposes one story into tasks, each one commit's worth, with test specifications and implementation notes pinned to code that was actually read. Plan is where engineering grammar becomes legitimate — but only because it is grounded. A task spec written without reading the code is the same confabulation compile is designed to avoid.

Executing existing tasks is `ri-execute`; shaping a new story from raw is `ri-compile`. Epics aren't planned: they were broken into stories at compile time, so plan each story on its own.

## Config

Read `.ri/config.md` for `default-rigor` (tier), `stacks` (which code each task touches, and its test command), `branch-default`, `landing` and `security-gate`. If it is missing, work at tier 3 and tell the operator.

At tier 1, planning is usually overkill: do a thin pass (one or two tasks, minimal test specs) or, if it is really "go do this", redirect to `ri-do`. At tier 2, test specifications are required on load-bearing tasks. At tier 3, describe only shape grounded in code you read; if you couldn't read it, say so and stop.

## Flow

### 1. Read the story and its surroundings

Open the story. If it is in `/sdlc/work/backlog/`, move it to `/sdlc/work/active/` and refresh `updated:` — planning is the moment work starts, so this is where backlog → active happens. Confirm it is `kind: story`, `status: active`, and has no tasks yet (check `children:` and look in `/sdlc/work/active/` for tasks naming it as `parent:`). If tasks exist, it is already partly planned: ask whether to extend, replan, or hand to `ri-execute`.

Read the parent epic. Its roadmap is the authoritative sequence; note where this story sits.
### 2. Read the code

For each stack the story plausibly touches (judge from its outcome and scope, the epic's roadmap, and `stacks:`), list the relevant directories, read the files it names, and read neighbouring code and existing tests for the patterns in use. Note module boundaries, types and the seams the work crosses. On a multi-stack repo the per-stack reads are independent; run them in parallel, delegating to sub-agents if that is quicker. If the story creates files that don't exist yet, say so; a task can name a planned file, with acceptance tied to what will exist.

Then pull prior context for those modules, so earlier calls get applied rather than rediscovered:

- Express the modules in the same vocabulary the tags use (the stack-relative unit — skill or agent name, Python module or package, JS/React module or component). There is no registry, so a mismatched token silently finds nothing.
- Match only inside the tag: `[area: …]` in `/sdlc/OPEN.md`, and the `area:` frontmatter field in `/sdlc/docs/decisions/`. A decision that merely mentions a module in its prose doesn't count.
- Use the matches to shape the tasks, and show them to the operator at approval. No matches, no section. (Sanity check: planning work on `ri-plan` itself should surface decisions tagged `area: [ri-plan]`.)

### 3. Check "missing" against the roadmap

If the operator says something is missing from this story, check the epic roadmap first. If it is scheduled later, say so — "X is in s05, by design" — rather than pulling it forward and forcing a rebuild. If it belongs here and is in no story, that is a real gap: raise it as a question for the operator.

### 4. Write the tasks

One file per task in `/sdlc/work/active/`, in execution order, numbered under the story (`e02-s06-t1`, `e02-s06-t2`). If a task needs three commits, it is three tasks.

```yaml
---
id: <story-id>-t<K>-<slug>   # never changed once written
kind: task
project: <from config>
status: active
autonomy: <inherit from the story; propose an override if this task's risk differs — the operator decides>
parent: <story-id>
stack: <stack name>          # multi-stack repos; `stacks: [a, b]` if it genuinely spans both
created: <today>
updated: <today>
---
```

Body:

1. **Outcome** — one line, operator grammar, the same line that goes in the roadmap.
2. **Acceptance** — what done looks like, in terms the operator can check by looking at the result.
3. **Decisions in plain terms** — only when the task embodies a real choice between options. One line per choice: the call and its consequence. If the decision is already recorded (the story's ADR), name it instead. Omit for mechanical tasks. A choice explained only in the implementation notes won't make sense to the operator now or later.
4. **Test specification** — engineering grammar. What is tested, inputs and expected outputs or properties, failure modes that must be caught, boundary conditions. Concrete enough that execute writes tests from it without inventing.
5. **Implementation notes** — engineering grammar, grounded in step 2: which modules change, which seams it crosses, which patterns to follow.
6. **Status** — `active`.

The first three are for the operator; the last two are for execute. The `stack:` field decides which test command execute runs.

### 5. Update the epic roadmap

Under this story's line, list the task lines in order, in the same operator grammar as the outcomes — no method names, paths or test names:

```
- s06 — nightly import moves to the job runner
  - t1 — the import runs as a job and reports its outcome
  - t2 — retire the old cron entry once a week of runs is clean
```

### 6. Senior-staff review

At tier 3 always, at tier 2 on request, never at tier 1: have the `senior-staff-engineer` sub-agent (`ri-skills:senior-staff-engineer` under a plugin install) review the task sequence. Brief it with the story id and the task file paths, not your reasoning. Apply the findings that are clearly load-bearing before the operator sees the plan, and show them what you applied and what you didn't; whether a finding can wait is their call.

### 6a. Security review

When `security-gate` isn't off (absent, it defaults to off only when the story's resolved tier is 1) and the story touches a sensitive surface, have the `security-reviewer` sub-agent (`ri-skills:security-reviewer` under a plugin install) review the plan in `plan` mode, briefed with the story id and the task file paths. Sensitive means any of: authentication or authorisation, payments, personal or customer data, a new or changed public endpoint or interface, secrets or credentials, file upload or parsing of untrusted input, or a model fed input the system doesn't control. Judge from the story and the code read in step 2; when unsure, run it.

Apply what it says the plan must add as tasks, acceptance criteria or test-spec cases, so the threats are tested rather than remembered. On NEEDS WORK, apply them and re-run the review once; anything still open goes to the operator at approval. Show the operator what you applied and what you didn't, as for the senior-staff review.

### 7. Operator approval

Present: the story line, the task lines, any senior-staff and security findings you applied, questions raised while planning, and the prior context surfaced in step 2. The operator approves the shape and may edit task lines. The engineering detail underneath is yours; they trust the grounding. Commit nothing until they approve.

### 8. Commit, open questions, STATE

Commit the task files, the epic update and any `OPEN.md` appends below together, with a message naming the story: `e02-s06: plan — task sequence and roadmap`. With `landing: merge` (the default) commit on `main`; planning isn't execution, and execute cuts the branch. With `landing: pull-request`, commit on the story branch (Compile may have cut it already; otherwise cut it now from `main`), so the plan is reviewed in the same pull request as the code. Under that mode the story file itself may exist only on its branch, so look for a branch named for the story id before concluding the story is missing.

Questions that block the plan belong in the conversation. Questions for later go to `/sdlc/OPEN.md`, appended one per line (create the file if needed; never rewrite or reorder existing lines):

```
- <YYYY-MM-DD> <question answerable from this line alone> [<story or task id>] [area: <module(s)>]
```

Append them before the commit above, so they land with the plan.

Finish by invoking `ri-state` in `report-only` mode. Active focus points at the story, now ready to execute.
