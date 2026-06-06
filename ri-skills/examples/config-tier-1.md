project: example-content-scripts
default-rigor: tier-1
branch-default: main
test-command: pytest
Tier-1 behaviour

Use tier-1 for: content scripts, glue code, doc fixes, individual pipeline
scripts where rebuild cost is trivial. If one breaks, you rerun it.

How the skills behave at tier-1:
- ri-do is the default verb (one-shot, no artefact, just execute and commit)
- ri-compile usually unnecessary; raw material can often go straight to ri-do
- Verifier skipped unless a task is explicitly load-bearing
- Senior-staff-engineer never runs at this tier
- Branching: lands directly on main, no branch ceremony

If a task in this repo turns out to be bigger than tier-1 (load-bearing,
architectural, or touching auth/payments/data), promote it: set autonomy
explicitly and consider whether the repo's tier itself needs revisiting.