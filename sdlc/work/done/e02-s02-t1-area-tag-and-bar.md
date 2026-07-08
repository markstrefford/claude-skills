---
id: e02-s02-t1-area-tag-and-bar
kind: task
project: claude-skills
status: done
autonomy: attended
parent: e02-s02-decisions-record
created: 2026-07-08
updated: 2026-07-08
---

## Outcome

The filing convention requires an area tag on every decision record and states
plainly what earns a record versus what dies unrecorded.

## Decisions in plain terms

The stance that the decisions record stays thin (only durable calls) and
area-tagged is recorded in `docs/decisions/sdlc-store-lifecycle.md`; this task
implements it in the filing skill. Two operator-approved choices it embodies:
**the area tag is a stack-relative code-module reference** (Python module/package;
JS/React top-level module or component; skill or agent here), at module
granularity, listed when a decision spans more than one — deliberately not an
epic-id, because epics stack over the same code. And **decision records use
descriptive slugs, not numeric prefixes** — the documented `NNNN-slug` convention
is corrected to match what the repo's records actually do.

## Acceptance

- ri-file's decision (ADR) frontmatter shape includes an `area:` field, defined
  as a stack-relative code-module reference at module granularity — the natural
  top-level code unit for the stack (Python module/package; JS/React module or
  component; skill or agent here) — listing more than one when the decision spans
  them, and going finer than a module only when the change genuinely is one file.
  The note says why: so decisions are greppable by the code they touch and can be
  surfaced when work starts on that module.
- ri-file states the durability bar as an extension of the existing hard rule
  (not a second, parallel statement): only durable, consequential calls become
  records; trivial closes — including a resolved question that established nothing
  lasting — die unrecorded.
- ri-file's documented decision `id` convention is corrected to descriptive slugs
  (matching the repo's actual records), not a `NNNN-` numeric prefix.
- The distributable (`ri-skills/skills/ri-file/SKILL.md`) and installed
  (`~/.claude/skills/ri-file/SKILL.md`) copies carry identical changes.

## Test specification

Instruction-file change; verification by coherence inspection:

- `area:` appears in ri-file's ADR frontmatter block, defined as a stack-relative
  code-module reference with the per-stack examples and the "list when it spans
  more than one" rule.
- The durability bar is folded into the existing hard rule about trivial ADRs
  (one rule, not two) — no separate parallel statement.
- The `id` convention note reads as descriptive slug, not `NNNN-` prefix.
- No claim remains that decisions and open questions already share tag vocabulary.
- ri-file is cp-safe (no pre-existing drift), so canonical and installed end
  byte-identical — confirm with `diff -q`.

## Implementation notes

Edit `ri-skills/skills/ri-file/SKILL.md` (canonical), then copy to the installed
copy (ri-file has no drift, so a full copy is safe — unlike ri-compile):

- In "Generate the artefacts" → the ADR frontmatter block, add an `area:` field
  alongside `id/kind/project/sources/created/updated/verified-on`. Describe it as
  the stack-relative code-module reference defined above (Python module/package;
  JS/React module or component; skill or agent here), module-granularity,
  list-capable, file-level only when the change is genuinely one file.
- Fix the `id` note in that same block: change `<NNNN-slug>` "sequential numeric
  prefix" to a descriptive slug matching actual practice.
- Fold the durability case into the existing hard rule "Never write an ADR for a
  trivial decision" — extend it in place to name the resolved-question-that-
  decided-nothing case. Do not add a second durability statement elsewhere.
- Do not build the OPEN→decision drain or any OPEN area-tagging here — those are
  s03. This task only makes the decisions record ready to receive area-tagged,
  durable decisions.

## Status

active
