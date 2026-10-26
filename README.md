# claude-skills

Skills for [Claude Code](https://code.claude.com/docs) from Reimagined Industries. The repo holds two independent sets.

| Set | What it does | Install |
| --- | --- | --- |
| [**ri-skills**](ri-skills/README.md) | A software development lifecycle: capture, compile, plan, execute, file, state and archive, with fresh-context verification, architectural and security review, and ceremony set per repo by risk tier | Copy the files into `~/.claude`, or install the plugin. See [installation](ri-skills/docs/installation.md) |
| [**orion**](orion/README.md) | Research skills that turn a body of experimental evidence into a published paper: evidence analysis, paper writing, rendering to HTML and PDF, arXiv-style first page, social snapshot, and publishing the research repo | Copy the skill folders into `~/.claude/skills/` |

Each set's README covers what it does, how to install it and how to use it. The ri-skills documentation is in [ri-skills/docs](ri-skills/docs/), and its releases are in [ri-skills/CHANGELOG.md](ri-skills/CHANGELOG.md).

## Layout

```
ri-skills/            the SDLC plugin: skills, agents, hook, examples, docs, changelog
orion/                the research skills
.claude-plugin/       the marketplace that publishes ri-skills
.ri/  sdlc/           this repo's own work tracking: it is developed with ri-skills
```

MIT licensed: see [LICENSE](LICENSE).
