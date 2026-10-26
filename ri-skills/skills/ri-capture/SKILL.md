---
name: ri-capture
description: Save material verbatim into /sdlc/raw/ for later shaping, in a repo that uses the ri SDLC (has /sdlc/ or .ri/config.md). Use when the operator wants a thought, paste, or conversation kept without being processed — "capture this", "drop it in raw", /ri-capture.
model: haiku
effort: low
---

# ri-capture

Raw is the inbox: the one place in the SDLC with no rules, so that nothing is lost while the operator is thinking. Capture writes what it is given and nothing more. Shaping it is `ri-compile`'s job, later.

If the operator wants the material shaped now, that is `ri-compile`.

## Flow

1. **Get the content.** In order of preference: the block the operator gave in this message, a file they pointed at, or the recent conversation if they said "capture this conversation". If none of those is clear, ask once what to capture.

2. **Name the file** `/sdlc/raw/<slug>.md`, with a 2–5 word hyphenated slug for the topic (`agent-os-roadmap.md`). No date prefix — dates live on compiled artefacts. Use the operator's name for it if they give one. If the slug is taken, add a qualifier (`-2`, `-followup`) rather than overwrite, because overwriting raw silently destroys a thought.

3. **Write it verbatim.** No summary, restructuring, frontmatter or tags; keep typos, stream of consciousness, names and timestamps. Compile needs the original to ground its output, and a summary would be compile done badly at the wrong time. The one adjustment allowed is making machine-mangled input readable (terminal escape characters, broken line endings).

4. **Report and check the count.** Say `Captured to /sdlc/raw/<file>.md.` Then count the files in `/sdlc/raw/`; if there are more than 20, add that raw has N items and is worth a compile pass. Past 20 the inbox becomes a junk drawer.

## Boundaries

- Capture never deletes from `/sdlc/raw/`. Only `ri-compile` removes raw files, and only after an artefact references them.
- Capture accepts anything. It doesn't judge whether material is worth keeping — that decision is compile's, with the operator.
