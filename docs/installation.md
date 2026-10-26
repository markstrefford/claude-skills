# Installation

Two ways to install. Use one, not both: both together load every skill and agent twice.

| | Plugin | Clone, linked |
| --- | --- | --- |
| For | Using the set as published; teams | Editing the skills |
| Names | `/ri-skills:ri-execute`, agent `ri-skills:verifier` | `/ri-execute`, agent `verifier` |
| Updates | `claude plugin update ri-skills@ri`, or turn on auto-update for the `ri` marketplace | `git pull` in the clone |
| Your own edits | Lost on update | Kept, in your fork |

Both forms trigger the same way from plain requests, and the skills name both agent forms, so behaviour is the same.

## Plugin

In a Claude Code session (2.1.275 or later):

```
/plugin install ri-skills --marketplace markstrefford/claude-skills
```

Choose a scope when asked. **User** gives you the set in every repo. **Project** writes the enablement to the repo's `.claude/settings.json`, which you commit, so collaborators get it too; each collaborator still runs the install once.

From a shell, or on older versions:

```bash
claude plugin marketplace add markstrefford/claude-skills
claude plugin install ri-skills@ri
```

Check it loaded: type `/ri-skills:` and the eight skills should be listed. `claude plugin list` shows the version.

**Uninstall:** `claude plugin uninstall ri-skills@ri`. Removing the `ri` marketplace also uninstalls it.

## Clone, linked

For working on the skills themselves. Each skill and agent is linked into `~/.claude/`, so edits in the clone are live in every session and stay under git.

```bash
git clone https://github.com/markstrefford/claude-skills.git ~/Development/claude-skills
cd ~/Development/claude-skills/ri-skills
for s in skills/*/; do ln -s "$PWD/$s" ~/.claude/skills/"$(basename "$s")"; done
for a in agents/*.md; do ln -s "$PWD/$a" ~/.claude/agents/"$(basename "$a")"; done
```

`ln -s` refuses to replace an existing file, so remove any earlier copy first. Because the working tree is live, switching branches in the clone changes what every session runs.

**Uninstall:** remove the links: `find ~/.claude/skills ~/.claude/agents -maxdepth 1 -lname "$HOME/Development/claude-skills/*" -delete`.

## Optional: standing behaviour

`ri-skills/user-claude-md-additions.md` is an example of the user-level `~/.claude/CLAUDE.md` the set was built alongside: how to pitch decisions, session hygiene, navigation. It reflects one person's preferences. Read it, take what fits, and write it in your own words.

## Optional: the cd guard hook

A `PreToolUse` hook that approves `cd` commands staying inside the current git repo without a prompt. A `cd` that leaves the repo still asks. It needs `jq` and `git`.

- **Plugin:** off by default, because it changes permission behaviour. Turn it on in `/plugin` → Installed → ri-skills → Configure options → `cd_guard`.
- **Clone:** install and register it by hand: see [ri-skills/hooks/README.md](../ri-skills/hooks/README.md).
