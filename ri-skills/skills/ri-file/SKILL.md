---
name: ri-file
description: File session outputs back to /sdlc/docs/ when work produced architectural decisions, runbook updates, strategy shifts, or architecture facts worth keeping. Distinct from ri-compile (which transforms raw material into shape); this skill captures emergent outputs from a working session and turns them into doc artefacts. Triggers on explicit slash command (/ri-file), end-of-session prompts ("anything to file", "file the outputs"), references to writing it up ("write up the ADR", "capture that decision"), or invocation by other skills at chain end. Use this skill whenever a session has produced durable knowledge that doesn't yet have a home.
model: sonnet
---

# ri-file

Turns session outputs into doc artefacts. ADRs, runbook updates, strategy shifts, architecture facts. The compounding layer of the SDLC — what makes one session useful to the next.

## When to run this

A session has done work and produced something worth keeping beyond the artefacts in `/work/`. Examples:

- "File the outputs"
- "Write up that decision as an ADR"
- "Anything worth filing from this session?"
- "/ri-file"
- Called at chain end by `ri-execute` or `ri-compile` when those skills touched filing-relevant material

If nothing's worth filing, this skill says so and does nothing. Don't write filler.

If the operator wants to compile raw material into shape, that's `ri-compile`, not this. This skill captures what emerged during a session, not what arrived as input.

## Read the repo config first

Open `.ri/config.md`. The fields that matter:

- `project` — used in frontmatter
- `default-rigor` — informs whether filing is even worth doing for this repo

On tier-1 repos, filing is usually skipped. Quick scripts don't generate ADRs or runbook updates. If the session was a one-off tier-1 fix, the answer to "anything to file?" is almost always no.

## The file flow

### 1. Identify what's worth filing

Scan the session for filing-worthy outputs in five categories:

- **Architectural decision.** A choice was made between concrete options that affects future work. Examples: chose Postgres over SQLite, picked event-driven over direct calls, deferred a feature with a clear rationale.
- **Runbook update.** An operational procedure ran, succeeded or failed in a notable way, and the next person needs the knowledge. Examples: deployment steps that diverged from docs, a recovery procedure that worked, a new monitoring check that's now part of the rotation.
- **Strategy shift.** The project's direction or positioning changed in a way that affects scope or priorities.
- **Architecture fact.** A long-standing structural truth surfaced or was clarified. Examples: module boundary documented, contract between services pinned, data flow mapped.
- **Spec divergence.** What got built differs from what the story spec said. The story spec gets updated to match reality.

If none of these apply, stop. Report "nothing to file" and update STATE.

Filler outputs to refuse:
- Restating what's already in commit messages
- Recapping what the artefact already says
- Generic observations that don't change future work
- ADRs for trivial decisions (renaming a variable is not an ADR)

### 2. Propose the filing outputs

Before generating any content, list what you'd file and where:

> - Architectural decision → `/sdlc/docs/decisions/<NNNN-slug>.md` because <one-line reason>
> - Runbook update → `/sdlc/docs/runbooks/<existing-name>.md` adding section X
> - Spec divergence → update `/sdlc/work/active/<story-id>.md` outcome from X to Y

Wait for operator approval. The operator may add, remove, or redirect. Don't generate content until shape is approved.

### 3. Generate the artefacts

For each approved item, generate the right structure:

**Architectural decisions (ADRs):**

```yaml
---
id: <NNNN-slug>           # sequential numeric prefix per repo's docs/decisions/
kind: decision
project: <from config>
sources: [<where this came from — task id, story id, raw note, session>]
created: <today>
updated: <today>
verified-on: <today>
---
```

Body:

```markdown
# <Title in operator-grammar>

## Status
Accepted

## Context
<What was the situation. Operator-grammar. The decision made sense because of these surrounding facts.>

## Decisions in plain terms
<The lead section. Each decision as one line: the call plus its consequence, in
operator/architect grammar — never method names, schema fields, or phase slots.
A single-decision ADR is one line; a multi-decision ADR is one line per decision
(D1..DN), in the same order as the engineering detail below. This section leads
so the ADR reads at architect altitude before any code-level detail. Example:
"Read the shocks already in the config; don't redesign the format - cheap and
safe, and the real calibrated events finally render as timeline markers.">

## Decision(s)
<The engineering detail, grounded in the code/data. One ## Decision section for
a single call, or ### D1..DN subsections for a multi-decision ADR. State what
was chosen, not every alternative.>

## Consequences
<What changes downstream. What this commits us to. What it rules out. What still depends on follow-up.>

## Alternatives considered
<If meaningful, the options that weren't chosen and why. One paragraph each, no more.>
```

The Context, Decisions-in-plain-terms, and Consequences sections are
operator-grammar — they explain the trade-off at architect altitude. The
engineering detail lives only in the Decision(s) and Alternatives sections, below
the plain-terms lead. The plain-terms section is not optional: a decision record
only a developer can parse has failed at being a record. The test is whether the
operator, reopening it cold months later, knows what was decided and why without
reading the engineering detail.

**Runbook updates:**

If updating an existing runbook, read it first to match its style and format. Add the new section at the appropriate place. Update the runbook's `verified-on:` field to today.

If creating a new runbook, use this shape:

```yaml
---
id: <slug>
kind: runbook
project: <from config>
sources: [<where this came from>]
created: <today>
updated: <today>
verified-on: <today>
---
```

Body: title, when this runbook applies, the procedure as numbered steps, what success looks like, what failure looks like, escalation if it fails.

**Strategy entries:**

Narrative paragraphs explaining the strategic position. Operator-grammar throughout — this is the kind of doc Mark will read months later and need to understand without code context. Frontmatter same shape as runbook but `kind: strategy`.

**Architecture entries:**

A structural fact about the system. Often a diagram description in prose, plus the consequences for future work. Frontmatter `kind: architecture`.

**Spec divergence updates:**

Open the story spec in `/work/active/`. Update the Outcome, Acceptance, or whichever section diverged. Add a note in the story body: `## Divergence from compile <today>` with a one-paragraph explanation of why what got built differs from what was specified.

### 4. Co-located drafts during in-flight epics

If an epic is in flight in `/work/active/`, drafts of architecture, decision, runbook, or strategy artefacts produced as part of that epic cluster alongside the epic in `/work/active/`, not in `/docs/`. They move to `/docs/<right-folder>/` when the epic moves to `/work/done/`.

If you're filing during an active epic, check whether the output should be co-located (during epic) or in /docs/ (post-epic). When uncertain, co-locate — moving later is cheap, separating across folders mid-epic is friction.

### 5. Commit

One commit per session of filing, atomic. Commit message names what was filed: `file: 0042-postgres-over-sqlite ADR, runbook deploy-checklist update`.

Doc-only changes to `/docs/` land directly on `main`. Spec divergence updates to `/work/active/` artefacts also land on `main` when they're doc-only.

### 6. STATE update

Hand off to `ri-state` at the end. The newly filed artefacts will appear in the next STATE regeneration.

## Tier sensitivity

**Tier 1:** Filing is usually skipped. Quick scripts don't produce ADR-worthy work. If the operator explicitly asks to file something from tier-1 work, do it, but default to "nothing to file."

**Tier 2:** Selective filing. ADRs for real architectural choices, runbook updates for operational learnings. No filler.

**Tier 3:** Active filing. Architectural choices on tier-3 are load-bearing and should produce ADRs. Operational learnings on public-deploy services should produce runbook updates. Strategy shifts get captured. The compounding effect matters most at this tier.

## Hard rules

- Never file filler. If nothing was decided, learned, or shifted, write nothing.
- Never duplicate content already in commit messages, task artefacts, or story specs.
- Never write an ADR for a trivial decision. ADRs are for choices that affect future work.
- Never let operator-grammar leak below architect altitude in Context, Decision, or Consequences. Implementation detail belongs in Alternatives or stays out.
- Never record an ADR's decisions without a plain-terms lead — each decision as call + consequence, one line, operator-grammar, before any engineering detail. A multi-decision ADR (D1..DN) gets one plain-terms line per decision. A decision record only a developer can parse has failed at being a record.
- Never edit `CLAUDE.md`, `~/.claude/CLAUDE.md`, or any `.ri/config.md` without explicit operator approval. These encode opinions and must sound like the operator.
- Never put strategy or architecture facts directly in `/docs/` if the originating epic is still in `/work/active/`. Co-locate first, move at epic close.
- Never edit an artefact's `id` field once written.

## What the operator decides

- Whether each proposed filing is worth doing
- Whether to merge, split, or redirect the proposed outputs
- Final approval before file moves and commits
- Whether a spec divergence is genuine (and the spec updates) or a mistake (and the build gets reworked)
- Any CLAUDE.md or config update — the skill drafts, the operator approves and edits

## What this skill does without re-asking

Scans the session for filing-worthy outputs, proposes shape, generates artefacts on approval, handles co-location for in-flight epics, commits, hands off to ri-state. The operator approves the shape and the substance; the file moves are mechanical.
