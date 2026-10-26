---
project: example-platform
default-rigor: tier-3
branch-default: story-level
landing: merge          # or pull-request for a team repo

stacks:
  backend:
    path: backend
    test: uv run pytest
  frontend:
    path: web
    test: npm test

# Tier-3 invariants
version-pairing: backend/pyproject.toml and backend/version.json carry the same semver; bump together, never let them drift
public-deploy: true
security-gate: required   # scoped by the footprint map below
security-review: full     # OWASP checklist plus /security-review at story close; owasp for the checklist alone

# Footprint map (optional) — which code is externally reachable vs internal-only.
# At story close /code-review always runs; the security review runs only when the
# story's changed files touch a `deployed` path. Most-specific rule wins (by path
# depth); an unmatched path defaults to deployed; omitting the whole block runs the
# security review on everything, exactly as before.
footprint:
  internal:            # only ever run on our machines; no external surface
    - backend/analysis/**
    - tests/**
  deployed:            # externally reachable; security review required
    - backend/**
    - web/**

# Scanners (optional) — the gate runs these at story close. secret always;
# dependency/code footprint-scoped. A match/high finding blocks; a scanner that
# can't run blocks (never green). Omit the block to run none.
scanners:
  - command: gitleaks detect --no-banner
    class: secret
  - command: pip-audit
    class: dependency
  - command: bandit -r backend
    class: code
---

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
- Branching: story-level by default; merge commits only, never rebase
- ri-do refuses tier-3 work by default; operator must explicitly override
  per-task if they want the lite path

`security-gate: required` is live. Sensitive stories get a security review of
their plan. At story close `ri-execute` runs the governance gate over the story
branch: `/code-review` always, and the security review (the OWASP checklist plus
`/security-review`, from `security-review: full`) when the story's changed files
touch a `deployed` path in the optional `footprint:` map above (omit the map to
run it on everything). When the epic closes, its combined change gets one more
OWASP checklist review, which never blocks. `security-gate: advisory` keeps the reviews
but stops them blocking; `off` turns them off.

`version-pairing` and `public-deploy` are still advisory — repo facts the
skills read but don't yet enforce. Keep them documented and ready to wire
in.