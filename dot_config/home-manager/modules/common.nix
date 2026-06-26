# modules/common.nix
# Packages shared across all machines
{ pkgs, username, ... }: {

  imports = [
    ./stylix.nix
    ./shell.nix
    ./starship.nix
    ./atuin.nix
    ./bat.nix
    ./git.nix
    ./ssh.nix
    ./lazygit.nix
    ./ripgrep.nix
    ./ghostty.nix
    ./tmux.nix
    ./devtools.nix
  ];

  home.username = username;
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
  programs.btop = {
    enable = true;
    settings = {
      shown_boxes = "proc cpu";
      proc_sorting = "memory";
      cpu_bottom = true;
      save_config_on_exit = false;
    };
  };
  programs.mpv.enable = true;

  home.sessionPath = [
    "/nix/var/nix/profiles/default/bin"
    "$HOME/.local/bin"
  ];

  home.packages = with pkgs; [
    # Shell
    chezmoi
    tealdeer

    # Core CLI
    age
    eza
    fd
    grex
    hl-log-viewer
    procs
    sd
    watchexec
    whosthere
    xh

    # Git
    convco
    git-absorb
    git-town
    github-cli
    gitleaks
    glow
    lefthook

    # Text / data
    csvlens
    fx
    gum
    jq
    miller
    pandoc
    tokei

    # System / monitoring
    bandwhich
    nmap
    dive
    duf
    dust
    hyperfine

    # Media
    ffmpeg
    imagemagick
    yt-dlp

    # Backup
    bash
    gnutar
    zstd

    # Secrets
    _1password-cli

    # Misc
    fastfetch
    onefetch
    wget
  ];
}
