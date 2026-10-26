---
name: ri-file
description: Record durable knowledge a working session produced — architectural decisions (ADRs), runbook updates, strategy shifts, architecture facts, spec divergences — and resolve questions in /sdlc/OPEN.md, in a repo that uses the ri SDLC. Use at session or chain end, or when the operator says "write up that decision", "anything to file", /ri-file.
model: sonnet
effort: medium
---

# ri-file

The compounding layer: what makes one session useful to the next. It records what emerged during work, where `ri-compile` shapes what arrived as input. It is also the one skill that removes questions from `/sdlc/OPEN.md`, as part of resolving them.

Filler is worse than nothing — it buries the records that matter. If nothing was decided, learned or shifted, say "nothing to file", refresh STATE (`report-only`), and stop.

## Config

Read `.ri/config.md` for `project` and `default-rigor`. Tier sets how much is worth filing:

- **Tier 1** — almost never anything. Quick scripts don't produce ADRs. File only if the operator asks.
- **Tier 2** — selective: ADRs for real architectural choices, runbook updates for operational lessons.
- **Tier 3** — active: architectural choices are load-bearing and get ADRs, operational lessons on public services get runbook updates, strategy shifts get recorded.

## Flow

### 1. Find what is worth filing

| Category | What qualifies |
| --- | --- |
| Architectural decision | A choice between concrete options that affects future work — Postgres over SQLite, event-driven over direct calls, a feature deferred for a clear reason. |
| Runbook update | A procedure ran and diverged from the docs, or a recovery worked, or a new check joined the rotation — something the next person needs. |
| Strategy shift | The project's direction or positioning changed in a way that affects scope or priorities. |
| Architecture fact | A long-standing structural truth surfaced or was pinned down — a module boundary, a contract between services, a data flow. |
| Spec divergence | What got built differs from what the story said; the story is updated to match reality. |

Not worth filing: anything already in commit messages, task artefacts or story specs; recaps; generic observations that don't change future work; trivial choices (renaming a variable is not an ADR).

### 2. Propose, and wait

List each proposed output and where it goes:

> - Architectural decision → `/sdlc/docs/decisions/<slug>.md` because <one-line reason>
> - Runbook update → `/sdlc/docs/runbooks/<name>.md`, adding section X
> - Spec divergence → update `/sdlc/work/active/<story-id>.md` outcome from X to Y

The operator may add, drop, merge or redirect. Write nothing until they approve.

### 3. Write

**Where it goes.** If the work belongs to an epic still in `/sdlc/work/active/`, put decision, runbook, strategy and architecture drafts alongside the epic in `/sdlc/work/active/`; they move to the right `/sdlc/docs/` folder when the epic closes. When unsure, co-locate — moving later is cheap, splitting an epic's material across folders mid-flight is not.

**ADR.**

```yaml
---
id: <slug>                # descriptive, no numeric prefix (e.g. sdlc-store-lifecycle); never changed once written
kind: decision
project: <from config>
area: [<module(s)>]       # the code the decision concerns, so it can be found from that code
sources: [<task id, story id, raw note, or session>]
created: <today>
updated: <today>
verified-on: <today>
---
```

`area:` uses the stack-relative module (a Python module or package, a JS/React top-level module or component, a skill or agent). List several when it spans them; go down to a single file only when the change genuinely is one file. Never an epic id — many epics stack on the same code.

```markdown
# <Title in operator grammar>

## Status
Accepted

## Context
<The situation, in operator grammar: the facts that made the decision make sense.>

## Decisions in plain terms
<One line per decision — the call and its consequence, in architect grammar, no
method names or schema fields. One line for a single decision; D1..DN for
several, in the same order as below. Example: "Read the shocks already in the
config; don't redesign the format — cheap and safe, and the real calibrated
events finally render as timeline markers.">

## Decision(s)
<The engineering detail, grounded in the code or data: one section, or ### D1..DN.
State what was chosen, not every alternative.>

## Consequences
<What changes downstream, what it commits us to, what it rules out, what still needs follow-up.>

## Alternatives considered
<If meaningful: the options not chosen and why, a paragraph each at most.>
```

Context, Decisions in plain terms, and Consequences are written for the operator. Engineering detail lives only in Decision(s) and Alternatives. The plain-terms section is required: the test is whether the operator, reopening the ADR months later, knows what was decided and why without reading the engineering detail.

**Runbook.** To update one, read it first and match its style; add the section where it fits; set `verified-on:` to today. A new runbook uses the ADR frontmatter with `kind: runbook` and no `area:`, and its body covers: when it applies, the procedure as numbered steps, what success looks like, what failure looks like, and escalation if it fails.

**Strategy.** Narrative paragraphs in operator grammar throughout — someone will read it months later without the code in front of them. Frontmatter as for a runbook, `kind: strategy`.

**Architecture.** A structural fact, often a diagram described in prose, plus what it means for future work. `kind: architecture`.

**Spec divergence.** Update the diverged section of the story (Outcome, Acceptance, or wherever it is), and add `## Divergence from compile <today>` with a paragraph on why what was built differs from what was specified. Whether the divergence is genuine or a mistake to rework is the operator's call.

### 4. Approve, commit, hand off

Show the operator the written content before committing. They approve the substance as well as the shape — an ADR or strategy entry is a statement in their name.

One commit for the session's filing, naming what was filed: `file: postgres-over-sqlite ADR, deploy-checklist runbook update`. Doc-only changes — to `/sdlc/docs/`, and doc-only divergence updates in `/sdlc/work/active/` — land on `main`; with `landing: pull-request` in config, on a short `sdlc/file-<slug>` branch opened as a pull request. When another skill invoked this one mid-chain, commit on the branch that chain is on. Then refresh STATE through `ri-state` in `report-only` mode — unless another skill invoked this one as part of its chain, in which case that skill refreshes STATE at its own end.

## Resolving an open question

The acting skills (`ri-compile`, `ri-plan`, `ri-execute`) only append to `/sdlc/OPEN.md`. `ri-state` only counts it. This skill is the only one that removes an entry, and only by resolving it — so a resolved question never lingers and an unresolved one never disappears.

Triggered when the operator asks to resolve a question, or another skill hands one over.

1. Read the question and its tags (the work id and the `area:`).
2. Propose a disposition: **durable** (a lasting call worth a record), **becomes-work** (the answer is something to do), or **trivial** (answered, nothing lasting).
3. The operator decides. You do the bookkeeping, not the judging.
4. Drain it in the same step:
   - durable → write the ADR as above, then delete the line;
   - becomes-work → hand the question to `ri-compile` as source material (it owns routing to backlog or active), then delete the line once the work item exists;
   - trivial → delete the line. Trivial answers don't become ADRs.

Commit the resolution and the `OPEN.md` removal together, landing as above.

## Boundaries

- `CLAUDE.md`, `~/.claude/CLAUDE.md` and `.ri/config.md` are edited only with the operator's explicit approval. They encode the operator's opinions and must sound like the operator; draft the change and let them approve it.
