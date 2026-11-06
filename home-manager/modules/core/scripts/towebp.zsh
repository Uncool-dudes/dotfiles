#!/usr/bin/env zsh
set -euo pipefail

dry=false
yes=false
jobs="-1"
while [[ "${1:-}" == -* ]]; do
  case "$1" in
    -n|--dry-run) dry=true ;;
    -y|--yes) yes=true ;;
    -j|--jobs) jobs="$2"; shift ;;
    *) print -u2 -- "unknown flag: $1"; exit 1 ;;
  esac
  shift
done
dir="${1:-.}"
exts=(-e jpg -e jpeg -e png -e gif -e bmp -e tiff)

if $dry; then
  fd "${exts[@]}" . "$dir" \
    | while IFS= read -r f; do print -r -- "${f} -> ${f:r}.webp"; done
  exit 0
fi

count=$(fd "${exts[@]}" . "$dir" | wc -l | tr -d ' ')
if (( count == 0 )); then
  gum style --foreground 2 "nothing to convert"
  exit 0
fi

if ! $yes; then
  gum confirm "convert ${count} file(s) to webp and delete originals?" || exit 1
fi

fd "${exts[@]}" -0 . "$dir" \
  | gum spin --title "converting ${count} file(s)..." -- parallel --unsafe -0 -j"$jobs" 'vips copy {} {.}.webp && rm {}'
