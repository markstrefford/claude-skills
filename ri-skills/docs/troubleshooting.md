# Troubleshooting

| Symptom | Likely cause | Fix |
| --- | --- | --- |
| A skill doesn't trigger from a plain request | The repo has no `/sdlc/` or `.ri/config.md`, which the descriptions require | Initialise the repo (see the [README](../README.md#quickstart)), or call the skill by name |
| Every skill appears twice | Installed both as a plugin and from a clone | Keep one: see [installation](installation.md) |
| An old version of a skill runs | A stale copy in `~/.claude/skills/`, or a skill uploaded to your claude.ai account and synced back | `claude plugin list` and `ls -la ~/.claude/skills` show every source; remove the stale one |
| Execute stops asking "continue?" between tasks | It shouldn't ask. The "go" authorises the whole chain | The chain should stop only for the reasons in [concepts](concepts.md#autonomy); if it stops elsewhere, report it |
| The verifier fails every task | Tests can't run in its environment, or the test command is wrong | Check `test-command` or `stacks:` in `.ri/config.md`. Tests that can't run should cap the verdict at PASS WITH NOTES, not fail it |
| The gate blocks on a scanner | The scanner isn't installed, or exited with an error | Install it or remove it from `scanners:`. A scanner that can't run blocks on purpose |
| `/security-review` reviewed the wrong diff | It compares against `origin`'s default branch, not local `main` | Push `main`, or read the gate's note on what was reviewed |
| `ri-state` holds a gate on a direct run | Five or more hygiene flags, or one past its hard age | Resolve the flagged items, or acknowledge them for this run. Chains never hit this |
| Commits to `main` are rejected | Branch protection with `landing: merge` | Set `landing: pull-request` |
| Pull requests aren't opened | `gh` missing or not authenticated | `gh auth login` |
| Two branches conflict in `OPEN.md` | No union merge for the file | Add `sdlc/OPEN.md merge=union` to `.gitattributes` |
| The cd guard doesn't fire | Plugin: `cd_guard` is off. Clone: the hook isn't registered, or settings weren't reloaded | Turn the option on, or follow [the hook README](../hooks/README.md); open `/hooks` once to reload |
| A skill runs on a different model than your session | Intended: the pin applies for that turn only | See [models and cost](models-and-cost.md) |
