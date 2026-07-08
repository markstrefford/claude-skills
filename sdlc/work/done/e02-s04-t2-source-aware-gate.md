---
id: e02-s04-t2-source-aware-gate
kind: task
project: claude-skills
status: done
autonomy: attended
parent: e02-s04-hygiene-audit
created: 2026-07-08
updated: 2026-07-08
---

## Outcome

The hygiene audit escalates and is source-aware: it blocks only on a direct
operator refresh once thresholds are crossed, and reports-only when invoked by
another skill at chain end.

## Decisions in plain terms

Implements `docs/decisions/hygiene-gate-escalation.md` — block on a direct
`/ri-state`, report-only when auto-invoked at chain end. No new decision.

## Acceptance

- Source is carried by an explicit token, not inferred: a skill calling ri-state at
  chain end **always emits a report-only token** in its handoff; **absence of the
  token defaults to direct/blocking**. This resolves the ambiguous case
  deterministically (unknown source → treat as direct). The "infer from context"
  option is removed.
- On a direct run, once the hygiene flags cross the escalation threshold, ri-state
  does not pass silently — it requires the operator to acknowledge or clear them.
  Below the threshold it reports without blocking.
- "Block" is a conversational acknowledgement gate, not a refusal to write: STATE
  still regenerates and commits (the snapshot/anti-drift identity is preserved); the
  ri-state action is simply not considered complete until the operator acknowledges
  or clears the flags. "Clear" is defined as an inspectable behaviour (the operator
  either resolves the flagged items — via ri-file resolution / moving stalled work —
  or explicitly acknowledges them this run).
- The escalation threshold keys off **deterministic signals only** (age/staleness
  counts). The already-decided heuristic is advisory and never contributes to the
  block count, so whether a direct run blocks is reproducible.
- On a skill-invoked (report-only) run, ri-state reports the flags but never blocks —
  the calling chain (including an `auto` ri-execute run) always proceeds.
- The three skills that call ri-state at chain end (ri-compile, ri-plan,
  ri-execute) emit the report-only token; a check confirms each handoff carries it.
- The escalation threshold is a named default (operator-agreed: block on a direct
  run when ≥5 deterministic flags, or any single deterministic flag past a hard age
  — active work stalled > 5 days or open question > 90 days), documented as
  changeable.
- ri-state's "derivation, not a decision" / "does without re-asking" / Hard-rules
  sections are rewritten to admit the direct-run acknowledgement gate, so the skill
  does not self-contradict.
- All edited skill copies are in parity.

## Test specification

Instruction-file change; verify by coherence inspection:

- ri-state branches on an explicit token: token present → report-only; token absent
  → direct/blocking. No other inference of source appears.
- The three calling skills' "hand off to ri-state" steps each emit the report-only
  token (verify all three).
- The escalation threshold is a named, changeable default and keys off deterministic
  signals only; the already-decided heuristic is excluded from the block count.
- The acknowledgement gate is defined: STATE still commits; the run is incomplete
  until cleared. ri-state's "derivation/does-without-re-asking/Hard rules" sections
  are updated to match, and the anti-drift rule is left intact.
- No path lets a report-only refresh block a chain; no path lets a direct
  over-threshold refresh pass silently; an untokened run defaults to blocking.
- Parity across ri-state, ri-compile, ri-plan, ri-execute.

## Implementation notes

Edit canonical copies then cp to install (all in parity):

- In `ri-state/SKILL.md`, extend the hygiene-audit step (from t1) with source
  awareness driven by an explicit token: if the invocation carries a report-only
  token (emitted by a calling skill at chain end) → report the flags and return,
  never block. Otherwise (no token — a direct operator run, or any unknown source)
  → apply the escalation threshold and, when crossed, hold an acknowledgement gate.
  Absence of the token defaults to direct/blocking; do NOT infer source any other
  way. State both branches plainly and the threshold as a named default.
- Define the acknowledgement gate concretely: STATE still regenerates and commits
  as normal; the run then surfaces the flags and is not complete until the operator
  clears them (resolve the flagged items, or explicitly acknowledge this run). It is
  a conversational gate, never a refusal to write STATE.
- Threshold uses deterministic signals only (stale/stalled ages and their counts).
  The already-decided heuristic is reported but excluded from the block count.
- In `ri-compile`, `ri-plan`, `ri-execute` SKILL.md, at the point each hands off to
  ri-state at chain end, state that the handoff emits the report-only token — so the
  gate never converts their authorised chain into a blocking review. Missing the
  token on any caller would fail the control toward blocking (safe but obstructive),
  so each caller's handoff must carry it; verify all three do.
- Rewrite the ri-state sections that would otherwise contradict the gate: the
  "derivation, not a decision" line, the "does without re-asking" section, and the
  relevant Hard rules — so they admit the direct-run acknowledgement gate. Keep the
  anti-drift rule intact (STATE is still derived and regenerated, never hand-edited).
- Depends on t1 (the audit must exist before it can be made blocking/source-aware).

## Status

active
