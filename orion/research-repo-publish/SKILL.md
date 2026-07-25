---
name: research-repo-publish
description: Make a research repository's public tree present a finished artifact cleanly - the report at the front door, a legible evidence pack, and nothing draft, provisional, or internal-only left publicly visible. Triggers on requests to tidy/organise a research or evidence repo for publication, "the report is buried", "what are all these published files", or preparing a study to go public. Encodes a structure and a keep/drop discipline, not one repo.
model: opus
---

# research-repo-publish

Gets a research repo's **public** tree into a state an outside reader can land in and understand: the finished report is the front door, the supporting evidence is legible and named for what it is, and everything draft, provisional, or internal-only has been removed from what ships. A public repo is a publication surface - a push there **is** publication - so what is visible is a deliberate choice, not an accident of where the pipeline happened to write files.

This is the last step of the research family: `evidence-analysis` produces the evidence, `research-paper` writes the report, `paper-render` renders it, and this skill packages the whole thing for the public.

## The failure this fixes

A study's output tree usually grows from the analysis pipeline, so the finished report ends up buried many levels deep in a folder named for an internal tier or epic id, surrounded by intermediate pipeline dumps, draft findings, and next-step handoffs - all of it tracked and therefore public. The reader cannot find the report, cannot tell the names apart, and cannot tell which files are trustworthy. The fix is structural (front-door the report) and editorial (publish only what you stand behind).

## Target structure

Lead with the deliverable; make every remaining folder reader-facing:

    <study>/
      README.md              # the study, the finding, and how the evidence is organised
      <Report>.pdf           # the finished report, at the front door
      paper/
        <report>.md          # the source, named for the report - not for a pipeline tier
        figures/             # the figures the report uses, beside it
      evidence/
        README.md            # one manifest: what each folder is, in plain language, with provenance
        <reader-facing folders>   # scorecards/, transcripts/, rollups/, origin/, the prompt
      scripts/               # analysis + build scripts, for reproducibility

Rename away from internal codes. Epic/tier/seed ids (`e14-s06`, `t3-synthesis`, `kimi-s105`) mean nothing to a reader; name folders for what they contain. Preserve provenance in the evidence README and in the source repo's manifests, not in the public folder names. Use `git mv` so history follows.

## Keep or drop: what belongs in public

The test is two questions - *would an outside reader use this?* and *do we stand behind it in public?*

**Keep (publish):**
- The finished report (PDF) and its source + figures.
- Rigorous, committed evidence: scorecards/results, the transcripts that are the primary receipts, cross-run rollups, the origin findings, the exact prompt.
- Scripts needed to reproduce the analysis and rebuild the report.

**Drop from public (keep locally or in the working repo):**
- Anything marked `status: draft` or `provisional` - especially a folder whose own README says "do not rely on anything here". Publishing a "do not rely" folder undercuts the report.
- Internal handoffs and working notes (facts-for-the-next-epic, claim ledgers used only during writing) unless they add reader value.
- Raw pipeline intermediate dumps: hundreds of per-run, per-tier files in internal formats that no external reader will navigate. The report + rollups + transcripts already carry the evidence. Keep these local for deep reproducibility if wanted, but they are not a public artifact.
- Bulk data caches - gitignore them (e.g. `**/raw-r2/`) and delete the local copies as housekeeping.

When a keep/drop call is genuinely the operator's judgment (how much raw evidence to expose, which transcripts to include), surface it as a decision, recommend, and let them choose.

## Editorial hygiene

- **No tracked file marked draft or provisional.** If the report is done, its surrounding framing is done too. Rewrite the top-level README to lead with the finished study, not an unfinished "evidence pack".
- **One manifest.** A single evidence README that explains every remaining folder in reader-facing language, with provenance (how many runs, what prompt, what scale). Not several draft indexes.
- **Provenance survives the rename.** Reader-facing names plus a manifest that records the original passes/ids.

## Execution

- `git mv` every move so history is preserved.
- Update any in-document paths the moves break - figure references in the report source especially.
- Commit the report's build recipe (from `paper-render`) so the PDF stays regenerable.
- One PR into the public repo's main. Remember the push is publication - review the final tracked file list before merging.

## Ship checklist

- The report PDF and a rewritten README sit at the study's front door; the source and figures are beside it and every reference resolves.
- No publicly tracked file is `draft`/`provisional`; internal handoffs and provisional folders are untracked.
- Raw intermediate dumps are dispositioned; whatever stays public is named for what it is.
- `evidence/` has one manifest explaining every folder, with provenance.
- History preserved via `git mv`; one PR; the final tracked list reviewed as publication.
