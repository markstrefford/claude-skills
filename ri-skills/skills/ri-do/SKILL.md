---
name: ri-do
description: Do a small, bounded change straight away with no artefact, plan or verifier, in a repo that uses the ri SDLC (has .ri/config.md). Use for tier-1 work and genuinely mechanical changes where the operator already knows what they want — /ri-do, or a one-shot request in such a repo.
model: sonnet
effort: medium
---

# ri-do

The lite execution path: do the work, commit, done. It exists because artefacts and verification are overhead when a mistake costs a rerun. That only holds while the rebuild cost is trivial, so the tier check is the whole safety mechanism.

Multi-step or load-bearing work, or work that needs grounding in unfamiliar code, goes to `ri-plan` (a story with structure) or `ri-compile` (raw material that needs shaping).

## Check the tier first

Read `.ri/config.md`. Ask: if this breaks, how expensive is the rebuild?

| Tier | Typical rebuild cost | ri-do |
| --- | --- | --- |
| 1 | Trivial — rerun the script, edit the doc | Default. Use freely. |
| 2 | Moderate — a user-visible regression, an afternoon to fix | Only for genuinely small mechanical tasks. If it touches several files in unrelated ways or carries architectural weight, push back: it is probably a story. |
| 3 | Severe — corrupted state, public outage, data loss | Refuse unless the operator explicitly overrides in this session: "This is a tier-3 repo. ri-do skips the plan and the verifier. Override, or take it through ri-compile / ri-plan?" |

No config: treat as tier 3 and ask before proceeding.

Whatever the tier, ri-do is not for architectural work, auth, payment paths, data writes that can't be rolled back, or public security surface. Those need the verifier, so they should be a story.

## Flow

1. **Confirm scope** in one sentence. If the instruction was clear, that line is enough and you proceed; if it was ambiguous, ask one question.
2. **Do the work.** No artefact in `/sdlc/work/`, no tests unless asked, no verifier or senior-staff review. If it turns out bigger than it looked — unrelated areas, an architectural choice, tests needed to be safe — stop and ask whether to back out and compile a story or proceed knowingly.
3. **Hold scope.** Anything else worth doing that you notice goes into a one-line file in `/sdlc/raw/`, not into this change. Mixing extras into the lite path is how a two-minute fix becomes an hour and the operator stops trusting it.
4. **Commit once**, with a message specific enough to find later: `content: update YouTube ingest to handle .webm files`. Tier 1 lands on `main` unless the operator asks for a branch. At tier 2, or on a tier-3 override, use a short-lived branch named for the change and merge it when done. With `landing: pull-request` at any tier, use the short branch and open a pull request instead of merging.
5. **Report in one line:** what changed and where it committed.
