# surg-flow.github.io

Project page for **SurgFlow: 3D Object-Centric Contact Flow for Surgical Robot Manipulation**.

Live at <https://surg-flow.github.io/>.

Static HTML — no build step, no dependencies, no JavaScript. GitHub Pages serves it as-is.

```
index.html              the whole page
static/css/style.css    styling (light + dark, responsive)
static/images/          the two figures, rendered from the paper PDFs
static/videos/          demo clips (h264) + poster frames
static/js/main.js       lazy-loads the demo clips on scroll
static/paper/           the paper PDF the Paper button links to
.nojekyll               serve static files verbatim
tools/build_assets.sh   re-render the figures from website/figures/*.pdf
```

Sections: hero, demo, abstract, method figure, execution figure, BibTeX.
Styled on the Nerfies project-page template (Bulma, vendored locally).

Demo clips are re-encoded from `surgflowx/website/video_gif/*.gif` — 32 MB of
GIF down to 3.1 MB of h264. Regenerate with the `enc` recipe in
`tools/build_assets.sh`.

## Preview locally

```bash
python3 -m http.server -d . 8000   # then open http://localhost:8000
```

## Still to fill in

Search `index.html` for `TODO`:

- [ ] arXiv link (currently a disabled "soon" pill)
- [ ] code link (same)
- [ ] BibTeX entry, once the paper has a venue

## Updating

```bash
# edit, then
git commit -am "..." && git push
```

Live about a minute later. To refresh the figures, replace the PDFs in
`surgflowx/website/figures/` and run `./tools/build_assets.sh`.

## If a printed QR code points here

The URL is what gets printed, so the page content stays editable forever — but
the URL must not move. Keep the org named `surg-flow`, and keep the repo public:
making it private stops GitHub Pages serving and the printed code dies.
