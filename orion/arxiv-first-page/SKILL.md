---
name: arxiv-first-page
description: Restyle a rendered paper's first page to arXiv conventions - centred serif title block, authors/affiliation/date, plain centred abstract, and a rotated provenance stamp down the left edge. Triggers on requests to make a paper "look like arXiv", give a report an arXiv-style first page or preprint cover, or academic-formalise a paper's opening. Works on the paper-render HTML/PDF pipeline; encodes the layout conventions and the print fixes, not one document.
model: opus
---

# arxiv-first-page

Gives a paper rendered through `paper-render` a first page that reads like an
arXiv preprint. Only the first page changes - title block, abstract, and a
left-edge stamp; the body of the document keeps its existing style. The
markdown stays the source of truth: mirror the title-block change back into it
(authors line, affiliation, date), then flow markdown -> screen HTML -> print
HTML -> PDF as paper-render prescribes.

## Never fabricate an arXiv identity

The stamp and the layout borrow arXiv's *visual grammar*, not its identity. No
made-up `arXiv:2507.xxxxx` number, no category tag pretending to be a real
submission. The rotated stamp carries real provenance instead - publisher,
series, study, date - e.g.:

    Reimagined Industries . Constellation . Agentic Economy Playbooks, study one . 27 Jul 2026

If the paper is ever actually submitted, arXiv adds its own stamp; until then a
fake one would misrepresent the work. This is a hard rule, not a taste choice.

## The first-page anatomy

- **Title** - centred, serif (the document's body serif is fine; no separate
  display face), ~1.9rem, bold, letter-spacing 0. Not the web-style
  left-aligned display title.
- **Authors** - one centred line, names separated by a wide gap
  (`span.gap { display:inline-block; width:2.2em }`), affiliation on its own
  smaller muted line beneath, then a contact email in small monospace under
  that (e.g. `research@reimagined.industries`). The email, not a caveat: the
  operator prefers no per-author explanatory notes on the first page.
- **Date** - centred, its own line, a little below the affiliation.
- **Abstract** - no panel, no background, no border. A centred bold "Abstract"
  heading in the text face (not the mono eyebrow style), over a justified
  (`text-align:justify; hyphens:auto`) block set narrower than the body column
  (~37.5rem vs 42-45rem) and slightly smaller (~.96rem). This single change -
  panel to plain centred block - does most of the arXiv work.
- **Stamp** - rotated 90deg, reading bottom-to-top, along the left edge:
  `writing-mode:vertical-rl; transform:rotate(180deg)`, monospace, ~.72rem,
  muted colour, ~.75 opacity. Kill the old web kicker/eyebrow line; the stamp
  now carries that provenance.

On screen, hide the stamp below ~62rem viewport width (it collides with the
column on phones). Everything else works at all widths.

## The print trap: Chrome clips the margin

Headless Chrome clips absolutely-positioned content that falls outside the
page content box. A stamp pushed into a 14mm `@page` side margin with
`left:-9mm` does not print faded or cropped - it vanishes entirely, with no
warning. The fix is to move the content box, not the stamp:

    @page { size: A4; margin: 16mm 6mm; }   /* side margins down from 14mm */
    .wrap { max-width: 42rem; }             /* text column keeps its width */
    .arxiv-stamp { display:block !important; position:absolute; top:28mm; left:0; font-size:.76rem; opacity:.8; }

The printable area now reaches to 6mm from the paper edge; the text column is
still held to paper width by `.wrap`, so the body looks identical; the stamp at
`left:0` lands 6mm in from the edge, exactly where arXiv puts it. The
`display:block !important` matters: the print viewport (~57rem at paper scale)
is narrower than the screen hide-below threshold, so without it the screen
media query hides the stamp in print too.

`position:absolute` at the top of the document naturally puts the stamp on
page one only - no page-selector tricks needed.

## Verify

Rasterise page one and look at it - confirm the stamp is present (it is the
element most likely to have silently vanished), the title block is centred,
and the abstract is plain. Then check the pages with figures and wide tables:
the `@page` margin change touches every page, so a table that fitted at 14mm
margins must be re-verified at 6mm. Extract the PDF text and grep for the
stamp string as a cheap regression check.

## Ship

Mirror the new title block into the markdown (authors, affiliation, date
lines). Record the stamp text and the override CSS in the paper's committed
build note (`build.md` per paper-render) so the page regenerates. The
first-page PNG for social posts is `paper-snapshot`'s job, not this skill's.
