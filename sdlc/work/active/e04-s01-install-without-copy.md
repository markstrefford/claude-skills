---
id: e04-s01-install-without-copy
kind: story
project: claude-skills
parent: e04-sdlc-contract-consolidation
status: active
autonomy: attended
sources: [raw/fix-the-install-no-copy.md]
created: 2026-08-09
updated: 2026-08-09
---

# Story — Install without copying, so an edit lands once

## Executive summary

The documented install copies this repo's content into the folders Claude
reads from. Those folders are then where editing actually happens — so a
change lands somewhere with no history, and the next install silently
overwrites it.

It has already bitten twice. The archive verb was written straight into the
install and the execute verb edited there; neither existed in this repo
until they were copied back by hand, and nothing warned. It happened again
while this epic was being compiled — a correction to the execute verb had
to be hand-copied to take effect.

The defect is not the copy itself. It is that the copy is editable and
authoritative: it is both what runs and what people change. Either the
repo becomes what runs, or the copy becomes something nobody edits and a
single command regenerates. This story picks one and applies it to every
surface the repo installs into.

Every other story in the epic edits skills, so until this lands, any
correction the epic makes can be silently lost.

## Outcome

- What Claude loads is traceable to a tracked file in this repo — one place
  to edit, one place with history.
- All three installed surfaces are covered: the skills, the agents, and the
  navigation hook. Each has the same defect today.
- Both sets of skills in this repo — the workflow verbs and the research
  skills — are installed and documented. The research set is installed on
  this machine and appears nowhere in the README.
- Content in those folders that does not come from this repo keeps working.
- Someone who only has a clone can install and get the same result, without
  knowing where the clone sits.
- The README documents whatever replaces the copy, including an uninstall
  that leaves nothing behind.

## Out of scope / carry-forward

**Choosing the mechanism up front.** Symlinks, a regenerating sync command,
and the platform's own plugin distribution all reach the outcome, and they
trade off differently against the staging question below. The mechanism is
a plan-time call made against the real install, not a compile-time
assumption. Nothing here rules any of them in or out.

**Moving the research skills under the distributable directory.** If a
clone should ship them by default, that is a repo-layout change with its
own consequences. The story requires them installed and documented; where
they live is decided at plan time.

**Changing what any skill does.** This story changes where things live and
how they get there, nothing else.

**Tidying the agents that come from elsewhere.** Four of the six agents in
place predate this repo and are not referenced by it. They must keep
working; whether they should be in the repo is a separate question.

## Standing gate

**The copy was buying something, and removing it has a cost.** Today the
installed folder is a snapshot, so this repo's working tree is a safe place
to edit — a half-finished change doesn't affect the session making it. If
the repo becomes what runs, the working tree becomes live for every repo on
the machine: an incomplete edit, a branch switch, or checking out an older
commit changes the workflow every session is executing, including the
session doing the editing. Five of this epic's six remaining stories edit
these skills. Whatever mechanism is chosen has to answer this, either by
keeping a deliberate staging step or by accepting the working tree as live
and saying so.

**The cutover can destroy the thing the story exists to protect.** Removing
the current install means removing folders that have twice been the only
home of real work. They happen to match the repo today. Nothing guarantees
they still will when the work runs, so reconciliation comes before removal,
not after.

**The mechanism's core assumption is unverified.** Whether Claude loads
skills through a link, and whether an edit takes effect in a running
session or only at next start, is the difference between the candidate
mechanisms. It is load-bearing and has to be tested before cutover, not
assumed — if it fails after the old install is gone, the workflow is
missing from every repo mid-epic.

**A path-anchored install has its own silent failure.** If what runs
resolves to the clone's location, moving or deleting the clone breaks the
workflow everywhere with no warning. Whatever is chosen needs an answer for
a legitimately relocated clone.

## Acceptance

1. Editing a skill, an agent, or the hook changes what Claude runs, with no
   copy step, and the file edited is the tracked file in this repo.
2. Both sets of skills in this repo are installed and load correctly.
3. The agents that do not come from this repo still load and still work.
4. Installed content is reconciled against the repo before anything is
   removed, and any difference is resolved into the repo first.
5. The README's install produces a working setup for someone who has only
   cloned the repo, and its uninstall removes everything the install added.
6. The chosen mechanism is verified working before the existing install is
   removed.

## Status

Compiled 2026-08-09 from the raw capture, grounded in the state of the
install on this machine, revised after senior review. Gates the rest of the
epic — every later story edits skills, and until this lands those edits can
be overwritten. Plan reads the install surface and tests the mechanism
before writing the cutover.
