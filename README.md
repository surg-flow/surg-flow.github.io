# surgflow.github.io

Project page for **SurgFlowX: Contact-Coupled Flow for Deformable Surgical Manipulation**.

Static HTML — no build step, no dependencies. GitHub Pages serves it as-is.

```
index.html              the whole page
static/css/style.css    styling (light + dark, responsive)
static/js/main.js       lazy-loads result videos on scroll
static/images/          figures rendered from the paper PDFs
static/videos/          result clips (h264, web-sized) + poster frames
.nojekyll               serve static files verbatim
```

## Preview locally

```bash
python3 -m http.server -d . 8000   # then open http://localhost:8000
```

## Before it goes public

The page is currently anonymous for double-blind review. Search `index.html`
for `TODO` — each marker sits next to what it is waiting for:

- [ ] author list + affiliations (hero)
- [ ] paper / arXiv / code / dataset links (remove `aria-disabled="true"`)
- [ ] final abstract
- [ ] quantitative tables (every `&mdash;` cell)
- [ ] BibTeX entry
- [ ] `og:url` and `og:image` absolute URLs

Visible `TODO` badges are styled `.todo` in the stylesheet — deleting that rule
is a quick way to spot any you missed.

## Regenerating assets

Figures are rendered from the color-fixed paper PDFs, videos re-encoded for web
delivery (~200 MB of source assets down to ~15 MB). See `tools/build_assets.sh`.
