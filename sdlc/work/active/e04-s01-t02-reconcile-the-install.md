---
id: e04-s01-t02-reconcile-the-install
kind: task
project: claude-skills
parent: e04-s01-install-without-copy
status: active
autonomy: attended
created: 2026-08-09
updated: 2026-08-09
---

# Task — Back up and reconcile what is installed

## Outcome

Everything currently living only in the installed folders is backed up and,
where it belongs to this repo, brought into it — so the cutover cannot
destroy work.

## Acceptance

A restorable copy of the current install exists, including the registration
that points at the hook. Every installed file either matches its
counterpart in the repo, has been brought into the repo, or is recorded as
coming from elsewhere. The operator can see that list. Nothing is removed
in this task.

## Decisions in plain terms

- **A record is not a backup.** The cutover's revert path has to be a copy
  of the real thing, taken before anything moves.
- **The unversioned content is the reason this task exists.** Four agents
  in place exist in no repository at all — not this one, not any other on
  the machine. If the cutover removes them they are gone. They get backed
  up first and adopted by nobody.
- **Reconciliation comes before removal, every time.** The installed
  folders have twice been the only home of real work. They happen to match
  the repo today; that is a fact about today, not a property of the setup.

## Test specification

Verification, not unit tests.

**Backup, first:**

- A copy of the installed skills, agents and hooks folders, plus the hooks
  block of the settings file, exists somewhere outside those folders and
  outside the repo working tree.
- Restoring from that copy reproduces a working install. Prove it, don't
  assume it.

**Then reconcile,** file by file:

- Each of the eight workflow skills, installed against `ri-skills/skills/`.
- Each of the six research skills, installed against `orion/`.
- Each installed agent, against `ri-skills/agents/`.
- The installed navigation hook, against `ri-skills/hooks/`.

Every installed file lands in exactly one bucket, and the bucket is
recorded:

| Bucket | Disposition |
| --- | --- |
| Identical to repo | Nothing to do |
| Differs from repo | Difference reviewed; the correct version lands in the repo |
| Present only in the install, sourced from this repo | Brought into the repo |
| Present only in the install, sourced elsewhere | Backed up and recorded as external |

A difference is never resolved by assuming the repo is right. The installed
copy is where editing has actually been happening, so it may hold the newer
version — that is the whole defect being fixed.

Failure mode that must be caught: a skill present in the install and absent
from the repo, silently skipped because the comparison iterates the repo
rather than the install. Iterate the install.

## Implementation notes

At the time of planning all fourteen installed skills are byte-identical to
their repo sources and the two repo agents match. The task must not encode
that — it may be false by the time it runs, and the story exists because
that gap has twice been non-empty.

The four agents with no repo counterpart are `code-quality-reviewer`,
`performance-auditor`, `software-architect` and `test-guardian`. A search
of the development tree finds them in no repository; they exist only in the
installed folder, unversioned, and total roughly eighty kilobytes.

The hook's registration lives in the user settings file as a pre-tool
command pointing at a home-relative path. It is part of the install and
therefore part of the backup.

Output is the backup, a written reconciliation record, and where needed
commits bringing content into the repo. No removals, and no changes to what
is installed.

## Status

active
