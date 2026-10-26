# Installation

Two ways to install. Pick one: with both, every skill and agent loads twice.

## 1. Simple: copy the files

```bash
git clone https://github.com/markstrefford/claude-skills.git
cd claude-skills/ri-skills
mkdir -p ~/.claude/skills ~/.claude/agents
cp -R skills/* ~/.claude/skills/
cp agents/*.md ~/.claude/agents/
```

Start a new Claude Code session. The skills load under their bare names (`/ri-execute`, agent `verifier`) and trigger from plain requests in a repo that uses the SDLC.

**Update:** `git pull`, then run the two `cp` lines again. That overwrites the copies, so don't edit them in `~/.claude`; anything changed there is lost.

**Uninstall:** delete the `ri-*` folders from `~/.claude/skills/`, and `verifier.md`, `senior-staff-engineer.md` and `security-reviewer.md` from `~/.claude/agents/`.

## 2. Better: install as a plugin

One command, no clone, and updates come from the published releases:

```
/plugin install ri-skills --marketplace markstrefford/claude-skills
```

The skills then appear as `/ri-skills:ri-execute` and so on. Choosing **project** scope at install turns the set on for everyone in a repo. Remove any copied files first. Updating, scopes and uninstalling are covered in [install and manage plugins](https://code.claude.com/docs/en/discover-plugins).

## You can also

Not covered here; the Claude Code docs explain each.

- **Turn on auto-update** for the `ri` marketplace in `/plugin` → Marketplaces, so new releases install at session start. It is off by default for marketplaces outside Anthropic's own. See [keep plugins updated](https://code.claude.com/docs/en/discover-plugins#keep-plugins-updated).
- **Roll it out across an organisation** through managed settings, so it is pre-installed or required for everyone. See [manage plugins for your organization](https://code.claude.com/docs/en/plugins/org.md).
- **Run the plugin straight from a clone** with `claude --plugin-dir <clone>/ri-skills`, if you are changing the skills and want to try edits without installing. See [flags that load a plugin for one session](https://code.claude.com/docs/en/plugins/cli-reference.md#flags-that-load-a-plugin-for-one-session).

## Optional: standing behaviour

`ri-skills/user-claude-md-additions.md` is an example of the user-level `~/.claude/CLAUDE.md` the set was built alongside: how to pitch decisions, session hygiene, navigation. It reflects one person's preferences. Read it, take what fits, and write it in your own words.

## Optional: the cd guard hook

A `PreToolUse` hook that approves `cd` commands staying inside the current git repo without a prompt. A `cd` that leaves the repo still asks. It needs `jq` and `git`.

- **Plugin:** off by default, because it changes permission behaviour. Turn it on in `/plugin` → Installed → ri-skills → Configure options → `cd_guard`.
- **Copied files:** install and register it by hand: see [hooks/README.md](../hooks/README.md).
