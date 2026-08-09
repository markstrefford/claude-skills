# Open — judgment queue

Live questions for the operator — only unresolved ones live here. Each is one per
line, tagged with the work it gates and the code module(s) it touches
(`[<work-id>] [area: <module(s)>]`). The acting skills (ri-compile / ri-plan /
ri-execute) append questions; `ri-file` removes one when it is resolved (its
resolution flow). A resolved question never lingers.

- 2026-08-09 No skill currently reads SDLC.md at all, so putting the shared contract where the skills read it adds a file every verb loads on invocation — against the repo's stated principle that nothing monolithic gets loaded each session. One shared file, or each verb carrying its own slice? [e04-sdlc-contract-consolidation] [area: ri-skills/skills]
- 2026-08-09 Is signalstrata in scope for the contract migration? It has no repo config file, keeps its SDLC.md at the repo root rather than under sdlc/, and was not in the census this epic's numbers come from — so including it changes the size of that story materially. [e04-sdlc-contract-consolidation] [area: ri-skills/skills]
- 2026-08-09 Three repos have no config file at all (signalstrata, voss_crm, constellation-core), so they run at the highest rigor by accident and have nowhere to declare their own artefact kinds. Create the file for them, or let the contract assume its absence? [e04-sdlc-contract-consolidation] [area: ri-skills/skills]
