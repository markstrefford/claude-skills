project: example-platform
default-rigor: tier-3
branch-default: story-level

stacks:
  backend:
    path: backend
    test: uv run pytest
  frontend:
    path: web
    test: npm test

# Tier-3 invariants (advisory until wired into the governance layer)
version-pairing: backend/pyproject.toml and backend/version.json carry the same semver; bump together, never let them drift
public-deploy: true
security-gate: required before merge

# Tier-3 behaviour

Use tier-3 for: load-bearing systems, public deployments, anything where
failure compounds quickly (economic models, financial logic, security
surface, data integrity).

How the skills behave at tier-3:
- Full SDLC flow mandatory (no shortcuts)
- Tests-first required, never skipped
- Verifier mandatory on every task (no exceptions)
- Senior-staff-engineer mandatory on every epic, story, strategy, or
  architecture compile
- Compile stays conservative on thin output; if source material doesn't
  ground a detail, the artefact leaves a placeholder rather than
  confabulating
- Branching: story-level by default; merge only, never rebase
- ri-do refuses tier-3 work by default; operator must explicitly override
  per-task if they want the lite path

The `version-pairing`, `public-deploy`, and `security-gate` lines are
repo facts the skills don't enforce yet (the security-reviewer sub-agent
at story close lives in the parked governance layer). Keep them in
config so they're documented and ready to wire in.