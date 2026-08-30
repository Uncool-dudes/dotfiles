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
    ./aria2.nix
    ./devtools.nix
  ];

  home = {
    inherit username;
    homeDirectory = if pkgs.stdenv.hostPlatform.isDarwin then "/Users/${username}" else "/home/${username}";
    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  programs = {
    nix-index.enable = true;

    tealdeer = {
      enable = true;
      settings.display.use_pager = true;
    };

    yazi = {
      enable = true;
      shellWrapperName = "y";
      settings = {
        mgr.show_hidden = false;
        preview = {
          image_filter = "triangle";
          max_width = 1000;
          max_height = 800;
        };
        tasks = {
          preload_workers = 15;
          fetch_workers = 10;
        };
      };
    };

    fd = {
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

    eza = {
      enable = true;
      icons = "auto";
      git = true;
      extraOptions = [ "--group-directories-first" ];
    };
    btop = {
      enable = true;
      settings = {
        shown_boxes = "proc cpu";
        proc_sorting = "memory";
        cpu_bottom = true;
        save_config_on_exit = false;
      };
    };
  };
  home.sessionPath = [
    "/nix/var/nix/profiles/default/bin"
    "$HOME/.local/bin"
  ];

  home.packages = with pkgs; [
    # Shell
    chezmoi
    parallel

    # Core CLI
    # age # file encryption - unused, no sops/secrets workflow consumes it yet
    grex
    hl-log-viewer
    lnav
    oha
    procs
    sd
    watchexec
    whosthere
    witr
    xh

    # Git
    act
    convco
    git-absorb
    glow
    lefthook
    # tig # git TUI browser - redundant, lazygit covers this

    proximity-sort

    # Text / data
    csvlens
    fx
    gum
    jq
    miller
    pandoc
    tokei

    # System / monitoring
    iperf3
    nmap
    # dive # docker image layer inspector - only useful when actively building images
    duf
    dust
    hyperfine

    # Media
    ffmpeg
    ffmpegthumbnailer
    imagemagick
    vips

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
