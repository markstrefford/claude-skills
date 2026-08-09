---
name: ri-archive
description: Consolidate /sdlc/work/done/ into one record per completed epic, so a repo doesn't accumulate a file per task forever. Triggers on explicit slash command (/ri-archive), complaints about the done folder ("done/ is huge", "hundreds of files in done", "tidy up done", "consolidate the archive"), or natural language signalling the work tree has outgrown itself. Reads the closed artefacts under an epic and writes a single record carrying its stories, its critical tasks, what was done, the decisions that steered it, and the commits — then removes the files it replaced. Use this skill whenever /sdlc/work/done/ has grown past being readable.
model: opus
---

# ri-archive

Collapses `/sdlc/work/done/` from one file per task into one record per epic.

The done tree is the audit trail, and per-task files are the wrong granularity for it. They accumulate without bound, load into agent context, and clog the repo tree — while the thing anyone actually needs later is coarser: what the epic was, what shipped, and why it went that way.

## When to run this

`/sdlc/work/done/` has more files than anyone will read. Examples:

- "done/ has hundreds of files in it"
- "tidy up the done folder"
- "/ri-archive e02"
- an epic just closed and its stories and tasks are all sitting in done/

Not for: closing individual tasks (that's `ri-execute`), or filing decisions to `/docs/` (that's `ri-file`).

## Read the repo first

1. Read `.ri/config.md` for `project:`. If absent, infer from existing frontmatter and warn.
2. List `/sdlc/work/done/`. For each artefact note `id`, `kind`, `parent`, `children`, `updated`, and any `commits:`.
3. List `/sdlc/work/active/` and `/sdlc/work/backlog/`. **Any epic with a descendant still in active or backlog is not archivable** — skip it and say so.
4. Note any file that is already a consolidated record (`kind: archive`) or a pre-SDLC bulk import (`done-historical.md` and similar). Leave both alone.

## Grouping

Group done artefacts into archivable sets by lineage:

- **By epic.** Follow `parent:` up from each task and story. The hierarchical id (`e02-s07-t21`) is a strong hint but `parent:` is authoritative — trust the frontmatter, fall back to the id prefix only when `parent:` is missing.
- **Orphans.** Artefacts with no epic ancestor are common (standalone stories, one-off tasks). Collect them into a single period record — `done/archive-<YYYY>-h<1|2>.md` — rather than forcing a false parent.

An epic is archivable when every descendant is in `/work/done/` (or `/work/dropped/`) and the epic itself is `status: done`.

## What the record contains

One file per epic, replacing every file it consolidates. Keep it short — this is a record, not a reconstruction.

- **The epic**, and the fact it closed, with dates spanning first-created to last-updated.
- **Its stories, at story level.** One heading each, with what it delivered in two or three sentences of operator grammar.
- **Only the critical tasks named.** The ones that changed direction, took several attempts, or carry a fact worth grepping. A task that went in cleanly gets no line — its commit is the record.
- **The decisions that steered it, and why.** The load-bearing part. Anything that reversed a position, ruled an approach out, or would surprise someone reading the code later.
- **Gotchas worth keeping** — data identity traps, environment quirks, anything that bit twice.
- **Commits.** The final merge per story is enough. Don't enumerate every commit.

Explicitly not: acceptance criteria, test plans, implementation notes, out-of-scope sections, per-task narrative. Those served their purpose while the work was live and die with the files.

Target roughly one screen per epic regardless of how many files it replaces. If it runs past two, it's carrying detail that should have been dropped.

### Frontmatter

    ---
    id: <epic-id>
    kind: archive
    project: <from config>
    status: done
    replaces: [<ids of every consolidated artefact>]
    span: 2026-05-05..2026-08-08
    created: <original epic created>
    updated: <date of archiving>
    tags: [<union of the constituents' tags, deduped>]
    ---

`replaces:` is what makes the collapse reversible in principle and greppable in practice — the old ids stay findable even though the files are gone.

## The flow

1. **Group** and report: for each archivable epic, how many files it would replace; which epics are skipped and why.
2. **Get approval on the grouping** before writing anything. The operator approves the set, not each record.
3. **Write each record**, reading every constituent file first. Never summarise from ids and headings alone — the decisions are in the bodies.
4. **Verify before deleting.** Every constituent id appears in `replaces:`, and every decision carried in a constituent body is either in the record or was a deliberate drop.
5. **Remove the consolidated files** with `git rm`. If a file isn't tracked, plain `rm` and stage with `git add -A`.
6. **Commit** — one commit per epic, message naming the epic and the file count collapsed.
7. **Update STATE** via `ri-state` at the end, once.

## Hard rules

- Never archive an epic with a descendant in `/work/active/` or `/work/backlog/`. Live work loses its context.
- Never delete a constituent file before its record is written and verified. Write first, delete second, in that order, always.
- Never run against a dirty working tree. The deletions must be reviewable as a single diff against a clean baseline.
- Never consolidate `/docs/` artefacts. ADRs, runbooks, architecture and strategy are not part of the work tree and are not archived by this skill.
- Never drop a decision or a gotcha to hit a length target. Drop process detail instead — acceptance criteria, test plans, implementation notes.
- Never re-archive an existing `kind: archive` record, or touch a pre-SDLC bulk import.
- Never invent a summary for a story whose file doesn't support one. If a constituent is thin, the record says so rather than filling the gap.
- Never rewrite git history to remove the old files. They stay reachable; the point is the working tree, not the history.

## What the operator decides

- Which epics to archive now versus leave
- Whether an orphan bucket is right, or those artefacts should stay individual
- Whether a task is "critical" enough to name, when it's borderline
- Whether to archive at all in a repo where the done tree is still small

## What this skill does without re-asking

Groups by lineage, reports the plan, and once the grouping is approved: reads every constituent, writes the records, verifies coverage, removes the replaced files, commits per epic, and refreshes STATE. The operator approves the grouping once; the rest is mechanical.
