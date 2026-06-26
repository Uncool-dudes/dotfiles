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
    ./mpv.nix
    ./gh.nix
    ./fastfetch.nix
    ./yt-dlp.nix
    ./devtools.nix
  ];

  home.username = username;
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  programs.tealdeer = {
    enable = true;
    settings.display.use_pager = true;
  };
  programs.fd = {
    enable = true;
    hidden = true;
    ignores = [
      ".git/"
      "node_modules/"
      "__pycache__/"
      "*.pyc"
      ".DS_Store"
      "target/"
      "dist/"
      ".direnv/"
    ];
  };
  programs.eza = {
    enable = true;
    icons = "auto";
    git = true;
    extraOptions = [ "--group-directories-first" ];
  };
  programs.btop = {
    enable = true;
    settings = {
      shown_boxes = "proc cpu";
      proc_sorting = "memory";
      cpu_bottom = true;
      save_config_on_exit = false;
    };
  };
  home.sessionPath = [
    "/nix/var/nix/profiles/default/bin"
    "$HOME/.local/bin"
  ];

  home.packages = with pkgs; [
    # Shell
    chezmoi

    # Core CLI
    age
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

    # Backup
    bash
    gnutar
    zstd

    # Secrets
    _1password-cli

    # Misc
    onefetch
    wget
  ];
}
