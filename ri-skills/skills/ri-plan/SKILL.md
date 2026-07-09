---
name: ri-plan
description: Plan an active story by breaking it into a grounded task sequence. Reads the actual code the story touches before writing any task specs, then produces task artefacts with outcomes, acceptance criteria, test specifications, and implementation notes. Also updates the epic's roadmap with the task one-liners under this story. Triggers on explicit slash command (/ri-plan), references to a specific story ("plan the marketerbot story", "/ri-plan e02-s06"), or natural language signalling readiness to break a story into tasks ("ready to plan", "let's get tasks for this story", "what's the breakdown"). Use this skill whenever a story needs decomposing into tasks before execution. Don't ask which verb to use, run.
model: opus

---

# ri-plan

Decomposes an active story into a grounded task sequence. Reads code before writing specs, so test cases and implementation notes are pinned to what's actually there.

## When to run this

The operator has a story in `/sdlc/work/active/` and wants it broken into tasks. Examples:

- "Plan the marketerbot story"
- "Ready to plan that one"
- "/ri-plan e02-s06"
- "What are the tasks for the supply gate story?"

If the operator wants the story executed (tasks already exist), this is the wrong skill — hand off to `ri-execute`. If they want a fresh story shaped from raw material, hand off to `ri-compile`. If they want to plan an epic, redirect: epics are decomposed at compile time into stories, not at plan time into tasks. Plan each story individually.

## Read the repo config first

Open `.ri/config.md` at the repo root. Fields that matter:

- `default-rigor` — sets ceremony level for the planning event
- `stacks` — used to assign tasks to a stack and locate the code
- `branch-default` — informs task branch hygiene at execute time

If the config is missing, default to tier-3 and warn the operator.

## The plan flow

### 1. Read the story and its surroundings

Open the story artefact. If it lives in `/sdlc/work/backlog/`, promote it first: move the file to `/sdlc/work/active/` (refresh its `updated:` date). Planning a story is the moment work on it starts, so this is where the backlog→active exit is owned — a story is promoted once, when it is planned. Then confirm:

- `kind: story`
- `status: active`
- No existing task children (check `children:` in frontmatter, and `ls /sdlc/work/active/` for tasks naming the story id as parent). If tasks already exist, the story is partly or fully planned — stop and ask whether to extend the plan, replan, or hand off to `ri-execute`.

Read the parent epic if one exists. The epic's roadmap section is the authoritative sequence — note where this story sits in it.

### 2. Read the code

Before writing any task spec, read the code the story will touch.

For each stack the story plausibly touches (use the story's outcome and scope, the epic's roadmap context, and the `stacks:` block in config to decide):

- List the relevant directory under the stack's `path:`
- Read the files the story explicitly names
- Read adjacent files and existing tests to understand current patterns
- Note module boundaries, type definitions, and any seams the work will cross

This is the load-bearing step. Without it, task specs are confabulation. If the story names files that don't exist yet (work that creates new modules), say so — the task spec for that work can reference the planned new file by name, but acceptance is tied to what will exist.

**Surface prior context by module.** Now that you know the code the story touches, pull the open questions and decisions already tagged to those modules — so prior context is applied to the plan instead of rediscovered later. This is the payoff of the module-area tags.

- Express the modules the story touches in the **same vocabulary the tags use** — the stack-relative code unit (a skill/agent name here, a Python module/package, a JS/React module or component). Note: this vocabulary is a convention with no registry, so the token you derive must match the token the tags carry, or the match silently misses.
- Match **only inside the `area:` tag/field**, never a bare body grep: in `/sdlc/OPEN.md` inside the inline `[area: …]` tag (comma-list), and in `/sdlc/docs/decisions/` in the YAML `area:` frontmatter. A decision that merely mentions a module in its prose must not match.
- Let the matches inform the task sequence here (agent-facing), and carry them into the operator presentation at approval (step 7). If there are genuinely no matches, surface nothing — don't manufacture a section. (Sanity check the matcher isn't silently broken: planning work that touches the `ri-plan` skill should surface the decisions tagged `area: […ri-plan…]`.)

### 3. The anti-gap check

If the operator has flagged something as "missing from the story" or "needs adding here," check the epic's roadmap before agreeing. If the missing piece is scheduled in a later story, say so plainly: "X is in story 5, by design — not a gap in this one." Don't force it into the current story and trigger a rebuild later.

If the missing piece genuinely belongs here and is absent from the roadmap, that's a real gap — flag it as an open question for the operator's call.

### 4. Generate the task sequence

Produce one task artefact per file in `/sdlc/work/active/`. Sequence them in the order they should execute. Each task is one commit's worth of work — if a "task" needs three commits, it's two tasks.

Task numbering follows the SDLC convention (e.g. `e02-s06-t10`, `e02-s06-t11`). The numbering reflects sequence within the story.

### 5. Update the epic's roadmap

Open the parent epic and find its roadmap section. Under this story's one-liner, list the task one-liners in order. Format:

```
- s06 — marketerbot judgment loop migration
  - t10 — wrap the MCP bridge with guardrail enforcement
  - t11 — write the judgment runner replacing the scheduler
  - t12 — retire the legacy scheduler and template files
  - t13 — pin the build clean and rotate the Notion token
```

Task one-liners are operator-grammar. No method names, file paths, or test names. Same rule as compile: the operator reads this map to see the shape of the work.

### 6. Senior-staff-engineer review (tier-aware)

- **Tier 3:** Always invoke the `senior-staff-engineer` sub-agent on the task sequence. Apply load-bearing findings before the operator review step.
- **Tier 2:** Invoke only if the operator asks for it. Default off.
- **Tier 1:** Never invoke.

The reviewer reads the story, the task files, and the relevant code with fresh context. Reports issues ranked by impact: scope, sequencing, architectural soundness, risk, missing work.

### 7. Operator approval

Present the plan to the operator. The summary at this point is:

- The story one-liner
- The task sequence as one-liner roadmap (already in the epic)
- Any senior-staff findings applied, briefly
- Any open questions raised during planning
- Prior context surfaced by module (from step 2): the open questions and decisions already tagged to the code this story touches, so the operator can apply or resolve them alongside the plan

Wait for approval (or edits) before committing. The operator approves the shape and may edit task one-liners directly. Implementation detail in the task bodies is not for the operator's approval — they trust the grounding step.

### 8. Commit, write any open questions, update STATE

Commit the new task files plus the epic update in one atomic plan output. Commit message references the story id: `e02-s06: plan — task sequence and roadmap`.

Lands on `main` since this is planning work, not execution. Execution work cuts the story branch when the first task runs.

**If planning surfaced questions that need the operator's judgment but aren't blocking** (deferred architectural decisions, ambiguities the operator can answer later, structural calls best made after seeing the first task execute), append a one-line entry to `/sdlc/OPEN.md` for each:

```
- <YYYY-MM-DD> <one-line question with enough context to answer without re-reading the artefact> [<story or task id>] [area: <module(s)>]
```

Rules for OPEN.md writes:

- Create the file if it doesn't exist.
- Append only. Never overwrite or rearrange existing entries. (Removing an entry happens only on resolution, and only `ri-file` does that — see its resolution flow.)
- One question per line.
- Operator-grammar. The question should be answerable by reading the line alone.
- Tag with the artefact id so the operator knows which work the question gates, and with an `area:` tag naming the code module(s) the question touches (the stack-relative code unit — Python module/package, JS/React module or component, skill/agent here; list more than one when it spans them). The area tag is what lets the question be surfaced when work later starts on that code.

Questions that block the plan belong in the conversation with the operator now, not in OPEN.md. OPEN.md is for the deferred judgment queue.

Then regenerate `/sdlc/STATE.md` — a chain-end handoff, so invoke ri-state in `report-only` mode (emit the report-only token) so its hygiene gate reports but never blocks this chain. Active focus points at the story now ready for execute.

## Task body structure

Each task artefact carries:

```yaml
---
id: <story-id>-t<NN>-<slug>
kind: task
project: <from config>
status: active
autonomy: <inherit from story, override only if risk profile differs>
parent: <story-id>
stack: <stack name, if multi-stack repo>
created: <today>
updated: <today>
---
```

Body sections:

1. **Outcome** — one line, operator-grammar. The same line that appears in the epic roadmap.
2. **Acceptance** — what "done" looks like in operator-readable terms. The operator should be able to look at the result and tell whether acceptance is met.
3. **Decisions in plain terms** — *only when the task embodies a design choice* (a pick between concrete options, not mechanical work). Each choice as one line: the call plus its consequence, operator-grammar. This sits above the engineering detail so the operator understands what was decided and why without reading the test spec or notes. A task that just executes an already-recorded decision (e.g. one made in the story's ADR) names the source instead of restating it. Omit the section entirely for purely mechanical tasks.
4. **Test specification** — engineering grammar is appropriate here. This is the contract for tests-first execute. Name what's tested, expected inputs and outputs (or properties), failure modes that must be caught, boundary conditions. Concrete enough that execute writes tests against it without inventing.
5. **Implementation notes** — engineering grammar, grounded in the code read at step 2. What modules change, what seams the work crosses, what patterns to follow. Specific enough that execute doesn't reinvent the shape.
6. **Status** — `active`.

The Outcome, Acceptance, and Decisions-in-plain-terms are operator-facing. Test specification and Implementation notes are engineering-facing. Both are allowed in this artefact because Plan is past the operator-grammar-only gate — the operator approves the plan, then doesn't read the engineering parts unless they want to. The decisions, though, must read at their altitude: a choice explained only in the implementation notes won't make sense to the operator now or in the future.

## Multi-stack handling

If the repo declares multiple stacks in `.ri/config.md`:

- Each task gets a `stack:` field naming which stack it touches.
- A task that genuinely spans stacks (an API contract change crossing backend and frontend) lists multiple: `stacks: [sim, viewer]`.
- The stack assignment drives which test command execute runs, and (later) which security scanner the close-gate uses.

If the repo declares one stack or none, omit the `stack:` field.

## Tier sensitivity

**Tier 1 (content pipelines, low-stakes):**

Plan is usually overkill here. If a story exists in a tier-1 repo and the operator asks to plan it, do a thin pass: one or two tasks, minimal test specifications, no senior-staff review. If it's really just "go do this thing," redirect to `ri-do`.

**Tier 2 (signalstrata, analytical workloads):**

Standard flow. Test specifications required on load-bearing tasks. Senior-staff on operator request.

**Tier 3 (constellation, high-stakes):**

Standard flow plus mandatory senior-staff review. Be especially conservative in implementation notes — only describe shape grounded in code actually read. If the code wasn't read, say so and stop, don't extrapolate.

## Hard rules

- Never write task specs without reading the code first. Engineering grammar in plan is allowed only when grounded in code that was read in step 2.
- Never plan a story that already has task children without first asking the operator whether to extend, replan, or execute.
- Never agree something is "missing from this story" without checking the epic roadmap first.
- Never put engineering grammar in task Outcomes or in the epic roadmap. Those are operator-grammar.
- Never bury a task's design choice in the implementation notes alone. If the task embodies a decision, it carries a plain-terms call + consequence line above the engineering detail (or names the ADR/story where the decision is already recorded that way).
- Never skip senior-staff-engineer review on tier-3.
- Never edit an artefact's `id` field once written.
- Never plan an epic. Epics are decomposed at compile time. Plan each story individually.

## What the operator decides

- Whether the task sequence is right in shape and order
- Whether senior-staff findings are load-bearing or deferrable
- Whether a flagged "gap" is a real gap or already scheduled in a later story
- Whether per-task autonomy or tier overrides apply
- Final approval before commit

## What this skill does without re-asking

Reads config, reads story and code, checks the roadmap, generates task artefacts, updates the epic roadmap, runs senior-staff on tier-3 (or on tier-2 by request), presents the plan, commits on approval, updates STATE. The operator approves the shape; the grounding and the engineering detail underneath it are the skill's responsibility.
