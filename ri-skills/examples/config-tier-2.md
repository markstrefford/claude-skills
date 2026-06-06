project: example-analytics-platform
default-rigor: tier-2
branch-default: story-level
stacks:
api:
path: api
test: pytest
workers:
path: workers
test: pytest -m worker
Tier-2 behaviour

Use tier-2 for: analytical workloads, internal tools, products approaching
production maturity but not yet load-bearing in a way that would cause real
damage on failure. Most repos sit here.

How the skills behave at tier-2:
- Full SDLC flow available (capture, compile, plan, execute, verify, file)
- Tests required on load-bearing tasks; skipped on mechanical ones
- Verifier mandatory on tier-2 tasks (post-execute review)
- Senior-staff-engineer runs on operator request (default off, to keep token
spend down on the planning step)
- Branching: story-level by default (multiple tasks share one branch and
merge as a unit when the story closes)

Single-stack repos can omit the stacks: block entirely and use the simpler
test-command: field. See config-tier-1.md for that shape.