# modules/common.nix
# Packages shared across all machines
{ pkgs, username, ... }: {

  home.username = username;
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  home.sessionPath = [
    "$HOME/.nix-profile/bin"
    "/nix/var/nix/profiles/default/bin"
    "$HOME/.local/bin"
    "$HOME/go/bin"
    "$HOME/.cargo/bin"
    "$HOME/.pnpm-global/bin"
  ];

  home.packages = with pkgs; [
    # Shell
    antidote
    chezmoi
    tealdeer

    # Core CLI
    git
    age
    bat
    eza
    csvlens
    miller
    tilt
    fd
    ripgrep
    delta
    whosthere
    procs
    hl-log-viewer
    sd
    grex
    xh
    watchexec

    # Git
    lazygit
    git-absorb
    github-cli
    gitflow
    gitleaks
    convco
    glow
    mpv
    lefthook

    # Editor
    neovim
    sqlfluff
    black

    # Go
    go
    golangci-lint

    # Rust
    rustup

    # Node
    nodejs
    pnpm

    # Python
    uv

    # Claude
    claude-code

    # Text / data
    jq
    fx
    gum
    tokei
    pandoc

    # Task runner
    just

    # System / monitoring
    btop
    dust
    duf
    hyperfine
    dive

    # Media
    ffmpeg
    yt-dlp
    imagemagick

    # Dev
    typst
    croc
    graphviz
    nmap
    tectonic

    # Nix
    nixfmt
    nil
    nvd
    statix
    deadnix

    # Secrets
    _1password-cli

    # Misc
    tmux
    onefetch
    fastfetch
    wget
  ];
}
