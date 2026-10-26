# Models and cost

Each skill and agent pins a model and an effort level in its frontmatter. The pin is cost routing: mechanical work runs on cheap models, judgment on strong ones.

## Routing

| Skill or agent | Model | Effort | Why |
| --- | --- | --- | --- |
| `ri-capture` | haiku | low | Writes text verbatim |
| `ri-state` | haiku | medium | Reads folders and counts |
| `ri-do` | sonnet | medium | Small, bounded changes |
| `ri-file` | sonnet | medium | Writes up what the session already decided |
| `ri-archive` | sonnet | high | Summarises without dropping a decision |
| `ri-compile` | opus | high | Shapes ambiguous material; the highest-leverage judgment |
| `ri-plan` | opus | high | Reads code and designs the task sequence |
| `ri-execute` | opus | high | Implements and runs long chains |
| `verifier` | sonnet | high | Checks work against a spec; runs often |
| `senior-staff-engineer` | opus | high | Architectural review; runs rarely |
| `security-reviewer` | sonnet | high | Works through fixed OWASP lists; runs at plan, story and epic close. `security-review: full` adds `/security-review` in the session model |

## How the pins behave

- A skill's `model:` applies for the rest of the turn that invoked it. Your session model resumes on your next message. A pin never changes your session.
- An agent's `model:` applies only inside that agent.
- `effort` takes `low`, `medium`, `high`, `xhigh` or `max`. Higher effort means more thinking and more tokens.
- `ri-execute` calls `ri-state` last in a chain, so the Haiku pin never lands on the story-close gate.

## Changing a pin

Edit the `model:` or `effort:` line in the skill's `SKILL.md` or the agent's file. Remove `model:` to inherit the session model.

Under a plugin install, the files are replaced on update. To keep your own routing, install from a clone (see [installation](installation.md)) and carry the change in your fork.

## Relative cost

List prices per million tokens, input / output, as of October 2026. Check [current pricing](https://docs.claude.com/en/docs/about-claude/pricing) before relying on them.

| Model | Input | Output | Relative to Sonnet |
| --- | --- | --- | --- |
| Haiku 5.5 | $0.10 | $0.50 | 1/20 |
| Sonnet 5.5 | $2 | $10 | 1 |
| Opus 5.5 | $4 | $20 | 2 |
| Fable 5.1 | $10 | $50 | 5 |

Nothing in the set is pinned to Fable. If your session runs on Fable, every skill still routes to its pin, so the expensive model only does the conversation around the skills.
