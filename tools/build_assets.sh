#!/usr/bin/env bash
# Regenerate the site's figures from the paper PDFs.
# Usage: SRC=/path/to/surgflowx ./tools/build_assets.sh
set -euo pipefail

SRC="${SRC:-$HOME/workspace/surgflowx}"
FIG="$SRC/website/figures"
SITE="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$SITE/static/images"

render() { # pdf out target_width_px
  local w dpi
  w=$(pdfinfo "$1" | awk '/Page size/{print $3}')
  dpi=$(python3 -c "print(max(72,round($3/$w*72)))")
  # render oversized, trim the PDF's own white margins, then scale to target
  pdftoppm -r "$((dpi * 2))" -png -singlefile "$1" /tmp/_surgflow_render
  convert /tmp/_surgflow_render.png \
    -bordercolor white -border 1 -trim +repage \
    -bordercolor white -border 14 +repage \
    -resize "$3"x -strip -define png:compression-level=9 "$2"
  rm -f /tmp/_surgflow_render.png
  printf '%-24s %s\n' "$(basename "$2")" "$(identify -format '%wx%h' "$2")"
}

render "$FIG/method1_fixed_color.pdf"                 "$SITE/static/images/method.png"          2200
render "$FIG/needle_handover_exp_fixed_color (1).pdf" "$SITE/static/images/needle_handover.png" 2000

echo "figures rebuilt -> $(du -sh "$SITE/static" | cut -f1)"

# ---------------------------------------------------------------------------
# Demo clips: GIF -> h264. Sources live in $SRC/website/video_gif.
#   enc <src.gif> <name>   =>  static/videos/<name>.mp4 + <name>.jpg poster
# ---------------------------------------------------------------------------
enc() {
  ffmpeg -nostdin -v error -y -i "$1" \
    -vf "scale='min(960,iw)':-2:flags=lanczos,fps=15" \
    -c:v libx264 -profile:v high -pix_fmt yuv420p -crf 26 -preset slow \
    -movflags +faststart -an "$SITE/static/videos/$2.mp4"
  ffmpeg -nostdin -v error -y -i "$1" \
    -vf "scale='min(960,iw)':-2,select=eq(n\,12)" -vframes 1 -q:v 4 "$SITE/static/videos/$2.jpg"
}

if [ "${WITH_VIDEOS:-0}" = "1" ]; then
  mkdir -p "$SITE/static/videos"
  GIF="$SRC/website/video_gif"
  enc "$GIF/exvivo_reveal_contact_flow_w10.gif"   tissue_flow
  enc "$GIF/needle_contact_flow.gif"              needle_flow
  enc "$GIF/tissue_reveal_surgflow_clip2_low.gif" tissue_exec
  enc "$GIF/needle_exp3_contactflow.gif"          needle_exec
  echo "demo clips rebuilt -> $(du -sh "$SITE/static/videos" | cut -f1)"
fi
