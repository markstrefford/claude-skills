# Governance

## What each tier turns on

| Behaviour | Tier 1 | Tier 2 | Tier 3 |
| --- | --- | --- | --- |
| Default verb | `ri-do` | compile → plan → execute | compile → plan → execute |
| `ri-do` | Freely | Small mechanical changes only | Refused unless you override in the session |
| Compile | Often unnecessary | Standard | Conservative: placeholders over guesses |
| Senior-staff review of epics, stories, strategy, architecture, task plans | Never | On request | Always |
| Test specification in tasks | If useful | Load-bearing tasks | Every task |
| Tests first | When the task has a spec | When the task has a spec | Always |
| Verifier on each task | Only for auth, payments, irreversible writes | Yes | Yes |
| Story-close gate | If `security-gate: required` | If `security-gate: required` | Normally set |
| Branching | `main` with `branch-default: main`, else story branch | Story branch | Story branch |
| Filing decisions and runbooks | Only on request | Real architectural choices | Active |

Whatever the tier, `ri-do` won't touch architecture, auth, payment paths, irreversible data writes or public security surface. Those need the verifier, so they become a story.

## The verifier

Runs after each task at tier 2 and 3. It reads the task spec, the parent story and the diff since the task started, runs the tests, and reports alignment, coverage, drift and smells.

| Verdict | Effect |
| --- | --- |
| PASS | Task is marked done |
| PASS WITH NOTES | Task is marked done; notes are reported |
| FAIL | The chain stops and the task stays active |

Tests that can't run cap the verdict at PASS WITH NOTES and say why. They never pass silently.

## The senior-staff reviewer

Runs at planning time on epics, stories, strategy and architecture artefacts, and on task plans: always at tier 3, on request at tier 2. It reports the top issues by impact with a READY, READY WITH NOTES or NEEDS WORK verdict. Findings that are clearly load-bearing are applied before you see the artefact, and you're shown what was and wasn't applied. Whether the rest can wait is your call.

## The story-close gate

The verifier checks each task against its own spec. The gate reviews the whole story as one change, when it becomes a merge candidate, to catch security problems and cross-task problems no single task shows.

**When it fires.** A chain moves a story's last task to done, and the config has `security-gate: required`. Once per story, over the story's full diff: the story branch against `main`, or the story's own commits when a tier-1 repo works on `main`.

**What it runs**, in parallel:

| Check | When |
| --- | --- |
| `/code-review high` (`xhigh` at tier 3) | Always. The level is explicit because the command otherwise reuses whatever level was last typed |
| `/security-review` | When the story touches deployed code, per the `footprint` map. It compares against `origin`'s default branch; if that differs from the story's base, the verdict says so |
| `secret` scanners | Always |
| `dependency` and `code` scanners | When the story touches deployed code |

**Verdicts.**

| Finding | Effect |
| --- | --- |
| Security finding, any severity | Blocks |
| High-severity correctness bug | Blocks |
| Secret-scanner match | Blocks |
| Dependency or code finding at or above the threshold | Blocks |
| A scanner that couldn't run | Blocks |
| Lower-severity findings | Advisory: added to `OPEN.md` against the story |
| Clean | The story is marked done and landed |

A blocked story stays active. The fix is new task work through `ri-plan`, or a trivial fix followed by a re-run.

The verdict is recorded in the story's done commit, and offered as the merge message under `landing: merge` or written into the pull request body under `landing: pull-request`. Release-based repos also carry it into release notes. The gate never merges.

## What the gate doesn't cover

`version-pairing` and `public-deploy` are read but not enforced. Nothing checks that a story's release notes match its verdict, or that the operator merged a story whose gate blocked. Those are your controls.
