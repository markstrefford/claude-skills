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
| Security review of sensitive plans | Off by default | Yes | Yes |
| Story-close gate | Off by default | Advisory: runs, never blocks | Required: blocks |
| Security review depth | OWASP checklist | OWASP checklist | Checklist plus `/security-review` |
| Epic-close security review | Off by default | Yes, never blocks | Yes, never blocks |
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

## Security

Security is checked at four points, each catching what the one before can't.

| Point | Who | Catches | Blocks? |
| --- | --- | --- | --- |
| Plan, for sensitive stories | `security-reviewer`, plan mode | Design flaws before code exists: trust boundaries, access, data exposure. Its findings become tasks and test cases | No; you approve the plan |
| Each task | `verifier` | Obvious security smells while the change is small | Yes, as a FAIL |
| Story close | The gate: `security-reviewer` checklist, plus `/security-review` under `full`, plus scanners | Vulnerabilities in the finished story | Under `required` |
| Epic close | `security-reviewer` checklist, over every story's commits | Flaws that span stories | Never; findings go to `OPEN.md` |

A story is sensitive if it touches authentication or authorisation, payments, personal or customer data, a public endpoint or interface, secrets, untrusted file or input parsing, or a model fed outside input.

**Depth.** `security-review: owasp` runs the checklist. The reviewer works through every category of the OWASP lists that apply (the Top 10:2025 for deployed code, the API Security Top 10 for HTTP APIs, the LLM Top 10 for model calls) and reports each as pass, finding or not applicable, so the result reads as an audit. `full` adds Claude Code's `/security-review` at story close, an open-ended review that finds logic flaws no list has a category for, on the session's model, at more cost. The epic review is always the checklist: `/security-review` diffs against `origin`'s default branch, where earlier stories already are.

**Strictness.** `security-gate: required` blocks a story on a security finding. `advisory` runs the same reviews and queues findings in `OPEN.md`. `off` turns off the whole story-close gate (code review and scanners included) and the plan and epic security reviews; the verifier's smell check stays. The defaults follow the story's resolved tier.

### Limitations

These reviews raise the floor. They don't replace a penetration test, a human security review, or a compliance audit, and a client should be told so.

| Limitation | Consequence | What covers it |
| --- | --- | --- |
| **Static only.** Every review reads code. Nothing runs the application or sends it a request | Flaws that only show at runtime are missed: server and cloud configuration, headers, TLS, session behaviour, rate limits in practice | A dynamic scan of a deployed environment, such as OWASP ZAP, or a penetration test |
| **The repo only.** Infrastructure, cloud permissions, network rules and third-party settings outside the repo aren't seen | A safe change can still ship onto an unsafe platform | Infrastructure and cloud reviews, outside this set |
| **The change, not the codebase.** Each review covers a story's or epic's commits and the code around them | Existing flaws in untouched code are never reviewed | A one-off review of the whole codebase when a repo adopts the SDLC |
| **Model judgment.** The reviewers are models | They can miss a real flaw, report one that isn't there, and give different results on different runs. The checklist makes sure every category is considered, not that every instance is found | `full` for depth; scanners for repeatable checks; human review on tier-3 work |
| **Decided by classification.** Plan review runs only for stories judged sensitive. Story and epic reviews run only on paths the `footprint` map counts as deployed | A misjudged story, or a deployed path mapped as internal, gets no security review. Both rules lean toward running it | Keep the `footprint` map conservative; ask for a plan review on any story you're unsure of |
| **Dependencies and secrets need scanners.** The checklist reads manifests and code. It doesn't look up known vulnerabilities or search history for secrets | Vulnerable packages and leaked keys are found only if a `dependency` or `secret` scanner is declared | Declare scanners in `.ri/config.md` |
| **Code can address the reviewer.** Comments or strings in the reviewed code can try to steer a model reviewer | A hostile or careless change could talk its way past the review | Scanners, which can't be argued with, and human review of tier-3 changes |
| **Findings can wait.** Under `advisory`, and at every epic close, findings go to `OPEN.md` and nothing stops the work. An epic's stories may already be deployed when its review runs | A real issue can sit in the queue | `ri-state` flags questions older than 30 days. Use `required` where that matters |
| **Off at tier 1.** Tier-1 repos get only the verifier's smell check, and only where the verifier runs | Glue code and scripts go unreviewed | Set `security-gate` on a tier-1 repo that handles anything sensitive |
| **Mapped, not certified.** Findings are labelled by OWASP category, and the lists are fixed editions in the reviewer's brief | The output supports an audit but isn't an attestation, and doesn't verify against OWASP ASVS. New editions need the brief updating | A formal assessment where a client or regulator requires one |

## The story-close gate

The verifier checks each task against its own spec. The gate reviews the whole story as one change, when it becomes a merge candidate, to catch security problems and cross-task problems no single task shows.

**When it fires.** A chain moves a story's last task to done, unless `security-gate` is off. Once per story, over the story's full diff: the story branch against `main`, or the story's own commits when a tier-1 repo works on `main`.

**What it runs**, in parallel:

| Check | When |
| --- | --- |
| `/code-review high` (`xhigh` at tier 3) | Always. The level is explicit because the command otherwise reuses whatever level was last typed |
| `security-reviewer` checklist | When the story touches deployed code, per the `footprint` map |
| `/security-review` | Under `security-review: full`, on the same condition. It compares against `origin`'s default branch; if that differs from the story's base, the verdict says so |
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

Under `security-gate: advisory` every row is advisory: the findings go to `OPEN.md`, a would-have-blocked one marked so, and the story lands. A blocked story stays active. The fix is new task work through `ri-plan`, or a trivial fix followed by a re-run.

The verdict is recorded in the story's done commit, and offered as the merge message under `landing: merge` or written into the pull request body under `landing: pull-request`. Release-based repos also carry it into release notes. The gate never merges.

## What the gate doesn't cover

`version-pairing` and `public-deploy` are read but not enforced. Nothing checks that a story's release notes match its verdict, or that the operator merged a story whose gate blocked. Those are your controls.
