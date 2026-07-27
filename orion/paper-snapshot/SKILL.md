---
name: paper-snapshot
description: Rasterise a page of a built paper PDF into a share-ready PNG - typically the first page, for posting to X or embedding in announcements. Triggers on requests for a "screenshot" of a paper's first page, an image of the paper for social media, or a page-N snapshot of a rendered PDF. Produces the image and puts it where marketing drafts live; posting itself stays manual.
model: opus
---

# paper-snapshot

Turns a page of the built PDF into a PNG the operator can upload by hand. The
PDF (built via `paper-render`, first page usually styled via
`arxiv-first-page`) is the source - never screenshot the HTML artifact or the
markdown preview; only the PDF shows the page as it actually ships, stamp and
page-breaks included.

## The recipe

pymupdf, one call, no browser involved:

    python3 -c "
    import fitz
    d = fitz.open('PAPER.pdf')
    d[0].get_pixmap(matrix=fitz.Matrix(2.5, 2.5)).save('OUT.png')
    "

- **Scale 2.5** takes an A4 page to ~1500 x 2100 px - crisp on X's timeline
  and lightbox without being a bloated upload. Below ~2x the body text goes
  fuzzy when zoomed; there is no need above ~3x.
- **Page index** is zero-based; default to page one (`d[0]`) unless the
  operator names another page (a results table or figure page also makes a
  good post).
- The PDF's white background comes through as opaque white - correct for
  timelines in both light and dark mode. No transparency, no added chrome.

## Where the file goes

The snapshot is marketing collateral, not evidence. Keep it **out of the
public research repo** - a push there is publication, and a social crop does
not belong beside the evidence pack. Put it with drafts in the private repo's
`sdlc/raw/`, named after the paper (`<paper>-page1.png`), and hand the
operator the path. Posting to X is the operator's manual step; this skill
ends at the file.

## Verify before handing over

Read the PNG and look at it. The snapshot inherits whatever state the PDF was
in - a stale build, a vanished margin stamp, or a clipped table transfers
straight into the post. If the paper changed this session, rebuild the PDF
first (paper-render lockstep: markdown -> HTML -> PDF), then snapshot. Report
the pixel dimensions with the path so the operator knows what they are
uploading.
