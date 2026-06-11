autoload -Uz add-zsh-hook

# ── Functions ────────────────────────────────────────────────────
function upgrade() {
  sudo pacman -Sy
  echo ":: Checking Arch Linux PGP Keyring..."
  local installedver="$(LANG= sudo pacman -Qi archlinux-keyring | grep -Po '(?<=Version         : ).*')"
  local currentver="$(LANG= sudo pacman -Si archlinux-keyring | grep -Po '(?<=Version         : ).*')"
  if [ "$installedver" != "$currentver" ]; then
    echo " Arch Linux PGP Keyring is out of date."
    echo " Updating before full system upgrade."
    sudo pacman -S --needed --noconfirm archlinux-keyring
  else
    echo " Arch Linux PGP Keyring is up to date."
    echo " Proceeding with full system upgrade."
  fi
  if (( $+commands[yay] )); then
    yay -Su
  elif (( $+commands[paru] )); then
    paru -Su
  else
    sudo pacman -Su
  fi
}

function fp() { ps aux | fzf --height 40% | awk '{print $2}' | xargs -r kill -9 }
function fk() { ss -tlnp 2>/dev/null | fzf --height 40% }
function tarzst() { tar --use-compress-program=zstd -cvf "${1}.tar.zst" "$1" }
function zsh-update-plugins() {
  antidote bundle < "${ZDOTDIR:-$HOME}/.zsh_plugins.txt" > "${ZDOTDIR:-$HOME}/.zsh_plugins.zsh"
  exec zsh
}

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

_cache_eval chezmoi completion zsh
_cache_eval pnpm    completion zsh
_cache_eval zoxide  init zsh --cmd cd
_cache_eval direnv  hook zsh
_cache_eval atuin   init zsh
(( $+commands[starship] )) && _cache_eval starship init zsh
