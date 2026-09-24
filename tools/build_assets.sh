#!/usr/bin/env bash
# Regenerate web assets from the surgflowx working tree.
# Usage: SRC=/path/to/surgflowx ./tools/build_assets.sh
set -euo pipefail

SRC="${SRC:-$HOME/workspace/surgflowx}"
SITE="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$SITE"/static/{images,videos}

render() { # pdf out width
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
}

render "$SRC/experiment_figures/method/coverfig_color_fixed.pdf"            "$SITE/static/images/teaser.png"              1800
render "$SRC/experiment_figures/method/method1_fixed_color.pdf"             "$SITE/static/images/method.png"              2200
render "$SRC/experiment_figures/method/needle_handover_exp_fixed_color.pdf" "$SITE/static/images/needle_handover_exp.png" 2000
render "$SRC/experiment_figures/experimental_setup/dvrk_and_lapsurgie.pdf"  "$SITE/static/images/setup.png"               1800
render "$SRC/experiment_figures/grasping_loaction/grasping_location.pdf"    "$SITE/static/images/grasping_location.png"   1800

for f in flow_tracks_duo cloud_tracks; do
  convert "$SRC/experiment_figures/exvivo_reveal/episode_0005/$f.png" \
    -resize 1400x -strip "$SITE/static/images/exvivo_$f.png"
done

enc() { # in outname
  ffmpeg -nostdin -v error -y -i "$1" \
    -vf "scale='min(1100,iw)':-2:flags=lanczos" \
    -c:v libx264 -profile:v high -pix_fmt yuv420p -crf 25 -preset slow \
    -movflags +faststart -an "$SITE/static/videos/$2.mp4"
  ffmpeg -nostdin -v error -y -i "$1" \
    -vf "scale='min(1100,iw)':-2,select=eq(n\,0)" -vframes 1 "$SITE/static/videos/$2.jpg"
}

enc "$SRC/experiment_video/needle_handover/contact_flow.mp4"                 nh_contact_flow
enc "$SRC/experiment_video/needle_handover/object_flow.mp4"                  nh_object_flow
enc "$SRC/experiment_video/exvivo_reveal/episode_0005/contact_flow_w15.mp4"  exvivo_contact_flow
enc "$SRC/experiment_video/exvivo_reveal/episode_0005/object_flow_w15.mp4"   exvivo_object_flow

echo "assets rebuilt -> $(du -sh "$SITE/static" | cut -f1)"
