---
name: ri-capture
description: Drop unstructured material into /sdlc/raw/ verbatim, with no transformation. The "no rules" zone of the SDLC — anything captured here gets shaped later by ri-compile, but at capture time the only rule is don't lose the thought. Triggers on explicit slash command (/ri-capture), capture phrasing ("capture this", "drop into raw", "save for later", "add to the raw folder"), or when the operator pastes a block of thinking with no clear question attached. Use this skill whenever the operator wants something preserved without being processed. Don't ask which verb to use, run.
model: haiku

---

# ri-capture

Writes material into `/sdlc/raw/` exactly as given. Doesn't shape it, doesn't summarise it, doesn't tag it. Compile happens later.

## When to run this

The operator wants a thought preserved without being processed. Examples:

- "Capture this conversation"
- "Drop this into raw — I'll deal with it later"
- "Save this for the next session"
- "/ri-capture"
- Operator pastes a long block, screenshot transcript, or thinking dump with no clear question

If the operator is asking for the material to be shaped, that's `ri-compile`, not this. Capture is the inbox; compile is the sorting.

## The capture flow

### 1. Get the content

Three sources, in order of preference:

- An explicit block the operator provided in the current message
- A file the operator referenced ("capture what's in the clipboard at `/tmp/notes.md`")
- The recent conversation context, if the operator says "capture this conversation"

If none of those are clear, ask once: "What do you want captured?" Then proceed when answered.

### 2. Choose a filename

Format: `<slug>.md` in `/sdlc/raw/`.

The slug should be derived from the content's topic in 2-5 hyphenated words. Examples:

- `moltbot-engagement-thoughts.md`
- `constellation-pricing-musings.md`
- `agent-os-roadmap.md`

Don't prefix with dates. The `created:` timestamp lives in compiled artefacts; raw files have no frontmatter and don't need a date in the filename.

If a file with that slug already exists in `/sdlc/raw/`, append a short qualifier rather than overwriting: `moltbot-engagement-thoughts-2.md`, `moltbot-engagement-thoughts-followup.md`. Never overwrite raw material silently.

### 3. Write the content verbatim

Write exactly what the operator provided. No reformatting. No structure imposed. No frontmatter. No tagging.

If the operator's input has typos, leave them. If it's stream-of-consciousness, keep it that way. If it's a chat transcript with names and timestamps, preserve them.

The only adjustment allowed: if the operator pasted text that's clearly machine-mangled (escape characters from a terminal, broken line endings), gently normalise to readable markdown. This is a fidelity-to-intent fix, not a content edit.

### 4. Report and check the threshold

After writing, report briefly:

> Captured to `/sdlc/raw/<filename>.md`.

Then count the files in `/sdlc/raw/`. If the count is over 20:

> `/sdlc/raw/` has <N> items. Worth a compile pass when you have ten minutes.

20 is the SDLC's threshold. Past that, raw stops being an inbox and starts being a junk drawer.

## Hard rules

- Never summarise the captured material. Verbatim or nothing.
- Never restructure or reformat content (markdown normalisation of obviously-mangled input is the only exception).
- Never add frontmatter to raw files. Raw is unstructured by design.
- Never overwrite an existing raw file. Use a qualifier in the new filename.
- Never delete from `/sdlc/raw/`. Only `ri-compile` deletes raw, and only after producing a compiled artefact that references it.
- Never refuse to capture. Raw accepts anything.
- Always count `/raw/` after writing and prompt to compile if over 20.

## What the operator decides

- What gets captured
- When to compile what's been captured
- Whether to override the proposed filename

## What this skill does without re-asking

Writes the file, names it sensibly, checks the threshold, reports. No shape decisions, no content decisions.
