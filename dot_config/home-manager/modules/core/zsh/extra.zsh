typeset -U path fpath cdpath manpath

autoload -Uz add-zsh-hook

# ── Safety nets ──────────────────────────────────────────────────
export FUNCNEST=1000

# ── Command timing/memory reports ───────────────────────────────
REPORTTIME=10
REPORTMEMORY=102400
TIMEFMT='%J  %U user %S system %P cpu %*E total'

# ── Autosuggestions ──────────────────────────────────────────────
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=100

# ── Vi mode ──────────────────────────────────────────────────────
bindkey -v
export KEYTIMEOUT=1
bindkey -M viins '^R' atuin-search
bindkey -M viins '^T' fzf-file-widget
bindkey -M viins '^G' _navi_widget
bindkey -M viins '\es' sesh-sessions
bindkey -M viins '\ec' fzf-cd-widget
bindkey -M viins '\ee' edit-command-line
bindkey -M vicmd '\ee' edit-command-line
bindkey -M emacs '\ee' edit-command-line
bindkey -r '^X^E'
bindkey -M viins ' ' magic-space
bindkey -M emacs ' ' magic-space

function clear-screen-or-self-insert() {
  if [[ -z $BUFFER ]]; then
    zle clear-screen
  else
    zle self-insert
  fi
}
zle -N clear-screen-or-self-insert
bindkey -M viins '/' clear-screen-or-self-insert
bindkey -M emacs '/' clear-screen-or-self-insert
bindkey -M viins '\ek' clear-screen

function copy-buffer-to-clipboard() {
  print -rn -- "$BUFFER" | pbcopy
  zle -M "copied to clipboard"
}
zle -N copy-buffer-to-clipboard
bindkey -M viins '\ey' copy-buffer-to-clipboard
bindkey -M vicmd '\ey' copy-buffer-to-clipboard
bindkey -M emacs '\ey' copy-buffer-to-clipboard
bindkey -M vicmd '\ek' clear-screen
bindkey -M emacs '\ek' clear-screen

# ── fzf-tab ──────────────────────────────────────────────────────
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --tree --level=2 --icons --color=always $realpath'
zstyle ':fzf-tab:*' fzf-flags --height=40% --layout=reverse --border

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
function rvim() {
  local host="$1" path="${2:-}"
  nvim "scp://${host}/${path}"
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
# Staleness is checked by resolved store path, not mtime - nix store
# files all carry epoch 1970 mtimes, so "cache -ot bin" never fires
# on a version bump and silently serves a stale init script forever.
_cache_eval() {
  local name="$1"
  local cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/${name}.zsh"
  local stamp="${cache}.path"
  local bin="${commands[$name]:-$(whence $name 2>/dev/null)}"
  [[ -z "$bin" ]] && return
  local resolved="${bin:A}"
  if [[ ! -f "$cache" || ! -f "$stamp" || "$(<$stamp)" != "$resolved" ]]; then
    mkdir -p "${cache:h}"
    "$name" "${@:2}" > "$cache" 2>/dev/null
    print -r -- "$resolved" > "$stamp"
  fi
  [[ -f "$cache" ]] && source "$cache"
}

_cache_eval fnm     env --use-on-cd --shell zsh
_cache_eval fzf     --zsh
_cache_eval zoxide  init zsh --cmd cd
_cache_eval direnv  hook zsh
_cache_eval atuin   init zsh
_cache_eval starship init zsh
_cache_eval navi    widget zsh

zsh-defer _cache_eval chezmoi completion zsh
zsh-defer _cache_eval pnpm    completion zsh
zsh-defer _cache_eval sesh    completion zsh

# ── sesh picker (outside tmux) ───────────────────────────────────
function sesh-sessions() {
  {
    exec </dev/tty
    exec <&1
    local session
    session=$(sesh list -t -c | fzf --height 40% --reverse --border-label ' sesh ' --border --prompt '⚡  ' \
      --header '  ^d kill tmux session' \
      --bind 'ctrl-d:execute(tmux kill-session -t {} 2>/dev/null)+reload(sesh list -t -c)')
    zle reset-prompt > /dev/null 2>&1 || true
    [[ -z "$session" ]] && return
    sesh connect $session
  }
}
zle     -N             sesh-sessions
bindkey -M emacs '\es' sesh-sessions
bindkey -M vicmd '\es' sesh-sessions
bindkey -M viins '\es' sesh-sessions

# ── Postgres / AlloyDB ───────────────────────────────────────────
function pgc() {
  local svc="$1" db="$2"
  local user
  user=$(awk -v s="[$svc]" '$0==s{f=1;next} /^\[/{f=0} f && /^user=/{sub(/^user=/,"");print;exit}' ~/.pg_service.conf)
  if [[ -z "$db" ]]; then
    pgcli "postgresql:///?service=$svc&user=$user"
  else
    pgcli "postgresql:///?service=$svc&dbname=$db&user=$user"
  fi
}
_pgc() {
  local -a services dbs
  services=(${(f)"$(grep -oE '^\[[^]]+\]' ~/.pg_service.conf 2>/dev/null | tr -d '[]')"})
  dbs=(
    staging_gamma_ats staging_gamma_auth staging_gamma_calendar staging_gamma_candidate
    staging_gamma_chatbroker staging_gamma_hiring staging_gamma_llm staging_gamma_meet
    staging_gamma_notification staging_gamma_admin staging_gamma_recruiter staging_gamma_resource
    staging_gamma_source staging_gamma_wsht staging_gamma_wshtqueue
    prod_gamma_ats prod_gamma_auth prod_gamma_calendar prod_gamma_candidate
    prod_gamma_chatbroker prod_gamma_hiring prod_gamma_llm prod_gamma_meet
    prod_gamma_notification prod_gamma_admin prod_gamma_recruiter prod_gamma_resource
    prod_gamma_source prod_gamma_wsht prod_gamma_wshtqueue
  )
  case $CURRENT in
    2) _describe 'service' services ;;
    3) _describe 'database' dbs ;;
  esac
}
compdef _pgc pgc

# ── fzf: live ripgrep search ─────────────────────────────────────
function rgf() {
  local rg_cmd='rg --column --line-number --no-heading --color=always --smart-case -- {q}'
  fzf --ansi --disabled --query "${*:-}" \
    --bind "start:reload:$rg_cmd" \
    --bind "change:reload:sleep 0.1; $rg_cmd || true" \
    --delimiter : \
    --preview 'bat --color=always --style=numbers --highlight-line {2} {1}' \
    --preview-window 'up,60%,border-rounded,+{2}+3/3,~3' \
    --bind "enter:become($EDITOR {1} +{2})"
}

# ── fzf: ssh host picker ─────────────────────────────────────────
function sshf() {
  local hosts
  hosts=$(
    {
      grep -iE '^\s*host(name)?\s' ~/.ssh/config 2>/dev/null \
        | awk '{for(i=2;i<=NF;i++) print $i}' | grep -v '[*?]'
      grep -oE '^[^#, ]+' ~/.ssh/known_hosts 2>/dev/null | tr -d '[]'
      grep -vE '^\s*#|^\s*(0\.0\.0\.0|127\.0\.0\.1)' /etc/hosts 2>/dev/null \
        | awk '{for(i=2;i<=NF;i++) print $i}'
    } | sort -u
  )
  local selected
  selected=$(print -r -- "$hosts" | fzf --multi --reverse \
    --header 'ctrl-y: copy selected hostnames' \
    --preview 'dig +short {} 2>/dev/null' \
    --bind 'ctrl-y:execute-silent(print -rl -- {+} | tr "\n" " " | pbcopy)+bell')
  [[ -z "$selected" ]] && return

  local -a selected_hosts=(${(f)selected})
  if (( ${#selected_hosts} == 1 )); then
    ssh "${selected_hosts[1]}"
  elif [[ -n "$TMUX" ]]; then
    tmux new-window -n ssh-multi "ssh ${selected_hosts[1]}"
    local host
    for host in "${selected_hosts[@]:1}"; do
      tmux split-window -t ssh-multi "ssh $host"
      tmux select-layout -t ssh-multi tiled
    done
    tmux set-window-option -t ssh-multi synchronize-panes on
  else
    print -rl -- "${selected_hosts[@]/#/ssh }"
  fi
}

# ── Home-manager ─────────────────────────────────────────────────
function hms() { nh home switch -c uncool@mac "$@" }

# ── gcloud ───────────────────────────────────────────────────────
local _gcloud_sdk="/opt/homebrew/share/google-cloud-sdk"
[[ -f "$_gcloud_sdk/path.zsh.inc" ]] && source "$_gcloud_sdk/path.zsh.inc"
[[ -f "$_gcloud_sdk/completion.zsh.inc" ]] && zsh-defer source "$_gcloud_sdk/completion.zsh.inc"

