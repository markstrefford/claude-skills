---
id: e04-sdlc-contract-consolidation
kind: epic
project: claude-skills
status: active
autonomy: attended
sources: [raw/t31-sdlc-vocabulary-alignment.md, raw/fix-the-install-no-copy.md]
created: 2026-08-09
updated: 2026-08-09
---

# Epic — SDLC contract consolidation

## Executive summary

The workflow describes itself in three places that disagree. The per-repo
`SDLC.md` says one thing, the skills do another, and the work trees contain
a third. Measured across the three repos under active development — around
900 artefacts — there are fifty frontmatter fields, fourteen artefact kinds
and eighteen status values in use, against ten, seven and three that are
written down anywhere.

Nothing detects the difference, so every session widens it. Two failures on
the day this was captured came straight out of it: an epic filed as
finished while still holding live work, and five items sitting in the
active queue that had never been started.

This epic makes the contract single-sourced, gives it a distribution
mechanism that doesn't rot, and leaves behind a check that keeps it true.
The shared vocabulary moves out of the seven diverging per-repo copies; the
skills are corrected to emit only what the contract describes; the repos
under active development are brought onto it; and the state refresh gains a
conformance flag so the next divergence is reported rather than
accumulated.

It does not change how the workflow behaves. The verbs, the tiers, the
autonomy model and the gates all stay as they are. This is about the
workflow being able to state what it is, and notice when it stops.

## Outcome

- One shared contract — glossary, directory layout, artefact contract,
  vocabulary — held in a single place rather than copied per repo.
- Repo-specific facts stay per-repo, in the config file that already exists
  for most of them, including each repo's own subject-matter artefact kinds.
- A skills and agents bundle that is edited where it is stored, so a change
  lands once and is visible in history, and installs cleanly for someone
  else cloning the repo.
- Every artefact kind and state value in use either described by the
  contract or declared by the repo as its own.
- Ids that restart within their parent and sort correctly, so a story with
  four pieces of work reads as four rather than thirty-five.
- One statement of whether work is queued, running or finished, rather than
  two that can disagree.
- The repos under active development agreeing with the contract, and their
  own copies reduced to what is genuinely local to them.
- A standing check that reports vocabulary drift, so this epic is a fix
  rather than a snapshot.

## Out of scope / carry-forward

**Rewriting existing artefacts.** Redundant state fields and mis-numbered
ids get corrected as artefacts are next touched. Five hundred files is not
worth a migration, and the archive verb collapses most of them anyway. The
accepted cost: old and new id formats coexist and sort badly against each
other until the old ones age out.

**The three dormant repos** — voss_crm, Content-Pipeline, constellation-core.
Carry-forward, not scope. Because the skills are global, they receive the
behaviour change without the migration, so the skills must tolerate a work
tree built under the old model rather than assume the new one. That
tolerance is in scope; migrating those repos is not.

**Normalising the stray state values.** Around a dozen artefacts use words
that are synonyms of values the contract will define. Worth correcting, but
after the contract exists to correct them against. Dated follow-up rather
than silent carry.

**Replacing the stable-id rule.** The source note proposed replacing an
existing rule about moved artefacts leaving a marker file behind. That rule
does not exist — not in any repo's copy and not in any skill. Nothing to
replace, so the item is dropped rather than carried.

**Changing workflow behaviour.** No new verbs, no changes to the tier
model, the autonomy gate or the governance gates.

## Standing gate

The skills are global and every Reimagined Industries repo runs them, so
the blast radius is every project, not this one. That is why this repo is
governed at the highest rigor.

Three things carry real risk.

**The state change reaches repos the migration doesn't.** The skills
install once and apply everywhere; only the actively-developed repos get
brought onto the contract. Every other repo's next session runs new skills
against an old tree. The skills have to degrade gracefully there, and that
is a requirement on the story, not a sequencing problem.

**Removing the state field breaks a precondition elsewhere.** The archive
verb currently refuses to act unless an epic's file says it is finished. If
the state field goes away without that verb changing in the same breath,
epic close hands off to something that can never proceed — and it fails at
the end of the next epic to close, anywhere, in a chain the operator has
already approved.

**Removing the state field also removes a signal that was doing work.** The
state refresh currently picks out what is in flight by reading that field.
Placement alone cannot distinguish work that is running from work that is
merely sitting in the active folder — which is precisely the second of the
two failures that motivated this epic. Whatever replaces that derivation
has to be settled inside the story, not assumed.

Nothing is committed outside this repo without operator approval per repo.

## Roadmap

- s01 — stop the skills and agents bundle being a copy, so an edit lands once
- s02 — settle the shared contract, correct every skill that emits vocabulary, and give repos a declared way to extend it
- s03 — ids restart within their parent and sort correctly
- s04 — placement becomes the single statement of state, without breaking what read the old one
- s05 — bring the repos under active development onto the contract
- s06 — the state refresh reports vocabulary drift

## Acceptance

1. A census of the live work trees returns no artefact kind or state value
   that the contract doesn't describe or the repo doesn't declare as its
   own — other than the dozen known strays, which carry a dated follow-up.
2. No skill emits a field or value the contract doesn't describe.
3. The shared contract exists in exactly one place. Where a per-repo file
   survives, it holds only what is genuinely local to that repo and points
   at the shared contract for the rest.
4. A newly planned story numbers its first piece of work as the first, the
   numbers sort in the order they were created, and the skill's own worked
   example shows that restart.
5. An edit to a skill or an agent is visible in this repo's history without
   a manual copy step, and the documented install works for someone who
   only has the repo.
6. A repo that has not been migrated still refreshes its cursor and runs
   its work queue without error.
7. The state refresh names any artefact carrying vocabulary the contract
   doesn't describe.

## Status

Compiled 2026-08-09 from two raw captures, grounded in a census of the live
repos and revised after senior review. Stories are one-liners in the
roadmap; each gets planned against the actual skills before any work
starts. Sequence matters — the distribution fix first, then the contract,
then the skills that read it. Two questions are parked in the judgment
queue rather than settled here.
