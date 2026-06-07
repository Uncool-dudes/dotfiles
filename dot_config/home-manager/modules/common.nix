# modules/common.nix
# Full environment shared across all machines
{ pkgs, username, ... }: {

  home.username = username;
  home.homeDirectory = builtins.getEnv "HOME";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # Shell
    zsh
    atuin
    starship
    chezmoi
    direnv
    mise

    # Core CLI
    git
    bat
    eza
    fd
    fzf
    ripgrep
    delta
    zoxide
    procs
    hl-log-viewer

    # Git
    lazygit
    github-cli

    # Editor
    neovim

    # Go
    go

    # Rust
    rustup

    # Node
    pnpm

    # Claude
    claude-code

    # GUI — cross platform
    ghostty
    _1password-gui
    chromium
  ];
}
