---
name: ri-state
description: Regenerate /sdlc/STATE.md — the present-tense cursor of active focus, last completed, next, blockers, open-question count and hygiene flags — from the filesystem and git, in a repo that uses the ri SDLC. Use at session end, when another ri skill hands off at chain end, or when the operator asks "what's the state", /ri-state.
model: haiku
effort: medium
---

# ri-state

STATE.md is a snapshot, overwritten every run. It is derived, never remembered: if STATE and `/sdlc/work/active/` disagree, the filesystem wins, so regenerate rather than edit STATE to match a recollection. If you want to write something the filesystem doesn't support, it belongs elsewhere — a new artefact (compile it), a finished one (move it to done), or a question (`OPEN.md`).

`OPEN.md` is the judgment queue. This skill only counts it. Adding questions is done by the acting skills; resolving them is `ri-file`.

## Gather

1. List `/sdlc/work/active/`: each artefact's `kind` and `status`.
2. For each story or epic there, find its tasks (artefacts naming it as `parent:`); count active versus done, and note `status: blocked` with its `blocker:` text.
3. List `/sdlc/work/backlog/`: shaped, unstarted candidates for Next.
4. In `/sdlc/work/done/`, find the item with the latest `updated:` — the last completed.
5. Count entries in `/sdlc/OPEN.md` if it exists.

An empty active folder is an idle repo, which is a valid state.

## Write STATE.md

```markdown
# State — last updated <ISO date>

**Active focus:** <the story or task in flight; one line each if several>
**Last completed:** <id and one line>
**Next:** <id and one line>
**Blockers:** <one line per blocked artefact with its blocker, or "none">

**Open questions:** <count — see OPEN.md, or "none">
**Hygiene:** <N flags, or "clean">
```

- **Active focus** — the active story or task most recently updated; list all of them if several lines of work are running in this repo.
- **Next** — the next undone task in the active story, else the next story in the active epic's roadmap, else a shaped backlog item (starting it promotes it). Only if backlog is empty too: "operator's call".
- **Open questions** and **Hygiene** — counts only. The question text stays in `OPEN.md`; the flag detail goes in this run's output.

Every line is operator grammar, at the altitude of the epic roadmap: no method names, file paths or test names. A short **Notes** section is allowed for facts the next session needs that the filesystem can't show — a backup location, a pause and why, a cross-repo dependency. Keep the whole file to one screen; detail that doesn't fit belongs in an artefact.

## Hygiene audit

After deriving the cursor, look for neglect the operator would otherwise have to remember to check. Every flag is derived from files or git.

| Flag | Rule | Counts toward escalation |
| --- | --- | --- |
| Stale open question | `OPEN.md` entry dated more than 30 days ago | yes |
| Stalled active work | Artefact in active whose last commit (`git log -1 --follow -- <path>`) is more than 2 days old | yes |
| Stale backlog item | Backlog artefact more than 60 days old | no — advisory |
| Epic ready to close | An active epic whose roadmap stories are all in done | no — advisory; close it with `ri-execute` ("mark <epic> done") |
| Already-decided question | An `OPEN.md` entry whose wording reads as already resolved | no — advisory, model-judged |

Two caveats on the stalled flag, to state rather than hide: an artefact with no commit history yet (new, or just promoted) counts as fresh; and the check only sees the current branch, so work on an unmerged branch can look stalled from `main`, and open questions raised on an unmerged story branch aren't counted until it lands. Treat it as a nudge.

Thresholds are named defaults, easy to change. List flags in this run's output, one line each in operator grammar.

### When the audit holds a gate

How ri-state was invoked decides whether it reports or holds a gate, and that is carried by an explicit token, never inferred:

- **`report-only`** — a skill calling at its own end (`ri-compile`, `ri-plan`, `ri-execute`, `ri-file`, `ri-archive`) must say so; the token is required on every such hand-off. Report the flags and finish. This keeps authorised chains, including `auto` runs, moving.
- **No token** — a direct `/ri-state`, or any unknown caller. Report, and if the flags cross the threshold, hold an acknowledgement gate. Defaulting to the gate means a caller that forgets the token gets an over-cautious review, never a silently skipped one.

The threshold is crossed by five or more counting flags, or any single counting flag past a hard age: active work stalled more than 5 days, or an open question older than 90 days. Advisory flags never count, so whether a direct run blocks is reproducible.

The gate is conversational. STATE is still written and committed as normal; the run just isn't complete until the operator clears the flagged items (resolve questions through `ri-file`, move or unblock stalled work) or acknowledges them for this run. It never edits `OPEN.md`.

## Commit

STATE.md is doc-only and lands on `main` with no branch or review: `state: refresh <repo or focus>`. Commit it only when you are on `main`. On any other branch, such as at the end of a story's chain, write it and leave it uncommitted: a STATE commit on every story branch would conflict at each merge. The next refresh on `main` commits it. Each acting skill commits its own `OPEN.md` appends with its work, so don't sweep them up here. Leave `OPEN.md` in place even when empty, so the structure is the same in every repo.

With `landing: pull-request` in config, write STATE.md but don't commit it. That mode means nothing commits to `main` directly, and STATE is regenerated from the filesystem on every run, so nothing is lost by keeping it local. The repo should gitignore it.
