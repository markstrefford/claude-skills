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

# Epic — Retire SDLC.md and single-source the vocabulary

## Executive summary

The workflow describes itself in three places that disagree. The per-repo
`SDLC.md` says one thing, the skills do another, and the work trees contain
a third. Measured across the repos under active development — around 900
artefacts — there are fifty frontmatter fields, fourteen artefact kinds and
eighteen status values in use, against ten, seven and three that are
written down anywhere.

Nothing detects the difference, so every session widens it. Two failures on
the day this was captured came straight out of it: an epic filed as
finished while still holding live work, and five items sitting in the
active queue that had never been started.

`SDLC.md` goes away rather than moving. Seven copies exist, no two alike,
sizes from five to twenty kilobytes, four of them months stale, three of
them referenced by nothing at all. Everything in them already has a better
home: the workflow belongs to the skills that run it, repo gates and
invariants belong in the repo config, and standing rules belong in the
repo's own instructions where they are already read. Only the shared
vocabulary needs somewhere new, and it belongs with the skills that emit it.

What is left is a workflow that states itself once, skills that emit only
what is stated, every repo agreeing, and a check that reports the next
divergence instead of absorbing it. Behaviour doesn't change — same verbs,
same tiers, same autonomy model, same gates.

## Outcome

- No `SDLC.md` in any repo. Its content lands in the three places that
  already exist: the skills, the repo config, the repo's own instructions.
- One statement of the shared vocabulary, held with the skills that emit it
  rather than copied per repo.
- Repo-specific facts — tier, gates, invariants, and each repo's own
  subject-matter artefact kinds — declared in the repo config, including
  the three repos that currently have no config at all.
- A skills and agents bundle that is edited where it is stored, so a change
  lands once and is visible in history, and installs cleanly for someone
  else cloning the repo.
- Every artefact kind and state value in use either described by the shared
  vocabulary or declared by the repo as its own.
- Ids that restart within their parent and sort correctly, so a story with
  four pieces of work reads as four rather than thirty-five.
- One statement of whether work is queued, running or finished, rather than
  two that can disagree.
- A standing check that reports vocabulary drift, so this is a fix rather
  than a snapshot.

## Out of scope / carry-forward

**Rewriting existing artefacts.** Redundant state fields and mis-numbered
ids get corrected as artefacts are next touched. Five hundred files is not
worth a migration, and the archive verb collapses most of them anyway. The
accepted cost: old and new id formats coexist and sort badly against each
other until the old ones age out.

**Nothing carried forward on repo coverage.** All seven repos are in scope.
The skills install once and apply everywhere, so leaving any repo behind
means its next session runs new skills against a tree built under the old
model. Three of them — signalstrata, constellation-core, voss_crm — have no
config file and run at the highest rigor by default; that is the right tier
for each, so the work is recording it rather than changing it.

**Normalising the stray state values.** Around a dozen artefacts use words
that are synonyms of values the vocabulary will define. Worth correcting,
but after there is something to correct them against. Dated follow-up
rather than silent carry.

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

**Retirement is not deletion, and local is not the only destination.** Each
repo's copy mixes three things: workflow the skills already own, invariants
genuinely local to that repo, and rules that read as local but are actually
standing policy everywhere. Each needs a different home, and a rule sorted
into the wrong one is either lost or wrongly confined to one repo. The two
copies at the current version are near-identical and easy; the older ones
carry sections that both duplicate and contradict what the skills now do,
and deciding what survives is a judgment call per repo, not a merge.

**The no-pull-requests rule is the live instance of that.** It is recorded
in one repo as though local; it is standing policy for all of them. The
skills still route story close to a pull request by tier, so in six repos
the workflow is currently instructing the operator to do something the
operator has ruled out. This is drift being actively served, not just
recorded, and it should be corrected ahead of the retirement rather than
inside it.

**Removing the state field breaks a precondition elsewhere.** The archive
verb refuses to act unless an epic's file says it is finished. If the state
field goes away without that verb changing in the same breath, epic close
hands off to something that can never proceed — and it fails at the end of
the next epic to close, anywhere, in a chain the operator has already
approved.

**Removing the state field also removes a signal that was doing work.** The
state refresh reads it to pick out what is in flight. Placement alone
cannot distinguish work that is running from work that is merely sitting in
the active folder — which is precisely the second of the two failures that
motivated this epic. Whatever replaces that derivation has to be settled
inside the story, not assumed.

Nothing is committed outside this repo without operator approval per repo.

## Roadmap

- s01 — stop the skills and agents bundle being a copy, so an edit lands once
- s02 — state the shared vocabulary once, with a declared way for a repo to extend it
- s03 — ids restart within their parent and sort correctly
- s04 — placement becomes the single statement of state, without breaking what read the old one
- s05 — retire SDLC.md across all seven repos, sorting each rule to the skills, the repo config, or the repo's own instructions
- s06 — the state refresh reports vocabulary drift

## Acceptance

1. No repo contains an `SDLC.md`, and nothing references one.
2. Every rule in a retired copy survives, in the right one of three homes:
   the skills where it is standing policy, the repo config where it is a
   gate or tier, the repo's own instructions where it is genuinely local.
3. Story close never routes to a pull request, in any repo, at any tier.
4. A census of the live work trees returns no artefact kind or state value
   that the vocabulary doesn't describe or the repo doesn't declare as its
   own — other than the dozen known strays, which carry a dated follow-up.
5. No skill emits a field or value the vocabulary doesn't describe.
6. A newly planned story numbers its first piece of work as the first, the
   numbers sort in the order they were created, and the skill's own worked
   example shows that restart.
7. An edit to a skill or an agent is visible in this repo's history without
   a manual copy step, and the documented install works for someone who
   only has the repo.
8. Every repo has a config file declaring its tier.
9. The state refresh names any artefact carrying vocabulary the shared
   statement doesn't describe.

## Status

Compiled 2026-08-09 from two raw captures, grounded in a census of the live
repos, revised after senior review and again on the operator's call to
retire `SDLC.md` rather than relocate it. Stories are one-liners in the
roadmap; each gets planned against the actual skills before any work
starts. Sequence matters — the distribution fix first, then the vocabulary,
then the skills that emit it, then the retirement.
