---
name: ri-archive
description: Collapse /sdlc/work/done/ from one file per task into one record per closed epic — its stories, critical tasks, steering decisions and commits — then remove the files it replaced, in a repo that uses the ri SDLC. Use when an epic closes, or when the done folder has grown past being readable — "tidy up done", /ri-archive <epic>.
model: sonnet
effort: high
---

# ri-archive

Per-task files are the wrong granularity for the audit trail. They accumulate without limit, get pulled into agent context, and clutter the tree, while what anyone needs later is coarser: what the epic was, what shipped, and why it went the way it did.

Closing individual tasks is `ri-execute`; filing decisions to `/sdlc/docs/` is `ri-file`.

## Gather

1. Read `.ri/config.md` for `project:`. If it is missing, infer it from existing frontmatter and say so.
2. List `/sdlc/work/done/`, noting each artefact's `id`, `kind`, `parent`, `children`, `updated` and any `commits:`.
3. List `/sdlc/work/active/` and `/sdlc/work/backlog/`. An epic with any descendant still there is not archivable — archiving it would strip live work of its context. Skip it and say why.
4. Leave alone anything already consolidated (`kind: archive`) and pre-SDLC bulk imports (`done-historical.md` and similar).

The working tree must be clean before you start, apart from an uncommitted `STATE.md`, so the deletions can be reviewed as one diff.

## Group

- **By epic.** Follow `parent:` up from each task and story. `parent:` is authoritative; fall back to the id prefix (`e02-s07-t21`) only when it is missing.
- **Orphans** with no epic ancestor go into one period record, `done/archive-<YYYY>-h<1|2>.md`, rather than a made-up parent.

An epic is archivable when it is `status: done`, every story in its roadmap has a file in `/sdlc/work/done/`, and so does every other descendant. A roadmap line with no story file is a story still to do. When invoked on a story branch, a story in done on `main` counts too: it may have landed after the branch was cut.

Report each archivable epic with the number of files it would replace, and each skipped epic with the reason. The operator approves the grouping — whether to archive now, whether the orphan bucket is right, whether the done tree is even big enough to bother — before anything is written.

## The record

One file per epic, about a screen long however many files it replaces; if it runs past two screens it is carrying detail that should have gone.

- **The epic** and that it closed, with the span from first created to last updated.
- **Its stories**, a heading each, with what it delivered in two or three sentences of operator grammar.
- **Critical tasks only**: those that changed direction, took several attempts, or carry a fact worth grepping for. A task that went in cleanly gets no line; its commit is its record. Ask the operator about borderline ones.
- **The decisions that steered it, and why** — the most important part. Anything that reversed a position, ruled an approach out, or would surprise someone reading the code later.
- **Gotchas** — data identity traps, environment quirks, anything that bit twice.
- **Commits** — the final merge per story is enough. A story not yet merged (when this runs at epic close) is recorded by its branch name.

Leave out acceptance criteria, test plans, implementation notes, out-of-scope sections and per-task narrative; they served the live work. When trimming for length, drop process detail, never a decision or a gotcha. If a constituent is too thin to summarise, say so rather than invent a summary.

```yaml
---
id: <epic-id>
kind: archive
project: <from config>
status: done
replaces: [<id of every consolidated artefact>]
span: 2026-05-05..2026-08-08
created: <the epic's original created date>
updated: <today>
tags: [<union of the constituents' tags>]
---
```

`replaces:` keeps every old id greppable after its file is gone.

## Flow

1. Group and report, then get approval on the grouping.
2. Write each record from the full text of every constituent — the decisions are in the bodies, not the ids and headings.
3. Verify: every constituent id is in `replaces:`, and every decision in a constituent body is in the record or was dropped on purpose.
4. Only then remove the consolidated files, with `git rm` (or `rm` then `git add -A` for untracked files). Writing first and deleting second is what makes the collapse safe.
5. Commit once per epic, naming the epic and how many files it collapsed. When `ri-execute` invoked this at epic close, commit on its story branch, so the record lands with the story. Otherwise commit on `main`, or with `landing: pull-request` in config, on a short `sdlc/archive-<epic>` branch opened as a pull request.
6. Refresh STATE through `ri-state` in `report-only` mode, once, at the end — unless `ri-execute` invoked this at epic close, in which case it refreshes STATE at the end of its chain.

## Boundaries

- `/sdlc/docs/` is out of scope: ADRs, runbooks, architecture and strategy aren't part of the work tree.
- Never rewrite git history to remove the old files. The point is a readable working tree; the history stays.
