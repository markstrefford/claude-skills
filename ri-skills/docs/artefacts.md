# Artefacts

Every artefact is a markdown file with YAML frontmatter. The frontmatter is for the skills; the body is for people, operator grammar first.

## Kinds

| Kind | Written by | Lives in | Body |
| --- | --- | --- | --- |
| `epic` | compile | `work/` | Summary, outcome, out of scope, standing gate, acceptance, status, roadmap |
| `story` | compile | `work/` | As an epic, without the roadmap |
| `task` | plan (rarely compile) | `work/` | Outcome, acceptance, decisions in plain terms, test specification, implementation notes |
| `decision` | compile, file | `docs/decisions/`, or beside its epic until it closes | ADR: status, context, decisions in plain terms, decision(s), consequences, alternatives |
| `runbook` | compile, file | `docs/runbooks/` | When it applies, steps, success, failure, escalation |
| `strategy` | compile, file | `docs/strategy/` | Narrative, operator grammar throughout |
| `architecture` | compile, file | `docs/architecture/` | A structural fact and what it means for future work |
| `archive` | archive | `work/done/` | One record per closed epic: stories, critical tasks, decisions, gotchas, merges |

## Frontmatter

| Field | On | Meaning |
| --- | --- | --- |
| `id` | all | Stable identifier. Never changed once written |
| `kind` | all | One of the kinds above |
| `project` | all | From `.ri/config.md` |
| `status` | work items | `active`, `blocked` or `done` |
| `blocker` | blocked work | One line on what it is waiting for |
| `parent` | stories, tasks | The id of the epic or story above it. Authoritative for grouping |
| `children` | epics, stories | Optional list of child ids |
| `autonomy` | stories, tasks | `attended` (default), `review` or `auto` |
| `tier` | stories, tasks | Overrides the repo tier |
| `stack` / `stacks` | tasks | Which stack's test command runs, on multi-stack repos |
| `sources` | compiled artefacts | The raw files or work it came from |
| `area` | decisions | The code modules it concerns, so it resurfaces when someone works there |
| `created`, `updated` | all | ISO dates. `updated` is refreshed on every change, including marking done |
| `verified-on` | docs | When the content was last checked against reality |
| `replaces`, `span`, `tags` | archive | The ids it consolidated, the date range, the union of tags |

## Ids

| Kind | Form | Example |
| --- | --- | --- |
| Epic | `e<NN>-<name>` | `e04-sdlc-contract-consolidation` |
| Story | `e<NN>-s<MM>-<slug>` | `e04-s01-install-without-copy` |
| Task | `e<NN>-s<MM>-t<K>-<slug>` | `e05-s02-t1-retry-once-before-alerting` |
| Decision and other docs | descriptive slug, no number | `sdlc-store-lifecycle` |

A new epic takes the next unused number. On a team, two people compiling epics on separate branches can pick the same number: see [team adoption](team-adoption.md).

## Area tags

`area` (on decisions) and `[area: …]` (on `OPEN.md` lines) name code modules in the stack's own unit: a Python module or package, a JS or React module or component, a skill or agent name. Matching is exact and only inside the tag, so a decision that mentions a module in its prose doesn't count. There is no registry; consistent naming is what makes surfacing work.

## Status and location

An artefact's folder and its `status` say the same thing: `done` files are in `done/`. The skills set both together. A planned change (e04) will make the folder the only statement of status.
