---
name: evidence-analysis
description: Turn raw multi-run experiment output (event logs, decision traces, transcripts across many runs) into a traceable evidence base a paper can be built from - per-run extraction, cross-run rollup, and a synthesis whose every claim lands on a receipt. Triggers on requests to analyse experiment/run data, build an evidence pack, roll up results across runs/seeds/models, or produce findings from raw logs. Encodes a layered pipeline pattern; the specific tiers are an example and are expected to vary per study.
model: opus
---

# evidence-analysis

Turns the raw output of a multi-run experiment - event logs, decision traces, transcripts, telemetry, across many runs, seeds, and conditions - into an evidence base where every claim traces to a receipt. The output feeds `research-paper` (which writes the report) and `research-repo-publish` (which publishes the pack).

This is a **pattern, not a fixed pipeline**. The tiers below are one instantiation; a given study adds, drops, or reshapes them. What is invariant is the shape: extract per-run, roll up across runs, synthesise into receipted claims, and keep rigorous separate from provisional throughout.

## The invariant shape

1. **Per-run extraction.** For each run, pull the facts that matter into a stable format: the decision trace with reasoning, a telemetry window, the outcome, the exemplar quotes. One artifact per run, per view.
2. **Cross-run rollup.** Aggregate the per-run facts into per-condition rates with their spread: hold rates by model, premium by seed, the scorecard. This is where "43 of 50" and its range come from.
3. **Synthesis + claims ledger.** State the headline claims, each as a rate with spread and a pointer to its receipt (run id, quote, or value). The ledger is the spine the paper is written from.

An example tiering that worked (do not treat as required): per-run governor-trace, telemetry-window, outcome-consistency, distribution chart, and readable dossier; then a per-model rollup and a cross-run pattern list; then the synthesis and claims ledger. Your study's tiers will differ - keep the three-layer shape, name the tiers for what they produce.

## Non-negotiables

- **Every claim traces to a receipt.** A rate points to the runs behind it; a behavioural claim points to a verbatim quote with its run id; a number points to the rollup cell it came from. A claim without a receipt is a draft, not a finding.
- **Label by reasoned read, and name the judge.** When outcomes are labelled by an LLM reading the full trace (more accurate than a keyword classifier on ambiguous cases), name the model that did it and treat that read as the authoritative label. State it at the method. Do not assume which model did the labelling - verify it against the run record before writing it down.
- **Rates carry their spread.** A hold rate is a rate and a range across seeds; economic effects vary run to run even when behaviour does not. Report the spread, not just the mean.
- **Rigorous and provisional never mix.** In-session, single-run, or unverified analysis is quarantined and labelled as such - its inputs may be reusable, its conclusions are not established. Never let a provisional conclusion (e.g. a "welfare null" drawn from one run) leak into the synthesis as a finding.
- **Provenance is recorded.** Prompt version, scenario, tick count, seed set, model set - captured once in a manifest so any claim can be traced back to the exact conditions.

## Determinism and reproducibility

Where runs are deterministic given a seed, say so and pair each experimental run with its matched baseline (same seed, condition off) so effects are differences, not absolutes. Keep the scripts that produce each tier; keep the bulk raw logs out of the published tree (gitignore) but analysable locally.

## Handing off

The synthesis + claims ledger is what `research-paper` reads first. Give it clean inputs: the scorecard, the pattern list, the verbatim receipts, and an honest note on what is solid versus qualified. The paper's rigor is only as good as this base - the hook, the headline rates, and every quoted receipt come from here.
