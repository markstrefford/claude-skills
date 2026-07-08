# Open — judgment queue

Live questions for the operator — only unresolved ones live here. Each is one per
line, tagged with the work it gates and the code module(s) it touches
(`[<work-id>] [area: <module(s)>]`). The acting skills (ri-compile / ri-plan /
ri-execute) append questions; `ri-file` removes one when it is resolved (its
resolution flow). A resolved question never lingers.

- 2026-06-06 Where should the autonomy gate's common behaviour live, given the skills are self-contained today — duplicated into each acting skill, or a shared section in the user-level CLAUDE.md template? Decide before s01 builds. [e01-sdlc-autonomy-additions] [area: ri-compile, ri-plan, ri-execute, ri-do, user-claude-md-additions]
- 2026-06-06 Which of Jiri's tier-3 hygiene items actually have a home in the current system (per-project memory snapshots, feedback memories, dormant-skill /plugin audits) and is the `document` verb real or to be created — confirm before grounding s03/s04 rather than building machinery that doesn't exist. [e01-sdlc-autonomy-additions] [area: ri-file, ri-state]
- 2026-06-06 The full hard-stop list was deferred to the PR diff and isn't in the raw note; recover it before s01 plans, or the gate ships with an incomplete set of always-escalate conditions. [e01-sdlc-autonomy-additions] [area: ri-compile, ri-plan, ri-execute, ri-do]
