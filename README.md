# surgflow.github.io

Project page for **SurgFlow: 3D Object-Centric Contact Flow for Surgical Manipulation**.

Static HTML — no build step, no dependencies, no JavaScript. GitHub Pages serves it as-is.

```
index.html              the whole page
static/css/style.css    styling (light + dark, responsive)
static/images/          the two figures, rendered from the paper PDFs
.nojekyll               serve static files verbatim
tools/build_assets.sh   re-render the figures from website/figures/*.pdf
```

Deliberately minimal: hero, abstract, method figure, execution figure, BibTeX.
Result videos, the teaser, the platform figure and the results tables were all
removed in favour of a clean page — they are in the git history if wanted back.

## Preview locally

```bash
python3 -m http.server -d . 8000   # then open http://localhost:8000
```

## Before it goes public

The page is anonymous for double-blind review. Search `index.html` for `TODO` —
each marker sits next to what it is waiting for:

- [ ] author list + affiliations (hero)
- [ ] paper / arXiv / code / dataset links (remove `aria-disabled="true"`)
- [ ] final abstract
- [ ] BibTeX entry
- [ ] absolute `og:url`

Visible `TODO` badges are styled `.todo` in the stylesheet — deleting that rule
is a quick way to spot any you missed.

## If a printed QR code points here

The URL is what gets printed, so the page content stays editable forever — but
the URL must not move. Keep the org named `surgflow`, and keep the repo public:
making it private stops GitHub Pages serving and the printed code dies.
