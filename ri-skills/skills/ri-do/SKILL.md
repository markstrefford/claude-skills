---
name: ri-do
description: Execute one-shot work without ceremony. No artefact, no plan, no verifier. The tier-1 lite path for content scripts, glue code, doc fixes, quick mechanical changes — anywhere the rebuild cost is trivial and the operator already knows what they want. Triggers on explicit slash command (/ri-do), one-shot phrasing ("just do this", "quick fix", "make this change", "small edit"), or natural language signalling a bounded mechanical task in a tier-1 repo. Use this skill whenever the operator wants something done now and the work is small enough that artefacts and verification would be overhead. Don't ask which verb to use, run.
model: sonnet

---

# ri-do

The minimum-viable execute path. Skip the artefact, skip the verifier, do the work, commit, done. Tier-1's default execution mode.

## When to run this

The operator wants something done now and the work is bounded, small, and mechanical. Examples:

- "Quick fix: change the YouTube ingest path to handle the new file format"
- "Update the README with the latest setup steps"
- "Just bump the version in package.json"
- "/ri-do clean up the old log files in the cron output folder"
- A tier-1 repo and the request is a single change with no architectural weight

If the work is multi-step, load-bearing, or needs grounding against unfamiliar code, this is the wrong skill. Hand off to `ri-plan` (for stories with structure) or `ri-compile` (for raw material that needs shaping).

## Read the repo config first

Open `.ri/config.md`. The tier matters more for this skill than for any other:

- **Tier 1:** Default behaviour, use freely.
- **Tier 2:** Acceptable for genuinely small mechanical tasks. If the work would touch multiple files in unrelated ways, or has architectural implications, push back: this is probably a story, not a do.
- **Tier 3:** Refuse by default. Tell the operator: "This is a tier-3 repo. ri-do skips the verifier and the plan step. Want to override (set per-task autonomy and proceed) or take it through ri-compile or ri-plan?" Don't proceed without explicit override.

If `.ri/config.md` doesn't exist, default to refusing — operator confirms before this skill runs.

## The flow

### 1. Confirm the scope

State back what you're about to do in one sentence. If the operator's instruction was already crystal clear, this is one line and you proceed. If there's ambiguity, ask one question, then proceed.

### 2. Do the work

Make the change. Write the code, edit the doc, run the command, whatever the operator asked. No artefact in `/work/active/`. No test spec unless the operator explicitly asks for tests. No verifier invocation.

If you discover the work is bigger than it looked (touching unrelated areas, requiring architectural choices, needing tests to be safe), stop and report:

> This is larger than a ri-do task. Want to back out and compile a story, or proceed and accept the ceremony skip?

The operator decides. Don't silently expand scope.

### 3. Handle scope creep

If you notice things that would also benefit from changing (refactors, related fixes, "while I'm here" improvements), do not include them. Capture them as a one-liner in `/sdlc/raw/` via `ri-capture` style — a single file describing what you noticed — and finish what was asked.

The operator can compile those into proper work later. Mixing scope into a ri-do task is how trivial fixes become hour-long sessions and how trust in the lite path breaks down.

### 4. Commit

One commit, meaningful message. No task id (there's no task), but the message should be specific enough to find later:

```
content: update YouTube ingest to handle .webm files
docs: README setup steps for the new dev container
deps: bump axios to 1.7.4 for CVE fix
```

Tier-1 repos: land directly on `main`. No branch unless the operator asks for one.

Tier-2 repos (the override case): cut a short-lived branch named for the change, merge when done.

### 5. Report

Single line. What was done, where it committed. No long summary. The operator can read the diff if they want detail.

> Updated `pipelines/youtube_ingest.py` to detect .webm. Committed to main.

## Tier sensitivity (the whole point)

This skill exists for tier-1. The whole guard is in step "Read the repo config." If you ever find yourself running ri-do on tier-3 work without explicit override, something has gone wrong.

The mental check: "If this breaks, how expensive is the rebuild?"

- Trivial: rerun the script, edit the doc, redeploy a container. Tier-1, ri-do is fine.
- Moderate: a feature regressed, users see it, fix takes an afternoon. Tier-2, push back.
- Severe: state corruption, public outage, data loss. Tier-3, refuse.

## Hard rules

- Never use ri-do for architectural work, auth changes, payment paths, data writes that can't be rolled back, or anything touching public security surface.
- Never use ri-do on tier-3 work without explicit operator override in this session.
- Never silently expand scope. Capture extras to raw and finish what was asked.
- Never run the verifier or senior-staff sub-agent from this skill. If they're needed, this should have been a story.
- Never create artefacts in `/sdlc/work/active/`. If the work warrants an artefact, this should have been ri-compile or ri-plan.
- Never commit without a meaningful message.

## What the operator decides

- Whether the work is genuinely ri-do scope or should be promoted to a story
- Whether to override the tier-3 refusal
- Whether captured scope-creep observations are worth compiling later

## What this skill does without re-asking

Confirms scope in one sentence, does the work, commits, reports. The operator already said what they wanted; the skill just runs it.
