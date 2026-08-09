# ri-skills

An opinionated [Claude Code](https://docs.claude.com/en/docs/claude-code) skill set for AI-native software development. Filesystem as source of truth, operator-grammar separated from engineering-grammar, ceremony proportional to risk. Built originally for [Reimagined Industries](https://reimaginedindustries.com); released under MIT in case it's useful.

Seven thin skills, loaded on demand. No 400-line spec document read every session.

## What this is

A working set of Claude Code skills encoding a specific opinion about how AI-assisted software development should work. Each skill covers one verb of the workflow: capture, compile, plan, execute, file, state, plus a tier-1 lite path. Two supporting sub-agents handle review.

The set was built for a solo operator (founder, AI-first) running multiple repos in parallel: a multi-agent simulation platform, a disclosure monitoring product, and a personal agentic OS. The pattern adapts to teams, but everything below assumes one human in the loop.

## The ethos

Most AI development setups suffer one of two failure modes. Either there's no structure at all (vibe coding goes off the rails in production) or there's so much structure that the model burns its budget reading the spec before doing any work. This set sits in the middle.

Five principles drove the design:

**Filesystem as source of truth.** No Linear, no Jira, no SaaS dashboard. Artefacts are markdown files with YAML frontmatter. Git history is the audit trail. State is derived from `/work/backlog/`, `/work/active/`, and `/work/done/` rather than tracked in a parallel system. Migrating to a different substrate would be mechanical, not a rebuild.

**Thin compile, grounded plan.** Compile produces operator-readable shape (outcome, scope, acceptance, standing gate). It refuses to invent engineering detail it hasn't grounded in source material. Plan reads the actual code before writing test specs and implementation notes. This stops the failure mode where compile generates 500-line stories full of confabulated function names and made-up test specifications.

**Operator-grammar separated from engineering-grammar.** Operator-facing fields (outcome, scope, acceptance, roadmap entries, status notes) use plain words about consequences. Engineering-grammar (test names, function signatures, field paths, schemas) lives in test specifications and implementation notes inside the artefact, below the fold. The operator reads the top; the model reads the rest.

**Ceremony proportional to risk.** Each repo declares its tier in `.ri/config.md`. Tier-1 (content scripts, low-stakes glue) gets the lite path: no artefact, no verifier, just do and commit. Tier-3 (load-bearing systems, public deployments) gets full rigor: tests-first, verifier mandatory, senior-staff review at planning events. Tier-2 sits between with operator-discretion on the heavier steps.

**Skills as progressive disclosure.** No monolithic spec gets loaded every session. Each verb lives in its own SKILL.md, loaded on demand when invoked. Cross-cutting behaviour (how to talk to the operator, when to /clear and /compact) lives in `~/.claude/CLAUDE.md`, the user-level file Claude Code reads every session. The tax on session start stays small.

## What's in the box

### Skills (`~/.claude/skills/`)

| Skill | What it does |
| --- | --- |
| `ri-capture` | Drops unstructured material into `/sdlc/raw/` verbatim. No shaping, no tagging, no frontmatter. |
| `ri-compile` | Turns raw material into a shaped artefact (epic, story, task, decision, runbook, strategy, architecture, or discard). Operator-grammar only; defers engineering detail to plan. Seeds the epic roadmap. |
| `ri-plan` | Breaks an active story into grounded tasks. Reads the actual code before writing test specs and implementation notes. Updates the epic roadmap with task one-liners. |
| `ri-execute` | Runs task chains. Tests first, implementation, verifier, commit, move to done. Handles autonomy levels (attended, review, auto) and multi-stack repos. At story close on a `security-gate: required` repo, runs the governance gate (`/security-review` + `/code-review`) over the story branch. |
| `ri-file` | Files session outputs back to `/sdlc/docs/` when work produced decisions, runbook updates, strategy shifts, or architecture facts. Refuses filler. |
| `ri-state` | Regenerates `/sdlc/STATE.md` from filesystem truth. Reads `/sdlc/OPEN.md` for the open question count. |
| `ri-archive` | Collapses `/sdlc/work/done/` into one record per closed epic, carrying the stories, the decisions that steered them, and the commits — then removes the files it replaced. Fired at epic close by `ri-execute`, or on demand when the done tree has outgrown itself. |
| `ri-do` | Tier-1 lite path. No artefact, no verifier, just execute and commit. Refuses tier-3 work without explicit override. |

### Sub-agents (`~/.claude/agents/`)

| Sub-agent | What it does |
| --- | --- |
| `verifier` | Fresh-context review of completed work. Reads spec, plan, and diff with no memory of how the implementation was built. Reports alignment, gaps, drift, smells. |
| `senior-staff-engineer` | Architectural review at significant planning events. Reads the artefact and the relevant code with fresh context. Reports top issues by impact. |

### User-level standing behaviour (`~/.claude/CLAUDE.md`)

The cross-repo, always-on rules. Covers how the operator wants to be talked to (architect altitude, not method-and-class detail), session hygiene (when to /clear, when to /compact), and navigation gotchas.

### Per-repo footprint

Small. The skills do the heavy lifting; each repo carries about 40 lines:

```
CLAUDE.md          # repo-specific context, points to user-level skills
.ri/config.md      # project name, tier, stacks, test commands, branch convention
/sdlc/
  raw/             # captured material, no rules
  work/
    backlog/       # shaped but not started
    active/        # things being worked on
    done/          # archived
  docs/
    decisions/     # ADRs
    runbooks/      # operational guides
    strategy/      # strategic positioning
    architecture/  # long-standing structural facts
  STATE.md         # current cursor, regenerated each session
  OPEN.md          # judgment queue, persistent
```

## Install

### 1. Get Claude Code

If you don't have Claude Code yet, [install it](https://docs.claude.com/en/docs/claude-code/setup). The skills require it.

### 2. Clone or copy this repo's `skills/` and `agents/` directories

```bash
git clone https://github.com/markstrefford/claude-skills.git
cd claude-skills

# the distributable set lives under ri-skills/
# user-level install (recommended)
cp -r ri-skills/skills/* ~/.claude/skills/
cp -r ri-skills/agents/* ~/.claude/agents/
```

The repo root also carries a live `sdlc/` instance and `.ri/config.md` — this set is dogfooded on itself. You only need the `ri-skills/` directory to install.

If you want to start with a subset, copy individual skills. Each is self-contained.

### 3. Add the standing behaviour to `~/.claude/CLAUDE.md`

```bash
cat ri-skills/user-claude-md-additions.md >> ~/.claude/CLAUDE.md
```

This is the always-on layer. Edit it to match how you actually want to be talked to. The defaults are operator-style (consequences over implementation detail) and assume you don't review code line by line.

### 4. Install the `cd` guard hook

```bash
mkdir -p ~/.claude/hooks
cp ri-skills/hooks/cd-repo-guard.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/cd-repo-guard.sh
```

Then register it in `~/.claude/settings.json` and reload — full merge command and verification in [`ri-skills/hooks/README.md`](ri-skills/hooks/README.md). The hook makes `cd` inside the current repo silent while `cd` outside it still asks, so you're told when Claude leaves the repo. It pairs with the Navigation guidance from step 3.

### 5. (Optional) Adjust the model pins

Every skill and sub-agent ships with a `model:` pin in its frontmatter, chosen to match the work: cheap models for mechanical verbs (`ri-capture` on haiku), the strongest for judgement-heavy ones (`ri-compile`, `ri-plan` on opus), mid-tier for review (`verifier` on sonnet). This is the main lever on token spend — routing reviews and mechanical work off the top model cuts cost by roughly 5x with no real quality loss.

To change one, edit the `model:` line in the relevant `SKILL.md` or agent file:

```yaml
---
name: verifier
description: ...
tools: Read, Grep, Glob, Bash
model: sonnet   # bump to haiku for maximum economy, or remove to inherit the session model
---
```

### 5. Initialise per-repo config

In each repo where you want to use the skills:

```bash
cd <your-repo>
mkdir -p .ri sdlc/raw sdlc/work/backlog sdlc/work/active sdlc/work/done sdlc/docs/{decisions,runbooks,strategy,architecture}
cp /path/to/claude-skills/ri-skills/examples/config-tier-2.md .ri/config.md  # or tier-1 / tier-3
```

Edit `.ri/config.md` to match the repo: project name, tier, stacks, test commands.

## Use

### Common flows

**Capture an idea, shape it, plan it, execute it:**

```
> capture this thought: we should add caching to the supply graph builder
[ri-capture writes /sdlc/raw/supply-graph-caching.md]

> compile that
[ri-compile proposes shape, you approve, generates story]

> plan it
[ri-plan reads the supply graph code, writes task sequence]

> go execute those tasks
[ri-execute chains through each task with verifier]
```

**Quick fix on a low-stakes repo:**

```
> just update the dependency version
[ri-do runs, commits, done]
```

**Resume work after a break:**

```bash
cat sdlc/STATE.md
# See where the cursor is, what's blocked, how many open questions
cat sdlc/OPEN.md  # if anything's pending your judgment
```

**Plan only the next story, not the whole epic:**

The compile produces the epic and seeds the roadmap with story one-liners. Each story stays as a roadmap entry until you're ready to work on it, then `ri-plan` fills in the task one-liners under that story.

### Triggering

The skills auto-trigger from natural language matching their descriptions. You don't need to remember slash commands. "Compile that note" hits ri-compile. "Run those tasks" hits ri-execute. "Capture this" hits ri-capture.

Slash commands work too if you prefer explicit: `/ri-compile`, `/ri-execute`, etc.

### The story-close governance gate

On a repo whose `.ri/config.md` carries `security-gate: required` (tier-3 by default), `ri-execute` runs a gate the moment a story's last task lands — before the branch goes near `main`. It reviews the whole story as one change, not task by task:

- `/code-review` runs over the story branch's full diff against `main`, always. `/security-review` runs too — but if the repo declares a `footprint:` map (see below), only when the story's changed files touch externally-deployed code. No map → it runs on everything, as before.
- Any scanners the repo declares run here too: `secret` scanners always (within a firing gate, regardless of footprint), `dependency`/`code` scanners footprint-scoped like the security review. A secret match blocks; a dependency/code finding blocks at high/critical and is advisory below; a scanner that can't run blocks rather than passing green.
- A security finding or a high-severity correctness bug **blocks**: the story isn't merge-ready, you're told now, and the fix becomes new task work (back through `ri-plan`).
- Cleanups and low-severity findings are **advisory**: logged to `OPEN.md`, tagged with the story id, and the chain continues.
- A clean run means merge-ready. The gate never merges and never marks the story done — that stays your call.

Drop the `security-gate` line from a repo's config to disable it.

### Tiers in practice

The default for an unconfigured repo is tier-3 (full rigor). Most repos genuinely sit at tier-2. A few content/glue repos sit at tier-1. Declare honestly. Over-engineering tier-1 work wastes tokens; under-engineering tier-3 work bites you in production.

### Landing work — branch, then merge

**No pull requests.** (Operator, 2026-08-09.) Review already happens in-session: senior-staff at plan, the verifier at execute, the governance gate at story close. The PR added no reviewer and no gate those three don't already provide, so it's gone at every tier.

Work still starts on a `feature/<name>` branch so `main` stays deployable, and a story close still runs `/code-review` and `/security-review` against that branch. What the PR *was* carrying — the durable audit trail — moves into git history: the **per-story governance-gate verdict is recorded in the story's close/merge commit** (a line or trailer: gate clean, or the findings). A repo that ships via semver releases also summarises it per story in the release notes at the tag.

Open a PR only when you specifically want the GitHub-side diff view, or when a change is unusually risky and you want it parked for eyes before it lands. That's a call you make, not one the workflow makes for you.

## Configure

### Per-repo `.ri/config.md`

```
project: my-project
default-rigor: tier-2
branch-default: story-level

stacks:
  backend:
    path: api
    test: pytest
  frontend:
    path: web
    test: npm test

# Optional invariants (advisory until wired into governance layer)
version-pairing: api/pyproject.toml and api/version.json carry the same semver
public-deploy: false
```

Single-stack repos can use a simpler form:

```
project: small-thing
default-rigor: tier-1
branch-default: main
test-command: pytest
```

On a `security-gate: required` repo you can optionally scope the security review by **footprint** — which code is externally reachable versus internal-only:

```
security-gate: required

footprint:
  internal:            # never externally reachable
    - tests/**
    - analysis/**
  deployed:            # externally reachable; /security-review required
    - api/**
    - web/**
```

At story close `/code-review` always runs; `/security-review` runs only when the story's changed files touch a `deployed` path. Most-specific rule wins (by path depth), an unmatched path counts as deployed, and **omitting the block runs the security review on everything, exactly as before** — it's optional and additive.

You can also declare **scanners** the gate runs at story close — each with a `command` and a `class`:

```
security-gate: required

scanners:
  - command: gitleaks detect --no-banner
    class: secret        # always runs; a match blocks
  - command: pip-audit
    class: dependency     # footprint-scoped; high/critical blocks, else advisory
    block-threshold: high # optional; default high
```

`secret` scanners always run within a firing gate; `dependency` and `code` scanners are footprint-scoped like the security review. A scanner that can't run blocks rather than passing green. The block is optional and additive — declare none and the gate behaves exactly as without it.

### User-level `~/.claude/CLAUDE.md`

This file is loaded in every Claude Code session across every repo. Keep it short. The shipped template covers:

- How to talk to you (architect altitude, not implementation detail)
- Session hygiene (when to suggest /clear, /compact)
- Navigation rules (don't ask permission for trivial cd operations)

Edit it to your taste. The point is to set the standing behaviour once, not in every session.

## What's parked

This set is deliberately incomplete. Things that aren't here and the reasons:

- **`ri-frame`** — loose start for big-shape work without raw material. Useful but most work flows through capture-then-compile. Add later if you find yourself wanting it.
- **`ri-morning`** — overnight summary skill. Only earns its keep when you're actually running unattended overnight sessions with an orchestrator like NanoClaw.
- **Cross-repo dashboard** — the "I'm juggling three repos and lost track" view. Genuinely useful but a separate piece of work outside the skill set.
- **Wider governance scanners** — the security gate at story close is now live (see below), orchestrating `/security-review` and `/code-review`. Still parked: wiring repo-declared dependency/secret scanners (npm audit, pip-audit, bandit, gitleaks) into the same gate, and enforcing the `version-pairing` / `public-deploy` invariants rather than just reading them.
- **Senior-staff-engineer split** — the current sub-agent does both lead-SWE and architect review. Splitting them into two more focused sub-agents would improve signal and let each use the right model.

## Possible improvements

Honest observations from running this set:

**Reduce skill weight.** The skills sit at 100-200 lines each. Some sections could be trimmed. Token economy compounds over many invocations.

**Better operator-grammar tests.** The "language test" is a self-check the model does. A separate small sub-agent that scans artefacts for jargon leakage would catch what the model misses.

**Roadmap rendering.** Currently you read the epic file to see the roadmap. A dedicated render skill that shows the roadmap with live status from the filesystem would help when juggling multiple lines of work.

**Per-stack tier override.** Currently tier is repo-wide with per-task override. A repo with a tier-3 backend and tier-1 frontend glue would benefit from per-stack defaults.

**Cross-agent compatibility (AGENTS.md).** A neutral file describing the conventions for any file-reading agent (Codex, other Claude variants, future entrants). Cheap to add when you actually have a second agent in the loop.

**Replay-style verification.** The verifier reads the diff. A deeper version could re-run the test specs against the implementation in a clean environment to catch flakes.

## Credits

This set draws on:

- **[Andrej Karpathy's wiki pattern](https://karpathy.bearblog.dev/the-llms-knowledge-base/)** — raw sources compiled by an LLM into structured artefacts, structure emerging from content rather than imposed upfront. The Compile verb adapts this from knowledge management to development work.
- **Karpathy's three-layer coding workflow** — tiered ceremony (vibe code for throwaway, augmented coding for production, context-loaded mode for hard problems). The tier system here is the same idea applied to repos rather than tasks.
- **[James Brawner's TLD-Skills / Offload Kit](https://github.com/Jbrawner/tld-skills)** — the file-first agent coordination pattern, skill-per-verb structure, AGENTS.md convention, Bus vs Vault split. Different decisions on substrate (filesystem vs Linear) but the structural debt is real.
- **[Anthropic's Claude Code primitives](https://docs.claude.com/en/docs/claude-code)** — skills, sub-agents, slash commands, hooks, CLAUDE.md auto-loading. The progressive disclosure design comes free; this set just opinionated it.
- **[Augment Code's Coordinator / Implementor / Verifier pattern](https://www.augmentcode.com)** — the fresh-context verifier idea.
- **Anthropic internal practice** — fresh-context PR review by a separate Claude instance.
- **Spec-Driven Development (arXiv 2602.00180)** — spec-anchored as the practical middle between vibe coding and full waterfall.

## License

MIT. See [LICENSE](LICENSE).

Use it, fork it, change it, build something better. If you do, a star on the repo is a useful signal for whether to keep iterating.