---
id: e02-s04-t1-hygiene-audit
kind: task
project: claude-skills
status: active
autonomy: attended
parent: e02-s04-hygiene-audit
created: 2026-07-08
updated: 2026-07-08
---

## Outcome

ri-state runs a hygiene audit at state refresh that flags neglect across the
stores, derived from the filesystem and git.

## Decisions in plain terms

Implements the audit half of the epic's forcing function
(`docs/decisions/sdlc-store-lifecycle.md`). The one choice it embodies:
**staleness of active work is judged by commit history, not by the `updated:`
frontmatter field** — because an artefact's `updated:` can be fresh while no real
work has happened, so commit recency is the honest signal.

## Acceptance

- ri-state gains a hygiene-audit step that flags, each derived from the filesystem
  or git (never invented):
  - open questions older than the stale threshold with no update;
  - open questions whose text reads as already-decided (a resolved item that never
    drained — the "we decided X" tail);
  - active work that has stalled — the most recent commit touching the artefact
    (on the current branch) is older than the stalled threshold, judged from git
    history with `git log -1 --follow` so the signal survives the backlog→active
    `git mv`. An artefact with no commit history yet (freshly created/promoted) is
    treated as fresh, not stalled. The signal is relative to the current branch —
    ri-state cannot see commits on branches it isn't on, and this limitation is
    stated plainly rather than papered over;
  - backlog items older than the backlog-stale threshold.
- Thresholds are stated as named defaults in the skill (proposed: open question
  stale > 30 days, active stalled > 14 days, backlog stale > 60 days) and are
  documented as easy to change.
- The audit produces a short hygiene list reported to the operator; STATE itself
  gains at most a one-line hygiene pointer (count), staying within its length rule.
- The audit reads git history for staleness — a capability ri-state does not have
  today (it derives from `updated:` fields only).
- Canonical and installed ri-state copies are identical.

## Test specification

Instruction-file change; verify by coherence inspection:

- ri-state has a hygiene-audit step listing the four flag types, each tied to a
  filesystem or git signal.
- The stalled-active check explicitly uses commit history, not `updated:`.
- Thresholds appear as named, changeable defaults.
- The audit's output is a reported list plus at most a one-line STATE pointer; the
  under-30-lines and operator-grammar STATE rules are preserved.
- This task adds only the audit (the flags); the block-vs-report escalation and
  source-awareness are t2 — do not add blocking behaviour here.

## Implementation notes

Edit `ri-skills/skills/ri-state/SKILL.md` (canonical), then cp to install (parity):

- Add a "Hygiene audit" step to the read/derive flow. It runs after the stores are
  read. For each flag type, name the concrete signal: OPEN entry date vs threshold;
  OPEN entry wording heuristic for already-decided (advisory only — see t2, it never
  drives blocking); per active artefact, `git log -1 --follow -- <path>` on the
  current branch vs the stalled threshold, with no-history treated as fresh; backlog
  entry age vs threshold.
- Do not reference a "story branch" — there are no per-story branches (work is on
  per-epic/feature branches), and ri-state often runs on `main` where it cannot see
  unmerged branch commits. State the branch-relative limitation of the stalled
  signal honestly; do not invent branch discovery.
- State thresholds as named defaults near the audit, and note they can be tuned
  (leave the config-surface question — hardcoded default vs `.ri/config.md` field —
  for the operator; default to documented-in-skill for now).
- Output: a short "Hygiene" list in the ri-state run output; in STATE.md, at most a
  one-line pointer (e.g. "Hygiene: N flags — see run output"), never the full list,
  to keep STATE within its length discipline.
- Do NOT add blocking or source-awareness here — t2 owns that. This task makes the
  audit exist and report.
- Keep the audit derived-not-invented, consistent with ri-state's anti-drift rule.

## Status

active
