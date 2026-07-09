# Hooks

Claude Code `PreToolUse` hooks that ship with `ri-skills`. Global (user-level), so they apply to every repo once installed.

## `cd-repo-guard.sh` — in-repo `cd` is silent, out-of-repo `cd` asks

**Problem it solves.** Claude Code kept prompting for permission on `cd` commands within the current repo — most often a needless `cd <repo-root> && …` prepended to a command when Claude was already at the root. A blanket `Bash(cd:*)` allow rule can't fix this (compound `cd X && Y` never matches a `cd`-prefix rule) and would be wrong anyway: it would also silence `cd` commands that leave the repo, which you *do* want to be asked about.

**What it does.** On every `Bash` tool call it inspects the command. If it contains a `cd`, it discovers the current repo root at runtime (`git rev-parse --show-toplevel` against the session's cwd) and auto-approves only when *every* `cd` target resolves to a path inside that repo. Anything that leaves the repo — or that it can't prove stays inside — falls through to the normal permission prompt.

- Generic: no repo paths are hard-coded, so it works in every repository unchanged.
- Fail-safe: the hook only ever *adds* an allow for a proven in-repo `cd`. It never blocks and never forces a prompt beyond normal behaviour, so a parsing miss degrades to "ask as usual", never to a wrong auto-approve.
- Pairs with the **Navigation** guidance in `user-claude-md-additions.md`, which tells Claude not to emit needless in-repo `cd` in the first place. The guidance removes the noise at the source; the hook enforces the boundary regardless of discipline.

### Install

1. Copy the script to your user hooks directory:

   ```bash
   mkdir -p ~/.claude/hooks
   cp ri-skills/hooks/cd-repo-guard.sh ~/.claude/hooks/
   chmod +x ~/.claude/hooks/cd-repo-guard.sh
   ```

2. Register it in `~/.claude/settings.json`. `settings.json` is JSON, so you must **merge** — don't overwrite the file. Merge this block in with `jq`:

   ```bash
   jq '.hooks.PreToolUse += [{
         "matcher": "Bash",
         "hooks": [{
           "type": "command",
           "command": "bash \"$HOME/.claude/hooks/cd-repo-guard.sh\"",
           "statusMessage": "cd guard"
         }]
       }]' ~/.claude/settings.json > ~/.claude/settings.json.tmp \
     && mv ~/.claude/settings.json.tmp ~/.claude/settings.json
   ```

   Or add it by hand — the shape is:

   ```json
   {
     "hooks": {
       "PreToolUse": [
         {
           "matcher": "Bash",
           "hooks": [
             { "type": "command", "command": "bash \"$HOME/.claude/hooks/cd-repo-guard.sh\"", "statusMessage": "cd guard" }
           ]
         }
       ]
     }
   }
   ```

3. Reload settings so the watcher picks up the new hook: open `/hooks` once in a running session, or restart Claude Code. (If `settings.json` had no `hooks` block when the session started, the change isn't live until you do this.)

### Verify

```bash
# in-repo cd -> emits an allow decision
printf '{"tool_input":{"command":"cd sub && ls"},"cwd":"'"$(git rev-parse --show-toplevel)"'"}' \
  | bash ~/.claude/hooks/cd-repo-guard.sh
# -> {"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow"}}

# out-of-repo cd -> no output (falls through to the normal prompt)
printf '{"tool_input":{"command":"cd /tmp"},"cwd":"'"$(git rev-parse --show-toplevel)"'"}' \
  | bash ~/.claude/hooks/cd-repo-guard.sh
# -> (no output)
```

Requires `jq` and `git` on `PATH` (both are already assumed by the ri-skills workflow).

### One consequence worth knowing

When a command chains work after an in-repo `cd` (e.g. `cd sub && <cmd>`), approving the `cd` approves the whole command line — the chained part runs without its own prompt. That is the intended trade: in-repo work is trusted. Commands that step outside the repo still prompt in full.
