# Concepts

## The problem it addresses

AI-assisted development tends to fail in one of two ways. With no structure, work drifts and nobody can say later why the code is the way it is. With heavy structure, the model spends its budget reading a spec before doing anything. ri-skills sits between them: one small skill per verb, loaded only when that verb runs, and a few files in the repo that hold the state.

## Principles

**Filesystem as source of truth.** Every work item is a markdown file with YAML frontmatter under `/sdlc/`. Its folder says where it is in the lifecycle. Git history is the audit trail. `STATE.md` is derived from the folders on every run and is never edited by hand, so it can't drift from them.

**Thin compile, grounded plan.** `ri-compile` works from what you wrote, not from the code, so it states outcome, scope and acceptance and stops there. Where a template asks for detail the source doesn't support, it leaves a placeholder. `ri-plan` reads the code before it writes a single test spec. This separation stops a 500-line story full of invented function names reaching execution.

**Two grammars.** Operator grammar is plain words about consequences: what changes, what it costs, what it rules out. Engineering grammar is test names, signatures, file paths and schemas. Everything the operator reads or approves is in operator grammar. Engineering grammar lives below it in the same file, in the test specification and implementation notes, where execution needs it.

**Ceremony proportional to risk.** Each repo declares a tier. The tier decides whether tests come first, whether the verifier runs, whether a reviewer checks the plan, and whether a story faces a security gate before it lands. See [governance](governance.md).

**Fresh-context review.** A reviewer who has heard the implementer's reasoning tends to confirm it. The verifier is briefed with a task id and the commit before work started; the senior-staff reviewer with an artefact path. Each reads the spec and the code cold.

**Progressive disclosure.** No document is loaded every session. Each skill's description is short, scoped to repos that use the SDLC, and its body loads only when invoked.

## Tiers

The tier answers one question: if this breaks, how expensive is the rebuild?

| Tier | Rebuild cost | Typical repo |
| --- | --- | --- |
| 1 | Trivial: rerun the script, edit the doc | Content scripts, glue code |
| 2 | Moderate: a user-visible regression, an afternoon's fix | Internal tools, analytics, maturing products |
| 3 | Severe: corrupted state, public outage, data loss | Public services, financial logic, security surface |

A repo sets `default-rigor` in `.ri/config.md`. A story or task can override it with `tier:`. A repo with no config is treated as tier 3, never assumed low-risk.

## Autonomy

Autonomy decides how much `ri-execute` does before stopping for you. It is set per story or task with `autonomy:` and defaults to `attended`. The model never raises it.

| Level | What happens when a task passes verification |
| --- | --- |
| `attended` | Commit, mark done, continue to the next task |
| `review` | Commit, summarise, pause until you approve; then mark done and continue |
| `auto` | Commit, mark done, continue, unattended |

`attended` and `auto` behave the same within a chain. The difference is intent: `auto` is for chains you will not watch, and three kinds of task can never run at `auto`: architectural decisions, public interface changes, and changes to the verifier itself.

Saying "go do these" authorises the whole chain. The chain stops only for a failed verification, a `review` task, a blocked task, a constrained `auto` task, new tests that pass before any code is written, ambiguity the files can't resolve, or a blocking gate.

## The operator

The skills address "the operator": the person who approves shapes, makes judgment calls and merges. They are expected to read consequences, not code. Approval points are explicit: compile's shape and final artefact, plan's task sequence, file's written content, archive's grouping, and every merge.
