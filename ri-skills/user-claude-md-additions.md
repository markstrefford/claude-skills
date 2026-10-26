# Example: ~/.claude/CLAUDE.md additions

Optional. This is the user-level standing behaviour `ri-skills` was built alongside: how decisions are pitched, navigation, and session hygiene. It encodes one operator's preferences, and some of it (the hygiene thresholds) is policy a team should set for itself. The skills work without it.

To use it, read it, take what fits, and add it to your `~/.claude/CLAUDE.md` in your own words. The two places worth customising are the concrete example in the "architect level" section (see the TODO marker below) and the session hygiene thresholds.

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

If the `cd-repo-guard.sh` PreToolUse hook is installed (see `ri-skills/hooks/`; opt-in under the plugin), it enforces this: `cd` anywhere inside the current repo runs without a prompt; `cd` outside it asks. The hook discovers the repo root at runtime from git, so it works in every repo with no per-repo configuration.

## Session hygiene

At session end, after `STATE.md` regenerates, suggest `/clear` if the next session is a different project or unrelated task. Don't suggest `/clear` if work continues on the same line.

When context approaches 150k mid-session, suggest `/compact` before continuing.

When switching between two tasks in the same session that share no files or context, suggest `/clear`.