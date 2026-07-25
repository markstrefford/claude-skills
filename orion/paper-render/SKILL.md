---
name: paper-render
description: Render a markdown paper or report into a theme-aware HTML artifact (for reading and sharing) and a white-background, paper-scale PDF (for download and print), from one markdown source of truth. Triggers on requests to render/publish a paper as an artifact, produce a PDF of a report, or "make a white-background PDF", and whenever a paper written via the research-paper skill needs a readable output. Encodes a reusable build pipeline and its hard-won print fixes, not one document.
model: opus
---

# paper-render

Turns one markdown paper into two renders: a **theme-aware HTML artifact** for on-screen reading and sharing, and a **white-background, paper-scale PDF** for download. The markdown is the single source of truth; the artifact and the PDF are disposable renders kept in lockstep with it. Edit the markdown, mirror the change into the artifact HTML, rebuild the PDF - never let the three drift.

This is the companion to `research-paper` (which writes the document) and feeds `research-repo-publish` (which puts the finished PDF at a repo's front door).

## The two outputs, and who they are for

- **HTML artifact** - screen reading and a shareable link. Comfortable web size (~17px body), light/dark theme-aware, published via the Artifact tool. This is what the operator reads and forwards.
- **PDF** - the downloadable, printable deliverable. White background always, academic paper scale (~11pt body), A4. This is what ships in the repo and gets posted.

Screen and print want different sizes. Do not force one size on both: keep the artifact comfortable for a monitor and shrink only the PDF to paper scale.

## Source of truth and lockstep

The markdown is authoritative. The artifact HTML is a hand-maintained render (because the Artifact layout - pulled-out receipts, scorecard tables, figures - is richer than a markdown-to-HTML dump). The PDF is derived from the artifact HTML by injecting a print stylesheet.

Every content edit flows markdown -> artifact HTML -> PDF, in that order, each time. When the operator edits the markdown, re-mirror and rebuild. When the operator edits their own wording, mirror it verbatim - flag anything you think is wrong, never silently "fix" operator text.

## The artifact (screen)

A self-contained HTML file rendered by the Artifact tool. The Artifact CSP blocks every external host, so **inline all CSS and embed every image as a base64 data URI** - no external stylesheets, fonts, or image URLs.

- **Theme-aware.** Define the palette as CSS custom properties on `:root`; redefine the tokens under `@media (prefers-color-scheme: dark)` and again under `:root[data-theme="dark"]` / `[data-theme="light"]` so the viewer's toggle wins in both directions. Style components through the tokens, never inside the media query.
- **Structure to encode.** Give receipts (verbatim quotes) pulled-out blocks; give comparisons a scorecard table; give the paper one or two figures where the evidence supports them. Full-width figures (`figure.fig-full`, `width:100%`) for a system diagram; capped-width (`figure.fig`, `max-width` ~320px) for a chart.
- **Images.** Base64-inject each figure into the `<img src="data:...">`. Verify the injection (count occurrences) before publishing - a missing image is silent.
- **Publish.** Call the Artifact tool with the file path. Republishing the **same file path** in the session keeps the same URL. Set a stable `<title>` and a stable `favicon`; keep both constant across redeploys (users find the tab by its icon).

If a republish seems to serve a stale render, publish to a fresh file path once to mint a new URL - a cache can pin an old build to a URL.

## The PDF (print) - the build recipe

Derive a print variant from the artifact HTML by appending an override `<style>` block, wrap it in a minimal HTML document, then run headless Chrome. The override is where the paper-scale and the print fixes live:

    :root { --paper:#ffffff; color-scheme: light; }
    @media (prefers-color-scheme: dark){ :root { /* repeat the LIGHT tokens so a dark-mode OS still prints white */ } }
    html { font-size: 87.5%; }              /* ~11pt body: academic paper scale */
    html, body { background:#ffffff !important; }
    .wrap { max-width: 42rem; }             /* a touch narrower for print */
    h2, h3 { break-after: avoid; }
    .tablewrap, figure, .receipt, table { break-inside: avoid; }
    pre.prompt { box-decoration-break: clone; -webkit-box-decoration-break: clone; }
    table { font-size:.72rem; }             /* wide scorecards fit A4 */
    thead th, tbody td { padding:.4rem .45rem; white-space:normal; overflow-wrap:break-word; }
    @page { size: A4; margin: 16mm 14mm; }

Then:

    google-chrome --headless=new --disable-gpu --no-pdf-header-footer --print-to-pdf=OUT.pdf file://PRINT.html

Why each fix exists (all learned the hard way):

- **`html { font-size: 87.5% }`** scales every rem-based size together to ~11pt. 16-17px is a web size; a paper reads at 10-11pt. This alone can drop a paper a page or two and is what makes it read like a paper, not a webpage.
- **Repeat the light tokens inside the dark media query.** Chrome honours the OS theme; without this a dark-mode machine prints a dark PDF.
- **`box-decoration-break: clone` on bordered code/prompt boxes.** When a bordered box breaks across a page, the continuation loses its top border by default; `clone` gives each page-fragment its own full border.
- **Table shrink + `overflow-wrap: break-word`.** Wide scorecards (8+ columns) clip on A4 otherwise; word-wrap stops a header breaking mid-word.
- **`break-inside: avoid`** keeps tables, figures, and receipts from splitting across a page break.

## Verify the render, do not assume it

Rendering a PDF page to an image and looking at it is the only way to catch a clipped table, a missing figure, or a lost border. After each build, rasterise the pages you changed (e.g. pymupdf `page.get_pixmap`) and read them. Check the title/abstract page, any page with a figure, and any page with a wide table or a box that spans a break.

## Ship checklist

- Markdown, artifact HTML, and PDF all carry the same content (lockstep).
- Artifact: theme-aware, all assets inlined, images verified present, stable title + favicon, published to its URL.
- PDF: white background even from a dark-mode OS, ~11pt paper scale, A4, tables fit, figures present, boxes keep borders across breaks.
- The build (override CSS + Chrome command) is captured somewhere regenerable, not only in a shell session - the PDF must be reproducible from the markdown later. Hand it to `research-repo-publish` as a committed build note or script.
