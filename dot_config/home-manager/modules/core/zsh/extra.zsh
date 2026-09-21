typeset -U path fpath cdpath manpath

autoload -Uz add-zsh-hook

# ── Functions ────────────────────────────────────────────────────
function gcd() { cd "$(ghq list --full-path | fzf --height 40%)" }
function y() {
  local target="$PWD"
  local -a rest=("$@")
  if [[ $# -gt 0 && "$1" != -* ]]; then
    if [[ -d "$1" ]]; then
      target="$1"
      rest=("${@:2}")
    else
      local match
      if match="$(zoxide query -- "$1" 2>/dev/null)"; then
        target="$match"
        rest=("${@:2}")
      fi
      # no zoxide match: fall through, pass args to yazi as-is
    fi
  fi
  local tmp
  tmp="$(mktemp -t yazi-cwd.XXXXXX)"
  yazi "$target" --cwd-file="$tmp" "${rest[@]}"
  local cwd
  cwd="$(cat -- "$tmp")"
  [[ -n "$cwd" && "$cwd" != "$PWD" ]] && cd -- "$cwd"
  rm -f -- "$tmp"
}
function mkcd() {
  if [[ -z "$1" ]]; then
    echo "usage: mkcd <dir>" >&2
    return 1
  fi
  mkdir -p -- "$1" && cd -- "$1"
}
_auto_ls_on_cd() { eza }
add-zsh-hook chpwd _auto_ls_on_cd

# ── Cached eval ──────────────────────────────────────────────────
_cache_eval() {
  local name="$1"
  local cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/${name}.zsh"
  local bin="${commands[$name]:-$(whence $name 2>/dev/null)}"
  if [[ ! -f "$cache" || -z "$bin" || "$cache" -ot "$bin" ]]; then
    mkdir -p "${cache:h}"
    "$name" "${@:2}" > "$cache" 2>/dev/null
  fi
  [[ -f "$cache" ]] && source "$cache"
}

_cache_eval fnm     env --use-on-cd --shell zsh
_cache_eval fzf     --zsh
_cache_eval zoxide  init zsh --cmd cd
_cache_eval direnv  hook zsh
_cache_eval atuin   init zsh
_cache_eval starship init zsh

zsh-defer _cache_eval chezmoi completion zsh
zsh-defer _cache_eval pnpm    completion zsh
zsh-defer _cache_eval wt        config shell init zsh

# ── Home-manager ─────────────────────────────────────────────────
function hms() { nh home switch -c uncool@mac "$@" }

# ── gcloud ───────────────────────────────────────────────────────
local _gcloud_sdk="/opt/homebrew/share/google-cloud-sdk"
[[ -f "$_gcloud_sdk/path.zsh.inc" ]] && source "$_gcloud_sdk/path.zsh.inc"
[[ -f "$_gcloud_sdk/completion.zsh.inc" ]] && zsh-defer source "$_gcloud_sdk/completion.zsh.inc"

