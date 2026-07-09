---
name: ri-compile
description: Compile raw material from /sdlc/raw/ (or pre-existing legacy notes) into a shaped artefact (task, story, epic, decision, runbook entry, strategy, architecture, or discard) in a Reimagined Industries repo. Triggers on explicit slash command (/ri-compile), references to raw files ("compile that note", "what should I do with raw/X.md", "make that into a story"), or natural language signalling the user wants raw material shaped ("triage the raw folder", "process this idea I dropped in"). Produces thin, operator-readable artefacts grounded in the source material — never confabulates engineering detail to fill template sections. Use this skill whenever the user wants raw material moved into shape. Don't ask which verb to use, run.
model: opus

---

# ri-compile

Transforms raw material into shaped artefacts. The output is operator-readable, source-grounded, and thin — engineering grammar is deferred to Plan, not invented at compile time.

## When to run this

The operator references raw material (a file in `/sdlc/raw/`, a legacy note, a chat snippet) and wants it shaped into something the workflow can act on. Examples:

- "Compile `raw/moltbot-idea.md`"
- "What should I do with that note about CONSTELLATION pricing?"
- "Triage the raw folder"
- "Turn this Slack message into a story"
- "/ri-compile raw/agent-os-roadmap.md"

If the operator is asking to execute work, this is the wrong skill — hand off to `ri-execute`. If they're asking to capture raw material without shaping it, hand off to `ri-capture`.

## Read the repo config first

Before touching anything, read `.ri/config.md` at the repo root. Fields that matter:

- `default-rigor: tier-1 | tier-2 | tier-3` — sets ceremony level
- `project: <name>` — used in the artefact's `project:` frontmatter field

If `.ri/config.md` doesn't exist, default to tier-3 and warn the operator.

For tier-1 repos (content pipelines, low-stakes scripts), most raw material doesn't need full compile. Propose `discard` or "just do it via `ri-do`" liberally. Compile is for work that needs shape, not for everything.

## The compile flow

### 1. Read all the source material

Open every file the operator named. Read the whole thing. If they referenced "the raw folder," `ls` it and read each file. Don't compile from a summary or from memory — compile from what's actually there.

If the operator referenced legacy notes (pre-SDLC backlogs, changelogs, scratch docs in unexpected locations), treat those the same as `/sdlc/raw/` content.

### 2. Propose the output shape

Before writing any artefact content, decide what each piece of raw material should become and propose it to the operator. The valid outputs:

- **task** — one commit's worth of work (rare from raw; usually emerges via Plan)
- **story** — one coherent change worth specifying
- **epic** — one strategic commitment with multiple stories under it
- **decision** — an ADR; goes to `/sdlc/docs/decisions/`
- **runbook entry** — operational guide; goes to `/sdlc/docs/runbooks/`
- **strategy entry** — strategic positioning; goes to `/sdlc/docs/strategy/`
- **architecture entry** — long-standing architectural fact; goes to `/sdlc/docs/architecture/`
- **addition to existing** — append to an existing artefact, link source
- **discard** — not worth shaping; the thought has served its purpose

A work item (task, story, or epic) is routed by whether the operator is starting it now: to **active** (`/sdlc/work/active/`) if work begins now, or to **backlog** (`/sdlc/work/backlog/`) if it is shaped but not yet started. Backlog is the home for shaped-but-unstarted work so it neither lingers in the capture zone nor gets forced prematurely into active. A backlog item has a defined way out — starting work on it promotes it to active (owned by `ri-plan`).

**Drain invariant:** every shaped item leaves the capture zone for exactly one home — docs, backlog, active, or discard. Nothing shaped stays in `/sdlc/raw/`. This is per-item: un-shaped captures may still wait in raw for a later pass (the inbox model is preserved); the rule is that no item you have shaped is left behind there.

Present the proposal as:

> Raw file `<path>` → propose **<shape>** because <one-line reason>.

For multiple raw items, list them all with proposed shapes. Wait for operator approval (or edits) before generating any content. This is the highest-leverage step — getting shape right at this point prevents wasted compile work.

**When proposing an epic, also propose its story breakdown.** Epics need a roadmap, and the roadmap needs to be approved at shape time, not invented after. Format:

> Raw file `<path>` → propose **epic** with these stories:
> - s01 — <one-line outcome>
> - s02 — <one-line outcome>
> - s03 — <one-line outcome>

The operator approves both the epic and the story sequence. If the story breakdown changes during approval, that's fine — the roadmap reflects the final approved shape. The point is the operator doesn't see an epic land with a story list they didn't sign off on.

Stories under a proposed epic don't get separate artefact files at compile time. They exist as one-liner entries in the epic's roadmap until each one is compiled individually (or until the operator asks to break them out as separate story artefacts now).

**Number the epic and its children.** A new epic gets a sequential two-digit number with a readable name: `e<N>-<name>` (e.g. `e01-governor-foresight`), assigned at compile time as the next unused epic number in the repo. Stories and tasks under it drop the long epic-name prefix for the compact number — story `e<N>-s<M>-<slug>`, task `e<N>-s<M>-t<K>-<slug>` (`s<M>` two digits, `t<K>` one). The number keeps two concurrent epics from colliding on `s01/s02` and makes parentage and ordering visible at a glance. Number new epics going forward; pre-existing name-based epics (`epic-<name>` with `<name>-s<N>` children) are **not** renumbered until they are done — the scheme is deliberately mixed in the interim.

### 3. Generate the artefact, thin

Once the operator approves the shape, generate the artefact. The rules:

**Body structure for `task`, `story`, `epic`:**

1. **Executive summary** — what the work is, why now, what it doesn't change. 30-second read.
2. **Outcome** — named items the work delivers.
3. **Out of scope / carry-forward** — what this work explicitly doesn't touch.
4. **Standing gate** — architecture, extraction, downstream consumers. One paragraph or "none".
5. **Acceptance** — high-level criteria.
6. **Status** — where in the workflow this artefact sits (compile, planning-review, approval, execution).

**Epics carry one additional section: the Roadmap.** This is the ordered list of stories under the epic, each as a one-liner in the sequence they're meant to land. It's the authoritative answer to "what builds what, in what order" for the lifetime of the epic. Format:

```markdown
## Roadmap

- s01 — wrap the MCP bridge with guardrail enforcement
- s02 — write the judgment runner replacing the scheduler
- s03 — retire legacy scheduler and template files
- s04 — pin the build clean and rotate the Notion token
```

At compile time the roadmap is story one-liners only — tasks don't exist yet. When `ri-plan` runs on each story it appends the task one-liners under that story's line. Status doesn't get written into the roadmap; it's read live from the filesystem when rendered.

The roadmap is operator-grammar, same altitude as the Outcome line. No method names, no file paths, no test names. The operator should be able to scan it and see the shape of the work without thinking about implementation.

**Every operator-facing field is operator-grammar.** Not just Outcome. Status notes, scope statements, acceptance criteria, gate notes, roadmap entries — all operator-grammar. The operator should be able to read the whole artefact without encountering function names, file paths, test names, schemas, or implementation jargon.

**What does NOT go in any operator-facing field:**

- Test names or test specifications
- Function signatures or pseudo-code
- Field paths, schema sketches, exact validation paths
- ADR questions framed against specific code lines or modules you haven't read
- Implementation grammar of any kind
- Enumerated lists of "things Plan needs to ground" that name those things in implementation terms

Status note examples:

> Bad: "compile done. Plan should ground the runner spawn flags, the wrapped-bridge call sites, and the legacy retirement against the actual code in src/ before execution."

> Good: "compile done. Plan reads the code before writing tasks."

Same handoff. Plain words. No leaked jargon.

If you find yourself reaching for any banned item to fill a field, stop. That detail belongs in Plan, when the story is active and the code can be read. At compile time, leave a placeholder:

> ### Detailed implementation
> *Populated at Plan time. Source material does not ground this level of detail.*

**The grounding test:** before writing any sentence, ask "is this claim grounded in what I read in the source material?" If no, don't write it. Don't make it up because the template expects it.

**The language test:** before writing any sentence in an operator-facing field, ask "would the operator read this and immediately know what it means without thinking about implementation?" If no, rewrite in plain words.

### 4. Frontmatter

Required fields:

```yaml
---
id: <stable-id>           # follow the repo's id convention (e.g. e02-rns-automation)
kind: task | story | epic | decision | runbook | strategy | architecture
project: <from .ri/config.md>
status: active            # for /work/ items; omit for /docs/ items
autonomy: attended        # default; operator can override
sources: [raw/<source-files-here>]
created: <today's ISO date>
updated: <today's ISO date>
---
```

For docs (decision, runbook, strategy, architecture): omit `status`, add `verified-on: <today>`.

### 5. Significant planning event — invoke senior-staff-engineer (tier-aware)

If the compile produced an `epic`, `story`, `strategy`, or `architecture` artefact, the senior-staff-engineer sub-agent may run. The trigger depends on the repo's tier:

- **Tier 3:** Always invoke. Apply load-bearing fixes before presenting the compile to the operator.
- **Tier 2:** Invoke only if the operator asks for it. Default off.
- **Tier 1:** Never invoke. Tier-1 compiles are rare anyway, and the review overhead isn't worth it.

The agent reads the artefact with fresh context and reports the top issues ranked by impact (scope, sequencing, architectural soundness, risk, missing work).

Skip the review entirely for `task`, `decision`, `runbook`, addition-to-existing, and discard — they don't warrant it at any tier.

The senior-staff-engineer cannot rescue a confabulated compile. If the source material was thin and you generated thin output, the agent will say so. That's the correct outcome.

### 6. File moves

For each compiled artefact:

1. Write the artefact to its correct location (`/sdlc/work/active/` for work items being started now, `/sdlc/work/backlog/` for shaped-but-unstarted work items, `/sdlc/docs/...` for docs)
2. Confirm the `sources:` field references the original raw path
3. Delete the original raw file (only after the artefact is committed)

For discards: delete the raw file with a note in commit message ("raw/X.md discarded — superseded by Y" or "raw/X.md discarded — no longer relevant").

For additions to existing artefacts: update the existing artefact's `sources:` field to include the new raw path. Delete the raw file.

Never delete from `/sdlc/raw/` without first producing a compiled artefact that references it as a source.

### 7. Raise questions to OPEN.md if any, then update STATE

If the compile surfaced questions that need the operator's judgment but aren't blocking (deferred decisions, ambiguities the operator can resolve later, structural calls best made after seeing more), append a one-line entry to `/sdlc/OPEN.md` for each:

```
- <YYYY-MM-DD> <one-line question, with enough context that the operator can answer without re-reading the artefact> [<artefact id this relates to>] [area: <module(s)>]
```

Rules for OPEN.md writes:

- Create the file if it doesn't exist.
- Append only. Never overwrite or rearrange existing entries. (Removing an entry happens only on resolution, and only `ri-file` does that — see its resolution flow.)
- One question per line.
- Operator-grammar. The question should be answerable by reading the line alone.
- Tag with the artefact id so the operator knows which work the question gates, and with an `area:` tag naming the code module(s) the question touches (the stack-relative code unit — Python module/package, JS/React module or component, skill/agent here; list more than one when it spans them). The area tag is what lets the question be surfaced when work later starts on that code.

Questions that block the current compile step belong in the conversation with the operator now, not in OPEN.md. OPEN.md is for the deferred judgment queue.

After OPEN.md (if anything was added), regenerate `/sdlc/STATE.md`. This is a chain-end handoff — invoke ri-state in `report-only` mode (emit the report-only token) so its hygiene gate reports but never blocks this chain. The "Active focus" line probably points at the newly compiled artefact. STATE will reflect the new OPEN.md count.

## Tier sensitivity

**Tier 1 (content pipelines, low-stakes):**

Most raw material here is "I need this script to do X." Propose `discard, hand to ri-do` for most items. Don't generate artefacts for one-shot script work. Reserve compile for actual structural changes (new pipeline, new orchestration layer).

**Tier 2 (signalstrata, analytical workloads):**

Standard flow applies. Stories for load-bearing work, tasks for mechanical work, decisions for architecture choices.

**Tier 3 (constellation, high-stakes):**

Standard flow plus mandatory senior-staff-engineer review. Be especially conservative on thin output — better to compile thin and let Plan ground than to confabulate detail at compile time.

## Hard rules

- Never write engineering detail (test names, function signatures, schemas, code refs) at compile time. That belongs in Plan, when the story is active and code can be read.
- Never let engineering jargon leak into operator-facing fields. Status, scope, acceptance, gate notes, roadmap entries — all plain words. If you'd name a function, file, or implementation concept, recast in language the operator would use.
- Never compile a `decision` artefact without a plain-terms lead — each decision as call + consequence, one line, before any engineering detail (the ADR shape ri-file defines). A story that bundles decisions carries the same plain-terms lines. A record only a developer can parse has failed at being a record.
- Never confabulate to fill a template section. If the source doesn't ground a claim, leave a placeholder.
- Never produce an epic without a Roadmap section listing its stories as one-liners in sequence. The roadmap is the epic's reason for being.
- Never include task one-liners in the epic roadmap at compile time. Tasks don't exist yet — `ri-plan` fills them in under each story when the story is planned.
- Never write status markers (done, in progress) into the roadmap. Status is read live from the filesystem when the roadmap is rendered.
- Never delete from `/sdlc/raw/` without producing a compiled artefact referencing it in `sources:`.
- Never skip senior-staff-engineer review on tier-3 epic, story, strategy, or architecture compiles. Tier-2 runs it on operator request; tier-1 never.
- Never edit an artefact's `id` field once written.
- Never produce the artefact body before the operator has approved the shape proposal.

## What the operator decides

- Whether each proposed shape is right
- Whether to merge multiple raw items into one artefact
- Whether to discard rather than shape
- Whether senior-staff-engineer findings are load-bearing or can be deferred
- Final approval before file moves happen

## What this skill does without re-asking

Reads raw material, proposes shape, generates thin artefact on approval, runs senior-staff-engineer on significant planning events, performs file moves, updates STATE. The operator approves shape once; the rest is mechanical.

