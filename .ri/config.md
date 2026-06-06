---
project: claude-skills
default-rigor: tier-3
created: 2026-06-06
---

# RI config — claude-skills

This repo defines the Reimagined Industries SDLC and the ri-skills system.
It runs at **tier 3** by design: errors in these skills — especially the
autonomy gate that decides when an agent acts without operator check-in —
propagate into every tier-3 project that runs them. The blast radius is the
whole system, so this repo is governed at the highest rigor.

- `default-rigor: tier-3` — mandatory senior-staff-engineer review on epic,
  story, strategy, and architecture compiles.
- `project: claude-skills` — used in artefact frontmatter.
