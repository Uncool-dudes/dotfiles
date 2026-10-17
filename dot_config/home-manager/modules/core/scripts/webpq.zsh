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
q=80
if [[ "${1:-}" == <-> ]]; then
  q="$1"
  shift
fi
dir="${1:-.}"

if $dry; then
  fd -e webp . "$dir" \
    | while IFS= read -r f; do print -r -- "requantize ${f} @ Q=${q}"; done
  exit 0
fi

count=$(fd -e webp . "$dir" | wc -l | tr -d ' ')
if (( count == 0 )); then
  gum style --foreground 2 "nothing to requantize"
  exit 0
fi

if ! $yes; then
  gum confirm "requantize ${count} file(s) to Q=${q} in place?" || exit 1
fi

fd -e webp -0 . "$dir" \
  | gum spin --title "requantizing ${count} file(s)..." -- parallel --unsafe -0 -j"$jobs" "vips copy {} {.}.tmp.webp'[Q=${q}]' && mv {.}.tmp.webp {}"
