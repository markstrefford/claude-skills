# Configuration

Each repo has a `.ri/config.md`: YAML frontmatter holding the settings, then free prose for anything the team wants Claude to know about the repo. Start from one of the [examples](../ri-skills/examples/). A repo with no config file is treated as tier 3, and the skills say so.

## Keys

| Key | Type | Default | Read by | Meaning |
| --- | --- | --- | --- | --- |
| `project` | string | inferred from frontmatter | all | Written into every artefact's frontmatter |
| `default-rigor` | `tier-1` \| `tier-2` \| `tier-3` | `tier-3` | all | The repo's tier. See [governance](governance.md) |
| `branch-default` | `main` \| `story-level` | `story-level` | plan, execute | `main`: tier-1 repos commit straight to main (under `landing: merge`). `story-level`: each story gets a branch named for its id, shared by its tasks |
| `landing` | `merge` \| `pull-request` | `merge` | all that commit | How work reaches `main`. See below |
| `test-command` | string | none | execute, verifier | Test command for a single-stack repo |
| `stacks` | map | none | plan, execute, verifier | Multi-stack repos: each stack has a `path` and a `test` command. A task's `stack:` picks which command runs |
| `security-gate` | `required` \| `advisory` \| `off` | tier 3 `required`, tier 2 `advisory`, tier 1 `off` | plan, execute | Whether the story-close gate and the plan and epic security reviews run, and whether a gate finding blocks. Defaults follow the story's resolved tier. See [governance](governance.md) |
| `security-review` | `owasp` \| `full` | tier 3 `full`, otherwise `owasp` | execute | `owasp`: the OWASP checklist. `full`: the checklist plus `/security-review` at story close |
| `footprint` | map with `internal` and `deployed` glob lists | absent (everything deployed) | execute | Scopes the security reviews to changes that touch deployed code |
| `scanners` | list | none | execute | Commands the gate runs: each has `command`, `class` (`secret`, `dependency`, `code`) and an optional `block-threshold` |
| `version-pairing` | string | none | — | Advisory. Documents files that must version together; not yet enforced |
| `public-deploy` | boolean | none | — | Advisory. Not yet enforced |

## landing

| Value | Code | Doc-only commits (compile, plan, file, archive) | STATE.md | Gate verdict goes in |
| --- | --- | --- | --- | --- |
| `merge` | Story branch; the operator merges. Tier-1 repos with `branch-default: main` commit straight to `main` | Straight to `main`, except that archive and file commit on the story branch when a story close invokes them | Committed when on `main`; left uncommitted on a story branch | The story's done commit, offered as the merge message |
| `pull-request` | Story branch; `ri-execute` pushes it and opens a pull request | A new story is committed on its own branch, where plan and execute continue, so it lands as one pull request. Anything else goes on a short `sdlc/<id>` branch and a pull request, except archive and file at a story close, which use the story branch | Written locally, not committed; gitignore it | The story's done commit and the pull request body |

Use `merge` for a repo with one operator. Review already happens in the session, through the verifier, the senior-staff reviewer and the gate, so a pull request adds no reviewer. Use `pull-request` when a second person reviews, or when `main` has branch protection, which would reject the direct commits `merge` makes. `pull-request` needs the `gh` CLI, authenticated.

No skill merges a story. The one merge any skill makes is `ri-do` merging its own short branch at tier 2 or on a tier-3 override, under `merge` only.

## footprint

```yaml
footprint:
  internal:
    - backend/analysis/**
    - tests/**
  deployed:
    - backend/**
    - web/**
```

Classify each path a story changed. The most specific matching rule wins, measured by path depth. An unmatched path counts as deployed, and with no map at all everything counts as deployed. If two rules of equal depth conflict, the gate asks you, defaulting to running the review; in an `auto` chain it just runs it. A rename counts as deployed if either side is. One deployed path is enough to run the security review.

## scanners

```yaml
scanners:
  - command: gitleaks detect --no-banner
    class: secret              # always runs when the gate fires; any match blocks
  - command: pip-audit
    class: dependency          # footprint-scoped; high and critical block
    block-threshold: high      # optional
  - command: bandit -r backend
    class: code                # footprint-scoped
```

The gate runs each command and reads its output; it never reimplements a scan. A scanner that can't run (not installed, or a non-findings error) blocks rather than passing green.

## Artefact-level overrides

| Field | On | Overrides |
| --- | --- | --- |
| `tier:` | story, task | `default-rigor` for that work |
| `autonomy:` | story, task | The `attended` default. See [concepts](concepts.md#autonomy) |
| `stack:` / `stacks:` | task | Which stack's test command runs |
