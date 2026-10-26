---
name: ri-compile
description: Shape raw material (files in /sdlc/raw/, legacy notes, a pasted snippet) into an epic, story, task, decision, runbook, strategy or architecture entry — or discard it — in a repo that uses the ri SDLC. Use when the operator wants captured material turned into something the workflow can act on — "compile that note", "triage raw", "make this a story", /ri-compile.
model: opus
effort: high
---

# ri-compile

Turns raw material into a shaped artefact the operator can read and approve. The output is thin on purpose: compile works from source material, not code, so it states outcome, scope and acceptance in plain words and leaves engineering detail to `ri-plan`, which reads the code. A compile that invents function names, test cases or schemas to fill a template produces confident fiction that Plan then has to unpick.

Executing work is `ri-execute`; preserving material unshaped is `ri-capture`.
## Config

Read `.ri/config.md` for `default-rigor` (tier) and `project` (used in frontmatter). If it is missing, work at tier 3 and tell the operator.

Tier changes what compile is for. At tier 1 most material is "make this script do X": propose discard-and-`ri-do` freely and keep compile for genuine structural change. At tier 2 the standard flow applies. At tier 3, be especially conservative with thin source material — a placeholder is better than a confabulated detail.

## Flow

### 1. Read all the source

Open every file the operator named; for "the raw folder", list it and read each file. Legacy notes (pre-SDLC backlogs, changelogs, scratch docs elsewhere) count as raw. Compile from what is on disk, never from a summary or memory.

### 2. Propose a shape, and wait for approval

Decide what each item should become, and present it before writing anything — this is the highest-leverage step, and a wrong shape wastes everything after it.

| Shape | Lands in |
| --- | --- |
| task — one commit's worth (rare from raw; usually comes from Plan) | work |
| story — one coherent change worth specifying | work |
| epic — a strategic commitment with several stories | work |
| decision (ADR) | `/sdlc/docs/decisions/` |
| runbook entry | `/sdlc/docs/runbooks/` |
| strategy entry | `/sdlc/docs/strategy/` |
| architecture entry — a long-standing structural fact | `/sdlc/docs/architecture/` |
| addition to an existing artefact | that artefact |
| discard — the thought has served its purpose | nowhere |

A work item goes to `/sdlc/work/active/` if the operator is starting it now, or `/sdlc/work/backlog/` if it is shaped but not started. Backlog exists so shaped work neither lingers in raw nor gets pushed into active before anyone is working on it; starting a backlog item promotes it (owned by `ri-plan`). Every item you shape leaves raw for exactly one of docs, backlog, active or discard. Unshaped captures may keep waiting in raw for a later pass.

Format each proposal as:

> Raw file `<path>` → propose **<shape>** because <one-line reason>.

An epic proposal includes its story breakdown, because the roadmap is what the operator is really approving:

> Raw file `<path>` → propose **epic** with these stories:
> - s01 — <one-line outcome>
> - s02 — <one-line outcome>

The operator may merge items, change shapes, edit the story list or redirect to discard. Write nothing until they approve. Stories under a new epic don't get files at compile time; they live as roadmap lines until each is compiled on its own, unless the operator asks for story files now.

**Numbering.** A new epic takes the next unused two-digit number and a readable name: `e<N>-<name>` (`e01-governor-foresight`). Its children use the compact number: story `e<N>-s<M>-<slug>` (two-digit `s`), task `e<N>-s<M>-t<K>-<slug>`. Numbers keep concurrent epics from colliding and make parentage visible. Older name-based epics (`epic-<name>` with `<name>-s<N>` children) keep their ids until they are done.

### 3. Write the artefact, thin

Body for task, story and epic:

1. **Executive summary** — what the work is, why now, what it doesn't change. A 30-second read.
2. **Outcome** — the named things the work delivers.
3. **Out of scope / carry-forward** — what it deliberately leaves alone.
4. **Standing gate** — architecture, extraction or downstream-consumer concerns, in a paragraph, or "none".
5. **Acceptance** — high-level criteria.
6. **Status** — where it sits: compile, planning-review, approval, execution.

An epic also carries a **Roadmap**: its stories in the order they should land, one line each. It is the authoritative answer to "what builds what, in what order" for the epic's life.

```markdown
## Roadmap

- s01 — wrap the MCP bridge with guardrail enforcement
- s02 — write the judgment runner replacing the scheduler
```

At compile time the roadmap holds story lines only; `ri-plan` adds task lines under each story when it plans it. Status never goes in the roadmap — it is read from the filesystem when needed, so writing it would create a second, drifting copy.

**Every field the operator reads is in operator grammar** — outcome, scope, acceptance, gate notes, status notes, roadmap lines. The operator should be able to read the whole artefact without meeting a function name, file path, test name, schema or implementation term. Before each sentence, check two things: is it grounded in the source I read, and would the operator understand it without thinking about implementation? If either fails, rewrite it plainly or leave it out.

> Bad status: "compile done. Plan should ground the runner spawn flags, the wrapped-bridge call sites, and the legacy retirement against the actual code in src/ before execution."
> Good status: "compile done. Plan reads the code before writing tasks."

Where the template expects detail the source doesn't support, leave the placeholder rather than fill it:

> ### Detailed implementation
> *Populated at Plan time. Source material does not ground this level of detail.*

A **decision** artefact, or a story that bundles decisions, leads with each decision as one plain line — the call and its consequence — before any engineering detail, in the ADR shape `ri-file` defines. A decision record only a developer can parse has failed as a record.

### 4. Frontmatter

```yaml
---
id: <stable-id>           # never changed once written
kind: task | story | epic | decision | runbook | strategy | architecture
project: <from .ri/config.md>
status: active            # work items only
autonomy: attended        # default; the operator can override
sources: [raw/<source-files>]
created: <today>
updated: <today>
---
```

Docs (decision, runbook, strategy, architecture) omit `status` and add `verified-on: <today>`.

### 5. Senior-staff review on significant artefacts

For an epic, story, strategy or architecture artefact, the `senior-staff-engineer` sub-agent (`ri-skills:senior-staff-engineer` under a plugin install) reviews it with fresh context: always at tier 3, on request at tier 2, never at tier 1. Tasks, decisions, runbooks, additions and discards don't warrant it at any tier.

Brief it with the artefact path and nothing about how you shaped it — its value is that it hasn't heard your reasoning. Apply the findings that are clearly load-bearing, then show the operator what you applied and what you didn't; whether a finding is load-bearing or can wait is their call. It cannot rescue a compile built on thin source; if it says the artefact is thin, that is the correct result.

### 6. Final approval, then file moves

Show the operator the finished artefact, with any senior-staff findings. Nothing moves or commits until they approve it.

1. Write the artefact to its home (active, backlog, or the right `/sdlc/docs/` folder) with `sources:` pointing at the raw path.
2. Commit, together with any `OPEN.md` appends from step 7, then delete the raw file. The raw file goes only once a committed artefact references it, so a thought is never lost between the two.
3. A discard deletes the raw file with the reason in the commit message (`raw/X.md discarded — superseded by Y`).
4. An addition adds the raw path to the existing artefact's `sources:`, then deletes the raw file.

Compile output is doc-only, so it commits on `main`. With `landing: pull-request` in config nothing commits to `main` directly, so: a story is committed on a new branch cut from `main` and named for its id (`e05-s02`), where Plan and Execute continue and the story lands as one pull request; anything else goes on a short `sdlc/<artefact-id>` branch opened as a pull request. An epic must be merged before its stories are compiled.

### 7. Open questions, then STATE

Questions the operator must answer before the compile can continue belong in the conversation now. Questions that need their judgment later — deferred calls, ambiguities that can wait — go to `/sdlc/OPEN.md`, one line each, appended (create the file if needed; never rewrite or reorder existing lines):

```
- <YYYY-MM-DD> <question answerable from this line alone> [<artefact id>] [area: <module(s)>]
```

The `area:` tag names the code module(s) the question touches, as the stack-relative unit (a Python module or package, a JS/React module or component, a skill or agent). It is what lets the question resurface when someone later works on that code. Append them before the step 6 commit, so they land with the artefact.

Finish by invoking `ri-state` in `report-only` mode, so its hygiene check reports but never blocks this chain. Active focus will usually point at the new artefact.
