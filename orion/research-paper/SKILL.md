---
name: research-paper
description: Write or regenerate a research paper from a body of evidence — turning a directory of runs, measurements, traces, and a claims ledger into a rigorous, results-forward paper whose rigor is the selling point. Triggers on explicit slash command (/research-paper), or requests to write/draft/regenerate a paper, findings document, or research writeup from evidence ("write this up as a paper", "regenerate the paper", "turn the evidence into a writeup", "make the synthesis document"). Encodes a reusable pattern, not one paper. Use whenever a body of evidence needs to become a paper.
model: opus
---

# research-paper

Turns a body of evidence — runs, measurements, traces, a claims ledger — into a research paper. The paper is an OUTPUT, regenerated from two inputs: **this skill** (the HOW) and an **evidence directory** (the WHAT). When you learn something about how to write better, edit this skill; then regenerate. The skill is the durable asset; the paper is disposable and cheap to reprint.

This is a pattern, not a template for one paper. It must fit any research the operator runs — an economics study, a benchmark, an ablation, a safety audit. Where this skill gives a concrete example, it is drawn from a past paper and marked as illustration, never as a required subject.

## The one principle everything serves

**The rigor is the selling point — so make the results shine, and let the evidence carry them. Show; never tell.**

A paper earns belief by being concrete, quotable, receipted, and honest about its edges — not by announcing that it is rigorous. There are two failure directions, both fatal:

- **Hype without receipts** — claims that outrun the evidence. A reader who catches one unbacked claim distrusts every other claim in the document.
- **Rigour theatre** — opening with methodology, hedging findings that are actually solid, foregrounding *how you measured* instead of *what you found*. The reader never reaches the amazing thing.

Aim between them: strong claims, stated plainly, each landing on a receipt. If a finding is airtight, say it airtight. If it is qualified, qualify it. Calibrate to the evidence, in both directions.

## The method: message first, then outline, then prose

Never draft prose first. The order is fixed, and it is the whole game:

1. **Nail the core messages.** In plain sentences, what is the paper actually claiming? Three to seven of them. Each must be TRUE of what you did, not what sounds impressive. Get these agreed before anything else. A polished paragraph built on a wrong message is wasted work, and worse, it misleads.
2. **Outline to the messages.** One line per section, naming which message it carries. Structure serves the messages, never the reverse.
3. **Only then flesh out**, section by section, each claim grounded in a receipt.

Most wasted effort in writing comes from fleshing out before the message is right. When handed a body of evidence, produce the core-messages list and the outline FIRST, get agreement, then write. This is what makes a clean one-pass draft possible: the thinking is finished before the prose starts.

## Before you write a word

1. **Read the whole evidence base.** Not a summary, not from memory — the actual runs, traces, ledgers, rollups on disk. You cannot make shine results you have not seen, and you will hedge or misstate what you only half-read. If the evidence is large, fan out and read it all.
2. **Find the hook: the single most surprising TRUE thing.** Usually a counterintuitive result (in the exemplar: *price discipline harmed the victim more than defection did*). The hook leads the subtitle and often the abstract. It is the reason a stranger keeps reading.
3. **List the headline claims, each with its strength.** For every claim: the rate, its spread/variance, and the on-disk receipt. Know which claims are airtight, which solid, which qualified. A claims ledger, if one exists, is your spine — read it first.
4. **Collect the verbatim receipts.** The exact quotes, numbers, and traces that prove each headline. These are the paper's currency — the deepseek "I'm holding 3.5x" over its private undercut; the fabricated reading a peer then relied on. One vivid, real receipt beats three sentences of assertion.
5. **List what the work builds on.** The lineage — foundational works and the sister studies you compare against. You will acknowledge them at the end.

## Structure — a spine, not a cage

Use the sections that carry THIS paper's argument. Most papers want most of these, in this order. Do not import another paper's full structure wholesale — take the pattern, fit your material.

- **Title + results-forward subtitle.** The subtitle states the result or the hook, not the topic. Not "A controlled study of X" but "Give two agents a supply line and a reason to cheat — in 46 of 50 runs they formed a cartel." The reader should know the punchline before the abstract.
- **Abstract.** Leads with the *result*, then the method briefly, then the sharpest findings. One paragraph. It answers "what did you find" in the first sentence, not "what did you study." One exception, and it is the operator's call: when the paper opens a programme and the reader needs the setting before the specifics will mean anything, the abstract may lead with context (the field, the gap, why this environment) and let the results land in the body. Default to results-first; take context-first only deliberately, for a series opener where dropping the reader straight into study-specific detail would lose them.
- **Introduction.** Stakes (why this matters now) → the gap (what prior work leaves open) → your contributions (a tight bulleted list, each pointing at its section). Establish stakes before mechanism.
- **Design / method.** Just enough for a reader to trust the results: the setup, the conditions, the scale, the baseline, how outcomes were labelled. Enough to reproduce and to believe — no more. Method is a foundation, not a headline.
- **Results, as findings.** Each finding is a declarative claim, backed by a rate with its spread, backed by a receipt. Order by importance, not by when you measured. Counterintuitive findings get their own emphasis. Use a scorecard table where entities are compared; give it tabular numbers and, where it helps memorability, a one-word signature per entity.
- **The qualitative narrative — where the work shines.** If the evidence has stories (traces, transcripts, negotiations, failures), give them a section and lead with them, in-body — do not bury them in an appendix. This is usually the most compelling part of the paper. Carry it on short verbatim receipts, not full logs.
- **Discussion.** What it means, the cross-cutting insight, the one sentence a reader should leave with. Connect to the wider question.
- **Limitations.** The honest edges, stated plainly. This section *buys* the strong claims elsewhere — a reader trusts your airtight claims because you flagged the qualified ones. Use the defensible number, not the impressive one (45/50, not "50/50").
- **Building on.** A short acknowledgement of the lineage — foundational works and sister studies. A light list at the end is enough unless the paper is a full related-work treatment; inline placement can be a later pass.
- **Evidence base.** What backs the paper, in plain language: how many runs, what was recorded, what it was measured against. Not internal file paths or repo jargon — a reader-facing statement of the ground truth.

## Voice

- **Lead with the answer.** Every section, every paragraph: the claim first, the support after.
- **Declarative, concrete, quotable.** "The model that defects most harms the victim least" beats "our analysis suggests a possible inverse relationship."
- **Numbers are load-bearing, and they are exact.** A rate, a range, a delta — never "significantly" without the figure.
- **No jargon that hasn't earned its place.** If a term needs a decoder, define it or cut it. Never open with insider phrasing (a reader hitting "every quantitative claim is a rate with its across-seed spread" in the first line learns nothing and bounces).
- **First-person plural ("we") is fine** — it is standard research register. Restrained, not chatty.
- **Register 8/10:** real substance, dynamics connected, assuming an informed reader. Not a dense 10 of disconnected jargon; not a 3 that re-explains the obvious.

## Anti-patterns — mistakes that cost us; do not repeat

- **Do not open with methodology or an evidence disclaimer.** "We have receipts for everything" is assumed of a research paper — stating it up front wastes the most valuable line in the document. Cut the throat-clearing; open on the result.
- **Do not foreground an insignificant methodological detail.** That you used a reasoned read instead of a keyword classifier is a one-line method note at most — never a headline, never in the opening. Leading with the smallest measurement choice while an amazing body of results waits behind it is the single most common self-inflicted wound.
- **Do not call a publication an "internal document."** Write every paper as the thing that ships. If it is going out, no framing that assumes it won't.
- **Do not bury the result under process.** If a reader has to get through three paragraphs of setup to reach the finding, move the finding up.
- **Do not over-hedge solid findings.** Hedging is for genuinely uncertain claims. Applied to a solid result it reads as a lack of conviction and buries the point.
- **Do not copy an exemplar's whole structure.** Study how strong papers are built, then build yours to fit your material and its stakes. A 6-page findings paper is not a 40-page platform paper; do not graft the skeleton.
- **Do not state the rigour — show it.** Replace "this is rigorous / receipted / evidence-based" with the receipt itself.
- **Do not use the impressive number when a smaller one is the defensible one.** Overstating one figure ("50/50") makes a skeptic reread everything. The honest 45/50 is stronger because it survives scrutiny.
- **Scope a lineage or comparative claim so it cannot be nitpicked.** "X established the pattern" invites a reader to recall an earlier Y; "X was the landmark study" is equally confident and unimpeachable. When the operator is nervous a single phrase could get the whole paper dismissed, they are usually right - tighten the scope of the claim rather than weaken the sentence.

## House style and honesty (non-negotiable)

- **No em dashes, ever.** Use commas, colons, parentheses, or full stops. Applies to every document.
- **Match the proportion of the surrounding context.** When the operator explains a rationale at length out loud, compress it to fit the format. If four of five items get a one-line description, the fifth gets one line too. Never paste three paragraphs of spoken rationale into a one-line slot.
- **No staccato.** Do not string short clipped fragments or one-clause sentences together ("The economy sharpens. The library grows. The role deepens."). Join them into connected sentences with real subordination. Fix staccato by joining clauses, never by adding words: tighten, do not pad.
- **No flowery or literary phrasing.** This is a research paper, not an essay. Avoid metaphor and figurative flourish ("come apart", "both halves", "runs outward from here", "places for strategy to live", "the world waits for them", "the game decides"). Use plain, declarative, professional prose. If a phrase would feel at home in a blog headline or a song lyric, cut it.
- **Precise domain terminology.** Use the subject's own words exactly; do not borrow another field's or another paper's vocabulary. A thing is what it is in this system (a "system", not a "world"), whatever a neighbouring paper calls its objects.
- **Name what you actually did; do not dress it up.** If the prompt instructed a behaviour, it is not "emergent". If a result is a property of how you built the environment, it is a characteristic, not a discovery. Distinguish a finding (the world revealed it) from a design consequence (you caused it), and state design consequences forward ("the current model does X; the next step is Y"), never as a confessional realization.
- **Drop internal identifiers a reader does not need.** Run IDs, ticket codes, seed numbers, and repo paths are reproducibility metadata, not reader-facing, unless the identifier itself carries meaning (e.g. same setup, different run).

## Attribution and the use of AI

When a study is produced with AI assistance and will carry that openly, two pieces belong in the paper:

- **Byline.** Name the human author and, where the work warrants it, the AI agent as a disclosed contributor (not an acknowledgement-only footnote). A named, disclosed AI co-worker is honest and, for a research programme, a coherent stance.
- **A short "use of AI" section.** State the organisation's use of AI in confident present tense (what it does, not what it "aims to do"), name the agent and its role in producing the paper, and close with the line that carries the weight: *all claims, results, and conclusions are the responsibility of the human author*, plus a correspondence address. Keep this section about the general use of AI in the work. A specific analytical mechanism (e.g. which model assigned the outcome labels) belongs where that method is discussed, not here - name the model once, at the method.

Keep the framing mature and specific. "Uses AI extensively, with rigour and openness about how it is used" reads like an organisation that does this as a matter of course; "aims to use AI appropriately" reads tentative and defensive. And let the section deliver what it promises: if it claims openness, the surrounding method and disclosure must actually be open.

## Verify before you cite — and before you attribute

Every external claim — a comparison to another paper, a cited result, a "prior work found X" — is verified against the primary source before it goes in. Read the actual paper; do not cite from memory or from a secondhand description. If you cannot verify it, either fetch the source or frame it explicitly as reported/unverified. A confidently-wrong comparison to a paper the reader knows will sink the whole document. (In the exemplar, the Grok/Emergence-World claim was only trustworthy once the source PDF was read and the specific finding — 0/10 survival in four days — confirmed.)

The same rule applies to your own method. Do not state which model or tool performed a step from assumption or plausibility ("it was a low-complexity task, so we probably used the smaller model"); check it against the run record and write what the record says. In the exemplar the operator was confident the labelling ran on a smaller model, and the evidence showed it was Opus - naming the wrong model in a published paper's own method is exactly the kind of error the honesty of the paper is judged on.

## The regenerate loop

The paper is a function of (this skill) x (the evidence directory). To regenerate:

1. Point at the evidence directory. Read it whole (see "Before you write a word"). That directory is the output of the `evidence-analysis` skill: per-run extraction, cross-run rollup, and a claims ledger. If it does not exist yet, build it there first.
2. Draft the paper per this skill's structure and voice, grounding every claim in a receipt.
3. Produce the document (markdown, source of truth). To render it for reading and download, hand the markdown to the `paper-render` skill (theme-aware artifact + white-background paper-scale PDF). To put the finished report into a public repo, use `research-repo-publish`.
4. When the operator gives feedback, decide: is this a fact about THIS paper (edit the paper) or a lesson about HOW to write papers (edit THIS skill, then regenerate)? Prefer the second whenever the feedback generalises — that is the whole point of the loop.

Keep the source document and any rendered artifact in lockstep: edit once, mirror to both.

## Ship checklist

Before it goes out, confirm:

- The opening leads with the result, not the method or a disclaimer.
- The single most surprising true thing is visible in the first screenful.
- Every number is exact and traceable to a receipt on disk.
- Every headline claim has a verbatim receipt near it.
- Every external/comparison claim was verified against its source.
- Strong claims are matched by an honest limitations section using defensible figures.
- No internal jargon, repo paths, ticket codes, or "internal document" framing.
- The lineage is acknowledged.
- Claim strengths are calibrated — airtight stated plainly, qualified flagged.
