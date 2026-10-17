#!/usr/bin/env zsh
set -euo pipefail

dry=false
yes=false
jobs=2
q=55
while [[ "${1:-}" == -* ]]; do
  case "$1" in
    -n|--dry-run) dry=true ;;
    -y|--yes) yes=true ;;
    -j|--jobs) jobs="$2"; shift ;;
    -q|--quality) q="$2"; shift ;;
    *) print -u2 -- "unknown flag: $1"; exit 1 ;;
  esac
  shift
done
dir="${1:-.}"

is_hevc() {
  ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of csv=p=0 "$1" 2>/dev/null \
    | grep -qE '^(hevc|av1)$'
}

candidates() {
  fd -e mp4 -0 . "$dir" | while IFS= read -r -d '' f; do
    is_hevc "$f" || print -rn -- "${f}"$'\0'
  done
}

if $dry; then
  candidates | while IFS= read -r -d '' f; do print -r -- "${f} -> hevc @ q=${q}"; done
  exit 0
fi

count=$(candidates | tr -cd '\0' | wc -c | tr -d ' ')
if (( count == 0 )); then
  gum style --foreground 2 "nothing to re-encode"
  exit 0
fi

if ! $yes; then
  gum confirm "re-encode ${count} file(s) to hevc @ q=${q} in place?" || exit 1
fi

candidates \
  | gum spin --title "re-encoding ${count} file(s)..." -- parallel --unsafe -0 -j"$jobs" \
    "ffmpeg -y -v error -i {} -c:v hevc_videotoolbox -tag:v hvc1 -q:v ${q} -c:a copy {.}.tmp.mp4 && mv {.}.tmp.mp4 {}"
