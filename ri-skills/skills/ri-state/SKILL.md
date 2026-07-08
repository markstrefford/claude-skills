---
name: ri-state
description: Regenerate /sdlc/STATE.md at session end (or on demand) to reflect the current state of work in a Reimagined Industries repo. STATE.md is the present-tense cursor — active focus, what's in flight, immediate next, blockers. It's a snapshot, overwritten each time. Reads /sdlc/work/active/ and the relevant epic roadmaps to derive truth from the filesystem. Also reports the count of items in /sdlc/OPEN.md so the cursor includes a pointer to the judgment queue without duplicating its content. Triggers on explicit slash command (/ri-state), session-end requests ("update STATE", "regenerate state"), or invocation by other skills at chain end. Use this skill whenever the cursor needs refreshing.
model: sonnet

---

# ri-state

Regenerates `/sdlc/STATE.md` to reflect what's currently happening. STATE is the present-tense snapshot, overwritten each call. The judgment queue lives in `/sdlc/OPEN.md`, which this skill does not touch — it only reads its length to point at it from STATE.

## When to run this

- At session end, after the last unit of work is committed
- On demand when the operator asks ("what's the state", "regenerate state", "/ri-state")
- Invoked by other skills (`ri-compile`, `ri-execute`, `ri-plan`) at chain end

If the operator wants to add or resolve an open question, that's not this skill — that's a direct edit to `/sdlc/OPEN.md` or an ADR if the resolution is substantive. This skill only summarises.

## Read the repo first

Before writing anything, gather the truth from the filesystem:

1. List `/sdlc/work/active/`. Note every artefact, its `kind`, its `status`.
2. For any story or epic in active, check whether it has child tasks (look for tasks naming it as `parent:`).
3. For any story with tasks, note how many are `active` versus `done`, and which are blocked (`status: blocked` carries a `blocker:` field).
4. List `/sdlc/work/backlog/`. Note the shaped-but-unstarted items — these are candidates for "Next" when nothing is in flight, not work in progress.
5. Find the most recently moved item in `/sdlc/work/done/` (highest `updated:` field). This is the "last completed" candidate.
6. Read `/sdlc/OPEN.md` if it exists. Count its open items. Do not transcribe their content into STATE.

If there's no `/sdlc/work/active/` content, STATE reflects an idle repo. That's a valid state, not an error.

## The STATE.md shape

`/sdlc/STATE.md` is exactly this structure, under 30 lines total:

```markdown
# State — last updated <ISO date>

**Active focus:** <one line — the story or task currently in flight>
**Last completed:** <id and one line>
**Next:** <id and one line, derived from the epic roadmap or task sequence>
**Blockers:** <one line each, or "none">

**Open questions:** <count, e.g. "3 — see OPEN.md"> or <"none">
```

Rules:

- One artefact per line. No nested bullets, no expanded detail.
- Operator-grammar throughout. The one-liners use the same language as the epic roadmap entries — not method names, file paths, or test names.
- Under 30 lines. If you'd write more, you're putting detail in the wrong file.
- "Blockers" line lists every blocked artefact in active with its blocker text in one phrase, or says "none."
- "Next" is derived: the next task in sequence for the active story, or the next story in the epic roadmap if no story is active, or a shaped item from `/sdlc/work/backlog/` if nothing is active.
- "Open questions" gives a count only, not content. The content lives in `OPEN.md`.

If the repo has multiple concurrently active stories (you're juggling work in two lines within one repo), list each on its own line under "Active focus." This is the within-repo cross-line view. The cross-repo view stays parked as the dashboard.

## Derivation rules

The cursor is derived, not invented. Each line answers a specific question from the filesystem:

- **Active focus:** the story or task whose `status: active` was most recently updated. If multiple, list all currently active.
- **Last completed:** the most recently moved artefact in `/sdlc/work/done/`.
- **Next:** look at the active story's task sequence, or the active epic's roadmap, and find the next item not yet done. If nothing's queued in active, a shaped item in `/sdlc/work/backlog/` is the likely next pick — name it (starting it promotes it to active). Only if backlog is also empty, write "operator's call" — meaning the queue is empty and the operator picks what comes next.
- **Blockers:** any artefact in active with `status: blocked`. Each gets one line.
- **Open questions:** count of items in `OPEN.md`. If `OPEN.md` doesn't exist, write "none."

## OPEN.md handling

This skill does not write to `OPEN.md`. Other skills do:

- `ri-compile` raises questions when source material has ambiguities the operator must resolve
- `ri-plan` raises questions when planning surfaces architectural decisions
- `ri-execute` raises questions when execution hits ambiguity it can't resolve from context

Each appends a single-line entry to `OPEN.md`:

```markdown
- <ISO date> <one-line question, with enough context that the operator can answer without re-reading artefacts> [<artefact id this relates to, if any>]
```

When the operator resolves an open question, they (or a skill on their behalf) delete the line and file the resolution as an ADR if substantive, or fold it into the relevant artefact.

`ri-state` only reads `OPEN.md` to count entries.

## Anti-drift

The cursor lives in the filesystem first. STATE.md is downstream of `/sdlc/work/active/`, not the other way around. If STATE.md and the active directory disagree, the active directory wins. Regenerate STATE rather than editing it to match a memory of what was happening.

If you find yourself wanting to write something in STATE that the filesystem doesn't support, the answer is either:

- The work isn't in `/sdlc/work/active/` and should be (compile a new artefact)
- The work is finished and should move to done
- The thought belongs in `OPEN.md`, not STATE

## Commit behaviour

STATE.md changes are doc-only edits and land directly on `main` (per branching rules). The commit message is brief: `state: refresh <repo or focus>`. No branch, no PR, no review.

If `OPEN.md` was touched in the same session by another skill, those edits also land on `main`.

## Hard rules

- Never edit `OPEN.md` from this skill. Its content is curated by the skills that raise and resolve questions.
- Never invent state that the filesystem doesn't support. The cursor is derived from `/sdlc/work/active/` and `/sdlc/work/done/`, not from session memory.
- Never let STATE.md exceed 30 lines. If you'd write more, the detail belongs somewhere else.
- Never put engineering grammar in STATE.md. Operator-grammar only, same altitude as the epic roadmap.
- Never delete `OPEN.md` even if it's empty. Leave the file with zero open items rather than removing it, so the structure stays consistent across the repo.

## What the operator decides

- Whether STATE accurately reflects current reality (usually it will, since it's derived)
- Whether to act on the cursor's "Next" suggestion or pick something else
- Whether any blockers need attention before more work proceeds
- Whether the open question count warrants a thinking session

## What this skill does without re-asking

Lists active, reads done, counts open questions, derives the cursor, writes the file, commits. The operator doesn't approve STATE — it's a derivation, not a decision.
