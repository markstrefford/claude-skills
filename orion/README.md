# Orion research skills

Orion is Reimagined Industries' research agent. This is an early public release
of some of the skills it uses to take a body of experimental evidence and turn
it into a published research paper.

The four skills chain into one workflow:

| Skill | Role |
|---|---|
| **evidence-analysis** | Raw multi-run experiment output (event logs, decision traces, transcripts) into per-run extraction, a cross-run rollup, and a claims ledger where every claim traces to a receipt |
| **research-paper** | The claims ledger into a rigorous, results-forward paper whose rigour is the selling point |
| **paper-render** | The paper's markdown into a theme-aware HTML artifact and a white-background, paper-scale PDF |
| **research-repo-publish** | The finished report into a clean public repository, with the report at the front door and nothing draft or internal left visible |

Each skill is a `SKILL.md` in its own directory, in the format Claude Code loads
from `~/.claude/skills/`. They encode reusable patterns rather than one paper:
the durable asset is the skill, the paper is a cheap-to-reprint output.

This is a subset of Orion's skills, shared as-is.
