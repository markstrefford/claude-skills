# Changelog

## 2.4.0 — 2026-10-26

- New `security-reviewer` agent, on Sonnet. In plan mode it names the threats a sensitive story's plan must answer, and they become tasks and test cases. In checklist mode it reviews a change against the OWASP Top 10:2025, API Security Top 10 (2023) and LLM Top 10 (2025), reporting every category.
- Security is checked at plan time for sensitive stories, per task by the verifier, at story close, and at epic close across the epic's combined change. The epic review is always the checklist and never blocks.
- `security-gate` takes `required`, `advisory` or `off`, defaulting by tier: tier 3 required, tier 2 advisory, tier 1 off. **Behaviour change:** without the key, tier-3 repos, and repos with no config (which run as tier 3), now get a blocking gate where they had none, and tier-2 repos get advisory reviews.
- New `security-review: owasp | full`. `owasp` runs the checklist; `full` adds `/security-review` at story close. The default is `full` at tier 3 and `owasp` otherwise.
- `docs/governance.md` states the limits of the security reviews: what they don't see, where they depend on judgment, and what covers each gap.
- The verifier checks for security smells. One with a plausible path from outside input fails the task.

## 2.3.0 — 2026-10-26

### Skills
- Rewritten to give reasons instead of restated rules: about 40% shorter, with descriptions scoped to repos that use the SDLC.
- Each skill and agent pins a model and effort level for cost routing. `ri-state` and `ri-capture` run on Haiku.
- `ri-archive` is new: it collapses a closed epic's done files into one record.

### Done and closing
- Tasks, stories and epics have defined done conditions, and every move to done is committed with its work.
- A story closes as soon as its last task is done, so a chain covering several stories closes each one in turn.
- Story close runs in order: gate, story done, epic close and archive, filing, then landing. The archive record and filed docs travel with the story.
- An epic closes only when every story on its roadmap is done. Stories that already landed on `main` count.
- Under `autonomy: auto`, archive and filing are queued in `OPEN.md` instead of waiting for approval, so an unattended chain still lands.
- "Mark X done" applies the same checks and commits on the right branch.

### Landing and branches
- New `landing: merge | pull-request` config switch. The default, `merge`, keeps the previous behaviour.
- Under `pull-request`, a story stays on one branch from compile to pull request. Other doc changes go on short `sdlc/` branches.
- Tier-1 repos with `branch-default: main` commit straight to `main` again. The gate reviews the story's own commits.
- The gate verdict is recorded in the story's done commit. It is offered as the merge message, or written into the PR body under `pull-request`.

### State and open questions
- `STATE.md` is committed only on `main`, and never under `pull-request`, so story branches don't conflict on it.
- Open questions commit with the work that raised them, and `OPEN.md` merges by union. The docs note its limits.
- `ri-file` and `ri-archive` run the state hygiene check report-only. A new advisory flag catches epics that are ready to close.

### Verification
- At tier 2, a task without a test spec runs without tests-first and is still verified. Only tier 3 requires a spec.
- The verifier no longer fails a task because its tests couldn't run.
- The story-close code review runs at a fixed depth.

### Packaging and docs
- Packaged as a Claude Code plugin with a marketplace in this repo. The cd guard hook is opt-in under the plugin.
- Documentation moved out of the README into `docs/`, with process diagrams and an illustrative page on where Jira would fit. The skills have no Jira behaviour.
- LICENSE added. Example configs fixed and given the `landing` key.

## 2.2.0 — 2026-07-09

- Footprint-scoped security review: `/code-review` always, `/security-review` only when a story touches deployed code.
- Declared scanners at the story-close gate: `secret` always, `dependency` and `code` footprint-scoped; a scanner that can't run blocks.

## 2.1.0 — 2026-07-09

- Backlog stage between raw and active.
- Decisions record with code-module `area` tags.
- `OPEN.md` judgment queue, drained by `ri-file`.
- `ri-state` hygiene audit, gating only on a direct run.
- Questions and decisions surfaced by code module when work starts.
- `cd-repo-guard` hook.

## 2.0.0 — 2026-06-06

- The ri SDLC as a skill set: capture, compile, plan, execute, file, state, do, with the verifier and senior-staff agents.
