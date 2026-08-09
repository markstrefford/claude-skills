---
id: install-by-symlink
kind: decision
project: claude-skills
parent: e04-s01-install-without-copy
area: [ri-skills]
created: 2026-08-09
updated: 2026-08-09
verified-on: 2026-08-09
---

# Decision — Install by linking each item from a clone that stays put

## The call, in plain terms

- **Each skill, agent and hook is linked individually from the repo into
  the folder Claude reads.** One place to edit, one place with history, and
  content from other sources is left alone.
- **The clone stays in the development tree.** It is a repo actively worked
  on; the install should not care where it sits.
- **The research skills stay where they are and are linked the same way.**
  They are not second-class, they were just undocumented.
- **The working tree is now live.** An unfinished edit or a branch switch
  changes the workflow every session is running. Accepted knowingly — see
  the cost below.

## What was tested

Two throwaway items — a skill and a sub-agent — were linked from the repo
into the read-from folders, live, without touching anything installed.

| Question | Answer |
| --- | --- |
| Does Claude load a skill through a link? | Yes |
| Does a sub-agent load through a link? | Yes |
| Under what name? | The bare name. No prefix, no namespace |
| Does it need a session restart? | No. Both appeared in the running session |
| Can content from other sources coexist? | Yes — linking per item leaves the folder's other entries untouched |

## What was ruled out, and why

**Whole-directory link.** Both destination folders carry content from more
than one source: the skills folder is fed by two directories in this repo,
and the agents folder holds four agents that exist in no repository at all.
Redirecting a folder wholesale drops them. Ruled out on inspection, not
tested.

**Platform plugin distribution.** Ruled out on a cost that is visible in
this session rather than assumed: plugin-provided skills are namespaced.
They surface as `plugin-name:skill-name`, so every workflow verb would be
renamed — breaking the operator's slash names and every reference across
roughly nine hundred artefacts. The same namespacing would break the bare
name each skill uses to invoke its reviewers, and that failure is silent:
the review gate would simply stop firing.

This was the right mechanism on principle — distribution is platform
infrastructure, and the standing position is to let the platform own
infrastructure. The naming cost overrides it. Worth revisiting if plugins
ever serve un-namespaced skills.

## What it costs

**The staging step is gone.** The copy was accidentally providing one: the
repo working tree was a safe place to edit because it was not what ran.
Now it is. An incomplete edit, a branch switch, or checking out an older
commit changes the workflow every session on this machine is executing,
including the session doing the editing. Five of the epic's remaining
stories edit these skills.

The mitigation is discipline, not machinery: edits to skills land on a
branch, and the branch is not left half-finished across sessions. If that
proves insufficient in practice, the fallback is a generated copy with an
explicit sync step, which restores staging at the cost of a slower loop.

**A moved or deleted clone breaks everything, silently.** Links resolve to
a path. If the clone moves, the workflow disappears from every repo with no
error. Re-running the install fixes it; nothing warns that it needs
running. Accepted as the cost of not copying.

## Consequences for the rest of the story

The cutover links per item rather than per folder, so the four external
agents and the six research skills need no special handling beyond being
included. Removal only takes out what this repo installed. The documented
install becomes a script that links from wherever the clone happens to be.
