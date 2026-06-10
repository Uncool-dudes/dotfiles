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
 
function auto_venv() {
  if [[ -d .venv ]]; then
    [[ "$VIRTUAL_ENV" != "$PWD/.venv" ]] && source .venv/bin/activate
  elif [[ -d venv ]]; then
    [[ "$VIRTUAL_ENV" != "$PWD/venv" ]] && source venv/bin/activate
  elif [[ -n "$VIRTUAL_ENV" ]]; then
    [[ "$PWD" != "${VIRTUAL_ENV%/*}"* ]] && deactivate
  fi
}
add-zsh-hook chpwd auto_venv
 
function fp() { ps aux | fzf --height 40% | awk '{print $2}' | xargs -r kill -9 }
function fk() { ss -tlnp 2>/dev/null | fzf --height 40% }
function tarzst() { tar --use-compress-program=zstd -cvf "${1}.tar.zst" "$1" }
function zsh-update-plugins() {
  antidote bundle < "${ZDOTDIR:-$HOME}/.zsh_plugins.txt" > "${ZDOTDIR:-$HOME}/.zsh_plugins.zsh"
  exec zsh
}
 
# ── Completions ──────────────────────────────────────────────────
source <(chezmoi completion zsh)
source <(pnpm completion zsh)
 
# ── Keybindings ──────────────────────────────────────────────────
bindkey '^[[1;3C' forward-word
bindkey '^[[1;3D' backward-wordindkey '^[[1;3D' backward-word
