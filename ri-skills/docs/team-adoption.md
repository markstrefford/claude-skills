# Team adoption

The set was built for one operator running several repos. These are the settings and conventions that change when more than one person works in a repo.

| Decision | Single operator | Team | How to set it |
| --- | --- | --- | --- |
| How work lands | `landing: merge`: the operator merges; the gate verdict goes in the story's done commit | `landing: pull-request`: stories, doc changes and tier-1 fixes arrive as pull requests; reviewers, CI and branch protection attach there | `.ri/config.md` |
| STATE.md | Committed to `main` on every refresh | Local only, gitignored. Each person regenerates their own | Follows `landing`; add `sdlc/STATE.md` to `.gitignore` |
| OPEN.md conflicts | Rare | Two branches appending a question conflict at the end of the file | `sdlc/OPEN.md merge=union` in `.gitattributes` |
| Install | Clone, linked into `~/.claude` | Plugin, so everyone runs the same version | See [installation](installation.md) |
| Standing behaviour | `ri-skills/user-claude-md-additions.md` appended to `~/.claude/CLAUDE.md` | Optional. It encodes one person's working preferences; treat it as an example | Each person's own `~/.claude/CLAUDE.md` |

## Still a call for the team

**Epic numbering.** A new epic takes the next unused number. Two people compiling epics on separate branches will both pick the same one, and the collision shows up at merge. Options: assign numbers when the epic lands rather than when it is compiled, or prefix ids with initials (`e07-ms-…`). Settle this before more than one person compiles epics. A team that shapes work in Jira would use Jira's numbering instead: see [where Jira fits](jira.md).

**Who the operator is.** The skills assume one person approves shapes and plans. On a team, decide whether that is whoever is driving the session, or a named owner per epic.

**Autonomy.** `auto` chains run unattended. On a team, decide who may set `autonomy: auto` and on which tiers.

## Branch protection

With `landing: merge`, `ri-compile`, `ri-plan`, `ri-file`, `ri-archive` and `ri-state` commit straight to `main` outside a story's chain. Branch protection on `main` rejects those commits. Use `landing: pull-request` on any repo with protection turned on.
