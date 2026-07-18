#!/usr/bin/env bash
set -euo pipefail

WALLPAPER_DIR="$HOME/Pictures/wallpapers"

# Pick a random image (jpg/jpeg/png/gif/webp/bmp), one level deep
mapfile -t images < <(find -L "$WALLPAPER_DIR" -maxdepth 1 -type f \( \
  -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \
  -o -iname '*.gif' -o -iname '*.webp' -o -iname '*.bmp' \))

if [ ${#images[@]} -eq 0 ]; then
  echo "No images found in $WALLPAPER_DIR" >&2
  exit 1
fi

wallpaper="${images[RANDOM % ${#images[@]}]}"

awww img "$wallpaper" --transition-type random --transition-fps 60