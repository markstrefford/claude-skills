# Template: ~/.claude/CLAUDE.md additions

This is the user-level standing behaviour `ri-skills` assumes is in place. Append the section below to your `~/.claude/CLAUDE.md` (create the file if it doesn't exist).

The defaults are operator-style: consequences over implementation detail, you trust the tooling to get the code right, you don't review code line by line. If you do review line by line and want method-level explanations, adjust accordingly.

To install:

```bash
cat user-claude-md-additions.md >> ~/.claude/CLAUDE.md
```

Then edit to suit. The two places worth customising are the concrete example in the "architect level" section (see the TODO marker below) and the session hygiene thresholds if your context preferences differ.

---

# Working with me

## Talk to me at architect level

When you surface a decision, frame it in consequences: implications, risk, business benefit. Not methods, classes, or line-level detail. I trust the process and tooling to get the code right; I don't review code line by line.

Implementation detail can go in the artefact for the record. Don't ask me to decide based on it. I decide on consequences. The code is yours.

If a decision only makes sense once I see the trade-off, explain the trade-off, then give me the options and your recommendation.

> **TODO for you to fill in:** add a concrete example of a decision you'd want surfaced at the right altitude. Something specific from your work that, once stated plainly, made the call obvious. Specific anchors calibrate the model far better than abstract principles. Delete this TODO once filled.

Default to this level. If I want more detail I'll say "show me the detail." If you've gone too low I'll say "lift it up."

## Navigation

The working directory persists across Bash calls, and you're at the repo root almost always — so you don't need to `cd` for in-repo work. Never prepend `cd <repo-root> && …` to a command; run it directly. To act in a subdirectory, prefer an absolute path over a `cd`. Only `cd` outside the current repo when a task genuinely needs it (e.g. searching another checkout) — that prompts for permission on purpose: I want to know when you leave the repo.

This is enforced by the `cd-repo-guard.sh` PreToolUse hook (see `ri-skills/hooks/`): `cd` anywhere inside the current repo runs without a prompt; `cd` outside it asks. The hook discovers the repo root at runtime from git, so it works in every repo with no per-repo configuration.

## Session hygiene

At session end, after `STATE.md` regenerates, suggest `/clear` if the next session is a different project or unrelated task. Don't suggest `/clear` if work continues on the same line.

When context approaches 150k mid-session, suggest `/compact` before continuing.

When switching between two tasks in the same session that share no files or context, suggest `/clear`.